#!/usr/bin/env python3
"""Per-task analyses of the held-out set, run after Seb unblinded it (PROTOCOL.md, "Unblinding the held-out set").

Exploratory, not pre-registered. Prints markdown:
  1. tasks passed within three attempts, per task and model, on both sets;
  2. the five tube holders against the other held-out tasks;
  3. checks per task on both sets, and the held-out failures closest to passing (for a hand check);
  4. request length, reference length and checks per task against per-task pass rates.

    python3 -I heldout_unblind.py [--near 0.8]
"""
import argparse
import collections
import json
import os
import statistics

import yaml
from scipy.stats import fisher_exact, spearmanr

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SETS = {
    "original": {"results": f"{ROOT}/bench/results", "tasks": f"{ROOT}/bench/tasks.yaml"},
    "held-out": {"results": f"{ROOT}/bench/heldout/harness/bench/results", "tasks": f"{ROOT}/bench/heldout/tasks.yaml"},
}
# label, original-set run, held-out run (RUN or RUN@MODEL); frontier models are left out of the pooled rates
MODELS = [
    ("Opus 5.5", "ceiling-opus", "ceiling-opus", "frontier"),
    ("Sonnet 5.5", "main-claude@claude:claude-sonnet-5-5", "r4-claude@claude:claude-sonnet-5-5", "frontier"),
    ("Haiku 4.5", "main-claude@claude:claude-haiku-4-5", "r4-claude@claude:claude-haiku-4-5", "pooled"),
    ("Gemma 26B", "box-gemma-h0", "r4-gemma26b-std", "pooled"),
    ("Gemma 26B h4", "box-gemma-h4", "r4-gemma26b-h4", "pooled"),
    ("Qwen3.6 27B", "main-tiiny@tiiny/Qwen/Qwen3.6-27B", "r4-qwen36-std", "pooled"),
    ("Qwen3.8 27B", "main-tiiny@tiiny/Qwen/Qwen3.8-27B", "r4-qwen38-std", "pooled"),
    ("Qwen3.8 scadfix", "box-scadfix-qwen38", "r4-qwen38-scadfix", "pooled"),
    ("Bonsai 27B", "main-bonsai", "r4-bonsai", "laptop"),
    ("Coder 7B", "main@qwen2.5-coder:7b", "r4-coder7b", "laptop"),
    ("Gemma E4B", "main@gemma4:e4b-it-q4_K_M", "r4-gemma4e4b", "laptop"),
    ("templates", "sm-template", "r4-template", "laptop"),
    ("features", "sm-features", "r4-features", "laptop"),
]
TUBE_HOLDERS = {"microtube_balance_stand", "roundbottom_tube_puck_2ml", "conical_15ml_incline_rack",
                "conical_50ml_carrier", "pcr_strip_ice_hanger"}


def load(results, spec):
    """The newest record per (model, task, sample) of RUN or RUN@MODEL, as r4_summary.py reads them."""
    run, _, model = spec.partition("@")
    path = os.path.join(results, run, "results.jsonl")
    newest = {}
    for line in open(path) if os.path.exists(path) else []:
        try:
            r = json.loads(line)
        except json.JSONDecodeError:
            continue
        if r.get("needs_rerun") or (model and r["model"] != model):
            continue
        key = (r["model"], r["task"], r["sample"])
        if key not in newest or str(r.get("finished", "")) >= str(newest[key].get("finished", "")):
            newest[key] = r
    return list(newest.values())


def tasks_of(path):
    out = {}
    for t in yaml.safe_load(open(path)):
        ref = t.get("reference") or ""
        ref_path = next((p for p in (os.path.join(ROOT, ref), os.path.join(ROOT, "bench", ref)) if ref and os.path.exists(p)), None)
        out[t["id"]] = {"short": t.get("short", t["id"]), "words": len(t["prompt"].split()), "top_checks": len(t["checks"]),
                        "ref_lines": sum(1 for l in open(ref_path) if l.strip()) if ref_path else None}
    return out


