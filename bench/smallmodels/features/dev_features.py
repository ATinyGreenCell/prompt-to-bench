#!/usr/bin/env python3
"""Development run for idea 4 (features), on batch-C descriptions only (never the 16 benchmark tasks): the model
lists features, compiler.py builds the file, and the part is compared with the description's verified file by the
rejection-sampling tolerances (finetune/scripts/rft_score.py: size per axis, volume, pieces). First attempt only.
Resumable: one line per (model, id) in dev_features.jsonl.

    ~/printpaper/.venv/bin/python -I dev_features.py [--per-family 2] [--models ...]
"""
import argparse
import collections
import json
import os
import random
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, os.path.dirname(HERE), "/home/seb/printpaper/finetune/scripts"]
from fbackend import FeaturesBackend  # noqa: E402
from rft_score import matches  # noqa: E402

DISTILL = "/home/seb/printpaper/finetune/rft/distill"
MODELS = ["gemma4:e4b-it-q4_K_M", "qwen3.5:4b-q4_K_M", "qwen2.5-coder:7b"]


def items(per_family: int, seed: int = 20261020) -> list[dict]:
    rows = [json.loads(line) for line in open(os.path.join(DISTILL, "prompts_clean_c.jsonl"))]
    by = collections.defaultdict(list)
    for r in rows:
        by[r["family"]].append(r)
    rng = random.Random(seed)
    pick = [r for fam in sorted(by) for r in rng.sample(by[fam], min(per_family, len(by[fam])))]
    text_to = {r["user"].strip(): r for r in pick}
    for k in range(8):
        for line in open(os.path.join(DISTILL, f"clean_c_shard{k}.jsonl")):
            m = json.loads(line)["messages"]
            r = text_to.get(m[1]["content"].strip())
            if r is not None:
                g = re.search(r"```(?:openscad)?\s*\n(.*?)```", m[2]["content"], re.S)
                if g:
                    r["ref"] = g.group(1)
    return [r for r in pick if r.get("ref")]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--per-family", type=int, default=2)
    ap.add_argument("--models", nargs="+", default=MODELS)
    a = ap.parse_args()
    its = items(a.per_family)
    out_path = os.path.join(HERE, "dev_features.jsonl")
    done = set()
    if os.path.exists(out_path):
        for line in open(out_path):
            try:
                d = json.loads(line)
                done.add((d["model"], d["id"]))
            except (json.JSONDecodeError, KeyError):
                pass
    print(f"{len(its)} batch-C descriptions", flush=True)
    for model in a.models:
        b = None
        for it in its:
            if (model, it["id"]) in done:
                continue
            b = FeaturesBackend(model, 0.2, 1000)
            t0 = time.time()
            try:
                text, usage = b.chat("", it["user"])
                code = re.search(r"```openscad\n(.*?)```", text, re.S).group(1)
                ok, score, detail = matches(code, it["ref"])
                err = None
            except Exception as e:  # noqa: BLE001
                usage, ok, score, detail, err, code = {}, False, 0.0, {}, repr(e)[:200], ""
            rec = {"model": model, "id": it["id"], "family": it["family"], "passed": bool(ok), "score": score,
                   "detail": detail if isinstance(detail, (dict, str)) else str(detail), "error": err,
                   "features": b.part, "wall_s": round(time.time() - t0, 1),
                   "usage": {k: usage.get(k) for k in ("prompt_tokens", "gen_tokens", "prompt_s", "gen_s")}}
            with open(out_path, "a") as fh:
                fh.write(json.dumps(rec, default=str) + "\n")
            print(f"{time.strftime('%H:%M:%S')} {model:24s} {it['family']:16s} {'PASS' if ok else 'fail'} "
                  f"{score if isinstance(score, float) else ''} {rec['wall_s']:.0f}s", flush=True)
        if b:
            b.close()


if __name__ == "__main__":
    main()
