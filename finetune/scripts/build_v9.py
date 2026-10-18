#!/usr/bin/env python3
"""Build the v9 training set: v5's rows plus on-policy repair conversations.

v9 changes one thing from v5 - it adds finetune/data/onpolicy_repairs_v5.jsonl (onpolicy_repairs.py build):
v5's OWN failed first attempts at held-out training prompts (never eval tasks; Jaccard-gated), each followed
by the benchmark's feedback for that attempt (measurement report, or OpenSCAD's errors) and then the
reference file. v5's synthetic repairs (one perturbed parameter) helped its first attempts but not its
repairs (README §6.4: it changed its file after 15% of feedback messages and won no pass by repair); these
show the model its own typical mistakes. Train with MASK_EARLIER=1 so the failed attempt is context only.

v5 passed 5,131 of its 6,000 attempts (rft_score tolerances): all of batch A's (it trained on them), 95.5% of
the augment prompts, but only 48% of batch B's 1,400 (families it never saw) - so 724 of the 869 repairs end
in a batch-B reference file. v8 holds every batch-B file as a plain single-turn example (x2), so v8 is the
control for that content; v9's difference is the shape (its own failed reply + feedback, then the file).
The repairs go in twice, like v8's batch B (1,738 rows, close to v5's 1,500 synthetic repairs).
Deterministic shuffle.

usage: ~/printpaper/.venv/bin/python -I finetune/scripts/build_v9.py
"""
import json
import pathlib
import random

FT = pathlib.Path("/home/seb/printpaper/finetune")
rows = [json.loads(l) for l in open(FT / "data" / "v5_train.jsonl") if l.strip()]
rep = [{"messages": json.loads(l)["messages"]} for l in open(FT / "data" / "onpolicy_repairs_v5.jsonl") if l.strip()] * 2
out = rows + rep
random.Random(20261020).shuffle(out)
with open(FT / "data" / "v9_train.jsonl", "w", encoding="utf-8") as fh:
    for r in out:
        fh.write(json.dumps(r, ensure_ascii=False) + "\n")
print(f"v5 rows {len(rows)} + on-policy repairs x2 {len(rep)} = {len(out)} -> {FT / 'data' / 'v9_train.jsonl'}")
