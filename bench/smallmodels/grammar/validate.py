#!/usr/bin/env python3
"""validate.py - test openscad.gbnf the way llama.cpp will use it.

    python -I -B bench/smallmodels/grammar/validate.py                  # corpus + negatives, writes the report
    python -I -B bench/smallmodels/grammar/validate.py --file x.scad    # one file (wrapped in a fence)
    python -I -B bench/smallmodels/grammar/validate.py --reply r.txt    # one full model reply, as is

There is no llama-gbnf-validator binary in the PrismML build (tests are not configured), so this file
re-implements, line for line, the two parts of llama.cpp's src/llama-grammar.cpp that decide acceptance:
  * the GBNF parser (llama_grammar_parser::parse): rule names, literals, escapes, character classes,
    groups, * + ? and {m,n} (rewritten into the same helper rules, with the same 2000-rule limit), # comments;
  * the pushdown acceptor: llama_grammar_init_impl (with its left-recursion check),
    llama_grammar_advance_stack and llama_grammar_accept, i.e. a set of parse stacks advanced one Unicode
    code point at a time. A text is accepted when its last code point leaves an empty stack in the set.
The stack expansion is precomputed per grammar position (same stacks, computed once) and the number of
live stacks is recorded: it is what llama.cpp walks for every candidate token, so it measures sampling cost.

ACCEPT corpus (each .scad file wrapped as "```openscad\\n" + file + "\\n```"; distilled replies used as is):
bench/reference, bench/variants, designs/**, finetune/seeds, finetune/rft/distill/clean{,_b,_c}_shard*.jsonl.
REJECT corpus: negatives/*.scad (wrapped) and negatives/*.reply.txt (as is). A negative may say on which
line of the file it must fail with a comment `// expect-reject-line: N`.
"""
from __future__ import annotations

import argparse
import glob
import json
import multiprocessing as mp
import os
import pathlib
import re
import statistics
import sys
import time

HERE = pathlib.Path(__file__).resolve().parent
REPO = HERE.parents[2]
GRAMMAR = HERE / "openscad.gbnf"

# llama_gretype
END, ALT, RULE_REF, CHAR, CHAR_NOT, CHAR_RNG_UPPER, CHAR_ALT, CHAR_ANY, TOKEN, TOKEN_NOT = range(10)
MAX_REPETITION_THRESHOLD = 2000
WORD = set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-0123456789")
DIGIT = set("0123456789")


class GrammarError(Exception):
    pass


