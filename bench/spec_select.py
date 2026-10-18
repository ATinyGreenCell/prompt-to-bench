#!/usr/bin/env python3
"""Choose one of k samples by checking each part against the numbers in its own request (no hidden checks).

self_consistency.py keeps a part that most samples agree on; a model can agree with itself on a wrong part.
This selector also reads the request: it renders every sample's final file, measures the part (scadreport) and
scores it by how many of the request's own numbers the part shows -
  - each of its three overall dimensions (sorted, so orientation does not matter) that equals a size stated in
    the request, within 0.25 mm or 1%,
  - the share of its distinct hole diameters (horizontal slices) that equal a stated size, and
  - whether some slice holds as many holes as a count stated in the request (an integer, or a product
    "A x B" / "A by B" for grids),
plus a small bonus for agreeing with the other samples (bounding box within 1 mm, volume within 2%), and keeps
the highest-scoring sample (the earliest on a tie). It sees only what a lab has - the request it typed and the
parts its samples build - and was applied once to every run, without tuning on the benchmark. Reported beside
pass@1 (sample 0), the self-consistency pick and pass@k (any sample passed, which needs the answer key).

usage: python bench/spec_select.py gpu-base gpu-base-h4 gpu-v9s1 [--workers 12]
"""
from __future__ import annotations

import argparse
import collections
import json
import os
import re
import sys
import tempfile
from concurrent.futures import ProcessPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, os.path.join(os.path.dirname(HERE), "tools")]
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
import yaml  # noqa: E402
from sample_stats import rows_for  # noqa: E402
from self_consistency import select as sc_select  # noqa: E402

NUM = re.compile(r"(?<![\w.])(\d+(?:\.\d+)?)(?![\w.])")
GRID = re.compile(r"(\d+)\s*(?:x|×|by)\s*(\d+)")
CACHE = os.path.expanduser("~/.cache/printpaper/spec_select.json")  # measurements of rendered files, by path


def request_numbers(prompt: str) -> tuple[list[float], set[int]]:
    """(sizes, counts) stated in a request: every number, and every whole number or grid product as a count."""
    nums = [float(m) for m in NUM.findall(prompt)]
    counts = {int(n) for n in nums if n.is_integer() and 1 < n <= 400}
    counts |= {int(a) * int(b) for a, b in GRID.findall(prompt) if 1 < int(a) * int(b) <= 400}
    return nums, counts


def measure(path: str) -> dict | None:
    """Render one file and keep what the selector needs; None if it does not build a watertight part."""
    from scadreport import analyse, load_mesh, render
    with tempfile.TemporaryDirectory() as d:
        stl = os.path.join(d, "p.stl")
        try:
            if not render(path, stl, timeout=120)["ok"]:
                return None
            an = analyse(load_mesh(stl))
        except Exception:  # noqa: BLE001
            return None
    if not an["watertight"]:
        return None
    holes = [h for s in an["slices"] for h in s["holes"]]
    return {"size": sorted(float(v) for v in an["size"]), "volume": float(an["volume"]),
            "hole_counts": sorted({len(s["holes"]) for s in an["slices"]}),
            "hole_d": sorted({round(float(h["d"]), 1) for h in holes if h.get("d")})}


def near(x: float, nums: list[float]) -> bool:
    return any(abs(x - n) <= max(0.25, 0.01 * n) for n in nums)


def score(m: dict, nums: list[float], counts: set[int], others: list[dict]) -> float:
    s = sum(near(v, nums) for v in m["size"])
    if m["hole_d"]:
        s += sum(near(d, nums) for d in m["hole_d"]) / len(m["hole_d"])
    s += any(c in counts for c in m["hole_counts"] if c)
    agree = sum(all(abs(a - b) <= 1.0 for a, b in zip(m["size"], o["size"]))
                and abs(m["volume"] - o["volume"]) <= 0.02 * max(m["volume"], o["volume"]) for o in others)
    return s + 0.1 * agree


def final_name(row: dict) -> str:
    """The file name run_bench gave a conversation's last attempt (task, sample, non-default language/feedback)."""
    a = max(int(x.get("attempt", 0)) for x in row["attempts"])
    suffix = "".join(f"_{x}" for x, default in ((row.get("lang", "en"), "en"), (row.get("feedback", "report"), "report"))
                     if x != default)
    return f"{row['task']}_s{row['sample']}{suffix}_a{a}.scad"


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("runs", nargs="+")
    ap.add_argument("--workers", type=int, default=12)
    a = ap.parse_args()
    prompts = {t["id"]: t["prompt"] for t in yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))}
    cache = json.load(open(CACHE)) if os.path.exists(CACHE) else {}
    print("| Run | pass@1 | self-consistency pick | request-checked pick | pass@k |")
    print("|---|---:|---:|---:|---:|")
    for run in a.runs:
        rows = [r for r in rows_for(run) if r.get("attempts")]
        files = {}  # file name -> path, over the run's folders (each conversation is in exactly one)
        for x in sorted(os.listdir(os.path.join(HERE, "results"))):
            if x == run or re.fullmatch(re.escape(run) + r"-g\d+", x):
                for root, _, fs in os.walk(os.path.join(HERE, "results", x, "code")):
                    files.update({f: os.path.join(root, f) for f in fs if f.endswith(".scad")})
        paths = {id(r): files.get(final_name(r), "") for r in rows}
        todo = sorted({p for p in paths.values() if p and p not in cache})
        with ProcessPoolExecutor(a.workers) as ex:
            for p, m in zip(todo, ex.map(measure, todo)):
                cache[p] = m
        by = collections.defaultdict(list)
        for r in rows:
            by[r["task"]].append(r)
        p1 = pk = picked = 0
        for task, rs in by.items():
            rs.sort(key=lambda r: r["sample"])
            p1 += bool(rs[0].get("passed"))
            pk += any(r.get("passed") for r in rs)
            nums, counts = request_numbers(prompts[task])
            cands = [(r, cache.get(paths[id(r)])) for r in rs]
            cands = [(r, m) for r, m in cands if m]
            if cands:
                best = max(cands, key=lambda rm: (score(rm[1], nums, counts, [m for _, m in cands if m is not rm[1]]),
                                                  -rm[0]["sample"]))
                picked += bool(best[0].get("passed"))
        sc = sc_select(rows)
        n = len(by)
        missing = sum(not p for p in paths.values())
        print(f"| {run} | {p1}/{n} | {len(sc['pick'])}/{n} | {picked}/{n} | {pk}/{n} |"
              + (f" ({missing} final files not found)" if missing else ""))
    os.makedirs(os.path.dirname(CACHE), exist_ok=True)
    json.dump(cache, open(CACHE, "w"))


if __name__ == "__main__":
    main()
