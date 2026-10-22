#!/usr/bin/env python3
"""scadfix - a conservative, rule-based repairer for the invalid OpenSCAD that small language models write.

    python scadfix.py in.scad > out.scad      # repaired file on stdout, the rules that fired on stderr
    from scadfix import fix                   # fix(code) -> (repaired code, names of the rules that fired)

Every rule is small, has a name, and rewrites one construct that OpenSCAD cannot parse - or, for Python's
True/False/None, math.* and range(), parses only as an unknown name that evaluates to undef: Python habits
(comments, operators, def, blocks, for ... in, list comprehensions, tuples, continue, membership), other
languages' list and range syntax, functions written as statement blocks with `return`, rotate() used on a
vector, geometry assigned to a variable (`rack = cube(...)`), prose left in the code, a missing semicolon, and -
as its own rule - a file cut off mid-reply. A rule looks only at code, never inside strings or comments, so a
valid file comes back unchanged (README.md: no rule fires on any of the repository's 2,124 verified files). The
rules run once each, in a fixed order, and never call OpenSCAD. Version 1.0 was frozen before its test run
(FROZEN.md).
"""
from __future__ import annotations

import functools
import re
import sys

VERSION = "1.0"

ID = r"[A-Za-z_][A-Za-z0-9_]*"
WS = r"[ \t\r\n]*"
KEYWORDS = {"module", "function", "if", "else", "for", "let", "each", "true", "false", "undef", "include", "use",
            "assert", "echo", "intersection_for", "return"}
# modules built into OpenSCAD that are not also functions, so `x = cube(...)` can only mean geometry
GEOMETRY = {"cube", "sphere", "cylinder", "polyhedron", "square", "circle", "polygon", "text", "import", "surface",
            "linear_extrude", "rotate_extrude", "translate", "rotate", "scale", "mirror", "multmatrix", "resize",
            "color", "offset", "hull", "minkowski", "union", "difference", "intersection", "render", "projection",
            "children", "for", "intersection_for"}
PRIMITIVES = {"cube", "sphere", "cylinder", "polyhedron", "square", "circle", "polygon", "text", "import", "surface"}
_PAIR = {")": "(", "]": "[", "}": "{"}
_BR = re.compile(r"[()\[\]{}]")
ERRORS: list = []  # (rule, exception) for rules that failed on odd input and were skipped


# --------------------------------------------------------------------------- lexing helpers

_HASH_MODIFIER = re.compile(r"[ \t]*(?:[!#%*][ \t]*)*[A-Za-z_$][A-Za-z0-9_$]*[ \t]*\(")
_SPECIAL = re.compile(r'["/#]')
_STRING = re.compile(r'"(?:[^"\\]|\\.)*(?:"|\Z)', re.S)


@functools.lru_cache(maxsize=1024)
def _scan(code: str) -> tuple:
    """Spans (kind, start, end) of strings ('str'), comments ('com') and Python-style '#' comments ('hash').
    A '#' that starts a module instantiation is OpenSCAD's debug modifier and stays code."""
    spans, i, n = [], 0, len(code)
    while True:
        t = _SPECIAL.search(code, i)
        if not t:
            break
        i, c = t.start(), t.group()
        if c == '"':
            j = _STRING.match(code, i).end()
            spans.append(("str", i, j))
        elif code.startswith("//", i):
            j = code.find("\n", i)
            j = n if j < 0 else j
            spans.append(("com", i, j))
        elif code.startswith("/*", i):
            j = code.find("*/", i + 2)
            j = n if j < 0 else j + 2
            spans.append(("com", i, j))
        elif c == "#" and not _HASH_MODIFIER.match(code, i + 1):
            j = code.find("\n", i)
            j = n if j < 0 else j
            spans.append(("hash", i, j))
        else:
            j = i + 1
        i = j
    return tuple(spans)


@functools.lru_cache(maxsize=1024)
def _mask(code: str) -> str:
    """The code with comment text and string contents blanked (same length, newlines kept), so that patterns
    match code only. String quotes stay, so a string still reads as one operand."""
    out, last = [], 0
    for kind, a, b in _scan(code):
        lo, hi = (a + 1, b - 1 if b - a >= 2 and code[b - 1] == '"' else b) if kind == "str" else (a, b)
        out += [code[last:lo], re.sub(r"[^\n]", " ", code[lo:hi])]
        last = hi
    out.append(code[last:])
    return "".join(out)


def _uncommented(code: str, a: int, b: int) -> str:
    """code[a:b] with its comments replaced by a space (strings kept), for moving a piece of code elsewhere."""
    out, last = [], a
    for kind, s, e in _scan(code):
        if kind != "str" and s < b and e > a:
            out += [code[last:max(s, a)], " "]
            last = min(e, b)
    out.append(code[last:b])
    return "".join(out)


def _close(m: str, i: int) -> int:
    """Index of the bracket that closes the one at m[i], or -1 (never closed, or closed by the wrong kind)."""
    stack = []
    for t in _BR.finditer(m, i):
        c = t.group()
        if c in "([{":
            stack.append(c)
        elif not stack or stack.pop() != _PAIR[c]:
            return -1
        elif not stack:
            return t.start()
    return -1


def _open_of(m: str, i: int) -> int:
    """Index of the bracket that the one at m[i] closes, or -1."""
    depth = 0
    for j in range(i, -1, -1):
        c = m[j]
        if c in ")]}":
            depth += 1
        elif c in "([{":
            depth -= 1
            if depth == 0:
                return j if _PAIR[m[i]] == c else -1
    return -1


def _enclosing(m: str, i: int) -> int:
    """Index of the innermost open bracket around position i, or -1 at the top level."""
    depth = 0
    for j in range(i - 1, -1, -1):
        c = m[j]
        if c in ")]}":
            depth += 1
        elif c in "([{":
            if depth == 0:
                return j
            depth -= 1
    return -1


def _top(m: str, a: int, b: int, pattern: str) -> list:
    """Matches of `pattern` in m[a:b] that start at bracket depth 0 (relative to a)."""
    out, depth, rx, i = [], 0, re.compile(pattern), a
    while i < b:
        c = m[i]
        if c in "([{":
            depth += 1
        elif c in ")]}":
            depth -= 1
            if depth < 0:
                break
        if depth == 0:
            t = rx.match(m, i)
            if t and t.end() <= b and t.end() > i:
                out.append(t)
                i = t.end()
                continue
        i += 1
    return out


def _skip(m: str, i: int) -> int:
    while i < len(m) and m[i] in " \t\r\n":
        i += 1
    return i


def _back(m: str, i: int) -> int:
    """Index of the last non-blank character before i, or -1."""
    i -= 1
    while i >= 0 and m[i] in " \t\r\n":
        i -= 1
    return i


def _word_before(m: str, j: int) -> str:
    """The identifier that ends at index j (inclusive), or '' (also when it follows a '.')."""
    if j < 0 or not (m[j].isalnum() or m[j] in "_$"):
        return ""
    i = j
    while i > 0 and (m[i - 1].isalnum() or m[i - 1] in "_$"):
        i -= 1
    return "" if i > 0 and m[i - 1] == "." else m[i:j + 1]


def _openers(m: str, positions: list) -> list:
    """Index of the innermost open bracket at each of the sorted positions (-1 at the top level), in one pass."""
    out, stack, it = [], [], _BR.finditer(m)
    t = next(it, None)
    for p in positions:
        while t is not None and t.start() < p:
            if t.group() in "([{":
                stack.append(t.start())
            elif stack:
                stack.pop()
            t = next(it, None)
        out.append(stack[-1] if stack else -1)
    return out