# =========================================================================== GBNF parser (llama_grammar_parser)
class Parser:
    def __init__(self, src: str):
        self.src = src
        self.n = len(src)
        self.symbol_ids: dict[str, int] = {}
        self.rules: list[list[tuple[int, int]]] = []

    def ch(self, i: int) -> str:
        return self.src[i] if i < self.n else "\0"

    def get_symbol_id(self, name: str) -> int:
        return self.symbol_ids.setdefault(name, len(self.symbol_ids))

    def generate_symbol_id(self, base: str) -> int:
        nid = len(self.symbol_ids)
        self.symbol_ids[f"{base}_{nid}"] = nid
        return nid

    def add_rule(self, rid: int, rule: list) -> None:
        if len(self.rules) <= rid:
            self.rules.extend([] for _ in range(rid + 1 - len(self.rules)))
        self.rules[rid] = rule

    def err(self, msg: str, pos: int):
        line = self.src.count("\n", 0, min(pos, self.n)) + 1
        raise GrammarError(f"{msg} at grammar line {line}: {self.src[pos:pos + 40]!r}")

    def parse_space(self, pos: int, newline_ok: bool) -> int:
        while True:
            c = self.ch(pos)
            if c in " \t#" or (newline_ok and c in "\r\n"):
                if c == "#":
                    while self.ch(pos) != "\0" and self.ch(pos) not in "\r\n":
                        pos += 1
                else:
                    pos += 1
            else:
                return pos

    def parse_name(self, pos: int) -> int:
        start = pos
        while self.ch(pos) in WORD:
            pos += 1
        if pos == start:
            self.err("expecting name", start)
        return pos

    def parse_int(self, pos: int) -> int:
        start = pos
        while self.ch(pos) in DIGIT:
            pos += 1
        if pos == start:
            self.err("expecting integer", start)
        return pos

    def parse_hex(self, pos: int, size: int) -> tuple[int, int]:
        end, value = pos + size, 0
        while pos < end and self.ch(pos) != "\0":
            c = self.ch(pos)
            if c in "0123456789abcdefABCDEF":
                value = value * 16 + int(c, 16)
            else:
                break
            pos += 1
        if pos != end:
            self.err(f"expecting {size} hex chars", pos)
        return value, pos

    def parse_char(self, pos: int) -> tuple[int, int]:
        if self.ch(pos) == "\\":
            c = self.ch(pos + 1)
            if c == "x":
                return self.parse_hex(pos + 2, 2)
            if c == "u":
                return self.parse_hex(pos + 2, 4)
            if c == "U":
                return self.parse_hex(pos + 2, 8)
            if c in "trn":
                return ord({"t": "\t", "r": "\r", "n": "\n"}[c]), pos + 2
            if c in '\\"[]':
                return ord(c), pos + 2
            self.err("unknown escape", pos)
        if self.ch(pos) != "\0":
            return ord(self.src[pos]), pos + 1
        self.err("unexpected end of input", pos)

    def parse_token(self, pos: int) -> tuple[int, int]:
        # only the vocab-free form <[id]> can be parsed without a model, as in llama.cpp
        if self.ch(pos) != "<":
            self.err("expecting '<'", pos)
        pos += 1
        if self.ch(pos) == "[":
            pos += 1
            e = self.parse_int(pos)
            tid = int(self.src[pos:e])
            pos = e
            if self.ch(pos) != "]":
                self.err("expecting ']'", pos)
            pos += 1
            if self.ch(pos) != ">":
                self.err("expecting '>'", pos)
            return tid, pos + 1
        self.err("no vocab to parse token", pos)

    def parse_sequence(self, pos: int, rule_name: str, rule: list, is_nested: bool) -> int:
        last_sym_start = len(rule)
        n_prev_rules = 1

        def handle_repetitions(min_times: int, max_times):  # max_times None: no maximum
            nonlocal n_prev_rules
            no_max = max_times is None
            if last_sym_start == len(rule):
                self.err("expecting preceding item to */+/?/{", pos)
            prev_rule = rule[last_sym_start:]
            total_rules = 1
            if not no_max and max_times > 0:
                total_rules = max_times
            elif min_times > 0:
                total_rules = min_times
            if n_prev_rules * total_rules >= MAX_REPETITION_THRESHOLD:
                self.err("number of rules that are going to be repeated multiplied by the new repetition "
                         "exceeds sane defaults", pos)
            if min_times == 0:
                del rule[last_sym_start:]
            else:
                for _ in range(1, min_times):
                    rule.extend(prev_rule)
            last_rec_rule_id = 0
            n_opt = 1 if no_max else max_times - min_times
            for i in range(n_opt):
                rec_rule = list(prev_rule)
                rec_rule_id = self.generate_symbol_id(rule_name)
                if i > 0 or no_max:
                    rec_rule.append((RULE_REF, rec_rule_id if no_max else last_rec_rule_id))
                rec_rule.append((ALT, 0))
                rec_rule.append((END, 0))
                self.add_rule(rec_rule_id, rec_rule)
                last_rec_rule_id = rec_rule_id
            if n_opt > 0:
                rule.append((RULE_REF, last_rec_rule_id))
            n_prev_rules *= total_rules

        while self.ch(pos) != "\0":
            c = self.ch(pos)
            if c == '"':
                pos += 1
                last_sym_start, n_prev_rules = len(rule), 1
                while self.ch(pos) != '"':
                    if self.ch(pos) == "\0":
                        self.err("unexpected end of input", pos)
                    cp, pos = self.parse_char(pos)
                    rule.append((CHAR, cp))
                pos = self.parse_space(pos + 1, is_nested)
            elif c == "[":
                pos += 1
                start_type = CHAR
                if self.ch(pos) == "^":
                    pos += 1
                    start_type = CHAR_NOT
                last_sym_start, n_prev_rules = len(rule), 1
                while self.ch(pos) != "]":
                    if self.ch(pos) == "\0":
                        self.err("unexpected end of input", pos)
                    cp, pos = self.parse_char(pos)
                    rule.append((CHAR_ALT if last_sym_start < len(rule) else start_type, cp))
                    if self.ch(pos) == "-" and self.ch(pos + 1) != "]":
                        if self.ch(pos + 1) == "\0":
                            self.err("unexpected end of input", pos)
                        cp2, pos = self.parse_char(pos + 1)
                        rule.append((CHAR_RNG_UPPER, cp2))
                pos = self.parse_space(pos + 1, is_nested)
            elif c in "<!":
                typ = TOKEN
                if c == "!":
                    typ = TOKEN_NOT
                    pos += 1
                tid, pos = self.parse_token(pos)
                last_sym_start, n_prev_rules = len(rule), 1
                rule.append((typ, tid))
                pos = self.parse_space(pos, is_nested)
            elif c in WORD:
                e = self.parse_name(pos)
                ref = self.get_symbol_id(self.src[pos:e])
                pos = self.parse_space(e, is_nested)
                last_sym_start, n_prev_rules = len(rule), 1
                rule.append((RULE_REF, ref))
            elif c == "(":
                pos = self.parse_space(pos + 1, True)
                n_rules_before = len(self.symbol_ids)
                sub = self.generate_symbol_id(rule_name)
                pos = self.parse_alternates(pos, rule_name, sub, True)
                n_prev_rules = max(1, len(self.symbol_ids) - n_rules_before)
                last_sym_start = len(rule)
                rule.append((RULE_REF, sub))
                if self.ch(pos) != ")":
                    self.err("expecting ')'", pos)
                pos = self.parse_space(pos + 1, is_nested)
            elif c == ".":
                last_sym_start, n_prev_rules = len(rule), 1
                rule.append((CHAR_ANY, 0))
                pos = self.parse_space(pos + 1, is_nested)
            elif c == "*":
                pos = self.parse_space(pos + 1, is_nested)
                handle_repetitions(0, None)
            elif c == "+":
                pos = self.parse_space(pos + 1, is_nested)
                handle_repetitions(1, None)
            elif c == "?":
                pos = self.parse_space(pos + 1, is_nested)
                handle_repetitions(0, 1)
            elif c == "{":
                pos = self.parse_space(pos + 1, is_nested)
                if self.ch(pos) not in DIGIT:
                    self.err("expecting an int", pos)
                e = self.parse_int(pos)
                min_times = int(self.src[pos:e])
                pos = self.parse_space(e, is_nested)
                max_times = None
                if self.ch(pos) == "}":
                    max_times = min_times
                    pos = self.parse_space(pos + 1, is_nested)
                elif self.ch(pos) == ",":
                    pos = self.parse_space(pos + 1, is_nested)
                    if self.ch(pos) in DIGIT:
                        e = self.parse_int(pos)
                        max_times = int(self.src[pos:e])
                        pos = self.parse_space(e, is_nested)
                    if self.ch(pos) != "}":
                        self.err("expecting '}'", pos)
                    pos = self.parse_space(pos + 1, is_nested)
                else:
                    self.err("expecting ','", pos)
                if min_times > MAX_REPETITION_THRESHOLD:
                    self.err("number of repetitions exceeds sane defaults", pos)
                if max_times is not None and max_times > MAX_REPETITION_THRESHOLD:
                    max_times = None
                handle_repetitions(min_times, max_times)
            else:
                break
        return pos

    def parse_alternates(self, pos: int, rule_name: str, rule_id: int, is_nested: bool) -> int:
        rule: list = []
        pos = self.parse_sequence(pos, rule_name, rule, is_nested)
        while self.ch(pos) == "|":
            rule.append((ALT, 0))
            pos = self.parse_space(pos + 1, True)
            pos = self.parse_sequence(pos, rule_name, rule, is_nested)
        rule.append((END, 0))
        self.add_rule(rule_id, rule)
        return pos

    def parse_rule(self, pos: int) -> int:
        e = self.parse_name(pos)
        name = self.src[pos:e]
        pos = self.parse_space(e, False)
        rid = self.get_symbol_id(name)
        if self.src[pos:pos + 3] != "::=":
            self.err("expecting ::=", pos)
        pos = self.parse_space(pos + 3, True)
        pos = self.parse_alternates(pos, name, rid, False)
        if self.ch(pos) == "\r":
            pos += 2 if self.ch(pos + 1) == "\n" else 1
        elif self.ch(pos) == "\n":
            pos += 1
        elif self.ch(pos) != "\0":
            self.err("expecting newline or end", pos)
        return self.parse_space(pos, True)

    def parse(self) -> None:
        pos = self.parse_space(0, True)
        while self.ch(pos) != "\0":
            pos = self.parse_rule(pos)
        names = {v: k for k, v in self.symbol_ids.items()}
        for rule in self.rules:
            if not rule:
                raise GrammarError("Undefined rule")
            for t, v in rule:
                if t == RULE_REF and (v >= len(self.rules) or not self.rules[v]):
                    raise GrammarError(f"Undefined rule identifier '{names.get(v, v)}'")


