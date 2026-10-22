#!/usr/bin/env python3
"""Per-task analyses of the held-out set, run after Seb unblinded it (PROTOCOL.md, "Unblinding the held-out set").

Exploratory, not pre-registered. Prints markdown:
  1. tasks passed within three attempts, per task and model, on both sets;
  2. the five tube holders against the other held-out tasks;
  3. checks per task on both sets, and the held-out failures closest to passing (for a hand check);
  4. request length, reference length and checks per task against per-task pass rates;
  5. logistic models of passing on request length and checks (added after sections 1-4 had been read).

    python3 -I heldout_unblind.py [--near 0.8]
"""
import argparse
import collections
import json
import os
import statistics
import sys

import numpy as np
import yaml
from scipy.stats import fisher_exact, norm, spearmanr

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
    """The newest record per (model, task, sample, lang, feedback) of RUN or RUN@MODEL, as r4_summary.py reads them;
    damaged lines are skipped and counted. [] if the run is missing (main() refuses to go on unless --allow-missing)."""
    run, _, model = spec.partition("@")
    path = os.path.join(results, run, "results.jsonl")
    newest, bad = {}, 0
    for line in open(path, encoding="utf-8", errors="replace") if os.path.exists(path) else []:
        try:
            r = json.loads(line)
            key = (r["model"], r["task"], r["sample"], r.get("lang", "en"), r.get("feedback", "report"))
        except (json.JSONDecodeError, KeyError, TypeError, AttributeError):  # half-written or foreign line
            bad += bool(line.strip())
            continue
        if r.get("needs_rerun") or (model and r["model"] != model):
            continue
        if key not in newest or str(r.get("finished", "")) >= str(newest[key].get("finished", "")):
            newest[key] = r
    if bad:
        print(f"warning: {spec}: {bad} damaged line(s) skipped", file=sys.stderr)
    return list(newest.values())


def fmt(x, spec=".2f"):
    return "-" if x is None else format(x, spec)


def tasks_of(path):
    out = {}
    for t in yaml.safe_load(open(path)):
        ref = t.get("reference") or ""
        ref_path = next((p for p in (os.path.join(ROOT, ref), os.path.join(ROOT, "bench", ref)) if ref and os.path.exists(p)), None)
        out[t["id"]] = {"short": t.get("short", t["id"]), "words": len(t["prompt"].split()), "top_checks": len(t["checks"]),
                        "ref_lines": sum(1 for l in open(ref_path) if l.strip()) if ref_path else None}
    return out


def items_per_task(recs):
    """Checker items per task: the most common count over the checked attempts. A few attempts that passed under an
    older checker still carry its smaller count, since rescore.py rewrites an attempt only when its verdict or score
    changes."""
    n = collections.defaultdict(collections.Counter)
    for r in recs:
        for a in r["attempts"]:
            if a.get("check") and a["check"].get("n"):
                n[r["task"]][a["check"]["n"]] += 1
    return {t: c.most_common(1)[0][0] for t, c in n.items()}


def best_attempt(r):
    checked = [a for a in r["attempts"] if a.get("check")]
    return max(checked, key=lambda a: a["check"].get("score", 0)) if checked else None


def logit(X, y):
    """Logistic regression by Newton's method: coefficients, model-based covariance, fitted probabilities."""
    b = np.zeros(X.shape[1])
    for _ in range(100):
        p = 1 / (1 + np.exp(-X @ b))
        step = np.linalg.solve(X.T @ (X * (p * (1 - p))[:, None]), X.T @ (y - p))
        b += step
        if np.abs(step).max() < 1e-10:
            break
    p = 1 / (1 + np.exp(-X @ b))
    return b, np.linalg.inv(X.T @ (X * (p * (1 - p))[:, None])), p