def _apply(code: str, edits: list) -> str:
    out, last = [], 0
    for a, b, s in sorted(edits, key=lambda e: (e[0], e[1])):
        if a < last:
            raise ValueError("overlapping edits")
        out += [code[last:a], s]
        last = b
    out.append(code[last:])
    return "".join(out)


def _defined(m: str, name: str) -> bool:
    """`name` is defined in the file (masked text) as a variable, a function or a module."""
    n = re.escape(name)
    return bool(re.search(rf"(?<![\w$.]){n}\s*=(?!=)|(?<![\w$.])(?:function|module)\s+{n}\b", m))


def _balanced(s: str) -> bool:
    depth = 0
    for c in s:
        depth += c in "([{"
        depth -= c in ")]}"
        if depth < 0:
            return False
    return depth == 0


def _indent(s: str) -> int:
    return len(s) - len(s.lstrip(" \t"))


def _lines(m: str):
    """Lines of the masked text and the offset where each starts."""
    lines, starts = m.split("\n"), [0]
    for ln in lines[:-1]:
        starts.append(starts[-1] + len(ln) + 1)
    return lines, starts


# --------------------------------------------------------------------------- rules: text that is not code

_PROSE = re.compile(r"[ \t]*(?:[-*+>][ \t]+|\d{1,2}[.)][ \t]+)?(?:\*\*|__)?[A-Z][^\n]*[.:!?][ \t]*")
_NOT_PROSE_START = KEYWORDS | {"and", "or", "not", "def", "elif", "while", "import", "from", "class", "pass"}


def prose_lines(code: str) -> str:
    """A line of plain sentences left in the code ("Here is the code for the rack:") becomes a // comment: it starts
    with a capital letter, ends like a sentence, holds at least four words and no code characters."""
    m = _mask(code)
    lines, starts = _lines(m)
    edits = []
    for ln, pos in zip(lines, starts):
        body = re.sub(r"\*\*|__", "", ln[re.match(r"[ \t]*(?:[-*+>][ \t]+|\d{1,2}[.)][ \t]+)?", ln).end():])
        if (_PROSE.fullmatch(ln) and not re.search(r"[=;{}\[\]<>*/+%^&|]|\w\(", body)
                and len(re.findall(r"[A-Za-z]{2,}", body)) >= 4
                and ln.split()[0].lower().strip(".:,") not in _NOT_PROSE_START):
            k = pos + _indent(ln)
            edits.append((k, k, "// "))
    return _apply(code, edits) if edits else code


def python_comments(code: str) -> str:
    """A Python '#' comment becomes '//' (a '#' that starts a module call is OpenSCAD's modifier and stays)."""
    edits = [(a, a + 1, "//") for kind, a, _ in _scan(code) if kind == "hash"]
    return _apply(code, edits) if edits else code


def close_truncated(code: str) -> str:
    """A file cut off mid-reply - brackets still open at the end, or an unclosed comment or string - is cut back to
    its last complete statement and the blocks still open there are closed with braces. Not used when a ( or [
    left open is followed by complete statements (a missing bracket inside the file, not a cut-off end)."""
    m = _mask(code)
    open_end = any((kind == "com" and code.startswith("/*", a) and not code[a:b].endswith("*/")) or
                   (kind == "str" and (b - a < 2 or code[b - 1] != '"')) for kind, a, b in _scan(code))
    stack, safe, safe_depth = [], 0, 0
    for t in re.finditer(r"[()\[\]{};]", m):
        c, i = t.group(), t.start()
        if c in "([{":
            stack.append((c, i))
            continue
        if c != ";":
            if not stack or stack.pop()[0] != _PAIR[c]:
                return code  # mismatched brackets: a different error, not a cut-off file
            if c != "}":
                continue
        if all(s == "{" for s, _ in stack):
            safe, safe_depth = i + 1, len(stack)
    if not stack and not open_end:
        return code
    first_paren = next((i for s, i in stack if s != "{"), None)
    if first_paren is not None and ";" in m[first_paren:]:
        return code
    head = code[:safe].rstrip()
    if not head.strip():
        return code
    return head + "".join("\n" + "    " * k + "}" for k in reversed(range(safe_depth))) + "\n"


_UNICODE = {"\u2212": "-", "\u2013": "-", "\u00d7": "*", "\u00f7": "/", "\u2264": "<=", "\u2265": ">=",
            "\u2260": "!="}  # minus, en dash, times, divide, <=, >=, != (OpenSCAD rejects them as identifiers)


def unicode_operators(code: str) -> str:
    """Typographic operators in code (U+2212 minus, the en dash, the times and division signs, <=, >=, !=) become
    ASCII."""
    m = _mask(code)
    edits = [(t.start(), t.end(), _UNICODE[t.group()]) for t in re.finditer("[" + "".join(_UNICODE) + "]", m)]
    return _apply(code, edits) if edits else code


# --------------------------------------------------------------------------- rules: Python habits

def python_import(code: str) -> str:
    """A Python `import math` or `from x import y` line becomes a comment."""
    m = _mask(code)
    lines, starts = _lines(m)
    edits = []
    for ln, pos in zip(lines, starts):
        if re.fullmatch(r"[ \t]*(?:import[ \t]+[A-Za-z_][\w.]*(?:[ \t]+as[ \t]+\w+)?|"
                        r"from[ \t]+[\w.]+[ \t]+import[ \t]+[\w, *]+)[ \t]*;?[ \t]*", ln):
            k = pos + _indent(ln)
            edits.append((k, k, "// "))
    return _apply(code, edits) if edits else code


def python_literals(code: str) -> str:
    """Python's True, False and None become true, false and undef (as in center=True)."""
    m = _mask(code)
    edits = []
    for word, new in (("True", "true"), ("False", "false"), ("None", "undef")):
        if not _defined(m, word):
            edits += [(t.start(), t.end(), new) for t in re.finditer(rf"(?<![\w$.]){word}(?![\w$(])", m)]
    return _apply(code, edits) if edits else code


def python_operators(code: str) -> str:
    """Python's `and`, `or`, `not`, `is None`, `is not None` and `**` become &&, ||, !, == undef, != undef and ^."""
    m = _mask(code)
    edits = []
    if not _defined(m, "and") and not _defined(m, "or"):
        for t in re.finditer(r"(?<=[\w)\]\"'])([ \t]+)(and|or)([ \t]+)(?=[\w(\[\"!+\-.$])", m):
            if re.search(r"(?<![\w$.])(?:and|or)$", m[:t.start(1)]):
                continue
            edits.append((t.start(2), t.end(2), "&&" if t.group(2) == "and" else "||"))
    if not _defined(m, "not"):
        for t in re.finditer(r"(?<![\w$.])not[ \t]+(?=[\w(\[!$])", m):
            if re.match(r"in\b", m[t.end():t.end() + 3]):
                continue
            j = _back(m, t.start())
            if j < 0 or m[j] in "(=,[?:!&|" or _word_before(m, j) in ("if", "elif", "return", "and", "or",
                                                                       "while"):
                edits.append((t.start(), t.end(), "!"))
    for t in re.finditer(r"(?<![\w$.])is[ \t]+(not[ \t]+)?(?=None\b)", m):
        edits.append((t.start(), t.end(), "!= " if t.group(1) else "== "))
    edits += [(t.start(), t.end(), "^") for t in re.finditer(r"\*\*", m)]
    return _apply(code, edits) if edits else code


_MATH_SAME = {"sqrt": "sqrt", "pow": "pow", "floor": "floor", "ceil": "ceil", "fabs": "abs", "exp": "exp",
              "log10": "log"}


