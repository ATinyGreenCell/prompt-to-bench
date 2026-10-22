#!/usr/bin/env python3
"""Development run for the request-derived check: laptop models write specs for batch-C descriptions (never the 16
benchmark tasks), scored against each description's true overall size and its verified reference file.

Resumable: specs are appended to dev_specs.jsonl, one line per (model, id); done pairs are skipped.

    ~/printpaper/.venv/bin/python -I dev_specs.py [--per-family 4] [--models m1 m2 ...]
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
sys.path.insert(0, HERE)
import spec as S  # noqa: E402

DISTILL = "/home/seb/printpaper/finetune/rft/distill"
MODELS = ["gemma4:e4b-it-q4_K_M", "qwen3.5:4b-q4_K_M", "qwen3.5:9b-q4_K_M", "gemma4:e2b-it-q4_K_M",
          "qwen2.5-coder:7b", "llama3.2:3b", "ministral-3:3b"]


def sample_ids(per_family: int, seed: int = 20261019) -> list[dict]:
    rows = [json.loads(line) for line in open(os.path.join(DISTILL, "prompts_clean_c.jsonl"))]
    by = collections.defaultdict(list)
    for r in rows:
        by[r["family"]].append(r)
    rng = random.Random(seed)
    out = []
    for fam in sorted(by):
        out += rng.sample(by[fam], min(per_family, len(by[fam])))
    return out


def reference_code(pid: str) -> str | None:
    """The verified file for a batch-C prompt id, from the distill shards (matched on the description text)."""
    return REF.get(pid)


REF = {}


def load_refs(wanted: dict) -> None:
    """Map prompt id -> verified OpenSCAD by matching each shard line's user message to the prompt text."""
    text_to_id = {r["user"].strip(): r["id"] for r in wanted.values()}
    for k in range(8):
        for line in open(os.path.join(DISTILL, f"clean_c_shard{k}.jsonl")):
            m = json.loads(line)["messages"]
            pid = text_to_id.get(m[1]["content"].strip())
            if pid:
                g = re.search(r"```(?:openscad)?\s*\n(.*?)```", m[2]["content"], re.S)
                if g:
                    REF[pid] = g.group(1)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--per-family", type=int, default=4)
    ap.add_argument("--models", nargs="+", default=MODELS)
    ap.add_argument("--prompt", default="v1", choices=list(S.VERSIONS))
    a = ap.parse_args()
    items = {r["id"]: r for r in sample_ids(a.per_family)}
    load_refs(items)
    refs_path = os.path.join(HERE, "dev_refs.json")
    refs = json.load(open(refs_path)) if os.path.exists(refs_path) else {}
    scad_dir = os.path.join(HERE, "dev_ref_scad")
    os.makedirs(scad_dir, exist_ok=True)
    for pid, r in items.items():
        if pid in REF and (pid not in refs or (refs[pid].get("measure") or {}).get("mv") != S.MEASURE_VERSION):
            p = os.path.join(scad_dir, f"{pid}.scad")
            open(p, "w").write(REF[pid])
            refs[pid] = {"bbox": r["bbox"], "measure": S.measure(p)}
            json.dump(refs, open(refs_path, "w"))
    print(f"{len(items)} descriptions, {sum(1 for v in refs.values() if v['measure'])} reference parts measured",
          flush=True)
    out_path = os.path.join(HERE, "dev_specs.jsonl")
    done = set()
    if os.path.exists(out_path):
        for line in open(out_path):
            try:
                d = json.loads(line)
                done.add((d["model"], d["id"]))
            except (json.JSONDecodeError, KeyError):
                pass
    for model in a.models:
        for pid, r in items.items():
            key = model if a.prompt == "v1" else f"{model}#{a.prompt}"
            if (key, pid) in done:
                continue
            t0 = time.time()
            try:
                res = (S.write_spec_claude(model.split(":", 1)[1], r["user"], version=a.prompt)
                       if model.startswith("claude:") else S.write_spec(model, r["user"], version=a.prompt))
            except Exception as e:  # noqa: BLE001
                res = {"spec": None, "raw": "", "usage": {}, "error": repr(e)[:200]}
            rec = {"model": key, "id": pid, "family": r["family"], "wall_s": round(time.time() - t0, 1), **res}
            ref = refs.get(pid) or {}
            rec["ref_ok"], rec["ref_why"] = S.gate(res["spec"], ref.get("measure")) if ref.get("measure") else (None, [])
            with open(out_path, "a") as fh:
                fh.write(json.dumps(rec) + "\n")
            print(f"{time.strftime('%H:%M:%S')} {model:24s} {pid:22s} {rec['wall_s']:6.1f}s accepts ref: "
                  f"{rec['ref_ok']} {'; '.join(rec['ref_why'])[:120]}", flush=True)


if __name__ == "__main__":
    main()
