#!/usr/bin/env python3
"""Test of idea 1 (bench/smallmodels/PROTOCOL.md) on the 16 benchmark tasks, run once with the frozen spec writer:
  1. the writer writes one spec per task from the request alone (seed 1000; kept in bench_specs.jsonl);
  2. the gate is tried on the 16 reference parts (a correct part it rejects only costs a hosted call);
  3. every saved attempt of the local models is measured and gated, and the gate's verdicts are compared with the
     hidden checks: first attempts (precision, recall), and the cascade - walk a conversation, keep the first attempt
     the gate accepts, otherwise send the task to the hosted model;
  4. teams: several local models' conversations on the same task, in a fixed order, the first accepted one kept.
The hidden checks are read only to score the gate, never to build it.

A rejected attempt goes on to the next saved attempt only when the hidden checks also failed it (then the same
scadreport feedback was sent). When the gate rejects an attempt the hidden checks passed, the saved conversation
ends there, where a gate-driven loop would have asked again: the task goes to the hosted model, and these cases are
counted ("cut short").

    ~/printpaper/.venv/bin/python -I bench_gate.py --measure-only            # fill the measurement cache
    ~/printpaper/.venv/bin/python -I bench_gate.py --writer gemma4:e4b-it-q4_K_M --prompt v1 --write
"""
import argparse
import collections
import hashlib
import json
import os
import re
import sys
from concurrent.futures import ProcessPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = "/home/seb/printpaper"
sys.path[:0] = [HERE, os.path.join(ROOT, "bench")]
import yaml  # noqa: E402
import spec as S  # noqa: E402
import analyze as A  # noqa: E402

CACHE = os.path.join(HERE, "bench_measure_cache.json")
SPECS = os.path.join(HERE, "bench_specs.jsonl")
LOCAL_RUNS = ["main", "main-bonsai", "ft-scad", "base-scad", "main-tiiny", "think-tiiny", "box-gemma-h4"]
HOSTED = [("Claude Sonnet 5.5", "claude:claude-sonnet-5-5"), ("Claude Haiku 4.5", "claude:claude-haiku-4-5")]
TEAMS = {  # fixed before the test, in order of cost (laptop) or of the published v0.3.0 results (box)
    "laptop: Gemma 4 E4B, scadcoder, Bonsai 2 27B": [("main", "gemma4:e4b-it-q4_K_M"), ("ft-scad", "scadcoder"),
                                                    ("main-bonsai", "bonsai2-27b-pq2_0")],
    "box: Gemma 4 26B, gpt-oss-120b thinking, Qwen3.6 27B": [("main-tiiny", "tiiny/google/gemma-4-26B-A4B-it"),
                                                            ("think-tiiny", "tiiny/openai/gpt-oss-120b"),
                                                            ("main-tiiny", "tiiny/Qwen/Qwen3.6-27B")],
}


def attempt_path(run, rec, k):
    suffix = "".join(f"_{x}" for x, d in ((rec.get("lang", "en"), "en"), (rec.get("feedback", "report"), "report"))
                     if x != d)
    safe = re.sub(r"[^A-Za-z0-9._-]+", "_", rec["model"])
    return os.path.join("bench", "results", run, "code", safe, f"{rec['task']}_s{rec['sample']}{suffix}_a{k}.scad")


def file_key(rel):
    """Cache key: the path from the repo root and the file's hash (a rerun that rewrites a file is measured again)."""
    return f"{rel}#{hashlib.sha1(open(os.path.join(ROOT, rel), 'rb').read()).hexdigest()[:12]}#mv{S.MEASURE_VERSION}"


def measure_rel(rel):
    return S.measure(os.path.join(ROOT, rel))


def walk(rec, verdicts):
    """('accept', right?) or ('escalate', cut_short?) for one conversation; verdicts[k] = the gate on attempt k."""
    att = rec["attempts"]
    for k, a in enumerate(att):
        if verdicts[k]:
            return "accept", bool(a.get("passed"))
        if a.get("passed"):
            return "escalate", True  # the gate rejected a right part; the saved conversation ends here
        if k == len(att) - 1:
            return "escalate", False
    return "escalate", False


