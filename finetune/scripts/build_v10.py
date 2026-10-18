#!/usr/bin/env python3
"""Build the v10 training set: v9's rows plus v9's OWN successful repairs (rejection sampling over repair turns).

v10 changes one thing from v9 - it adds finetune/data/repair_rft_v9c.jsonl (onpolicy_repairs.py build-rft):
v9 answered the 674 batch-C descriptions (14 part families no model here saw), each failure was shown back to
it with the benchmark's feedback, it wrote eight repairs per failure at temperature 1.0, and only the repairs
that pass the reference's tolerances were kept (at most two per failure) - files the model itself changed and
got right after reading the report. Unlike v9's repairs, whose final turn is a reference file written by
someone else, these final turns are in the model's own style. Train with MASK_EARLIER=1. Deterministic shuffle.

usage: ~/printpaper/.venv/bin/python -I finetune/scripts/build_v10.py [--times 2]
"""
import argparse
import json
import pathlib
import random

FT = pathlib.Path("/home/seb/printpaper/finetune")
ap = argparse.ArgumentParser()
ap.add_argument("--times", type=int, default=2, help="how many copies of each kept repair")
a = ap.parse_args()
rows = [json.loads(l) for l in open(FT / "data" / "v9_train.jsonl") if l.strip()]
rft = [{"messages": json.loads(l)["messages"]} for l in open(FT / "data" / "repair_rft_v9c.jsonl") if l.strip()]
out = rows + rft * a.times
random.Random(20261021).shuffle(out)
with open(FT / "data" / "v10_train.jsonl", "w", encoding="utf-8") as fh:
    for r in out:
        fh.write(json.dumps(r, ensure_ascii=False) + "\n")
print(f"v9 rows {len(rows)} + own successful repairs {len(rft)} x{a.times} = {len(out)} -> {FT / 'data' / 'v10_train.jsonl'}")