def items_per_task(recs):
    """Checker items per task, from any attempt that was checked (the count is fixed per task)."""
    n = {}
    for r in recs:
        for a in r["attempts"]:
            if a.get("check") and a["check"].get("n"):
                n.setdefault(r["task"], a["check"]["n"])
    return n


def best_attempt(r):
    checked = [a for a in r["attempts"] if a.get("check")]
    return max(checked, key=lambda a: a["check"].get("score", 0)) if checked else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--near", type=float, default=0.8, help="best score at or above which a failure is listed")
    args = ap.parse_args()

    data = {s: {label: load(SETS[s]["results"], spec) for label, *specs, _ in MODELS
                for spec in [specs[0] if s == "original" else specs[1]]} for s in SETS}
    tasks = {s: tasks_of(SETS[s]["tasks"]) for s in SETS}
    group = {label: g for label, _, _, g in MODELS}
    n_items = {s: {} for s in SETS}
    for s in SETS:
        for recs in data[s].values():
            for t, n in items_per_task(recs).items():
                n_items[s].setdefault(t, n)

    # 1. per task and model
    rate = {s: {} for s in SETS}
    for s in SETS:
        print(f"\n## 1. Tasks passed within three attempts, {s} set (passes / samples)\n")
        labels = [m[0] for m in MODELS if data[s][m[0]]]
        print("| task | " + " | ".join(labels) + " | pooled |")
        print("|---|" + "---:|" * (len(labels) + 1))
        for t in tasks[s]:
            cells, pp, pn = [], 0, 0
            for label in labels:
                rs = [r for r in data[s][label] if r["task"] == t]
                p = sum(r["passed"] for r in rs)
                cells.append(f"{p}/{len(rs)}" if rs else "-")
                if group[label] == "pooled":
                    pp, pn = pp + p, pn + len(rs)
            rate[s][t] = pp / pn if pn else None
            mark = " (tube)" if t in TUBE_HOLDERS else ""
            print(f"| {tasks[s][t]['short']}{mark} | " + " | ".join(cells) + f" | {pp}/{pn} |")

    # 2. tube holders against the rest
    print("\n## 2. Tube holders against the other held-out tasks (conversations passed)\n")
    print("| model | original set | held-out tube holders | held-out others | Fisher p (holders vs others) |")
    print("|---|---:|---:|---:|---:|")
    tot = collections.Counter()
    for label, *_ , g in MODELS:
        o = data["original"][label]
        h = data["held-out"][label]
        if not h:
            continue
        ht = [r for r in h if r["task"] in TUBE_HOLDERS]
        hx = [r for r in h if r["task"] not in TUBE_HOLDERS]
        a, b = sum(r["passed"] for r in ht), sum(r["passed"] for r in hx)
        p = fisher_exact([[a, len(ht) - a], [b, len(hx) - b]])[1] if (a + b) else 1.0
        print(f"| {label} | {sum(r['passed'] for r in o)}/{len(o)} | {a}/{len(ht)} | {b}/{len(hx)} | {p:.2f} |")
        if g == "pooled":
            tot.update({"o": sum(r["passed"] for r in o), "on": len(o), "a": a, "an": len(ht), "b": b, "bn": len(hx)})
    p = fisher_exact([[tot["a"], tot["an"] - tot["a"]], [tot["b"], tot["bn"] - tot["b"]]])[1]
    print(f"| pooled (Haiku and the box models) | {tot['o']}/{tot['on']} ({tot['o'] / tot['on']:.2f}) | "
          f"{tot['a']}/{tot['an']} ({tot['a'] / tot['an']:.2f}) | {tot['b']}/{tot['bn']} ({tot['b'] / tot['bn']:.2f}) | {p:.2f} |")

    # 3. checks per task, and the failures closest to passing
    print("\n## 3. Checks per task\n")
    for s in SETS:
        tops = [tasks[s][t]["top_checks"] for t in tasks[s]]
        items = [n_items[s][t] for t in tasks[s] if t in n_items[s]]
        print(f"- {s}: top-level checks {min(tops)}-{max(tops)} (mean {statistics.mean(tops):.1f}); "
              f"checker items {min(items)}-{max(items)} (mean {statistics.mean(items):.1f}, n = {len(items)} tasks)")
    print(f"\n### Held-out failures with a best attempt failing one item, or scoring at least {args.near}\n")
    print("| model | task | sample | best score | failed items |")
    print("|---|---|---:|---:|---|")
    for label, *_ , g in MODELS:
        for r in sorted(data["held-out"][label], key=lambda r: (r["task"], r["sample"])):
            if r["passed"]:
                continue
            a = best_attempt(r)
            if not a:
                continue
            bad = [i for i in a["check"].get("items", []) if not i.get("ok")]
            if len(bad) == 1 or a["check"].get("score", 0) >= args.near:
                msg = "; ".join(f"{i['check']}: {i.get('msg', '')}" for i in bad)
                print(f"| {label} | {r['task']} | {r['sample']} | {a['check'].get('score', 0):.2f} | {msg} |")
    print("\n### Claude Haiku 4.5's held-out failures (best attempt)\n")
    for r in sorted(data["held-out"]["Haiku 4.5"], key=lambda r: r["task"]):
        if r["passed"]:
            continue
        a = best_attempt(r)
        if not a:
            print(f"- {r['task']}: no attempt was checked")
            continue
        bad = [i for i in a["check"].get("items", []) if not i.get("ok")]
        print(f"- {r['task']} (best score {a['check'].get('score', 0):.2f}, {len(bad)} of {a['check'].get('n')} items failed): "
              + "; ".join(f"{i['check']}: {i.get('msg', '')}" for i in bad))

    # 4. task size against pass rates
    print("\n## 4. Task size against per-task pass rates (pooled: Haiku and the box models)\n")
    for s in SETS:
        print(f"### {s} set\n")
        print("| task | request words | reference lines | checker items | pooled pass rate |")
        print("|---|---:|---:|---:|---:|")
        for t in sorted(tasks[s], key=lambda t: -(rate[s][t] or 0)):
            print(f"| {tasks[s][t]['short']} | {tasks[s][t]['words']} | {tasks[s][t]['ref_lines']} | "
                  f"{n_items[s].get(t, '-')} | {rate[s][t]:.2f} |")
        words = [tasks[s][t]["words"] for t in tasks[s]]
        lines = [tasks[s][t]["ref_lines"] or 0 for t in tasks[s]]
        print(f"\n- means: {statistics.mean(words):.0f} words, {statistics.mean(lines):.0f} reference lines, "
              f"pooled pass rate {statistics.mean(rate[s][t] for t in tasks[s]):.2f}")
        for name, key in (("request words", lambda t: tasks[s][t]["words"]), ("reference lines", lambda t: tasks[s][t]["ref_lines"] or 0),
                          ("checker items", lambda t: n_items[s].get(t, 0))):
            rho, p = spearmanr([key(t) for t in tasks[s]], [rate[s][t] for t in tasks[s]])
            print(f"- Spearman, {name} against pass rate: {rho:.2f} (p = {p:.2f})")
        print()
    both = [(s, t) for s in SETS for t in tasks[s]]
    for name, key in (("request words", lambda s, t: tasks[s][t]["words"]), ("reference lines", lambda s, t: tasks[s][t]["ref_lines"] or 0),
                      ("checker items", lambda s, t: n_items[s].get(t, 0))):
        rho, p = spearmanr([key(s, t) for s, t in both], [rate[s][t] for s, t in both])
        print(f"- Both sets, 32 tasks, Spearman of {name} against pass rate: {rho:.2f} (p = {p:.3f})")


if __name__ == "__main__":
    main()
