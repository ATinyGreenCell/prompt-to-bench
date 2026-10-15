#!/usr/bin/env python3
"""Assemble verified (prompt -> scad) pairs into a chat-format training set.

Reads every data/*.jsonl produced by augment.py (and later gen_candidates.py), formats each as a
system / user / assistant message triple that matches the benchmark exactly - the same system
prompt (bench/prompts/system.md) and the same single ```openscad fenced block the eval extracts -
dedups, and splits into train / val.

The 16 eval tasks never appear here (seeds are disjoint by construction), so they stay a clean
held-out test; `val` here is only a random slice for watching overfitting during training.

Output is provider-neutral `{"messages": [...]}` JSONL - the trainer applies the base model's chat
template - so it works with TRL / Unsloth / axolotl.

usage: ~/printpaper/.venv/bin/python -I build_dataset.py [--val-frac 0.1] [--rng 0]
"""
from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import random
import re

ROOT = pathlib.Path("/home/seb/printpaper")
FT = ROOT / "finetune"
SYSTEM = (ROOT / "bench" / "prompts" / "system.md").read_text().strip()
TAIL = re.compile(r"\s*Reply with .*?(?:OpenSCAD file|code block)\.?\s*$", re.I | re.S)


def source_records():
    for f in sorted((FT / "data").glob("*.jsonl")):
        if f.name in ("train.jsonl", "val.jsonl"):
            continue
        for ln in f.open():
            ln = ln.strip()
            if ln:
                yield json.loads(ln)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--val-frac", type=float, default=0.1)
    ap.add_argument("--rng", type=int, default=0)
    a = ap.parse_args()

    seen, rows, dupes = set(), [], 0
    for r in source_records():
        if "messages" in r:                                   # pre-formatted (e.g. feedback.jsonl)
            msgs = r["messages"]
            if not msgs or msgs[0].get("role") != "system":
                msgs = [{"role": "system", "content": SYSTEM}] + msgs
            key = hashlib.sha256("\x00".join(m["content"] for m in msgs).encode()).hexdigest()
        else:                                                 # (prompt, scad) pair from augment
            user = TAIL.sub("", r["prompt"]).strip()
            scad = r["scad"].strip()
            msgs = [{"role": "system", "content": SYSTEM},
                    {"role": "user", "content": user},
                    {"role": "assistant", "content": "```openscad\n" + scad + "\n```"}]
            key = hashlib.sha256((user + "\x00" + scad).encode()).hexdigest()
        if key in seen:
            dupes += 1
            continue
        seen.add(key)
        rows.append({"messages": msgs})

    random.seed(a.rng)
    random.shuffle(rows)
    nval = max(1, int(len(rows) * a.val_frac))
    val, train = rows[:nval], rows[nval:]
    for name, data in (("train.jsonl", train), ("val.jsonl", val)):
        with (FT / "data" / name).open("w") as fh:
            for row in data:
                fh.write(json.dumps(row) + "\n")
    print(f"{len(rows)} unique examples ({dupes} duplicates dropped) -> {len(train)} train, {len(val)} val")


if __name__ == "__main__":
    main()