# =========================================================================== acceptor (llama_grammar_*)
class Grammar:
    """Flattened rules: a stack element is an index into self.t / self.v, like llama.cpp's element pointers."""

    def __init__(self, text: str, root: str = "root"):
        p = Parser(text)
        p.parse()
        if root not in p.symbol_ids:
            raise GrammarError(f"grammar does not contain a '{root}' symbol")
        self.n_rules = len(p.rules)
        self.n_user_rules = sum(1 for k in p.symbol_ids if not re.search(r"_\d+$", k))
        self.start: list[int] = []
        t, v = [], []
        for rule in p.rules:
            self.start.append(len(t))
            for typ, val in rule:
                t.append(typ)
                v.append(val)
        self.t, self.v = t, v
        self.check_left_recursion(p.rules)
        # char matchers: position -> (positive, ranges, position after the class)
        self.match: dict[int, tuple] = {}
        self.F: dict[int, frozenset] = {}
        self.E: dict[int, bool] = {}
        self._busy: set[int] = set()
        root_pos = self.start[p.symbol_ids[root]]
        stacks: set = set()
        pos = root_pos
        while True:
            stack = () if self.eos(pos) else (pos,)
            stacks |= self.advance(stack)
            while not self.eos(pos):
                pos += 1
            if t[pos] == ALT:
                pos += 1
            else:
                break
        self.init_stacks = frozenset(stacks)

    def eos(self, pos: int) -> bool:  # llama_grammar_is_end_of_sequence
        return self.t[pos] in (END, ALT)

    def check_left_recursion(self, rules) -> None:  # llama_grammar_detect_left_recursion
        n = len(rules)
        visited, in_progress, may_be_empty = [False] * n, [False] * n, [False] * n
        sys.setrecursionlimit(max(10000, sys.getrecursionlimit()))

        def detect(i: int) -> bool:
            if in_progress[i]:
                return True
            in_progress[i] = True
            rule = rules[i]
            at_start = True
            for typ, _ in rule:
                if typ in (END, ALT):
                    if at_start:
                        may_be_empty[i] = True
                        break
                    at_start = True
                else:
                    at_start = False
            recurse = True
            for typ, val in rule:
                if typ == RULE_REF and recurse:
                    if detect(val):
                        return True
                    if not may_be_empty[val]:
                        recurse = False
                elif typ in (END, ALT):
                    recurse = True
                else:
                    recurse = False
            in_progress[i] = False
            visited[i] = True
            return False

        for i in range(n):
            if not visited[i] and detect(i):
                raise GrammarError(f"unsupported grammar, left recursion detected for nonterminal at index {i}")

    def matcher(self, pos: int) -> tuple:  # precomputed llama_grammar_match_char
        m = self.match.get(pos)
        if m is None:
            t, v = self.t, self.v
            positive = t[pos] in (CHAR, CHAR_ANY)
            ranges, anyc, p = [], False, pos
            while True:
                if t[p + 1] == CHAR_RNG_UPPER:
                    ranges.append((v[p], v[p + 1]))
                    p += 2
                elif t[p] == CHAR_ANY:
                    anyc = True
                    p += 1
                else:
                    ranges.append((v[p], v[p]))
                    p += 1
                if t[p] != CHAR_ALT:
                    break
            ascii_set = frozenset(c for c in range(128) if anyc or any(lo <= c <= hi for lo, hi in ranges))
            m = (positive, anyc, tuple(ranges), ascii_set, p)
            self.match[pos] = m
        return m

    def accepts_char(self, pos: int, cp: int) -> tuple[bool, int]:
        positive, anyc, ranges, ascii_set, after = self.matcher(pos)
        if cp < 128:
            found = cp in ascii_set
        else:
            found = anyc or any(lo <= cp <= hi for lo, hi in ranges)
        return found == positive, after

    def closure(self, pos: int) -> tuple[frozenset, bool]:
        """F(pos): stack tails (bottom..top, top a terminal) that replace the frame at pos;
        E(pos): the rest of pos's sequence can match the empty string (the frame pops)."""
        if pos in self.F:
            return self.F[pos], self.E[pos]
        if pos in self._busy:
            raise GrammarError(f"left recursion through a nullable prefix at element {pos}")
        self._busy.add(pos)
        t, v = self.t, self.v
        typ = t[pos]
        if typ != RULE_REF:
            F, E = frozenset([(pos,)]), False
        else:
            c = None if self.eos(pos + 1) else pos + 1
            cont: list = []  # closure of the continuation, computed only if an alternative can be empty

            def after_rule():
                if not cont:
                    cont.append(self.closure(c) if c is not None else (frozenset(), True))
                return cont[0]

            out, E = set(), False
            sub = self.start[v[pos]]
            while True:
                if self.eos(sub):
                    Fc, Ec = after_rule()
                    out |= Fc
                    E = E or Ec
                else:
                    Fs, Es = self.closure(sub)
                    out |= {(c,) + tail for tail in Fs} if c is not None else Fs
                    if Es:
                        Fc, Ec = after_rule()
                        out |= Fc
                        E = E or Ec
                while not self.eos(sub):
                    sub += 1
                if t[sub] == ALT:
                    sub += 1
                else:
                    break
            F = frozenset(out)
        self._busy.discard(pos)
        self.F[pos], self.E[pos] = F, E
        return F, E

    def advance(self, stack: tuple) -> set:  # llama_grammar_advance_stack
        out: set = set()
        while stack:
            F, E = self.closure(stack[-1])
            base = stack[:-1]
            for tail in F:
                out.add(base + tail)
            if not E:
                return out
            stack = base
        out.add(())
        return out

    def run(self, text: str) -> dict:
        """Feed code points like llama_grammar_accept; report acceptance, failure point and stack counts."""
        stacks = self.init_stacks
        counts = []
        t = self.t
        for i, ch in enumerate(text):
            cp = ord(ch)
            new: set = set()
            for st in stacks:
                if not st:
                    continue
                top = st[-1]
                if t[top] in (TOKEN, TOKEN_NOT):
                    continue
                ok, after = self.accepts_char(top, cp)
                if ok:
                    nxt = st[:-1] if self.eos(after) else st[:-1] + (after,)
                    new |= self.advance(nxt)
            if not new:
                return {"ok": False, "pos": i, "char": ch, "why": f"unexpected character {ch!r}",
                        "expected": self.expected(stacks), "max_stacks": max(counts, default=len(stacks)),
                        "mean_stacks": statistics.fmean(counts) if counts else 0.0}
            stacks = new
            counts.append(len(stacks))
        ok = any(not st for st in stacks)
        res = {"ok": ok, "max_stacks": max(counts, default=0),
               "mean_stacks": statistics.fmean(counts) if counts else 0.0}
        if not ok:
            res.update(pos=len(text), char="", why="unexpected end of input", expected=self.expected(stacks))
        return res

    def expected(self, stacks) -> str:
        """Printable summary of the characters the grammar would accept next."""
        chars: set[str] = set()
        classes: set[str] = set()
        for st in stacks:
            if not st:
                chars.add("<end>")
                continue
            positive, anyc, ranges, _, _ = self.matcher(st[-1])
            if anyc or not positive or len(ranges) > 3 or any(hi - lo > 0 for lo, hi in ranges):
                classes.add(("" if positive else "^") + "".join(
                    chr(lo) if lo == hi else f"{chr(lo)}-{chr(hi)}" for lo, hi in ranges))
            else:
                chars.update(chr(lo) for lo, _ in ranges)
        out = sorted(repr(c) for c in chars) + sorted(f"[{c}]" for c in classes)
        return " ".join(out[:30]) + (" ..." if len(out) > 30 else "")


