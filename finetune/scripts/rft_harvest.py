#!/usr/bin/env python3
"""Harvest rejection-sampling training data: keep only the model's own generations that build the
CORRECT part (verified by rft_score against the known reference), and emit them as training examples.

This is the filter in the loop: generate many -> keep the ones the checker says are right -> train on
them. Because "right" is rft_score (same renderer/geometry as the eval), the kept examples are
correct by construction, and they are the model's own phrasings of a correct answer, which is what
rejection-sampling / STaR trains on.

Input (JSONL from rft_generate.py), one object per prompt:
  {"prompt": ..., "ref_scad": ..., "candidates": ["scad", ...]}                       single-turn
  {"prompt": ..., "ref_scad": ..., "turns": [{"scad":.., "feedback":..}, ...]}        multi-turn repair
The reference is rendered once and cached; each candidate is matched against it.

usage: ~/printpaper/.venv/bin/python -I rft_harvest.py gen.jsonl -o ../data/rft.jsonl [--min-score 1.0]
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from rft_score import matches, measure  # noqa: E402

ROOT = pathlib.Path("/home/seb/printpaper")
SYSTEM = (ROOT / "bench" / "prompts" / "system.md").read_text().strip()
TAIL = re.compile(r"\s*Reply with .*?(?:OpenSCAD file|code block)\.?\s*$", re.I | re.S)
FENCE = "```openscad\n{}\n```"


def user_turn(prompt: str) -> str:
    return TAIL.sub("", prompt).strip()


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("gen", type=pathlib.Path, help="generations JSONL from rft_generate.py")
    ap.add_argument("-o", type=pathlib.Path, default=ROOT / "finetune" / "data" / "rft.jsonl")
    ap.add_argument("--min-score", type=float, default=1.0, help="keep a candidate whose match score >= this (1.0 = full match)")
    ap.add_argument("--per-prompt", type=int, default=1, help="keep at most this many matching candidates per prompt")
    ap.add_argument("--timeout", type=int, default=60)
    a = ap.parse_args()

    prompts = kept = cand_total = cand_match = 0
    out = []
    for ln in a.gen.open():
        ln = ln.strip()
        if not ln:
            continue
        r = json.loads(ln)
        prompts += 1
        ref = measure(r["ref_scad"], a.timeout)      # render the reference once
        if not ref.get("ok"):
            continue
        user = user_turn(r["prompt"])

        if "turns" in r:                              # multi-turn repair trajectory
            final = r["turns"][-1]["scad"]
            cand_total += 1
            ok, score, _ = matches(final, ref_measure=ref, timeout=a.timeout)
            if score >= a.min_score:
                cand_match += 1
                msgs = [{"role": "system", "content": SYSTEM}, {"role": "user", "content": user}]
                for i, t in enumerate(r["turns"]):
                    msgs.append({"role": "assistant", "content": FENCE.format(t["scad"].strip())})
                    if i < len(r["turns"]) - 1:
                        msgs.append({"role": "user", "content": t.get("feedback", "").strip()})
                out.append({"messages": msgs, "score": round(score, 3)})
                kept += 1
            continue

        matched = 0                                   # single-turn: keep up to --per-prompt matches
        for scad in r.get("candidates", []):
            cand_total += 1
            ok, score, _ = matches(scad, ref_measure=ref, timeout=a.timeout)
            if score >= a.min_score:
                cand_match += 1
                out.append({"messages": [
                    {"role": "system", "content": SYSTEM},
                    {"role": "user", "content": user},
                    {"role": "assistant", "content": FENCE.format(scad.strip())}], "score": round(score, 3)})
                kept += 1
                matched += 1
                if matched >= a.per_prompt:
                    break

    with a.o.open("w") as fh:
        for row in out:
            fh.write(json.dumps(row) + "\n")
    prompts_hit = len({o["messages"][1]["content"] for o in out})
    rate = f" ({100 * cand_match / cand_total:.0f}% of candidates)" if cand_total else ""
    print(f"prompts {prompts} | candidates {cand_total} matched {cand_match}{rate}")
    print(f"kept {kept} training examples from {prompts_hit} distinct prompts -> {a.o}")


if __name__ == "__main__":
    main()
