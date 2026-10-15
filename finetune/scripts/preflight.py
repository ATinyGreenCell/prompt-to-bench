#!/usr/bin/env python3
"""GO / NO-GO gate for the fine-tune dataset - run before paying for a training run.

Checks the invariants that would silently waste money or poison the model:
  SEEDS      every seed parses; every @prompt placeholder is a sampled @param with an assignment
  FAMILIES   every seed produced a non-empty data/<seed>.jsonl (a crashed family can't vanish)
  DISJOINT   training data shares no id and no near-identical prompt with the 16 eval tasks
  FORMAT     every record is [system,user,assistant]; system == bench/prompts/system.md exactly;
             the assistant turn is exactly one ```openscad block (train == what the eval extracts)
  COUNTS     no prompt advertises a fractional count ("4.3 bolt holes")
  LENGTH     token lengths fit --max-seq (so no training target is silently truncated)
  SPLIT      train and val do not overlap
  RENDER     (optional, --render-sample N) a random N training targets still render watertight

Exit 0 only if every hard check passes. WARN items print but do not fail the gate.

usage: ~/printpaper/.venv/bin/python -I preflight.py [--max-seq 4096] [--render-sample 20]
"""
from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import random
import re
import sys

ROOT = pathlib.Path("/home/seb/printpaper")
FT = ROOT / "finetune"
DATA = FT / "data"
SEEDS = FT / "seeds"
SYSTEM = (ROOT / "bench" / "prompts" / "system.md").read_text().strip()
PARAM_RE = re.compile(r"//\s*@param\s+(\w+)\s+(.*?)\s*\[\s*([-\d.]+)\s*:\s*([-\d.]+)\s*(?::\s*([-\d.]+)\s*)?\]")
COUNT_WORDS = r"(?:holes?|teeth|tooth|flutes?|spokes?|grooves?|pockets?|rows?|cols?|columns?|wells?|slots?|segments?|sides?)"
DECIMAL_COUNT = re.compile(rf"\b\d+\.\d+\s+{COUNT_WORDS}\b", re.I)
FENCE = re.compile(r"```(?:openscad|scad)?\s*\n(.*?)```", re.S | re.I)

HARD, SOFT = [], []


def record(ok, name, detail, hard=True):
    (HARD if hard else SOFT).append((ok, name, detail))
    mark = "PASS" if ok else ("FAIL" if hard else "warn")
    print(f"  [{mark}] {name}: {detail}")


def words(s):
    return set(re.findall(r"[a-z0-9]+", s.lower()))


def jaccard(a, b):
    return len(a & b) / len(a | b) if (a | b) else 0.0