def python_math(code: str) -> str:
    """Python's math module: math.pi -> PI, math.sqrt -> sqrt and the like, and its radian trigonometry made exact
    in OpenSCAD's degrees: math.sin(x) -> sin((x) * 180 / PI), math.atan2(y, x) -> (atan2(y, x) * PI / 180),
    math.radians(x) -> ((x) * PI / 180)."""
    for _ in range(20):  # nested calls (math.sin(math.radians(a))): rewrite the outermost, then again
        m = _mask(code)
        if _defined(m, "math") or not re.search(r"(?<![\w$.])math\.", m):
            return code
        edits, last = [], -1
        for t in re.finditer(r"(?<![\w$.])math\.(\w+)", m):
            f, a = t.group(1), t.start()
            if a < last:
                continue
            new = None
            if f == "pi":
                new, end = "PI", t.end()
            elif f == "tau":
                new, end = "(2 * PI)", t.end()
            else:
                p = _skip(m, t.end())
                q = _close(m, p) if p < len(m) and m[p] == "(" else -1
                if q < 0:
                    continue
                args, end = _uncommented(code, p + 1, q).strip(), q + 1
                if f in _MATH_SAME:
                    new = _MATH_SAME[f] + code[t.end():end]
                elif f == "log" and not _top(m, p + 1, q, ","):
                    new = "ln" + code[t.end():end]
                elif f in ("sin", "cos", "tan"):
                    new = f"{f}(({args}) * 180 / PI)"
                elif f in ("asin", "acos", "atan", "atan2"):
                    new = f"({f}({args}) * PI / 180)"
                elif f == "radians":
                    new = f"(({args}) * PI / 180)"
                elif f == "degrees":
                    new = f"(({args}) * 180 / PI)"
            if new is not None:
                edits.append((a, end, new))
                last = end
        if not edits:
            return code
        code = _apply(code, edits)
    return code


def python_def(code: str) -> str:
    """A one-expression Python function, `def f(x): return e` (the return on the same line or on the next, indented
    line), becomes `function f(x) = e;`."""
    m = _mask(code)
    lines, starts = _lines(m)
    head = re.compile(rf"([ \t]*)def[ \t]+({ID})[ \t]*\(([^()]*)\)[ \t]*(?:->[^:]*)?:[ \t]*(.*?)[ \t]*")
    ret = re.compile(r"[ \t]*return[ \t]+(.+?)[ \t]*;?[ \t]*")
    edits = []
    for k, ln in enumerate(lines):
        t = head.fullmatch(ln)
        if not t:
            continue
        ind = len(t.group(1))
        params = [re.sub(r"^\s*(\w+)\s*:\s*[\w.\[\], ]+?(\s*=|$)", r"\1\2", p).strip()
                  for p in code[starts[k] + t.start(3):starts[k] + t.end(3)].split(",")]
        if t.group(4):
            r, rk, base = ret.fullmatch(t.group(4)), k, starts[k] + t.start(4)
        else:
            rk = next((j for j in range(k + 1, len(lines)) if lines[j].strip()), None)
            if rk is None or _indent(lines[rk]) <= ind:
                continue
            after = next((j for j in range(rk + 1, len(lines)) if lines[j].strip()), None)
            if after is not None and _indent(lines[after]) > ind:
                continue  # a longer body: not a one-expression function
            r, base = ret.fullmatch(lines[rk]), starts[rk]
        if not r:
            continue
        expr = code[base + r.start(1):base + r.end(1)]
        edits.append((starts[k] + ind, starts[rk] + len(lines[rk]),
                      f"function {t.group(2)}({', '.join(p for p in params if p)}) = {expr};"))
    return _apply(code, edits) if edits else code


_BLOCK_HEAD = re.compile(rf"([ \t]*)(?:(for)[ \t]+({ID})[ \t]+in[ \t]+(.+?)|(if|elif|while)[ \t]+(.+?)|(else))"
                         r"[ \t]*:[ \t]*")


def python_blocks(code: str) -> str:
    """Python blocks - a header ending in a colon, its body set off by indentation - become braces:
    `for i in X:` -> `for (i = X) {`, `if c:` -> `if (c) {`, `elif c:` -> `else if (c) {`, `else:` -> `else {`."""
    m = _mask(code)
    lines, starts = _lines(m)
    heads, ctx = {}, None
    for k, ln in enumerate(lines):
        t = _BLOCK_HEAD.fullmatch(ln)
        if t and t.group(5) != "while" and _balanced(t.group(4) or t.group(6) or ""):
            ctx = ctx or _openers(m, starts)
            if ctx[k] < 0 or m[ctx[k]] == "{":
                heads[k] = t  # a header at statement level, not a line inside ( ) or [ ]
    if not heads:
        return code
    edits = []
    for k, t in heads.items():
        ind = len(t.group(1))
        j, last = k + 1, None
        while j < len(lines) and (not lines[j].strip() or _indent(lines[j]) > ind):
            if lines[j].strip():
                last = j
            j += 1
        if last is None:
            return code  # a header without a body: leave the file alone
        if t.group(2):
            new = f"for ({t.group(3)} = {code[starts[k] + t.start(4):starts[k] + t.end(4)].strip()}) {{"
        elif t.group(5) == "if":
            new = f"if ({code[starts[k] + t.start(6):starts[k] + t.end(6)].strip()}) {{"
        elif t.group(5) == "elif":
            new = f"else if ({code[starts[k] + t.start(6):starts[k] + t.end(6)].strip()}) {{"
        else:
            new = "else {"
        edits.append((starts[k] + ind, starts[k] + len(lines[k].rstrip()), new))
        end = starts[last] + len(lines[last])
        edits.append((end, end, "\n" + " " * ind + "}"))
    # several blocks can end on the same line: join their closing braces, innermost first
    merged = {}
    for a, b, s in edits:
        if a == b and s.lstrip("\n").strip() == "}":
            merged.setdefault(a, []).append(s)
        else:
            merged.setdefault((a, b), s)
    out = []
    for key, val in merged.items():
        if isinstance(key, tuple):
            out.append((key[0], key[1], val))
        else:
            out.append((key, key, "".join(sorted(val, key=len, reverse=True))))
    return _apply(code, out)


def python_for_in(code: str) -> str:
    """`for (i in X)` becomes `for (i = X)`."""
    m = _mask(code)
    edits = [(t.start(1), t.end(1), " = ")
             for t in re.finditer(rf"(?<![\w$.])for[ \t]*\([ \t]*{ID}([ \t]+in[ \t]+)", m)]
    return _apply(code, edits) if edits else code


def python_comprehension(code: str) -> str:
    """A Python list comprehension, `[e for i in X if c]` (also written `for i = X`), becomes OpenSCAD's
    `[for (i = X) if (c) e]`."""
    for _ in range(10):  # nested comprehensions: the outer one first, then the ones it holds
        m = _mask(code)
        edits = []
        for t in re.finditer(r"\[", m):
            a = t.start()
            if any(e[0] <= a < e[1] for e in edits) or _is_index(m, a):
                continue
            b = _close(m, a)
            if b < 0:
                continue
            fors = _top(m, a + 1, b, rf"(?<=[\s)\]])for[ \t\r\n]+(?={ID}{WS}(?:in\b|=(?!=)))")
            if not fors or not m[a + 1:fors[0].start()].strip() or _top(m, a + 1, fors[0].start(), ","):
                continue
            clauses, cond, ok = [], None, True
            bounds = [f.start() for f in fors] + [b]
            for k, f in enumerate(fors):
                v = re.compile(rf"{WS}({ID}){WS}(?:in\b|=(?!=)){WS}").match(m, f.end())
                ifs = _top(m, v.end(), bounds[k + 1], r"(?<=[\s)\]])if\b") if v else []
                if ifs and k < len(fors) - 1:
                    ok = False
                it = _uncommented(code, v.end(), ifs[0].start() if ifs else bounds[k + 1]).strip() if v else ""
                if not it:
                    ok = False
                    break
                clauses.append(f"for ({v.group(1)} = {it})")
                if ifs:
                    cond = _uncommented(code, ifs[0].end(), bounds[k + 1]).strip()
                    ok = ok and bool(cond)
            if not ok:
                continue
            expr = _uncommented(code, a + 1, fors[0].start()).strip()
            edits.append((a, b + 1, "[" + " ".join(clauses) + (f" if ({cond})" if cond else "") + " " + expr + "]"))
        if not edits:
            return code
        code = _apply(code, edits)
    return code