def write_specs(tasks, writer, version, path):
    key = writer if version == "v1" else f"{writer}#{version}"
    have = {}
    if os.path.exists(path):
        for line in open(path):
            d = json.loads(line)
            have[(d["writer"], d["task"])] = d
    for t in tasks:
        if (key, t["id"]) in have:
            continue
        res = (S.write_spec_claude(writer.split(":", 1)[1], t["prompt"], version=version)
               if writer.startswith("claude:") else S.write_spec(writer, t["prompt"], version=version))
        d = {"writer": key, "task": t["id"], "spec": res["spec"], "raw": res["raw"], "usage": res["usage"]}
        with open(path, "a") as fh:
            fh.write(json.dumps(d) + "\n")
        have[(key, t["id"])] = d
        print(f"spec {t['id']}: {json.dumps(res['spec'])}", flush=True)
    return key, {t["id"]: have[(key, t["id"])]["spec"] for t in tasks if (key, t["id"]) in have}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--writer", help="the frozen spec writer (Ollama model)")
    ap.add_argument("--prompt", default="v1", choices=list(S.VERSIONS))
    ap.add_argument("--write", action="store_true", help="write the specs that are missing (the test's model calls)")
    ap.add_argument("--measure-only", action="store_true")
    ap.add_argument("--workers", type=int, default=3)
    ap.add_argument("--specs", default=SPECS, help="specs file (default: bench_specs.jsonl; another one for tests)")
    a = ap.parse_args()
    tasks = yaml.safe_load(open(os.path.join(ROOT, "bench", "tasks.yaml")))
    order = [t["id"] for t in tasks]
    runs = A.load_runs()
    recs = {run: [r for r in A.dedupe(runs.get(run, [])) if r.get("lang", "en") == "en"] for run in LOCAL_RUNS}
    hosted = {m: {r["task"]: bool(r["passed"]) for r in A.dedupe(runs.get("main-claude", [])) if r["model"] == m}
              for _, m in HOSTED}

    rels = {os.path.join("bench", "reference", f"{t}.scad") for t in order}
    for run, rs in recs.items():
        for r in rs:
            rels |= {attempt_path(run, r, k) for k in range(len(r["attempts"]))}
    present = sorted(p for p in rels if os.path.exists(os.path.join(ROOT, p)))
    cache = json.load(open(CACHE)) if os.path.exists(CACHE) else {}
    keys = {p: file_key(p) for p in present}
    todo = [p for p in present if keys[p] not in cache]
    print(f"{len(present)} files ({len(rels) - len(present)} missing), {len(todo)} to measure", file=sys.stderr, flush=True)
    with ProcessPoolExecutor(a.workers) as ex:
        for i, (p, m) in enumerate(zip(todo, ex.map(measure_rel, todo, chunksize=4)), 1):
            cache[keys[p]] = m
            if i % 50 == 0 or i == len(todo):
                json.dump(cache, open(CACHE, "w"))
                print(f"  measured {i}/{len(todo)}", file=sys.stderr, flush=True)
    if a.measure_only:
        return
    if not a.writer:
        raise SystemExit("--writer is required (the frozen spec writer)")
    if a.write:
        key, specs = write_specs(tasks, a.writer, a.prompt, a.specs)
    else:
        key = a.writer if a.prompt == "v1" else f"{a.writer}#{a.prompt}"
        specs = {}
        for line in open(a.specs):
            d = json.loads(line)
            if d["writer"] == key:
                specs[d["task"]] = d["spec"]
    if len(specs) != len(order):
        raise SystemExit(f"{key}: {len(specs)} of {len(order)} specs written - rerun with --write")
    m_of = lambda rel: cache.get(keys.get(rel)) if rel in keys else None  # noqa: E731

    out = {"writer": key, "specs": specs, "records": {run: len(rs) for run, rs in recs.items()}}
    lines = [f"# Spec gate on the 16 tasks: writer {key}", ""]
    ref_rows = []
    for t in order:
        ok, why = S.gate(specs[t], m_of(os.path.join("bench", "reference", f"{t}.scad")))
        ref_rows.append({"task": t, "accepts_reference": ok, "why": why})
    n_ref = sum(r["accepts_reference"] for r in ref_rows)
    out["references"] = ref_rows
    lines += [f"Accepts {n_ref}/16 reference parts.", ""]
    lines += [f"- {r['task']}: {'accepts' if r['accepts_reference'] else 'REJECTS: ' + '; '.join(r['why'])}"
              for r in ref_rows]

    def verdicts(run, r, gname):
        vs = []
        for k, att in enumerate(r["attempts"]):
            m = m_of(attempt_path(run, r, k))
            if gname == "oracle":
                vs.append(bool(att.get("passed")))
            elif gname == "render":
                vs.append(m is not None)
            else:
                vs.append(S.gate(specs[r["task"]], m)[0])
        return vs

    # first attempts and all attempts, per model
    rows = []
    for run, rs in recs.items():
        for model in sorted({r["model"] for r in rs}):
            c = collections.Counter()
            for r in (x for x in rs if x["model"] == model):
                vs = verdicts(run, r, "spec")
                for k, att in enumerate(r["attempts"]):
                    g = vs[k]
                    h = bool(att.get("passed"))
                    tag = ("tp" if h else "fp") if g else ("fn" if h else "tn")
                    c[("first_" if k == 0 else "later_") + tag] += 1
            rows.append({"run": run, "model": model, **c})
    out["attempts"] = rows
    pool = collections.Counter()
    for row in rows:
        for k, v in row.items():
            if k not in ("run", "model"):
                pool[k.split("_", 1)[1]] += v
    prec = pool["tp"] / max(1, pool["tp"] + pool["fp"])
    rec_ = pool["tp"] / max(1, pool["tp"] + pool["fn"])
    lines += ["", f"All saved local attempts: {sum(pool.values())}, right {pool['tp'] + pool['fn']}; the gate accepts "
              f"{pool['tp'] + pool['fp']}, of them right {prec:.2f} (precision), right parts accepted {rec_:.2f} (recall).", ""]
    lines += ["| Run | Model | First attempts | right | gate accepts | of them right | right accepted |",
              "|---|---|---:|---:|---:|---:|---:|"]
    for row in rows:
        tp, fp, fn, tn = (row.get("first_" + x, 0) for x in ("tp", "fp", "fn", "tn"))
        n = tp + fp + fn + tn
        lines.append(f"| {row['run']} | {row['model']} | {n} | {tp + fn} | {tp + fp} | "
                     f"{tp / (tp + fp) if tp + fp else float('nan'):.2f} | {tp / (tp + fn) if tp + fn else float('nan'):.2f} |")

    # the cascade, per model (full samples only)
    casc = []
    for run, rs in recs.items():
        for model in sorted({r["model"] for r in rs}):
            mine = [r for r in rs if r["model"] == model]
            full = [s for s in sorted({r["sample"] for r in mine}) if sum(r["sample"] == s for r in mine) == len(order)]
            if not full:
                continue
            for gname in ("render", "spec", "oracle"):
                tot = collections.Counter()
                for r in (x for x in mine if x["sample"] in full):
                    what, flag = walk(r, verdicts(run, r, gname))
                    if what == "accept":
                        tot["right" if flag else "wrong"] += 1
                    else:
                        tot["escalated"] += 1
                        tot["cut_short"] += flag
                        for hname, hm in HOSTED:
                            tot["hosted_ok:" + hname] += hosted[hm].get(r["task"], False)
                casc.append({"run": run, "model": model, "gate": gname, "samples": len(full),
                             **{k: round(v / len(full), 2) for k, v in tot.items()}})
    out["cascade"] = casc
    lines += ["", "Cascade (per sample of 16 tasks; escalated tasks take the hosted model's saved outcome):", "",
              "| Run | Model (samples) | Check | Kept, right | Kept, wrong | Sent to hosted | of them cut short |"
              " Right in the end, Sonnet 5.5 | Haiku 4.5 |", "|---|---|---|---:|---:|---:|---:|---:|---:|"]
    for o in casc:
        r, w, e = o.get("right", 0), o.get("wrong", 0), o.get("escalated", 0)
        lines.append(f"| {o['run']} | {o['model']} ({o['samples']}) | {o['gate']} | {r:g} | {w:g} | {e:g} | "
                     f"{o.get('cut_short', 0):g} | {r + o.get('hosted_ok:Claude Sonnet 5.5', 0):g} | "
                     f"{r + o.get('hosted_ok:Claude Haiku 4.5', 0):g} |")

    # teams
    team_rows = []
    for name, members in TEAMS.items():
        convs = []
        for run, model in members:
            mine = [r for r in recs[run] if r["model"] == model]
            convs.append((run, {(r["task"], r["sample"]): r for r in mine}))
        samples = sorted(set.intersection(*({s for (_, s) in c} for _, c in convs)))
        full = [s for s in samples if all((t, s) in c for _, c in convs for t in order)]
        for gname in ("spec", "oracle"):
            tot = collections.Counter()
            for s in full:
                for t in order:
                    for i, (run, c) in enumerate(convs):
                        what, flag = walk(c[(t, s)], verdicts(run, c[(t, s)], gname))
                        if what == "accept":
                            tot["right" if flag else "wrong"] += 1
                            tot[f"kept_by_{i}"] += 1
                            break
                    else:
                        tot["escalated"] += 1
                        for hname, hm in HOSTED:
                            tot["hosted_ok:" + hname] += hosted[hm].get(t, False)
            if full:
                team_rows.append({"team": name, "gate": gname, "samples": len(full),
                                  **{k: round(v / len(full), 2) for k, v in tot.items()}})
    # best of k samples of one model: its conversations on a task in sample order, the first accepted one kept
    for run, rs in recs.items():
        for model in sorted({r["model"] for r in rs}):
            mine = {(r["task"], r["sample"]): r for r in rs if r["model"] == model}
            full = [s for s in sorted({s for (_, s) in mine}) if all((t, s) in mine for t in order)]
            if len(full) < 2:
                continue
            for gname in ("spec", "oracle"):
                tot = collections.Counter()
                for t in order:
                    for s in full:
                        what, flag = walk(mine[(t, s)], verdicts(run, mine[(t, s)], gname))
                        if what == "accept":
                            tot["right" if flag else "wrong"] += 1
                            break
                    else:
                        tot["escalated"] += 1
                        for hname, hm in HOSTED:
                            tot["hosted_ok:" + hname] += hosted[hm].get(t, False)
                team_rows.append({"team": f"{model} ({run}), best of its {len(full)} samples", "gate": gname,
                                  "samples": 1, **tot})
    out["teams"] = team_rows
    lines += ["", "Teams and best of k samples (conversations in order; the first one the check accepts is kept):",
              "", "| Team (rounds) | Check | Kept, right | Kept, wrong | Sent to hosted | Right in the end, Sonnet 5.5 |",
              "|---|---|---:|---:|---:|---:|"]
    for o in team_rows:
        r, w, e = o.get("right", 0), o.get("wrong", 0), o.get("escalated", 0)
        lines.append(f"| {o['team']} ({o['samples']}) | {o['gate']} | {r:g} | {w:g} | {e:g} | "
                     f"{r + o.get('hosted_ok:Claude Sonnet 5.5', 0):g} |")
    base = os.path.join(HERE, "bench_gate_" + re.sub(r"[^A-Za-z0-9.]+", "_", key))
    json.dump(out, open(base + ".json", "w"), indent=1)
    open(base + ".md", "w").write("\n".join(lines) + "\n")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
