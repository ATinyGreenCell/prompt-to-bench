#!/usr/bin/env python3
"""Development run for idea 3 (templates), on data outside the 16 benchmark tasks:
  in-library  - seed-family descriptions with known parameters (finetune/rft/aug/<family>.jsonl): is the right
                design picked, are its parameters right, and does the built file match the family's own file;
  out-of-library - batch-C descriptions (families the library does not have): the right answer is "none"; any
                other pick builds a different part.
First attempt only (no feedback). Resumable: one line per (model, id) in dev_templates.jsonl.

    ~/printpaper/.venv/bin/python -I dev_templates.py [--per-family 3] [--outside 2] [--models ...]
"""
import argparse
import collections
import glob
import json
import os
import random
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, os.path.dirname(HERE), "/home/seb/printpaper/finetune/scripts"]
import library as L  # noqa: E402
from backend import TemplateBackend  # noqa: E402

MODELS = ["gemma4:e4b-it-q4_K_M", "qwen3.5:4b-q4_K_M", "qwen3.5:9b-q4_K_M", "qwen2.5-coder:7b", "llama3.2:3b"]


def items(per_family: int, outside: int, seed: int = 20261019) -> list[dict]:
    rng = random.Random(seed)
    out = []
    for path in sorted(glob.glob("/home/seb/printpaper/finetune/rft/aug/*.jsonl")):
        rows = [json.loads(line) for line in open(path)]
        for r in rng.sample(rows, min(per_family, len(rows))):
            out.append({"id": f"aug:{r['seed']}:{rows.index(r)}", "kind": "in", "family": r["seed"],
                        "request": r["prompt"], "params": r["params"], "scad": r["scad"]})
    by = collections.defaultdict(list)
    for line in open("/home/seb/printpaper/finetune/rft/distill/prompts_clean_c.jsonl"):
        r = json.loads(line)
        by[r["family"]].append(r)
    for fam in sorted(by):
        for r in rng.sample(by[fam], min(outside, len(by[fam]))):
            out.append({"id": r["id"], "kind": "out", "family": "none", "request": r["user"]})
    return out


def params_right(fam: dict, got: dict, truth: dict) -> bool:
    """Every parameter the request states (a placeholder in the family's request template) is right; parameters the
    request leaves out (3 in two families) are the model's free choice."""
    stated = set(re.findall(r"\{(\w+)\}", fam["prompt"]))
    want = L.clamp(fam, truth)
    return all(abs(float(got[k]) - float(want[k])) <= max(0.051, 0.01 * abs(float(want[k]))) for k in want if k in stated)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--per-family", type=int, default=3)
    ap.add_argument("--outside", type=int, default=2)
    ap.add_argument("--models", nargs="+", default=MODELS)
    a = ap.parse_args()
    its = items(a.per_family, a.outside)
    lib = L.load()
    out_path = os.path.join(HERE, "dev_templates.jsonl")
    done = set()
    if os.path.exists(out_path):
        for line in open(out_path):
            try:
                d = json.loads(line)
                done.add((d["model"], d["id"]))
            except (json.JSONDecodeError, KeyError):
                pass
    print(f"{len(its)} items ({sum(i['kind'] == 'in' for i in its)} in the library)", flush=True)
    for model in a.models:
        todo = [it for it in its if (model, it["id"]) not in done]
        if not todo:
            continue
        # Two passes, the same calls as TemplateBackend.chat: every pick first, then every fill. The pick prompt
        # (the 34-design catalog) is the same for all requests, so Ollama reuses its cached prefix.
        b = TemplateBackend(model, 0.2, 1000)
        picks = {}
        for it in todo:
            usage, t0 = {}, time.time()
            try:
                b.request = it["request"]
                fam, err = b._choose(usage), None
            except Exception as e:  # noqa: BLE001
                fam, err = None, repr(e)[:200]
            picks[it["id"]] = (fam, usage, time.time() - t0, err)
        for it in todo:
            fam, usage, t_pick, err = picks[it["id"]]
            values, t0 = None, time.time()
            if fam is not None and err is None:
                try:
                    b.request, b.family = it["request"], fam
                    values = b._fill(usage)
                except Exception as e:  # noqa: BLE001
                    err = repr(e)[:200]
            pick = fam or "none"
            rec = {"model": model, "id": it["id"], "kind": it["kind"], "family": it["family"], "pick": pick,
                   "params": values, "wall_s": round(t_pick + time.time() - t0, 1), "error": err,
                   "usage": {k: usage.get(k) for k in ("prompt_tokens", "gen_tokens", "prompt_s", "gen_s", "load_s")}}
            rec["family_right"] = pick == it["family"]
            rec["params_right"] = (rec["family_right"] and it["kind"] == "in" and values is not None
                                   and params_right(lib[pick], values, it["params"]))
            with open(out_path, "a") as fh:
                fh.write(json.dumps(rec) + "\n")
            print(f"{time.strftime('%H:%M:%S')} {model:24s} {it['kind']:3s} {it['family']:20s} -> {pick:20s} "
                  f"params {'ok' if rec['params_right'] else '-'} {rec['wall_s']:.0f}s", flush=True)
        b.close()

if __name__ == "__main__":
    main()