def _is_index(m: str, a: int) -> bool:
    """The '[' at a indexes a value (`v[0]`, `f(x)[1]`) rather than opening a list."""
    j = _back(m, a)
    return j >= 0 and (m[j] in ")]\"$" or m[j].isalnum() or m[j] == "_") and \
        _word_before(m, j) not in ("return", "each", "else", "in")


def pipe_comprehension(code: str) -> str:
    """A set-builder list, `[e | i = X]` (also `| i in X`, and an optional `if c` after X), becomes OpenSCAD's
    `[for (i = X) if (c) e]`."""
    m = _mask(code)
    edits = []
    for t in re.finditer(r"\[", m):
        a = t.start()
        if any(e[0] <= a < e[1] for e in edits) or _is_index(m, a):
            continue
        b = _close(m, a)
        bars = _top(m, a + 1, b, r"(?<!\|)\|(?!\|)") if b > 0 else []
        if len(bars) != 1:
            continue
        v = re.compile(rf"{WS}({ID}){WS}(?:in\b|=(?!=)|<-){WS}").match(m, bars[0].end())
        expr = _uncommented(code, a + 1, bars[0].start()).strip()
        if not v or not expr or _top(m, a + 1, bars[0].start(), ","):
            continue
        ifs = _top(m, v.end(), b, r"(?<=[\s)\]])if\b")
        it = _uncommented(code, v.end(), ifs[0].start() if ifs else b).strip()
        cond = _uncommented(code, ifs[0].end(), b).strip() if ifs else None
        if len(ifs) > 1 or not it or _top(m, v.end(), b, r",|(?<![\w$.])for\b") or (ifs and not cond):
            continue
        if cond and cond.startswith("(") and _close(_mask(cond), 0) == len(cond) - 1:
            cond = cond[1:-1].strip()
        edits.append((a, b + 1, f"[for ({v.group(1)} = {it})" + (f" if ({cond})" if cond else "") + f" {expr}]"))
    return _apply(code, edits) if edits else code


def bracketless_comprehension(code: str) -> str:
    """A comprehension written without its brackets, `xs = for (i = [0 : 3]) i * 10;`, becomes
    `xs = [for (i = [0 : 3]) i * 10];` (not when the loop makes shapes, which geometry_as_value handles)."""
    m = _mask(code)
    edits = []
    for t in re.finditer(rf"(?<![\w$.])\$?{ID}{WS}=(?!=){WS}(for{WS}\()", m):
        if not _statement_start(m, t.start()):
            continue
        p = t.end() - 1
        q = _close(m, p)
        if q < 0:
            continue
        k = _skip(m, q + 1)
        h = re.compile(rf"(?:[!#%*][ \t]*)*({ID}){WS}\(").match(m, k)
        mods = GEOMETRY | {u.group(1) for u in re.finditer(rf"(?<![\w$.])module{WS}({ID}){WS}\(", m)}
        if h and h.group(1) in mods:
            continue  # a module chain: geometry
        semi = _top(m, k, len(m), ";")
        if not semi or not m[k:semi[0].start()].strip():
            continue
        e = len(m[:semi[0].start()].rstrip())
        edits += [(t.start(1), t.start(1), "["), (e, e, "]")]
    return _apply(code, edits) if edits else code


def comprehension_let(code: str) -> str:
    """An assignment written inside a list comprehension, `[for (i = X) r = f(i); [r, 0]]`, becomes a let():
    `[for (i = X) let(r = f(i)) [r, 0]]`."""
    m = _mask(code)
    edits = []
    found = list(re.finditer(r"(?<![\w$.])for[ \t\r\n]*\(", m))
    for t, j in zip(found, _openers(m, [t.start() for t in found])):
        if j < 0 or m[j] != "[":
            continue
        q = _close(m, t.end() - 1)
        end = _close(m, j)
        if q < 0 or end < 0:
            continue
        i = q + 1
        while True:
            v = re.compile(rf"{WS}(\$?{ID}){WS}=(?!=)").match(m, i)
            if not v or v.group(1) in KEYWORDS:
                break
            semi = _top(m, v.end(), end, ";")
            if not semi:
                break
            s0 = _skip(m, v.start())
            edits.append((s0, semi[0].end(), f"let({v.group(1)} = {_uncommented(code, v.end(), semi[0].start()).strip()})"))
            i = semi[0].end()
    return _apply(code, edits) if edits else code


def list_semicolons(code: str) -> str:
    """A ';' used to separate the elements of a list, `[for (i = X) a; for (i = X) b;]`, becomes ',' (or is dropped
    before the closing ']'): a ';' directly inside [ ] cannot be valid OpenSCAD."""
    m = _mask(code)
    stack, inside, broken = [], [], set()
    for t in re.finditer(r"[()\[\]{};]", m):
        c = t.group()
        if c in "([{":
            stack.append((c, t.start()))
        elif c == ";":
            if stack and stack[-1][0] == "[":
                inside.append((t.start(), stack[-1][1]))
        elif not stack or stack.pop()[0] != _PAIR[c]:
            return code  # mismatched brackets: not a list problem
    broken = {i for _, i in stack}  # a '[' never closed: a broken file, not a list
    edits = []
    for pos, opener in inside:
        if opener in broken:
            continue
        k = _skip(m, pos + 1)
        edits.append((pos, pos + 1, "" if k < len(m) and m[k] == "]" else ","))
    return _apply(code, edits) if edits else code


def rotate_vector(code: str) -> str:
    """rotate() applied to a vector inside an expression, `rotate(a) [x, y]` or `rotate([0, 0, a]) [x, y, z]` - a
    module used as a function - becomes the rotation itself: `(let(scadfix_a = a) [[cos(scadfix_a),
    -sin(scadfix_a)], [sin(scadfix_a), cos(scadfix_a)]] * [x, y])`. Only rotations about Z, only 2- or 3-vectors."""
    m = _mask(code)
    if _defined(m, "rotate"):
        return code
    edits = []
    found = list(re.finditer(r"(?<![\w$.])rotate[ \t\r\n]*\(", m))
    for t, j in zip(found, _openers(m, [t.start() for t in found])):
        if j < 0 or m[j] not in "[(" or any(e[0] <= t.start() < e[1] for e in edits):
            continue
        p = t.end() - 1
        q = _close(m, p)
        k = _skip(m, q + 1) if q > 0 else -1
        if k < 0 or k >= len(m) or m[k] != "[":
            continue
        r = _close(m, k)
        if r < 0:
            continue
        ncomp = len(_top(m, k + 1, r, ",")) + 1
        if ncomp not in (2, 3):
            continue
        arg = _uncommented(code, p + 1, q).strip()
        am = _mask(arg)
        named = re.fullmatch(rf"a{WS}=(?!=){WS}(.+)", am, re.S)
        if named:
            arg, am = arg[named.start(1):].strip(), am[named.start(1):].strip()
        if am.startswith("["):
            parts = [x.strip() for x in _split_top(arg)]
            if not (am.endswith("]") and _close(am, 0) == len(am) - 1 and len(parts) == 3
                    and re.fullmatch(r"[-+]?0+(?:\.0*)?", parts[0]) and re.fullmatch(r"[-+]?0+(?:\.0*)?", parts[1])):
                continue
            ang = parts[2]
        elif _top(am, 0, len(am), ","):
            continue
        else:
            ang = arg
        v = _uncommented(code, k, r + 1)
        a_ = "scadfix_a"
        if ncomp == 2:
            mat = f"[[cos({a_}), -sin({a_})], [sin({a_}), cos({a_})]]"
        else:
            mat = f"[[cos({a_}), -sin({a_}), 0], [sin({a_}), cos({a_}), 0], [0, 0, 1]]"
        edits.append((t.start(), r + 1, f"(let({a_} = {ang}) {mat} * {v})"))
    return _apply(code, edits) if edits else code