def load_jsonl(p):
    return [json.loads(l) for l in p.open() if l.strip()] if p.exists() else []


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--max-seq", type=int, default=4096)
    ap.add_argument("--render-sample", type=int, default=0, help="re-render N random training targets (slow)")
    ap.add_argument("--tokenizer", default="Qwen/Qwen2.5-Coder-7B-Instruct", help="HF id for the exact token count")
    a = ap.parse_args()

    ev = json.load(open(FT / "data" / "eval_prompts.json"))
    eval_ids = {t["id"] for t in ev["tasks"]}
    eval_prompts = {t["id"]: t["user"] for t in ev["tasks"]}
    seed_files = sorted(SEEDS.glob("*.scad"))

    print("== SEEDS ==")
    for s in seed_files:
        txt = s.read_text()
        prompt = " ".join(re.findall(r"@prompt (.*)", txt))
        ph = set(re.findall(r"\{(\w+)\}", prompt))
        params = set(m.group(1) for m in PARAM_RE.finditer(txt))
        assigns = set(re.findall(r"(?m)^(\w+)\s*=", txt))
        bad = (ph - params) or (params - assigns) or (not prompt)
        if bad:
            record(False, f"seed {s.stem}", f"placeholder-no-param={sorted(ph-params)} param-no-assign={sorted(params-assigns)}")
    if not any(n.startswith("seed ") and not ok for ok, n, d in HARD):
        print(f"  [PASS] all {len(seed_files)} seeds valid (placeholders, params, assignments)")

    print("== EVAL DISJOINTNESS (seed ids) ==")
    overlap = {s.stem for s in seed_files} & eval_ids
    record(not overlap, "no seed shares an eval id", f"overlap={sorted(overlap) or 'none'}")

    print("== FAMILIES ==")
    counts = {}
    for s in seed_files:
        f = DATA / f"{s.stem}.jsonl"
        counts[s.stem] = len(load_jsonl(f))
    empty = [k for k, v in counts.items() if v == 0]
    record(not empty, "every family non-empty", f"empty={empty or 'none'}; total pairs={sum(counts.values())}")
    thin = {k: v for k, v in counts.items() if 0 < v < 50}
    record(not thin, "no family suspiciously thin (<50)", f"thin={thin or 'none'}", hard=False)

    train = load_jsonl(DATA / "train.jsonl")
    val = load_jsonl(DATA / "val.jsonl")
    allrecs = train + val
    record(bool(allrecs), "dataset assembled", f"{len(train)} train + {len(val)} val = {len(allrecs)}")
    if not allrecs:
        return finish()

    print("== FORMAT (train == eval) ==")
    fmt_bad, sys_bad, asst_bad = 0, 0, 0
    for r in allrecs:
        m = r.get("messages", [])
        if [x.get("role") for x in m] != ["system", "user", "assistant"]:
            fmt_bad += 1
            continue
        if m[0]["content"].strip() != SYSTEM:
            sys_bad += 1
        blocks = FENCE.findall(m[2]["content"])
        if len(blocks) != 1:
            asst_bad += 1
    record(fmt_bad == 0, "every record is [system,user,assistant]", f"malformed={fmt_bad}")
    record(sys_bad == 0, "system prompt == bench/prompts/system.md", f"mismatched={sys_bad}")
    record(asst_bad == 0, "assistant turn is exactly one openscad block", f"bad={asst_bad}")

    print("== COUNTS (no fractional counts in prompts) ==")
    offenders = []
    for r in allrecs:
        u = r["messages"][1]["content"].split("```")[0]        # the natural-language task, not embedded code
        if DECIMAL_COUNT.search(u):
            offenders.append(DECIMAL_COUNT.search(u).group(0))
    record(not offenders, "no fractional counts", f"examples={offenders[:4] or 'none'} (total {len(offenders)})")

    print("== DISJOINTNESS (near-duplicate prompts vs eval) ==")
    ewords = {tid: words(p) for tid, p in eval_prompts.items()}
    exact = 0
    worst = (0.0, "", "")
    eset = set(eval_prompts.values())
    for r in allrecs:
        u = r["messages"][1]["content"]
        if u.strip() in eset:
            exact += 1
        uw = words(u.split("```")[0])
        for tid, ew in ewords.items():
            j = jaccard(uw, ew)
            if j > worst[0]:
                worst = (j, r["messages"][1]["content"][:40], tid)
    record(exact == 0, "no training prompt equals an eval prompt", f"exact matches={exact}")
    record(worst[0] < 0.7, "max prompt similarity to eval < 0.7", f"max Jaccard={worst[0]:.2f} ({worst[2]} ~ {worst[1]!r})", hard=False)

    print("== SPLIT (train/val disjoint) ==")
    def key(r):
        return hashlib.sha256("\x00".join(x["content"] for x in r["messages"]).encode()).hexdigest()
    tk, vk = {key(r) for r in train}, {key(r) for r in val}
    record(not (tk & vk), "train and val disjoint", f"overlap={len(tk & vk)}")

    print(f"== LENGTH (fit max_seq={a.max_seq}) ==")
    lengths, exact_tok = [], False
    try:
        from transformers import AutoTokenizer
        tok = AutoTokenizer.from_pretrained(a.tokenizer)
        for r in allrecs:
            lengths.append(len(tok.apply_chat_template(r["messages"], tokenize=True, add_generation_prompt=False)))
        exact_tok = True
    except Exception as e:                                       # no transformers / no net: estimate from chars
        for r in allrecs:
            lengths.append(int(sum(len(x["content"]) for x in r["messages"]) / 3.3) + 16)
        print(f"  (exact tokenizer unavailable: {type(e).__name__}; using chars/3.3 estimate)")
    lengths.sort()
    n = len(lengths)
    p = lambda q: lengths[min(n - 1, int(q * n))]
    over = sum(1 for x in lengths if x > a.max_seq)
    label = "tokens" if exact_tok else "~tokens"
    record(over == 0, f"all examples <= max_seq ({label})",
           f"max={lengths[-1]} p50={p(.5)} p95={p(.95)} p99={p(.99)}; over {a.max_seq}: {over}")

    if a.render_sample:
        print(f"== RENDER (re-verify {a.render_sample} random targets) ==")
        sys.path.insert(0, str(FT / "scripts"))
        from verify import verify
        import tempfile, os
        random.seed(0)
        sample = random.sample(allrecs, min(a.render_sample, len(allrecs)))
        bad = 0
        for r in sample:
            blk = FENCE.search(r["messages"][2]["content"])
            with tempfile.TemporaryDirectory() as d:
                sp = os.path.join(d, "p.scad")
                open(sp, "w").write(blk.group(1) if blk else "// none")
                res = verify(sp, timeout=60)
                if not (res["ok"] and res.get("watertight")):
                    bad += 1
        record(bad == 0, "sampled targets render watertight", f"{bad}/{len(sample)} failed")

    finish()


def finish():
    print("\n" + "=" * 60)
    hard_fail = [n for ok, n, d in HARD if not ok]
    soft_warn = [n for ok, n, d in SOFT if not ok]
    if soft_warn:
        print(f"WARN ({len(soft_warn)}): " + "; ".join(soft_warn))
    if hard_fail:
        print(f"NO-GO - {len(hard_fail)} hard check(s) failed: " + "; ".join(hard_fail))
        sys.exit(1)
    print("GO - all hard checks passed. Safe to ship to a training run.")
    sys.exit(0)


if __name__ == "__main__":
    main()
