#!/usr/bin/env python3
"""How good is the request-derived check on development data? For the dev descriptions (batch C), take the saved
first attempts of the fine-tuned 9B models (finetune/rft/onpolicy/attempts_*_c.jsonl), judge each against its
verified reference with the rejection-sampling tolerances (the batch-C verdict), and against each spec writer's
spec (the gate). Reports, per spec writer: how often the gate accepts the reference, and its precision and recall
against the verdict over the attempts.

    ~/printpaper/.venv/bin/python -I dev_gate.py [--workers 3]
"""
import argparse
import collections
import json
import os
import re
import sys
import tempfile
from concurrent.futures import ProcessPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, "/home/seb/printpaper/bench", "/home/seb/printpaper/finetune/scripts"]
import spec as S  # noqa: E402

ONPOLICY = "/home/seb/printpaper/finetune/rft/onpolicy"
DISTILL = "/home/seb/printpaper/finetune/rft/distill"
RUNS = ["v5", "v5s1", "v9", "v9s1"]
CACHE = os.path.join(HERE, "dev_gate_cache.json")


def judge(args):
    """(verdict vs reference, gate measurement) for one candidate file."""
    code, ref_code = args
    from rft_score import matches
    try:
        ok, _, _ = matches(code, ref_code)
    except Exception:  # noqa: BLE001
        ok = False
    with tempfile.TemporaryDirectory() as d:
        p = os.path.join(d, "c.scad")
        open(p, "w").write(code)
        m = S.measure(p)
    return bool(ok), m


def measure_code(code):
    with tempfile.TemporaryDirectory() as d:
        p = os.path.join(d, "c.scad")
        open(p, "w").write(code)
        return S.measure(p)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--workers", type=int, default=3)
    a = ap.parse_args()
    from run_bench import extract_code
    specs = collections.defaultdict(dict)
    for line in open(os.path.join(HERE, "dev_specs.jsonl")):
        d = json.loads(line)
        specs[d["model"]][d["id"]] = d.get("spec")
    dev_ids = {i for s in specs.values() for i in s}
    prompts = {json.loads(l)["user"].strip(): json.loads(l)["id"] for l in open(os.path.join(DISTILL, "prompts_clean_c.jsonl"))}
    shard_line = {}  # 'd:clean_c_shardK.jsonl:L' -> (prompt id, reference code)
    for k in range(8):
        name = f"clean_c_shard{k}.jsonl"
        for i, line in enumerate(open(os.path.join(DISTILL, name))):
            m = json.loads(line)["messages"]
            pid = prompts.get(m[1]["content"].strip())
            g = re.search(r"```(?:openscad)?\s*\n(.*?)```", m[2]["content"], re.S)
            if pid in dev_ids and g:
                shard_line[f"d:{name}:{i}"] = (pid, g.group(1))
    jobs = []
    for run in RUNS:
        path = os.path.join(ONPOLICY, f"attempts_{run}_c.jsonl")
        for line in open(path):
            r = json.loads(line)
            if r["id"] in shard_line:
                code, _ = extract_code(r["reply"])
                if code:
                    pid, ref = shard_line[r["id"]]
                    jobs.append((run, r["sample"], pid, code, ref))
    cache = json.load(open(CACHE)) if os.path.exists(CACHE) else {}
    key = lambda j: f"{j[0]}|{j[1]}|{j[2]}"  # noqa: E731
    todo = [j for j in jobs if key(j) not in cache]
    stale = [j for j in jobs if key(j) in cache and (cache[key(j)]["measure"] or {"mv": S.MEASURE_VERSION}).get("mv")
             != S.MEASURE_VERSION]  # a part that does not build stays None
    print(f"{len(jobs)} saved attempts on {len(dev_ids)} dev descriptions; judging {len(todo)}, measuring {len(stale)} "
          "again", flush=True)
    with ProcessPoolExecutor(a.workers) as ex:
        for j, (ok, m) in zip(todo, ex.map(judge, [(j[3], j[4]) for j in todo])):
            cache[key(j)] = {"verdict": ok, "measure": m}
        for j, m in zip(stale, ex.map(measure_code, [j[3] for j in stale])):
            cache[key(j)]["measure"] = m
    json.dump(cache, open(CACHE, "w"))
    refm = json.load(open(os.path.join(HERE, "dev_refs.json")))
    print("| Spec writer | specs | accepts the reference | attempts | right parts | gate accepts | of them right "
          "(precision) | right parts accepted (recall) | F0.5 |")
    print("|---|---:|---:|---:|---:|---:|---:|---:|---:|")
    for model, sp in specs.items():
        acc_ref = sum(S.gate(s, (refm.get(i) or {}).get("measure"))[0] for i, s in sp.items())
        n = tp = fp = pos = 0
        for j in jobs:
            if j[2] not in sp:
                continue
            c = cache.get(key(j))
            if not c:
                continue
            n += 1
            ok = c["verdict"]
            pos += ok
            g, _ = S.gate(sp[j[2]], c["measure"])
            tp += g and ok
            fp += g and not ok
        prec = tp / (tp + fp) if tp + fp else float("nan")
        rec = tp / pos if pos else float("nan")
        f05 = 1.25 * prec * rec / (0.25 * prec + rec) if tp else 0.0  # precision weighted twice (PROTOCOL.md)
        print(f"| {model} | {len(sp)} | {acc_ref}/{len(sp)} | {n} | {pos} | {tp + fp} | {prec:.2f} | {rec:.2f} | {f05:.3f} |")


if __name__ == "__main__":
    main()