def _split_top(vec: str) -> list:
    """The top-level elements of a vector literal '[a, b, c]'."""
    mv = _mask(vec)
    cuts = [0] + [c.start() for c in _top(mv, 1, len(mv) - 1, ",")] + [len(mv) - 1]
    return [vec[cuts[i] + 1:cuts[i + 1]] for i in range(len(cuts) - 1)]


def python_in(code: str) -> str:
    """Python's membership test as an if condition, `if (x in L)` / `if (x not in L)`, becomes
    `if (len([for (scadfix_e = L) if (scadfix_e == x) 0]) > 0)` (`== 0` for not in)."""
    m = _mask(code)
    if _defined(m, "in"):
        return code
    edits = []
    for t in re.finditer(r"(?<![\w$.])if[ \t\r\n]*\(", m):
        p = t.end() - 1
        q = _close(m, p)
        ins = _top(m, p + 1, q, r"(?<=[\s)\]])(not[ \t]+)?in(?=[\s(\[])") if q > 0 else []
        if len(ins) != 1 or _top(m, p + 1, q, r"&&|\|\||\?"):
            continue
        x = _uncommented(code, p + 1, ins[0].start()).strip()
        lst = _uncommented(code, ins[0].end(), q).strip()
        if not x or not lst:
            continue
        op = "== 0" if ins[0].group(1) else "> 0"
        edits.append((p + 1, q, f"len([for (scadfix_e = {lst}) if (scadfix_e == {_paren_any(x)}) 0]) {op}"))
    return _apply(code, edits) if edits else code


def _paren_any(e: str) -> str:
    return e if re.fullmatch(r"[\w$.]+", e) else f"({e})"


def python_range(code: str) -> str:
    """Python's range(n), range(a, b) and range(a, b, s) become [0 : n - 1], [a : b - 1] and [a : s : b - 1]."""
    m = _mask(code)
    if _defined(m, "range"):
        return code
    edits = []
    for t in re.finditer(r"(?<![\w$.])range[ \t]*\(", m):
        p = t.end() - 1
        q = _close(m, p)
        if q < 0 or any(e[0] <= t.start() < e[1] for e in edits):
            continue
        cuts = [p] + [c.start() for c in _top(m, p + 1, q, ",")] + [q]
        args = [_uncommented(code, cuts[k] + 1, cuts[k + 1]).strip() for k in range(len(cuts) - 1)]
        if not all(args) or len(args) > 3 or "range" in m[p:q]:
            continue
        args = [f"({x})" if re.search(r"[?<>=!&|]", x) else x for x in args]
        if len(args) == 1:
            new = f"[0 : {args[0]} - 1]"
        elif len(args) == 2:
            new = f"[{args[0]} : {args[1]} - 1]"
        else:
            new = f"[{args[0]} : {args[2]} : {args[1]} - 1]"
        edits.append((t.start(), q + 1, new))
    return _apply(code, edits) if edits else code


def dotdot_range(code: str) -> str:
    """A range written with two dots, `[a..b]` or `for (i = a..b)`, becomes OpenSCAD's `[a : b]`."""
    m = _mask(code)
    edits = []
    found = list(re.finditer(r"[ \t]*(?<!\.)\.\.(?!\.)[ \t]*", m))
    for t, j in zip(found, _openers(m, [t.start() for t in found])):
        if j < 0:
            continue
        k = _close(m, j)
        if k < 0:
            continue
        if m[j] == "[" and len(_top(m, j + 1, k, r"\.\.")) == 1 and not _top(m, j + 1, k, r"[,:]|(?<![\w$.])for\b"):
            edits.append((t.start(), t.end(), " : "))
        elif m[j] == "(" and _word_before(m, _back(m, j)) == "for":
            cuts = [j] + [c.start() for c in _top(m, j + 1, k, ",")] + [k]
            for s, e in zip(cuts, cuts[1:]):
                v = re.compile(rf"{WS}\$?{ID}{WS}=(?!=){WS}").match(m, s + 1)
                if s < t.start() < e and v and len(_top(m, v.end(), e, r"\.\.")) == 1 \
                        and not _top(m, v.end(), e, r"[:?,]"):
                    end = len(m[:e].rstrip())
                    edits += [(v.end(), v.end(), "["), (t.start(), t.end(), " : "), (end, end, "]")]
    return _apply(code, edits) if edits else code


def range_brackets(code: str) -> str:
    """A for-loop range written without its brackets, `for (i = 0 : n - 1)`, becomes `for (i = [0 : n - 1])`."""
    m = _mask(code)
    edits = []
    for t in re.finditer(r"(?<![\w$.])for[ \t]*\(", m):
        p = t.end() - 1
        q = _close(m, p)
        if q < 0:
            continue
        cuts = [p] + [c.start() for c in _top(m, p + 1, q, ",")] + [q]
        for s, e in zip(cuts, cuts[1:]):
            v = re.compile(rf"{WS}\$?{ID}{WS}=(?!=){WS}").match(m, s + 1)
            if not v or v.end() >= e or m[v.end()] == "[":
                continue
            if _top(m, v.end(), e, ":") and not _top(m, v.end(), e, r"\?"):
                end = len(m[:e].rstrip())
                edits += [(v.end(), v.end(), "["), (end, end, "]")]
    return _apply(code, edits) if edits else code


def python_tuples(code: str) -> str:
    """A Python tuple used as a vector, `(0, 0, 12)`, becomes `[0, 0, 12]`: a parenthesis that is not a call and
    holds a comma at its top level cannot be valid OpenSCAD."""
    m = _mask(code)
    edits = []
    for t in re.finditer(r"\(", m):
        a = t.start()
        j = _back(m, a)
        if j >= 0 and not (m[j] in "=,[(?:+-/%<>!&|^" or (m[j] == "*" and not _statement_start(m, j))
                           or _word_before(m, j) == "return"):
            continue  # a call, a for/if/let header, or a parenthesis after a value
        b = _close(m, a)
        if b < 0 or not _top(m, a + 1, b, ","):
            continue
        edits += [(a, a + 1, "["), (b, b + 1, "]")]
    return _apply(code, edits) if edits else code


def _statement_start(m: str, i: int) -> bool:
    j = _back(m, i)
    return j < 0 or m[j] in ";{}"