def clustered(X, y, p, cov, groups):
    """Covariance robust to correlation within each group (here a task), with the usual small-sample factor."""
    u = X * (y - p)[:, None]
    meat = sum(np.outer(u[groups == g].sum(0), u[groups == g].sum(0)) for g in set(groups))
    n_groups, n, k = len(set(groups)), len(y), X.shape[1]
    return n_groups / (n_groups - 1) * (n - 1) / (n - k) * cov @ meat @ cov


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--near", type=float, default=0.8, help="best score at or above which a failure is listed")
    ap.add_argument("--allow-missing", action="store_true",
                    help="go on when a run in MODELS has no records (the pooled rates then cover fewer models)")
    args = ap.parse_args()

    data = {s: {label: load(SETS[s]["results"], spec) for label, *specs, _ in MODELS
                for spec in [specs[0] if s == "original" else specs[1]]} for s in SETS}
    tasks = {s: tasks_of(SETS[s]["tasks"]) for s in SETS}
    group = {label: g for label, _, _, g in MODELS}
    n_items = {s: items_per_task([r for recs in data[s].values() for r in recs]) for s in SETS}

    missing = [f"{s}: {label}" for s in SETS for label, *_ in MODELS if not data[s][label]]
    if missing and not args.allow_missing:  # a missing run would silently change every pooled number
        raise SystemExit("no records for " + "; ".join(missing) + " (use --allow-missing to go on without them)")

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
    share = lambda k, n: fmt(tot[k] / tot[n] if tot[n] else None)  # noqa: E731
    print(f"| pooled (Haiku and the box models) | {tot['o']}/{tot['on']} ({share('o', 'on')}) | "
          f"{tot['a']}/{tot['an']} ({share('a', 'an')}) | {tot['b']}/{tot['bn']} ({share('b', 'bn')}) | {p:.2f} |")

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
                  f"{n_items[s].get(t, '-')} | {fmt(rate[s][t])} |")
        words = [tasks[s][t]["words"] for t in tasks[s]]
        lines = [tasks[s][t]["ref_lines"] or 0 for t in tasks[s]]
        rated = [t for t in tasks[s] if rate[s][t] is not None]  # tasks with at least one pooled conversation
        print(f"\n- means: {statistics.mean(words):.0f} words, {statistics.mean(lines):.0f} reference lines, "
              f"pooled pass rate {fmt(statistics.mean(rate[s][t] for t in rated) if rated else None)}"
              + (f" ({len(tasks[s]) - len(rated)} task(s) without a pooled conversation left out)" if len(rated) < len(tasks[s]) else ""))
        for name, key in (("request words", lambda t: tasks[s][t]["words"]), ("reference lines", lambda t: tasks[s][t]["ref_lines"] or 0),
                          ("checker items", lambda t: n_items[s].get(t, 0))):
            rho, p = spearmanr([key(t) for t in rated], [rate[s][t] for t in rated])
            print(f"- Spearman, {name} against pass rate: {rho:.2f} (p = {p:.2f})")
        print()
    both = [(s, t) for s in SETS for t in tasks[s] if rate[s][t] is not None]
    for name, key in (("request words", lambda s, t: tasks[s][t]["words"]), ("reference lines", lambda s, t: tasks[s][t]["ref_lines"] or 0),
                      ("checker items", lambda s, t: n_items[s].get(t, 0))):
        rho, p = spearmanr([key(s, t) for s, t in both], [rate[s][t] for s, t in both])
        print(f"- Both sets, {len(both)} tasks, Spearman of {name} against pass rate: {rho:.2f} (p = {p:.3f})")

    # 5. logistic models over the pooled conversations, with a term for each model (no separate intercept)
    print("\n## 5. Logistic models of passing (pooled: Haiku and the box models; added after sections 1-4)\n")
    # a model needs records on both sets, or its term cannot be fitted (with --allow-missing, some may lack them)
    pooled = [label for label, *_, g in MODELS if g == "pooled" and data["original"][label] and data["held-out"][label]]
    left = [label for label, *_, g in MODELS if g == "pooled" and label not in pooled]
    if left:
        print(f"- Left out, without records on both sets: {', '.join(left)}")
    if not pooled:
        print("- No pooled model has records on both sets; no model fitted.")
        return
    convs = [(s, label, r["task"], float(bool(r["passed"]))) for s in SETS for label in pooled for r in data[s][label]]
    uncounted = sorted({f"{s}: {t}" for s, _, t, _ in convs if t not in n_items[s]})
    if uncounted:  # a task never checked has no item count, and 0 would bias the fits
        raise SystemExit("no checker-item count for " + ", ".join(uncounted))
    size = {"words": lambda s, t: tasks[s][t]["words"], "items": lambda s, t: n_items[s].get(t, 0),
            "lines": lambda s, t: tasks[s][t]["ref_lines"] or 0}

    def design(rows, cols, set_term):
        return np.array([[float(m == label) for label in pooled] + ([float(s == "held-out")] if set_term else [])
                         + [float(size[c](s, t)) for c in cols] for s, m, t, _ in rows])

    orig = [c for c in convs if c[0] == "original"]
    held = [c for c in convs if c[0] == "held-out"]
    obs_o, obs_h = statistics.mean(c[3] for c in orig), statistics.mean(c[3] for c in held)
    print(f"- Observed pass rates: original {obs_o:.3f}, held-out {obs_h:.3f} ({len(orig)} and {len(held)} conversations)")
    for cols in (["words"], ["lines"], ["items"], ["words", "items"]):
        b, _, _ = logit(design(orig, cols, False), np.array([c[3] for c in orig]))
        pred = float(np.mean(1 / (1 + np.exp(-design(held, cols, False) @ b))))
        print(f"- Fitted to the original set on {' + '.join(cols)}: predicted held-out rate {pred:.3f}, "
              f"{(obs_o - pred) / (obs_o - obs_h):.0%} of the drop")
    y = np.array([c[3] for c in convs])
    groups = np.array([f"{s}:{t}" for s, _, t, _ in convs])
    k = len(pooled)
    for cols in ([], ["words"], ["words", "items"]):
        X = design(convs, cols, True)
        b, cov, p = logit(X, y)
        se, se_c = np.sqrt(cov[k, k]), np.sqrt(clustered(X, y, p, cov, groups)[k, k])
        print(f"- Both sets, held-out term{''.join(' + ' + c for c in cols)}: odds ratio {np.exp(b[k]):.2f}; "
              f"p = {2 * norm.sf(abs(b[k] / se)):.4f} treating conversations as independent, "
              f"{2 * norm.sf(abs(b[k] / se_c)):.4f} with errors clustered by task")


if __name__ == "__main__":
    main()