# =========================================================================== corpus
def fence(code: str) -> str:
    return "```openscad\n" + code + "\n```"


def load_accept_corpus(include_extra: bool = True) -> list[tuple[str, str, str]]:
    """(group, name, reply text)"""
    items = []
    groups = [("bench/reference", "bench/reference/*.scad"), ("bench/variants", "bench/variants/*.scad"),
              ("designs", "designs/**/*.scad"), ("finetune/seeds", "finetune/seeds/*.scad")]
    for g, pat in groups:
        for f in sorted(glob.glob(str(REPO / pat), recursive=True)):
            rel = os.path.relpath(f, REPO)
            items.append((g, rel, fence(pathlib.Path(f).read_text(encoding="utf-8"))))
    for g, pat in [("distill A (clean_shard*)", "clean_shard*.jsonl"),
                   ("distill B (clean_b_shard*)", "clean_b_shard*.jsonl"),
                   ("distill C (clean_c_shard*)", "clean_c_shard*.jsonl")]:
        for f in sorted(glob.glob(str(REPO / "finetune/rft/distill" / pat))):
            rel = os.path.relpath(f, REPO)
            for i, line in enumerate(pathlib.Path(f).read_text(encoding="utf-8").splitlines(), 1):
                if not line.strip():
                    continue
                msgs = json.loads(line)["messages"]
                reply = [m for m in msgs if m["role"] == "assistant"][-1]["content"]
                items.append((g, f"{rel}:{i}", reply))
    if include_extra:  # hand-written syntax tour (not part of the repo corpus counts)
        for f in sorted((HERE / "positives").glob("*.scad")):
            items.append(("+ grammar/positives (extra)", os.path.relpath(f, REPO),
                          fence(f.read_text(encoding="utf-8"))))
    return items


