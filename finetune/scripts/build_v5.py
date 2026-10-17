#!/usr/bin/env python3
"""Build the v5 training set: v4's rows plus the multi-turn report-repair examples.

v5 changes one thing from v4 - it adds finetune/data/report_repairs.jsonl (make_report_repairs.py:
1,500 conversations in the benchmark's own shape, a flawed file, the benchmark's measurement report
of it, then the correct file). Train with MASK_EARLIER=1 (train_vlm.py --mask-earlier-assistant) so
the loss is v4's everywhere except the flawed turn, which is context only. Deterministic shuffle.

usage: ~/printpaper/.venv/bin/python -I finetune/scripts/build_v5.py
"""
import json
import pathlib
import random

FT = pathlib.Path("/home/seb/printpaper/finetune")
rows = [json.loads(l) for l in open(FT / "data" / "v4_train.jsonl") if l.strip()]
rep = [{"messages": json.loads(l)["messages"]} for l in open(FT / "data" / "report_repairs.jsonl") if l.strip()]
out = rows + rep
random.Random(20261019).shuffle(out)
with open(FT / "data" / "v5_train.jsonl", "w", encoding="utf-8") as fh:
    for r in out:
        fh.write(json.dumps(r, ensure_ascii=False) + "\n")
print(f"v4 rows {len(rows)} + report repairs {len(rep)} = {len(out)} -> {FT / 'data' / 'v5_train.jsonl'}")
