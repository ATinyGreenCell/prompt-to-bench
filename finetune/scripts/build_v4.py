#!/usr/bin/env python3
"""Build the v4 training set: v3's recipe with the eval-mirroring distilled data replaced by HELD-OUT
bench-style data, so v4 is a clean transfer test (v3 is in-family on half the eval; see §6.4).

  base     finetune/data/train.jsonl                        (v2's 7,238 verified examples)       x1
  rft      finetune/rft/rft_passes.jsonl                    (v2's own verifier-passing samples)  x2
  distill  finetune/rft/distill/clean_shard*.jsonl          (Opus, gen_prompts_clean families)   x2
           + v3-distilled examples already below the gate   (train_distill.jsonl, J <= MAX_J)

Every user prompt is gated against the 16 eval prompts by token Jaccard (gen_prompts_clean.TOK): the
distilled part must stay <= MAX_J, and the script reports the max for every component. Deterministic
(fixed shuffle seed). Writes finetune/data/v4_train.jsonl + a composition report next to it.

usage: ~/printpaper/.venv/bin/python -I finetune/scripts/build_v4.py
"""
from __future__ import annotations

import glob
import json
import pathlib
import random
import sys

ROOT = pathlib.Path("/home/seb/printpaper")
FT = ROOT / "finetune"
sys.path.insert(0, str(FT / "rft" / "distill"))
from gen_prompts_clean import eval_token_sets, max_jaccard  # noqa: E402

MAX_J = 0.364  # the held-out distillation prompts peak here (gen_prompts_clean, seed 20261018)
W_RFT, W_DISTILL = 2, 2
OUT = FT / "data" / "v4_train.jsonl"


def load(path):
    rows = []
    for ln in open(path, encoding="utf-8"):
        ln = ln.strip()
        if ln:
            rows.append({"messages": json.loads(ln)["messages"]})  # drop extras (e.g. rft "score")
    return rows


def user(r):
    return next(m["content"] for m in r["messages"] if m["role"] == "user")


def main() -> None:
    evs = eval_token_sets()
    eval_prompts = set()
    import yaml
    tasks = yaml.safe_load(open(ROOT / "bench" / "tasks.yaml"))
    for t in (tasks if isinstance(tasks, list) else tasks["tasks"]):
        eval_prompts.add(t["prompt"].strip())

    base = load(FT / "data" / "train.jsonl")
    rft = load(FT / "rft" / "rft_passes.jsonl")
    clean = [r for f in sorted(glob.glob(str(FT / "rft" / "distill" / "clean_shard*.jsonl"))) for r in load(f)]
    old = load(FT / "rft" / "distill" / "train_distill.jsonl")
    old_kept = [r for r in old if max_jaccard(user(r), evs)[0] <= MAX_J]

    report = {}
    for name, rows in (("base", base), ("rft", rft), ("distill_clean", clean), ("distill_v3_kept", old_kept)):
        js = [max_jaccard(user(r), evs) for r in rows]
        mj = max(js) if js else (0.0, "-")
        report[name] = {"n": len(rows), "max_jaccard": round(mj[0], 3), "nearest_eval": mj[1]}
        if any(user(r).strip() in eval_prompts for r in rows):
            raise SystemExit(f"ABORT: {name} contains an eval prompt verbatim")
    distill = clean + old_kept
    dj = max((max_jaccard(user(r), evs)[0] for r in distill), default=0.0)
    if dj > MAX_J + 1e-9:
        raise SystemExit(f"ABORT: distilled prompt above the gate ({dj:.3f} > {MAX_J})")

    # dedupe on (user, assistant) before weighting, so a weight never multiplies a duplicate
    seen, uniq = set(), []
    for r in base + rft + distill:
        k = (user(r), r["messages"][-1]["content"])
        if k not in seen:
            seen.add(k)
            uniq.append(r)
    keyset = {(user(r), r["messages"][-1]["content"]) for r in rft}
    dkeys = {(user(r), r["messages"][-1]["content"]) for r in distill}
    rows = []
    for r in uniq:
        k = (user(r), r["messages"][-1]["content"])
        w = W_RFT if k in keyset else W_DISTILL if k in dkeys else 1
        rows.extend([r] * w)
    random.Random(20261018).shuffle(rows)
    with open(OUT, "w", encoding="utf-8") as fh:
        for r in rows:
            fh.write(json.dumps(r, ensure_ascii=False) + "\n")
    report["weights"] = {"rft": W_RFT, "distill": W_DISTILL}
    report["unique_examples"] = len(uniq)
    report["total_rows"] = len(rows)
    report["distill_max_jaccard"] = round(dj, 3)
    json.dump(report, open(OUT.with_suffix(".report.json"), "w"), indent=1)
    print(json.dumps(report, indent=1))
    print("wrote", OUT)


if __name__ == "__main__":
    main()