def load_negatives() -> list[tuple[str, str, int | str | None]]:
    """(name, reply, expected reply line of the rejection | "end" (at the closing fence) | None)"""
    out = []
    for f in sorted((HERE / "negatives").glob("*")):
        if f.suffix == ".scad":
            code = f.read_text(encoding="utf-8")
            text = fence(code)
        elif f.name.endswith(".reply.txt"):
            code = text = f.read_text(encoding="utf-8")
        else:
            continue
        m = re.search(r"expect-reject-line:\s*(\d+|end)", code)
        if not m:
            line = None
        elif m.group(1) == "end":
            line = "end"
        else:
            line = int(m.group(1)) + (1 if f.suffix == ".scad" else 0)  # +1: the fence line
        out.append((f.name, text, line))
    return out


def locate(text: str, pos: int) -> tuple[int, int, str]:
    line = text.count("\n", 0, pos) + 1
    col = pos - (text.rfind("\n", 0, pos) + 1) + 1
    return line, col, text.splitlines()[line - 1] if line - 1 < len(text.splitlines()) else ""


_G: Grammar | None = None


def _init(path: str) -> None:
    global _G
    _G = Grammar(pathlib.Path(path).read_text(encoding="utf-8"))


def _job(item):
    group, name, text = item
    t0 = time.time()
    r = _G.run(text)
    r["sec"] = time.time() - t0
    r["chars"] = len(text)
    return group, name, text, r


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--grammar", default=str(GRAMMAR))
    ap.add_argument("--file", nargs="*", help=".scad files to test (wrapped in a fence)")
    ap.add_argument("--reply", nargs="*", help="full replies to test as they are")
    ap.add_argument("--jobs", type=int, default=6)
    ap.add_argument("--report", default=str(HERE / "validation_report.txt"))
    ap.add_argument("--no-report", action="store_true")
    a = ap.parse_args()

    t0 = time.time()
    g = Grammar(pathlib.Path(a.grammar).read_text(encoding="utf-8"))
    t_parse = time.time() - t0

    if a.file or a.reply:
        _init(a.grammar)
        items = [("file", f, fence(pathlib.Path(f).read_text(encoding="utf-8"))) for f in a.file or []]
        items += [("reply", f, pathlib.Path(f).read_text(encoding="utf-8")) for f in a.reply or []]
        bad = 0
        for group, name, text in items:
            r = _G.run(text)
            if r["ok"]:
                print(f"ACCEPT {name}  (max stacks {r['max_stacks']})")
            else:
                bad += 1
                ln, col, src = locate(text, r["pos"])
                print(f"REJECT {name}: {r['why']} at reply line {ln} col {col}\n    {src}\n    "
                      f"{' ' * (col - 1)}^ expected: {r['expected']}")
        sys.exit(1 if bad else 0)

    lines: list[str] = []

    def out(s: str = "") -> None:
        print(s, flush=True)
        lines.append(s)

    gtext = pathlib.Path(a.grammar).read_text(encoding="utf-8")
    import hashlib
    out(f"validate.py report - {time.strftime('%Y-%m-%d %H:%M %Z')}")
    out(f"grammar: {os.path.relpath(a.grammar, REPO)}  sha256 {hashlib.sha256(gtext.encode()).hexdigest()}")
    out(f"parsed as llama.cpp does: {g.n_user_rules} named rules, {g.n_rules} rules after expanding groups and "
        f"repetitions; no left recursion; {len(g.init_stacks)} initial stacks; parse {t_parse:.2f} s")
    out()

    corpus = load_accept_corpus()
    negs = load_negatives()
    ctx = mp.get_context("fork")
    t1 = time.time()
    with ctx.Pool(a.jobs, initializer=_init, initargs=(a.grammar,)) as pool:
        res = pool.map(_job, corpus, chunksize=8)
        nres = pool.map(_job, [("neg", n, t) for n, t, _ in negs], chunksize=1)
    elapsed = time.time() - t1

    out("== ACCEPT: every file must parse")
    by_group: dict[str, list] = {}
    for group, name, text, r in res:
        by_group.setdefault(group, []).append((name, text, r))
    tot_ok = tot = extra_ok = extra = 0
    for group, rows in by_group.items():
        ok = sum(1 for _, _, r in rows if r["ok"])
        if group.startswith("+"):
            extra_ok += ok
            extra += len(rows)
        else:
            tot_ok += ok
            tot += len(rows)
        mx = max(r["max_stacks"] for _, _, r in rows)
        mean = statistics.fmean(r["mean_stacks"] for _, _, r in rows)
        if group.startswith("+"):
            out(f"  {'TOTAL (repo corpus)':30s} {tot_ok:5d} / {tot:<5d} accepted")
        out(f"  {group:30s} {ok:5d} / {len(rows):<5d} accepted   stacks per character: mean {mean:5.1f}, "
            f"max {mx}")
    for group, rows in by_group.items():
        for name, text, r in rows:
            if not r["ok"]:
                ln, col, src = locate(text, r["pos"])
                out(f"  REJECTED {name}: {r['why']} at reply line {ln} col {col}")
                out(f"      {src}")
                out(f"      {' ' * (col - 1)}^ expected: {r['expected']}")
    chars = sum(r["chars"] for _, _, _, r in res)
    out(f"  {chars} characters in {elapsed:.0f} s on {a.jobs} processes")
    worst = sorted(res, key=lambda x: -x[3]["max_stacks"])[:3]
    out("  most stacks: " + "; ".join(f"{n} ({r['max_stacks']})" for _, n, _, r in worst))
    out()

    out("== REJECT: every negative must fail (at the line it names, if it names one)")
    neg_ok = 0
    for (name, text, want_line), (_, _, _, r) in zip(negs, nres):
        if r["ok"]:
            out(f"  FAIL  {name}: accepted")
            continue
        ln, col, src = locate(text, r["pos"])
        at_fence = text.endswith("```") and r["pos"] >= len(text) - 3
        if want_line == "end":
            good = at_fence or r["pos"] >= len(text)
        else:
            good = want_line is None or ln == want_line
        neg_ok += good
        flag = "ok  " if good else "FAIL"
        if name.endswith(".scad"):
            where = "the closing fence" if at_fence else f"file line {ln - 1} col {col}"
        else:
            where = f"reply line {ln} col {col}"
        out(f"  {flag}  {name:34s} rejected at {where}: {r['why']}")
        out(f"        {src.strip()[:110]}")
        if not good:
            out(f"        expected the rejection on file line "
                f"{want_line if want_line == 'end' else want_line - 1}")
    out(f"  {neg_ok} / {len(negs)} negatives rejected where expected")
    out()
    out(f"RESULT: accept {tot_ok}/{tot} repo files and replies (+ {extra_ok}/{extra} extra), "
        f"reject {neg_ok}/{len(negs)} negatives")
    if not a.no_report:
        pathlib.Path(a.report).write_text("\n".join(lines) + "\n", encoding="utf-8")
    sys.exit(0 if tot_ok == tot and extra_ok == extra and neg_ok == len(negs) else 1)


if __name__ == "__main__":
    main()