def python_continue(code: str) -> str:
    """`if (c) continue;` in a for-loop body, after nothing but assignments, becomes `if (!(c)) { <the rest of the
    body> }`."""
    for _ in range(20):
        m = _mask(code)
        new_code = None
        for t in re.finditer(r"(?<![\w$.])if[ \t]*\(", m):
            p = t.end() - 1
            q = _close(m, p)
            c = re.compile(rf"{WS}(?:continue{WS};|\{{{WS}continue{WS};{WS}\}})").match(m, q + 1) if q > 0 else None
            if not c:
                continue
            j = _enclosing(m, t.start())
            if j < 0 or m[j] != "{":
                continue
            h = _back(m, j)
            o = _open_of(m, h) if h >= 0 and m[h] == ")" else -1
            if o < 0 or _word_before(m, _back(m, o)) != "for":
                continue
            if not re.fullmatch(rf"(?:{WS}\$?{ID}{WS}=(?!=)[^;{{}}]*;)*{WS}", m[j + 1:t.start()]):
                continue
            end = _close(m, j)
            if end < 0:
                continue
            ind = " " * _indent(code[code.rfind("\n", 0, t.start()) + 1:t.start()])
            close_ind = " " * _indent(code[code.rfind("\n", 0, end) + 1:end])
            rest = code[c.end():end].rstrip()
            cond = _uncommented(code, p + 1, q).strip()
            new_code = _apply(code, [(t.start(), end, f"if (!({cond})) {{{rest}\n{ind}}}\n{close_ind}")])
            break
        if new_code is None:
            return code
        code = new_code
    return code


# --------------------------------------------------------------------------- rules: functions written as blocks

def function_keyword(code: str) -> str:
    """A function defined without its keyword, `w(x) = x * 2;` (as in mathematics), becomes
    `function w(x) = x * 2;`."""
    m = _mask(code)
    edits = []
    param = rf"[ \t]*\$?{ID}(?:[ \t]*=[^,()\[\]{{}};]+)?[ \t]*"
    for t in re.finditer(rf"(?<![\w$.])({ID})[ \t]*\((?:{param}(?:,{param})*)?\)[ \t]*=(?!=)", m):
        if t.group(1) in KEYWORDS | GEOMETRY or not _statement_start(m, t.start()):
            continue
        if not _top(m, t.end(), len(m), ";") or m[_skip(m, t.end()):_skip(m, t.end()) + 1] == "{":
            continue
        edits.append((t.start(), t.start(), "function "))
    return _apply(code, edits) if edits else code


def function_literal_equals(code: str) -> str:
    """A function literal written with '=', `f = function(x) = e;`, becomes `f = function(x) e;`."""
    m = _mask(code)
    edits = []
    for t in re.finditer(r"(?<![\w$.])function[ \t]*\(", m):
        q = _close(m, t.end() - 1)
        e = re.compile(rf"{WS}=(?!=){WS}").match(m, q + 1) if q > 0 else None
        if e:
            edits.append((q + 1, e.end(), " "))
    return _apply(code, edits) if edits else code


def function_if_else(code: str) -> str:
    """if/else used as an expression in a function, `function f(x) = if (c) a else if (d) b else e;` (with or
    without a ';' after each branch), becomes `function f(x) = (c) ? a : (d) ? b : e;`."""
    for _ in range(50):
        m = _mask(code)
        new_code = None
        for t in re.finditer(rf"(?<![\w$.])function({WS}{ID})?{WS}\(", m):
            named = t.group(1) is not None
            q = _close(m, t.end() - 1)
            e = re.compile(rf"{WS}(=)?{WS}(?=if{WS}\()").match(m, q + 1) if q > 0 else None
            if not e or (named and not e.group(1)):
                continue
            r = _if_chain(m, code, e.end())
            if r is None:
                continue
            expr, end = r
            new_code = _apply(code, [(q + 1, end, (" = " if named else " ") + expr + ";")])
            break
        if new_code is None:
            return code
        code = new_code
    return code


def _if_chain(m: str, code: str, i: int):
    """`if (c) e [;] else if (c2) e2 [;] else e3 ;` at i -> (the ?: expression, index after the final ';')."""
    t = re.compile(rf"if{WS}\(").match(m, i)
    if not t:
        return None
    p = t.end() - 1
    q = _close(m, p)
    if q < 0:
        return None
    stop = _top(m, q + 1, len(m), r"(?<![\w$.])else\b|;")
    if not stop:
        return None
    s = stop[0]
    then = _uncommented(code, q + 1, s.start()).strip()
    cond = _uncommented(code, p + 1, q).strip()
    if not then or then.startswith("{") or not cond:
        return None
    k = s.end()
    if s.group() == ";":
        nxt = re.compile(rf"{WS}else\b").match(m, s.end())
        if not nxt:
            return f"({cond}) ? {_paren(then)} : undef", s.end()
        k = nxt.end()
    k = _skip(m, k)
    if re.match(rf"if{WS}\(", m[k:k + 40]):
        r = _if_chain(m, code, k)
        return (f"({cond}) ? {_paren(then)} : {r[0]}", r[1]) if r else None
    semi = _top(m, k, len(m), ";")
    other = _uncommented(code, k, semi[0].start()).strip() if semi else ""
    if not other or other.startswith("{") or re.search(r"(?<![\w$.])else\b", m[k:semi[0].start()]):
        return None
    return f"({cond}) ? {_paren(then)} : {other}", semi[0].end()


_RETURN = re.compile(r"(?<![\w$.])return\b")


def function_block(code: str) -> str:
    """A function written as a statement block - `function f(x) { if (c) return a; return b; }`,
    `f = function(x) { ... };`, or a module whose body only computes and returns a value - becomes one expression
    with ?: and let(): `function f(x) = (c) ? a : b;`. Only bodies made of local assignments, if/else, blocks and
    return statements convert."""
    for _ in range(50):
        m = _mask(code)
        new_code = None
        for t in re.finditer(rf"(?<![\w$.])(function|module)(?:{WS}({ID}))?{WS}\(", m):
            kind, name = t.group(1), t.group(2)
            if kind == "module" and not name:
                continue
            p = t.end() - 1
            q = _close(m, p)
            b = re.compile(rf"{WS}(=)?{WS}\{{").match(m, q + 1) if q > 0 else None
            if not b or (kind == "module" and b.group(1)):
                continue
            o = b.end() - 1
            c = _close(m, o)
            if c < 0 or not _RETURN.search(m, o, c):
                continue
            nodes = _stmts(m, o + 1, c)
            expr = _as_expr(nodes, code) if nodes else None
            if expr is None:
                continue
            if name:
                s = re.compile(rf"{WS};").match(m, c + 1)
                new_code = _apply(code, [(t.start(), s.end() if s else c + 1,
                                          f"function {name}({code[p + 1:q]}) = {expr};")])
            else:
                new_code = _apply(code, [(q + 1, c + 1, f" {expr}")])
            break
        if new_code is None:
            return code
        code = new_code
    return code


def _stmts(m: str, a: int, b: int):
    """Statements of a block m[a:b] as nodes, or None if one is not an assignment, if/else, block or return."""
    out, i = [], a
    while True:
        i = _skip(m, i)
        if i >= b:
            return out
        node, i = _stmt(m, i, b)
        if node is None:
            return None
        if node != "empty":
            out.append(node)


