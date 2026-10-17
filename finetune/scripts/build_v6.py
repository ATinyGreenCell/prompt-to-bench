#!/usr/bin/env python3
"""Build the v6 training set: a base set (v5 by default, or v4) plus batch-B held-out distillation x2.

Batch B (gen_prompts_clean_b.py, seed 20261020): 14 more bench-style part families that are neither eval
tasks nor batch-A families, each prompt at token Jaccard <= 0.40 vs every eval prompt (max 0.373). v6 adds
only diversity of held-out part types, so v6 vs its base set isolates that. Deterministic shuffle.

usage: ~/printpaper/.venv/bin/python -I finetune/scripts/build_v6.py [--base v5|v4]
"""
import argparse
import glob
import json
import pathlib
import random
import sys

FT = pathlib.Path("/home/seb/printpaper/finetune")
sys.path.insert(0, str(FT / "rft" / "distill"))
from gen_prompts_clean import eval_token_sets, max_jaccard  # noqa: E402

ap = argparse.ArgumentParser()
ap.add_argument("--base", default="v5", choices=["v4", "v5"])
a = ap.parse_args()
rows = [json.loads(l) for l in open(FT / "data" / f"{a.base}_train.jsonl") if l.strip()]
bb = [{"messages": json.loads(l)["messages"]}
      for f in sorted(glob.glob(str(FT / "rft" / "distill" / "clean_b_shard*.jsonl"))) for l in open(f) if l.strip()]
evs = eval_token_sets()
mj = max(max_jaccard(next(m["content"] for m in r["messages"] if m["role"] == "user"), evs)[0] for r in bb)
if mj > 0.40:
    raise SystemExit(f"ABORT: batch-B prompt above the gate ({mj:.3f})")
out = rows + bb * 2
random.Random(20261020).shuffle(out)
with open(FT / "data" / "v6_train.jsonl", "w", encoding="utf-8") as fh:
    for r in out:
        fh.write(json.dumps(r, ensure_ascii=False) + "\n")
print(f"{a.base} rows {len(rows)} + batch-B {len(bb)} x2 = {len(out)} (batch-B max Jaccard {mj:.3f}) -> v6_train.jsonl")