def _stmt(m: str, i: int, b: int):
    if m[i] == ";":
        return "empty", i + 1
    if m[i] == "{":
        j = _close(m, i)
        if j < 0 or j >= b:
            return None, i
        inner = _stmts(m, i + 1, j)
        return (("block", inner), j + 1) if inner is not None else (None, i)
    t = _RETURN.match(m, i)
    if t:
        semi = _top(m, t.end(), b, ";")
        return (("return", t.end(), semi[0].start()), semi[0].end()) if semi else (None, i)
    t = re.compile(rf"if{WS}\(").match(m, i)
    if t:
        p = t.end() - 1
        q = _close(m, p)
        if q < 0 or q >= b:
            return None, i
        k = _skip(m, q + 1)
        if k >= b:
            return None, i
        then, k = _stmt(m, k, b)
        if then is None or then == "empty":
            return None, i
        els = None
        e = re.compile(rf"{WS}else\b").match(m, k)
        if e:
            k2 = _skip(m, e.end())
            if k2 >= b:
                return None, i
            els, k = _stmt(m, k2, b)
            if els is None or els == "empty":
                return None, i
        return ("if", (p + 1, q), then, els), k
    t = re.compile(rf"(\$?{ID}){WS}=(?!=)").match(m, i)
    if t and t.group(1) not in KEYWORDS:
        semi = _top(m, t.end(), b, ";")
        return (("let", t.group(1), t.end(), semi[0].start()), semi[0].end()) if semi else (None, i)
    return None, i


def _as_expr(nodes: list, code: str, cont=None):
    """The expression that a statement list returns on every path, or None. `cont` is the expression of the
    statements that follow the list, for a path that falls through it (an if without else, a block)."""
    lets = []
    for k, nd in enumerate(nodes):
        if nd[0] == "let":
            lets.append(f"let({nd[1]} = {_uncommented(code, nd[2], nd[3]).strip()})")
            continue
        if nd[0] == "return":
            e = _uncommented(code, nd[1], nd[2]).strip() or None
        else:
            rest = _as_expr(nodes[k + 1:], code, cont) if k + 1 < len(nodes) else cont
            if nd[0] == "block":
                e = _as_expr(nd[1], code, rest)
            else:  # if
                then = _as_expr([nd[2]], code, rest)
                els = _as_expr([nd[3]], code, rest) if nd[3] is not None else rest
                if then is None or els is None:
                    return None
                e = f"({_uncommented(code, nd[1][0], nd[1][1]).strip()}) ? {_paren(then)} : {els}"
        if e is None:
            return None
        return " ".join(lets) + " " + _paren(e) if lets else e
    if cont is None:
        return None
    return " ".join(lets) + " " + _paren(cont) if lets else cont


def _paren(e: str) -> str:
    """Parenthesise a ?: or let() expression that goes inside another expression."""
    wrapped = e.startswith("(") and _close(_mask(e), 0) == len(e) - 1
    return f"({e})" if not wrapped and ("?" in _mask(e) or e.startswith("let(")) else e


# --------------------------------------------------------------------------- rules: geometry as a value

def _scope(m: str, i: int):
    """For a statement at i: (module definitions allowed here, (start, end) of the scope it belongs to), or
    (False, None) if i is inside ( or [."""
    stack = []
    for t in _BR.finditer(m, 0, i):
        if t.group() in "([{":
            stack.append(t.start())
        elif stack:
            stack.pop()
    if any(m[s] != "{" for s in stack):
        return False, None
    for s in reversed(stack):
        h = _back(m, s)
        if h < 0 or m[h] in ";{}":
            continue  # a bare block belongs to its parent's scope
        e = _close(m, s)
        span = (s, e if e >= 0 else len(m))
        o = _open_of(m, h) if m[h] == ")" else -1
        name_end = _back(m, o) if o >= 0 else -1
        name = _word_before(m, name_end)
        if name and _word_before(m, _back(m, name_end - len(name) + 1)) == "module":
            return True, span
        return False, span  # the body of difference() {...}, for (...) {...}, if (...) {...}: a child block
    return True, (0, len(m))


def _chain(m: str, p: int, user_modules: set):
    """A module-instantiation chain at p (`translate(..) rotate(..) cube(..);` or `difference() {...}`):
    (end, number of calls, ends with a block), or None."""
    i, items = p, 0
    while True:
        i = _skip(m, i)
        t = re.compile(rf"(?:[!#%*][ \t]*)*({ID}){WS}\(").match(m, i)
        if not t:
            break
        if (items == 0 and t.group(1) not in GEOMETRY | user_modules) or \
                t.group(1) in KEYWORDS - {"for", "intersection_for", "if"}:
            return None
        q = _close(m, t.end() - 1)
        if q < 0:
            return None
        i, items = q + 1, items + 1
    if items == 0:
        return None
    i = _skip(m, i)
    if i < len(m) and m[i] == ";":
        return i + 1, items, False
    if i < len(m) and m[i] == "{":
        q = _close(m, i)
        if q < 0:
            return None
        j = _skip(m, q + 1)
        return (j + 1 if j < len(m) and m[j] == ";" else q + 1), items, True
    return None


def _uses(m: str, name: str, lo: int, hi: int, own: tuple):
    """Statement uses (`name;`, `name();`, `name` before '}') of `name` in m[lo:hi] outside its own assignment
    `own`: [(start, end)], or None if it is used in any other way."""
    out = []
    for t in re.finditer(rf"(?<![\w$.]){re.escape(name)}(?![\w$])", m):
        a = t.start()
        if own[0] <= a < own[1]:
            if a != own[0]:
                return None  # used inside its own definition
            continue
        if not lo <= a < hi:
            continue
        j = _back(m, a)
        if not (j < 0 or m[j] in ";{})#%!*" or _word_before(m, j) == "else"):
            return None
        u = re.compile(r"[ \t]*(?:\([ \t]*\))?[ \t]*(?:;|(?=\}))").match(m, t.end())
        if not u:
            return None
        out.append((a, u.end()))
    return out


def geometry_as_value(code: str) -> tuple:
    """Geometry assigned to a variable (`rack = difference() {...};`, `hole = translate(..) cylinder(..);`), which
    OpenSCAD cannot parse or evaluate, becomes geometry:
      geometry_to_module  where module definitions are allowed (the top level, a module body): `module rack() {...}`,
                          and its uses `rack;` become `rack();`;
      geometry_inline     inside a child block (difference() {...}, for (...) {...}): each use is replaced by the
                          shape itself and the assignment is removed;
      geometry_in_place   a variable never used again: the shape is made where it was assigned (`rack = ` is
                          dropped), but only when the assignment could not even be parsed (a chain, a block, a
                          keyword as the name, or an assignment as a module's child).
    A variable used in any other way (in an expression, in a list), or assigned twice, is left alone."""
    fired, tried = [], set()
    for _ in range(200):
        m = _mask(code)
        funcs = {t.group(1) for t in re.finditer(rf"(?<![\w$.])function{WS}({ID}){WS}\(", m)}
        user = {t.group(1) for t in re.finditer(rf"(?<![\w$.])module{WS}({ID}){WS}\(", m)} - funcs
        new_code = None
        for t in re.finditer(rf"(?<![\w$.])({ID}){WS}=(?!=){WS}", m):
            name, s = t.group(1), t.start()
            j = _back(m, s)
            child = j >= 0 and m[j] == ")"
            if not (j < 0 or m[j] in ";{}" or child):
                continue
            ch = _chain(m, t.end(), user)
            if ch is None:
                continue
            end, items, block = ch
            key = (name, code[t.end():end])
            if key in tried:
                continue
            tried.add(key)
            stmt = code[t.end():end].rstrip()
            if block and stmt.endswith(";"):
                stmt = stmt[:-1].rstrip()
            stmt = stmt if stmt.endswith(("}", ";")) else stmt + ";"
            elsewhere = any(not s <= u.start() < end
                            for u in re.finditer(rf"(?<![\w$.]){re.escape(name)}(?![\w$])", m))
            if name in KEYWORDS or child:
                if name not in KEYWORDS and elsewhere:
                    continue
                new_code, rule = _apply(code, [(s, t.end(), "")]), "geometry_in_place"
                break
            allows, scope = _scope(m, s)
            if scope is None:
                continue
            lo, hi = scope
            if name in user or name in funcs or any(
                    lo <= u.start() < hi and u.start() != s
                    for u in re.finditer(rf"(?<![\w$.]){re.escape(name)}{WS}=(?!=)", m)):
                continue
            uses = _uses(m, name, lo, hi, (s, end))
            if uses is None:
                continue
            if not uses:
                if (items > 1 or block) and not elsewhere:
                    new_code, rule = _apply(code, [(s, t.end(), "")]), "geometry_in_place"
                    break
                continue
            if allows:
                edits = [(s, end, f"module {name}() {{ {stmt} }}")] + [(a, b, f"{name}();") for a, b in uses]
                new_code, rule = _apply(code, edits), "geometry_to_module"
            else:
                new_code, rule = _apply(code, [(s, end, "")] + [(a, b, stmt) for a, b in uses]), "geometry_inline"
            break
        if new_code is None:
            break
        code = new_code
        if rule not in fired:
            fired.append(rule)
    return code, fired


def bare_module_call(code: str) -> str:
    """A module of the file used without its parentheses, `base;`, becomes `base();`."""
    m = _mask(code)
    edits = []
    for name in {t.group(1) for t in re.finditer(rf"(?<![\w$.])module{WS}({ID}){WS}\(", m)}:
        if re.search(rf"(?<![\w$.]){re.escape(name)}\s*=(?!=)", m):
            continue  # also a variable
        for t in re.finditer(rf"(?<![\w$.]){re.escape(name)}[ \t]*(?=;|\}})", m):
            j = _back(m, t.start())
            if j < 0 or m[j] in ";{})#%!*" or _word_before(m, j) == "else":
                edits.append((t.start(), t.end(), f"{name}()"))
    return _apply(code, edits) if edits else code


# --------------------------------------------------------------------------- rules: punctuation

def missing_semicolon(code: str) -> str:
    """A statement line that lacks its final ';' gets one when the next line plainly starts a new statement: an
    assignment `x = 5` followed by another assignment, a module call, a module or function definition, a '}' or the
    end of the file (a shape assigned to a variable, `p = translate(v) cube(5)`, before a module call only when its
    last call is a primitive such as cube() that takes no children, so the call cannot continue it); a module call
    `cube(5)` followed by a '}' or the end of the file. A run of such lines gets one ';' each."""
    m = _mask(code)
    lines, starts = _lines(m)
    nxt_new = re.compile(rf"[ \t]*(?:\$?{ID}[ \t]*=(?!=)|(?:module|function|include|use)\b|\}}|$)")
    nxt_call = re.compile(rf"[ \t]*(?:[!#%*][ \t]*)*{ID}[ \t]*\(")
    edits, stack, added = [], [], set()
    for k, ln in enumerate(lines):
        pb = _back(m, starts[k])
        at_stmt = all(c == "{" for c in stack) and (pb < 0 or m[pb] in ";{}" or pb + 1 in added)
        for c in ln:
            if c in "([{":
                stack.append(c)
            elif c in ")]}" and stack:
                stack.pop()
        s = ln.strip()
        if not at_stmt or not s or s[-1] in ";{},([+-*/%=?:&|<>!^." or not all(c == "{" for c in stack) \
                or not _balanced(s):
            continue
        n = next((j for j in range(k + 1, len(lines)) if lines[j].strip()), None)
        following = lines[n] if n is not None else ""
        assign = re.match(rf"\$?{ID}[ \t]*=(?!=)[ \t]*(?:({ID})[ \t]*(\()?)?", s)
        if assign:
            if assign.group(1) in ("function", "let"):
                continue  # a function literal or a let expression
            shape = assign.group(1) in GEOMETRY and assign.group(2)
            rhs = re.sub(r'"\s*"', '""', s[s.index("=") + 1:])
            if not shape and re.search(r"(?<![\w$.])(?:for|in|if|else|each)\b|[\w\]\"]\s+[\w(\[\"$]", rhs):
                continue  # not one plain expression: the missing ';' is not the only problem
            last = re.search(rf"({ID})[ \t]*\([^()]*(?:\([^()]*\)[^()]*)*\)$", s)
            complete = shape and last and last.group(1) in PRIMITIVES  # a shape that takes no children ends here
            if not (nxt_new.match(following) or ((not shape or complete) and nxt_call.match(following))):
                continue
        elif re.fullmatch(rf"(?:[!#%*][ \t]*)*{ID}[ \t]*\(.*\)", s):
            if not re.fullmatch(r"[ \t]*(?:\}.*)?", following):
                continue
        else:
            continue
        end = starts[k] + len(ln.rstrip())
        edits.append((end, end, ";"))
        added.add(end)
    return _apply(code, edits) if edits else code


# --------------------------------------------------------------------------- driver

RULES = [
    ("prose_lines", prose_lines),
    ("python_comments", python_comments),
    ("close_truncated", close_truncated),
    ("unicode_operators", unicode_operators),
    ("python_import", python_import),
    ("python_literals", python_literals),
    ("python_operators", python_operators),
    ("python_math", python_math),
    ("python_def", python_def),
    ("python_blocks", python_blocks),
    ("python_for_in", python_for_in),
    ("python_comprehension", python_comprehension),
    ("pipe_comprehension", pipe_comprehension),
    ("bracketless_comprehension", bracketless_comprehension),
    ("comprehension_let", comprehension_let),
    ("list_semicolons", list_semicolons),
    ("python_range", python_range),
    ("dotdot_range", dotdot_range),
    ("range_brackets", range_brackets),
    ("python_tuples", python_tuples),
    ("rotate_vector", rotate_vector),
    ("python_in", python_in),
    ("python_continue", python_continue),
    ("function_keyword", function_keyword),
    ("function_literal_equals", function_literal_equals),
    ("function_if_else", function_if_else),
    ("function_block", function_block),
    ("missing_semicolon", missing_semicolon),
    ("geometry_as_value", geometry_as_value),
    ("bare_module_call", bare_module_call),
]
RULE_NAMES = [n for n, _ in RULES if n != "geometry_as_value"] + [
    "geometry_to_module", "geometry_inline", "geometry_in_place"]


def fix(code: str, skip=()) -> tuple[str, list[str]]:
    """Return (repaired code, names of the rules that fired, in order). Rules named in `skip` are not run (for
    ablations, e.g. skip=("close_truncated",)). A rule that fails on odd input is skipped (and noted in ERRORS), so
    fix never raises on text."""
    fired = []
    for name, rule in RULES:
        if name in skip:
            continue
        try:
            out = rule(code)
        except Exception as e:  # noqa: BLE001
            ERRORS.append((name, repr(e)[:200]))
            continue
        names = [name]
        if isinstance(out, tuple):
            out, names = out
        if out != code:
            code = out
            fired += [n for n in names if n not in fired]
    return code, fired


def main() -> None:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("scad", help="OpenSCAD file to repair ('-' reads standard input)")
    ap.add_argument("--version", action="version", version=f"scadfix {VERSION}")
    a = ap.parse_args()
    code = sys.stdin.read() if a.scad == "-" else open(a.scad, encoding="utf-8", errors="replace").read()
    out, fired = fix(code)
    sys.stdout.write(out)
    print("scadfix: " + (", ".join(fired) if fired else "no rule fired"), file=sys.stderr)


if __name__ == "__main__":
    main()
