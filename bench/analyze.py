#!/usr/bin/env python3
"""Summarise benchmark runs into tables + figures and refresh the paper's results section.

    python bench/analyze.py                 # all runs under bench/results/
    python bench/analyze.py --no-readme     # do not touch README.md

Outputs
  bench/results/summary.csv            one row per (run, model)
  figures/fig_*_{light,dark}.png       charts (light and dark variants for GitHub)
  README.md                            text between <!-- AUTO:name --> markers
"""
import argparse
import collections
import csv
import glob
import hashlib
import json
import math
import os
import re
import statistics
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import yaml  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
FIG = os.path.join(ROOT, "figures")
CATS = ["benchware", "tools", "quick-fixes", "hardware"]
CAT_LABEL = {"benchware": "Benchware", "tools": "Tools", "quick-fixes": "Quick fixes", "hardware": "Full hardware"}

# Validated with the dataviz palette checker (ordinal / categorical, light + dark surfaces).
THEMES = {
    "light": {"surface": "#fcfcfb", "ink": "#0b0b0b", "ink2": "#52514e", "muted": "#898781",
              "grid": "#e1e0d9", "axis": "#c3c2b7",
              "first": "#86b6ef", "after": "#1c5cab",                          # dumbbell
              "ramp": ["#86b6ef", "#3987e5", "#184f95"],                       # wrong / pass-later / pass-first
              "cat": ["#2a78d6", "#eb6834", "#1baf7a", "#eda100"]},
    "dark": {"surface": "#1a1a19", "ink": "#ffffff", "ink2": "#c3c2b7", "muted": "#898781",
             "grid": "#2c2c2a", "axis": "#383835",
             "first": "#256abf", "after": "#9ec5f4",
             "ramp": ["#184f95", "#3987e5", "#9ec5f4"],
             "cat": ["#3987e5", "#d95926", "#199e70", "#c98500"]},
}


# --------------------------------------------------------------------------- loading

def conv_key(r):
    return (r["model"], r["task"], r["sample"], r.get("lang", "en"), r.get("feedback", "report"))


def load_runs():
    """All runs; damaged lines are skipped and repeated conversations keep only the newest record
    (by its `finished` time, so the order of lines in a merged file does not matter). Records that a
    rescore flagged `needs_rerun` are left out until run_bench.py has redone them."""
    runs = {}
    for path in sorted(glob.glob(os.path.join(HERE, "results", "*", "results.jsonl"))):
        run = os.path.basename(os.path.dirname(path))
        if run.startswith(("smoke", "calib", "_")):
            continue
        latest = {}
        for line in open(path, errors="replace"):
            try:
                r = json.loads(line)
            except json.JSONDecodeError:
                continue
            if not isinstance(r, dict) or not {"model", "task", "sample", "attempts"} <= r.keys() \
                    or not isinstance(r["attempts"], list):
                continue  # valid JSON but not a record (hand edit, foreign file)
            r["_run"] = run
            # A rescore can turn an earlier attempt into a pass; the attempts after it would never
            # have been requested, so they are dropped (they would count as repairs and cut-offs).
            first = next((i for i, a in enumerate(r["attempts"]) if a.get("passed")), None)
            if first is not None:
                r["attempts"] = r["attempts"][:first + 1]
            old = latest.get(conv_key(r))
            if old is None or str(r.get("finished", "")) >= str(old.get("finished", "")):
                latest[conv_key(r)] = r
        flagged = [r for r in latest.values() if r.get("needs_rerun")]
        if flagged:
            print(f"warning: {run}: {len(flagged)} conversation(s) flagged needs_rerun by a rescore are left out "
                  f"until run_bench.py redoes them, e.g. {flagged[0]['model']} {flagged[0]['task']} "
                  f"s{flagged[0]['sample']}", file=sys.stderr)
        runs[run] = [r for r in latest.values() if not r.get("needs_rerun")]
    return runs


def dedupe(records):
    """One record per conversation key across run folders (newest wins)."""
    latest = {}
    for r in sorted(records, key=lambda r: str(r.get("finished", ""))):
        latest[conv_key(r)] = r
    return list(latest.values())


GEOM_AS_VALUE = re.compile(r"^\s*\w+\s*=\s*(cube|cylinder|sphere|translate|rotate|union|difference|intersection|"
                           r"for|linear_extrude|rotate_extrude|polygon|hull|mirror)\s*[(\[]", re.M)


def first_code(rec):
    suffix = "".join(f"_{x}" for x, d in ((rec.get("lang", "en"), "en"), (rec.get("feedback", "report"), "report")) if x != d)
    path = os.path.join(HERE, "results", rec["_run"], "code", re.sub(r"[^A-Za-z0-9._-]+", "_", rec["model"]),
                        f"{rec['task']}_s{rec['sample']}{suffix}_a0.scad")
    return open(path).read() if os.path.exists(path) else None


def code_hash(rec, i):
    """Hash of the code in attempt i (recorded by newer runs; recomputed from the saved .scad otherwise)."""
    a = rec["attempts"][i]
    if a.get("code_sha1") is not None or not a.get("code_lines"):
        return a.get("code_sha1")
    suffix = "".join(f"_{x}" for x, d in ((rec.get("lang", "en"), "en"), (rec.get("feedback", "report"), "report")) if x != d)
    path = os.path.join(HERE, "results", rec["_run"], "code", re.sub(r"[^A-Za-z0-9._-]+", "_", rec["model"]),
                        f"{rec['task']}_s{rec['sample']}{suffix}_a{i}.scad")
    if not os.path.exists(path):
        return None
    return hashlib.sha1(open(path, "rb").read()).hexdigest()[:12]


def wilson(k, n, z=1.96):
    if n == 0:
        return (0.0, 0.0)
    p = k / n
    d = 1 + z * z / n
    c = (p + z * z / (2 * n)) / d
    h = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / d
    return (max(0.0, c - h), min(1.0, c + h))


def outcome(rec):
    """Ordinal outcome of one conversation: 3 pass on 1st try, 2 pass after feedback,
    1 rendered but never matched the spec, 0 nothing rendered."""
    atts = rec["attempts"]
    for i, a in enumerate(atts):
        if a.get("passed"):
            return 3 if i == 0 else 2, i + 1
    if any(a.get("render", {}).get("ok") for a in atts):
        return 1, None
    return 0, None


def failure_stage(a):
    if a.get("error"):
        return "error"
    if not a.get("render", {}).get("ok") and (a.get("usage") or {}).get("done_reason") in ("length", "repetition"):
        return "truncated"  # hit the token cap or looped: the file never ended
    if a.get("extract") == "none":
        return "no code"
    if not a.get("render", {}).get("ok"):
        msgs = " ".join(a.get("render", {}).get("messages", []))
        if "Parser error" in msgs or "syntax error" in msgs:
            return "syntax error"
        if "top level object is empty" in msgs or "not a 3D object" in msgs:
            return "no solid"
        if "timed out" in msgs:
            return "timeout"
        return "render error"
    return "pass" if a.get("passed") else "wrong geometry"


def tier(rec):
    """Best outcome reached in a conversation: 0 nothing rendered, 1 rendered,
    2 rendered with the right overall size and number of bodies, 3 passed."""
    best = 0
    for a in rec["attempts"]:
        if a.get("passed"):
            return 3
        chk = a.get("check")
        if chk:
            ok = {i["check"]: i["ok"] for i in chk["items"]}
            best = max(best, 2 if ok.get("bbox") and ok.get("bodies", True) else 1)
        elif a.get("render", {}).get("ok"):
            best = max(best, 1)
    return best


def summarise(records, models_meta, tasks):
    by_model = collections.defaultdict(list)
    for r in records:
        by_model[r["model"]].append(r)
    rows = []
    for model, recs in by_model.items():
        meta = models_meta.get(model, {"label": model})
        n = len(recs)
        k1 = sum(1 for r in recs if r["attempts"] and r["attempts"][0].get("passed"))
        k2 = sum(1 for r in recs if any(a.get("passed") for a in r["attempts"][:2]))
        k3 = sum(1 for r in recs if any(a.get("passed") for a in r["attempts"][:3]))
        rend1 = sum(1 for r in recs if r["attempts"] and r["attempts"][0].get("render", {}).get("ok"))
        best = [max((a.get("score") or 0) for a in r["attempts"]) if r["attempts"] else 0 for r in recs]
        walls = sorted(r["wall_s"] for r in recs)
        gtok = sum((a.get("usage") or {}).get("gen_tokens") or 0 for r in recs for a in r["attempts"])
        gsec = sum((a.get("usage") or {}).get("gen_s") or 0 for r in recs for a in r["attempts"])
        att0 = [r["attempts"][0] for r in recs if r["attempts"]]
        stages = collections.Counter(failure_stage(a) for a in att0)
        repairs = [(r, i) for r in recs for i in range(1, len(r["attempts"]))]
        same = sum(1 for r, i in repairs if code_hash(r, i) is not None and code_hash(r, i) == code_hash(r, i - 1))
        rows.append({
            "model": model, "label": meta.get("label", model), "family": meta.get("family", ""),
            "hosted": bool(meta.get("hosted")), "size_gb": meta.get("size_gb"), "params_b": meta.get("params_b"),
            "params_total_b": meta.get("params_total_b"),
            "licence": meta.get("licence", ""), "n_tasks": n, "complete": len({r["task"] for r in recs}) >= len(tasks),
            "pass1": k1, "pass2": k2, "pass3": k3, "render1": rend1,
            "pass1_rate": k1 / n, "pass3_rate": k3 / n, "pass3_ci": wilson(k3, n),
            "mean_best_score": sum(best) / n,
            "median_task_min": statistics.median(walls) / 60 if walls else None,
            "total_min": sum(walls) / 60,
            "gen_tok_s": gtok / gsec if gsec else None,
            "first_stage": dict(stages), "repeat_repairs": same, "n_repairs": len(repairs),
            "tiers": collections.Counter(tier(r) for r in recs),
            "tasks_half": sum(1 for b in best if b >= 0.5),
            # only real code: a whole unfenced reply ("bare") is usually prose about the code
            "geom_as_value": sum(1 for r in recs if r["attempts"] and r["attempts"][0].get("extract") in ("fenced", "unterminated")
                                 and GEOM_AS_VALUE.search(first_code(r) or "")),
            "truncated": sum(1 for r in recs for a in r["attempts"]
                             if (a.get("usage") or {}).get("done_reason") in ("length", "repetition")),
            "n_attempts": sum(len(r["attempts"]) for r in recs),
        })
    return rows


# --------------------------------------------------------------------------- figures

def style(ax, th, xgrid=True):
    ax.set_facecolor(th["surface"])
    for s in ("top", "right", "left"):
        ax.spines[s].set_visible(False)
    ax.spines["bottom"].set_color(th["axis"])
    ax.spines["bottom"].set_linewidth(1)
    ax.tick_params(colors=th["muted"], length=0, labelsize=9)
    if xgrid:
        ax.grid(axis="x", color=th["grid"], linewidth=1)
    ax.set_axisbelow(True)


def order_models(rows):
    local = sorted([r for r in rows if not r["hosted"]], key=lambda r: (r["size_gb"] or 99, r["label"]))
    hosted = [r for r in rows if r["hosted"]]
    return hosted + local




def fig_heatmap(records, rows, tasks, th, path, title):
    rows = order_models(rows)
    res = {(r["model"], r["task"]): outcome(r) for r in records}

    def cell(model, tid):
        o = res.get((model, tid))
        if o is None:
            return None
        level, att = o
        return level, str(att) if att else ("·" if level == 1 else "×")

    draw_grid(rows, tasks, cell, th, path, title,
              ["passed, 1st attempt (1)", "passed after feedback (2, 3)", "rendered but wrong (·)", "nothing rendered (×)"])


def fig_box_heatmap(records, rows, tasks, th, path, title):
    """Several samples per model: each cell counts the samples that passed the task (the complete
    samples only, once a model has one, so a sample still running cannot fake "every sample")."""
    used = {(r["model"], s) for r in rows for s in r["samples_used"]}
    by = collections.defaultdict(list)
    for r in records:
        if (r["model"], r["sample"]) in used:
            by[(r["model"], r["task"])].append(r)

    def cell(model, tid):
        rs = by.get((model, tid))
        if not rs:
            return None
        k = sum(any(a.get("passed") for a in r["attempts"]) for r in rs)
        if k:
            return (3 if k == len(rs) else 2), f"{k}/{len(rs)}"
        rendered = any(a.get("render", {}).get("ok") for r in rs for a in r["attempts"])
        return (1, "·") if rendered else (0, "×")

    draw_grid(rows, tasks, cell, th, path, title,
              ["passed in every sample", "passed in some samples", "rendered, never passed (·)",
               "nothing rendered (×)"])


def draw_grid(rows, tasks, cell, th, path, title, legend):
    """Models x tasks grid; cell(model, task) -> (level 0-3, text) or None."""
    tids = [t["id"] for t in sorted(tasks, key=lambda t: CATS.index(t["category"]))]
    H = 0.36 * len(rows) + 2.2
    fig, ax = plt.subplots(figsize=(10.5, H), dpi=150)
    fig.subplots_adjust(left=2.0 / 10.5, right=0.99, top=1 - 0.72 / H, bottom=1.3 / H)
    fig.patch.set_facecolor(th["surface"])
    ax.set_facecolor(th["surface"])
    cols = th["ramp"]
    for yi, r in enumerate(rows):
        for xi, tid in enumerate(tids):
            o = cell(r["model"], tid)
            x0, y0 = xi, len(rows) - 1 - yi
            if o is None:
                continue
            level, txt = o
            if level >= 1:
                ax.add_patch(plt.Rectangle((x0 + 0.04, y0 + 0.06), 0.92, 0.88, color=cols[level - 1], linewidth=0))
            tc = th["ink"] if level in (0, 1) else ("#ffffff" if th is THEMES["light"] or level == 2 else th["surface"])
            if th is THEMES["dark"] and level == 3:
                tc = "#0b0b0b"
            ax.text(x0 + 0.5, y0 + 0.5, txt, ha="center", va="center", fontsize=8, color=tc if level else th["muted"])
    ax.set_xlim(0, len(tids))
    ax.set_ylim(0, len(rows))
    ax.set_yticks([len(rows) - 1 - i + 0.5 for i in range(len(rows))])
    ax.set_yticklabels([r["label"] for r in rows], fontsize=8.5, color=th["ink"])
    short = {t["id"]: t.get("short", t["title"]) for t in tasks}
    ax.set_xticks([i + 0.5 for i in range(len(tids))])
    ax.set_xticklabels([short[t] for t in tids], rotation=40, ha="right", rotation_mode="anchor",
                       fontsize=8, color=th["ink2"])
    for s in ax.spines.values():
        s.set_visible(False)
    ax.tick_params(length=0)
    for ci, cat in enumerate(CATS):  # category bands
        idx = [i for i, t in enumerate(tids) if next(x for x in tasks if x["id"] == t)["category"] == cat]
        ax.text((idx[0] + idx[-1] + 1) / 2, len(rows) + 0.12, CAT_LABEL[cat], ha="center", va="bottom",
                fontsize=9, color=th["ink"], fontweight="bold", clip_on=False)
        if ci:
            ax.axvline(idx[0], color=th["surface"], linewidth=3)
    nh = sum(r["hosted"] for r in rows)
    if nh:
        ax.axhline(len(rows) - nh, color=th["surface"], linewidth=3)
    handles = [plt.Rectangle((0, 0), 1, 1, color=cols[2]), plt.Rectangle((0, 0), 1, 1, color=cols[1]),
               plt.Rectangle((0, 0), 1, 1, color=cols[0]),
               plt.Rectangle((0, 0), 1, 1, facecolor=th["surface"], edgecolor=th["axis"])]
    fig.legend(handles, legend, loc="lower center", bbox_to_anchor=(0.55, 0.0), ncol=4, frameon=False,
               fontsize=8.5, labelcolor=th["ink2"], handlelength=1.2)
    fig.suptitle(title, x=0.01, y=1 - 0.08 / H, ha="left", va="top", fontsize=11.5, color=th["ink"],
                 fontweight="bold")
    fig.savefig(path, facecolor=th["surface"])
    plt.close(fig)




def fig_lang(records, models_meta, th, path, title):
    langs = ["en", "es", "hi", "sw"]
    lang_label = {"en": "English", "es": "Spanish", "hi": "Hindi", "sw": "Swahili"}
    by = collections.defaultdict(lambda: [0, 0])
    for r in records:
        k = (r["model"], r.get("lang", "en"))
        by[k][1] += 1
        by[k][0] += any(a.get("passed") for a in r["attempts"])
    models = sorted({m for m, _ in by}, key=lambda m: (models_meta.get(m, {}).get("hosted", False), m))
    if not models:
        return False
    fig, ax = plt.subplots(figsize=(8.2, 1.0 + 0.9 * len(models)), dpi=150)
    fig.patch.set_facecolor(th["surface"])
    style(ax, th)
    bh = 0.18
    for mi, m in enumerate(models[::-1]):
        for li, lg in enumerate(langs):
            k, n = by.get((m, lg), [0, 0])
            if not n:
                continue
            yv = mi + (1.5 - li) * (bh + 0.02)
            ax.barh(yv, 100 * k / n, height=bh, color=th["cat"][li], linewidth=0)
            ax.text(100 * k / n + 1, yv, f"{lang_label[lg]} {k}/{n}", va="center", fontsize=7.5, color=th["ink2"])
    ax.set_yticks(range(len(models)))
    ax.set_yticklabels([models_meta.get(m, {}).get("label", m) for m in models[::-1]], fontsize=9, color=th["ink"])
    ax.set_xlim(0, 118)
    ax.set_xticks([0, 25, 50, 75, 100])
    ax.set_xticklabels(["0%", "25%", "50%", "75%", "100%"])
    handles = [plt.Rectangle((0, 0), 1, 1, color=th["cat"][i]) for i in range(4)]
    ax.legend(handles, [lang_label[lg] for lg in langs], loc="lower center", bbox_to_anchor=(0.45, 1.0),
              ncol=4, frameon=False, fontsize=9, labelcolor=th["ink2"])
    fig.suptitle(title, x=0.01, ha="left", fontsize=11.5, color=th["ink"], fontweight="bold")
    fig.tight_layout()
    fig.savefig(path, facecolor=th["surface"])
    plt.close(fig)
    return True


# --------------------------------------------------------------------------- tables

def mcnemar_exact(b, c):
    """Two-sided exact McNemar test on b and c discordant pairs."""
    n = b + c
    return 1.0 if n == 0 else min(1.0, 2 * sum(math.comb(n, i) for i in range(min(b, c) + 1)) / 2 ** n)


def language_tests(recs):
    """Paired comparison of each language with English, per model (passes and first tries)."""
    by = collections.defaultdict(dict)
    for r in recs:
        by[(r["model"], r.get("lang", "en"))][r["task"]] = (any(a.get("passed") for a in r["attempts"]),
                                                          bool(r["attempts"] and r["attempts"][0].get("passed")))
    out = ["| Model | Language | Pass ≤3 (vs English) | McNemar p | Pass 1st (vs English) | McNemar p |", "|---|---|---:|---:|---:|---:|"]
    for (model, lang), res in sorted(by.items()):
        en = by.get((model, "en"))
        if lang == "en" or not en:
            continue
        tasks = sorted(set(res) & set(en))
        row = [model, lang]
        for j in (0, 1):
            b = sum(en[t][j] and not res[t][j] for t in tasks)
            c = sum(res[t][j] and not en[t][j] for t in tasks)
            row += [f"{sum(res[t][j] for t in tasks)} ({sum(en[t][j] for t in tasks)})/{len(tasks)}", f"{mcnemar_exact(b, c):.3f}"]
        out.append("| " + " | ".join(row) + " |")
    return "\n".join(out)


def pct(k, n):
    return f"{100 * k / n:.0f}%" if n else "-"


def table_main(rows):
    out = ["| Model | Download | Licence | Pass, 1st try | Pass, ≤3 tries (95% CI) | Renders 1st try | "
           "Median min/task | Tokens/s | Same code after feedback |",
           "|---|---:|---|---:|---:|---:|---:|---:|---:|"]
    for r in order_models(rows):
        ci = r["pass3_ci"]
        out.append(
            f"| {r['label']}{'' if r['complete'] else ' *(partial)*'} | "
            f"{'hosted' if r['hosted'] else (str(r['size_gb']) + ' GB') if r['size_gb'] else '-'} | {r['licence']} | "
            f"{r['pass1']}/{r['n_tasks']} | {r['pass3']}/{r['n_tasks']} ({100 * ci[0]:.0f}-{100 * ci[1]:.0f}%) | "
            f"{r['render1']}/{r['n_tasks']} | "
            f"{r['median_task_min']:.1f} | {('%.1f' % r['gen_tok_s']) if r['gen_tok_s'] and not r['hosted'] else '-'} | "
            f"{r['repeat_repairs']}/{r['n_repairs']} |")
    return "\n".join(out)


def table_categories(records, rows):
    cat_of = {}
    for r in records:
        cat_of[r["task"]] = r["category"]
    out = ["| Model | " + " | ".join(CAT_LABEL[c] for c in CATS) + " |", "|---|" + "---:|" * len(CATS)]
    for row in order_models(rows):
        cells = []
        for c in CATS:
            recs = [r for r in records if r["model"] == row["model"] and r["category"] == c]
            k = sum(any(a.get("passed") for a in r["attempts"]) for r in recs)
            cells.append(f"{k}/{len(recs)}" if recs else "-")
        out.append(f"| {row['label']} | " + " | ".join(cells) + " |")
    return "\n".join(out)


def table_graded(rows):
    out = ["| Model | Rendered (any try) | Right size and body count | Passed | Tasks with ≥ half the checks | "
           "First file treats geometry as a value | Attempts cut off (cap or loop) | Same code after feedback |",
           "|---|---:|---:|---:|---:|---:|---:|---:|"]
    for r in order_models(rows):
        t, n = r["tiers"], r["n_tasks"]
        out.append(f"| {r['label']}{'' if r['complete'] else ' *(partial)*'} | {t[1] + t[2] + t[3]}/{n} | "
                   f"{t[2] + t[3]}/{n} | {t[3]}/{n} | {r['tasks_half']}/{n} | {r['geom_as_value']}/{n} | "
                   f"{r['truncated']}/{r['n_attempts']} | {r['repeat_repairs']}/{r['n_repairs']} |")
    return "\n".join(out)


def fig_tiers(rows, th, path, title):
    """Stacked bars: best outcome per task, ordinal single-hue ramp (validated palette)."""
    rows = order_models(rows)
    fig, ax = plt.subplots(figsize=(8.6, 0.42 * len(rows) + 1.6), dpi=150)
    fig.patch.set_facecolor(th["surface"])
    style(ax, th)
    cols = {1: th["ramp"][0], 2: th["ramp"][1], 3: th["ramp"][2]}
    y = list(range(len(rows)))[::-1]
    for yi, r in zip(y, rows):
        left = 0
        for lvl in (3, 2, 1):
            w = 100 * r["tiers"][lvl] / r["n_tasks"]
            if w:
                ax.barh(yi, w - 0.6, left=left, height=0.56, color=cols[lvl], linewidth=0)
            left += w
        ax.text(101, yi, f"{r['tiers'][3]}/{r['n_tasks']} passed" + ("" if r["complete"] else " (partial)"),
                va="center", fontsize=8, color=th["ink2"])
    ax.set_yticks(y)
    ax.set_yticklabels([r["label"] + (f"  ·  {r['size_gb']:.1f} GB" if r["size_gb"] else "") for r in rows],
                       fontsize=9, color=th["ink"])
    ax.set_xlim(0, 122)
    ax.set_xticks([0, 25, 50, 75, 100])
    ax.set_xticklabels(["0%", "25%", "50%", "75%", "100%"])
    handles = [plt.Rectangle((0, 0), 1, 1, color=cols[k]) for k in (3, 2, 1)]
    ax.legend(handles, ["passed every check", "right overall size and body count", "rendered, wrong size"],
              loc="lower center", bbox_to_anchor=(0.45, 1.0), ncol=3, frameon=False, fontsize=8.5,
              labelcolor=th["ink2"])
    fig.suptitle(title, x=0.01, ha="left", fontsize=11.5, color=th["ink"], fontweight="bold")
    fig.tight_layout()
    fig.savefig(path, facecolor=th["surface"])
    plt.close(fig)


def table_failures(rows):
    stages = ["truncated", "no code", "syntax error", "render error", "no solid", "timeout", "wrong geometry", "pass"]
    out = ["| Model | " + " | ".join(stages) + " |", "|---|" + "---:|" * len(stages)]
    for r in order_models(rows):
        fs = r["first_stage"]
        out.append(f"| {r['label']} | " + " | ".join(str(fs.get(s, 0)) for s in stages) + " |")
    return "\n".join(out)


RUNS_ON = {"tiiny": "Tiiny NPU box", None: "laptop CPU"}


def params_text(m):
    if m.get("params_note"):
        return m["params_note"]
    if not m.get("params_b"):
        return "-"
    return f"{m['params_b']:g}B" + (f" ({m['active_b']:g}B active)" if m.get("active_b") else "")


def table_models(models_meta, present=None):
    """The models in models.yaml; with `present`, only those that have results."""
    out = ["| Model | Family | Parameters | Download | Runs on | Licence |", "|---|---|---|---:|---|---|"]
    for m in models_meta.values():
        if present is not None and m["id"] not in present:
            continue
        size = "hosted" if m.get("hosted") else f"{m['size_gb']:g} GB" if m.get("size_gb") else "-"
        where = "hosted API" if m.get("hosted") else RUNS_ON.get(m.get("runtime"), m.get("runtime"))
        out.append(f"| {m['label']} (`{m['id']}`) | {m['family']} | {params_text(m)} | {size} | {where} | "
                   f"{m.get('licence', '')} |")
    return "\n".join(out)


def summarise_box(records, models_meta, tasks):
    """Runs with several samples per task (the Tiiny box): one row per model. Pass counts are kept per
    sample. Pooled columns use the complete samples only, because a sample still running covers only the
    first tasks of tasks.yaml; while no sample is complete they use what there is."""
    by = collections.defaultdict(lambda: collections.defaultdict(list))
    for r in records:
        by[r["model"]][r["sample"]].append(r)

    def passed(r):
        return any(a.get("passed") for a in r["attempts"][:3])

    rows = []
    for model, samples in by.items():
        meta = models_meta.get(model, {"label": model})
        per = [(s, sum(passed(r) for r in samples[s]), len(samples[s])) for s in sorted(samples)]
        full = [s for s, _, n in per if n >= len(tasks)]
        used = full or sorted(samples)
        recs = [r for s in used for r in samples[s]]
        thinks = {str(r.get("think")) for s in samples for r in samples[s]}
        if len(thinks) > 1:
            print(f"warning: {model}: records mix thinking settings ({', '.join(sorted(thinks))}); keep "
                  "thinking-on and thinking-off runs in separate run folders", file=sys.stderr)
        by_task = collections.defaultdict(list)
        for s in samples:
            for r in samples[s]:
                by_task[r["task"]].append((s in full, passed(r)))
        att = [a for r in recs for a in r["attempts"]]
        gtok = sum((a.get("usage") or {}).get("gen_tokens") or 0 for a in att)
        gsec = sum((a.get("usage") or {}).get("gen_s") or 0 for a in att)
        best = [max((a.get("score") or 0) for a in r["attempts"]) if r["attempts"] else 0 for r in recs]
        think_chars = sorted((a.get("usage") or {}).get("thinking_chars") or 0 for a in att)
        rows.append({
            "model": model, "label": meta.get("label", model), "hosted": False, "meta": meta,
            "size_gb": meta.get("size_gb"), "per_sample": per, "samples_used": used, "n": len(recs),
            "mean_pass3": sum(k for s, k, _ in per if s in full) / len(full) if full else None, "n_full": len(full),
            "pass1": sum(bool(r["attempts"] and r["attempts"][0].get("passed")) for r in recs),
            "render1": sum(bool(r["attempts"] and r["attempts"][0].get("render", {}).get("ok")) for r in recs),
            "tasks_any": sum(any(p for _, p in v) for v in by_task.values()),
            "tasks_every": sum(all(p for f, p in v if f) and any(f for f, _ in v) for v in by_task.values())
            if full else None,
            "mean_best_score": sum(best) / len(best),
            "median_task_min": statistics.median(r["wall_s"] for r in recs) / 60,
            "gen_tok_s": gtok / gsec if gsec else None,
            "truncated": sum((a.get("usage") or {}).get("done_reason") in ("length", "repetition") for a in att),
            "n_attempts": len(att),
            "reasoned": sum(c > 0 for c in think_chars),
            "median_think_chars": think_chars[len(think_chars) // 2] if think_chars else 0,
        })
    return sorted(rows, key=lambda r: (-(r["mean_pass3"] if r["mean_pass3"] is not None else -1),
                                       -r["mean_best_score"], r["label"]))


def total_params(meta):
    """Total parameters for the size axis (params_total_b where params_b holds an effective count)."""
    return meta.get("params_total_b") or meta.get("params_b")


def fig_scale(rows, box_rows, models_meta, th, path, title, n_tasks):
    """Tasks passed vs total parameters: laptop models (one sample) and Tiiny-box models (mean of the
    complete samples, whisker = range). Hosted models and the viability bar are reference lines."""
    fig, ax = plt.subplots(figsize=(8.6, 5.0), dpi=150)
    fig.patch.set_facecolor(th["surface"])
    ax.set_facecolor(th["surface"])
    for s in ("top", "right", "left"):
        ax.spines[s].set_visible(False)
    ax.spines["bottom"].set_color(th["axis"])
    ax.tick_params(colors=th["muted"], length=0, labelsize=9)
    ax.grid(axis="y", color=th["grid"], linewidth=1)
    ax.set_axisbelow(True)
    ax.set_xscale("log")
    ticks = [0.5, 1, 2, 5, 10, 20, 50, 100]
    ax.set_xticks(ticks)
    ax.set_xticklabels([f"{t:g}B" for t in ticks])
    ax.minorticks_off()
    ax.set_xlim(0.35, 170)
    ax.set_ylim(-0.6, n_tasks + 0.6)
    ax.set_yticks(range(0, n_tasks + 1, 4))
    ax.set_xlabel("Total parameters (log scale)", color=th["ink2"], fontsize=9)
    ax.set_ylabel(f"Tasks passed within 3 tries (of {n_tasks})", color=th["ink2"], fontsize=9)
    hosted = collections.defaultdict(list)  # hosted: size undisclosed -> reference lines, one per score
    for r in rows:
        if r["hosted"] and r["n_tasks"]:
            hosted[r["pass3"] * n_tasks / r["n_tasks"]].append(f"{r['label']}: {r['pass3']}/{r['n_tasks']}")
    for y, labels in hosted.items():
        ax.axhline(y, color=th["muted"], linewidth=1, zorder=1)
        ax.text(0.37, y + 0.15, " · ".join(labels), fontsize=8, color=th["ink2"], va="bottom", ha="left")
    ax.axhline(n_tasks / 2, color=th["ink2"], linewidth=1, zorder=1)
    ax.text(0.37, n_tasks / 2 + 0.15, "viability bar: half the tasks", fontsize=8, color=th["ink2"], va="bottom")
    ring = {"edgecolors": th["surface"], "linewidths": 1.2, "zorder": 3}
    lap = [r for r in rows if not r["hosted"] and r["complete"] and total_params(r)]
    ax.scatter([total_params(r) for r in lap], [r["pass3"] for r in lap], s=46, marker="o", color=th["cat"][0],
               label="laptop CPU, 4-bit (1 sample)", **ring)
    box = [r for r in box_rows if r["mean_pass3"] is not None and total_params(r["meta"])]
    for r in box:
        ks = [k for _, k, n in r["per_sample"] if n >= n_tasks]
        if len(ks) > 1:
            ax.vlines(total_params(r["meta"]), min(ks), max(ks), color=th["cat"][1], linewidth=1.5, zorder=2)
    ax.scatter([total_params(r["meta"]) for r in box], [r["mean_pass3"] for r in box], s=46, marker="s",
               color=th["cat"][1], label="Tiiny NPU box (mean of samples, range)", **ring)
    placed = []  # (log10 x, y) of labels already drawn: stack labels of nearby points instead of overprinting
    for r in sorted(box, key=lambda r: (-r["mean_pass3"], total_params(r["meta"]))):
        if r["mean_pass3"] <= 0:
            continue  # the zero line is crowded; those models are in the table
        x, y = total_params(r["meta"]), r["mean_pass3"]
        k = sum(abs(math.log10(x) - px) < 0.3 and abs(y - py) < 1.2 for px, py in placed)
        placed.append((math.log10(x), y))
        left = x > 50  # near the right edge: label on the left of the marker
        ax.annotate(r["label"], (x, y), xytext=(-7 if left else 7, -3 - 11 * k), textcoords="offset points",
                    fontsize=8, color=th["ink2"], ha="right" if left else "left",
                    arrowprops={"arrowstyle": "-", "color": th["muted"], "linewidth": 0.6} if k else None)
    ax.legend(loc="lower center", bbox_to_anchor=(0.45, 1.0), ncol=2, frameon=False, fontsize=8.5,
              labelcolor=th["ink2"], handletextpad=0.4)
    fig.suptitle(title, x=0.01, ha="left", fontsize=11.5, color=th["ink"], fontweight="bold")
    fig.tight_layout()
    fig.savefig(path, facecolor=th["surface"])
    plt.close(fig)


def per_sample_text(r, n_tasks):
    return " · ".join(str(k) if n >= n_tasks else f"{k} of {n}\\*" for _, k, n in r["per_sample"])


def table_box(rows, n_tasks):
    out = ["| Model | Parameters | Download | Passed ≤3 tries, per sample | Mean | Tasks passed in any sample | "
           "Passed 1st try | Renders 1st try | Mean best score | Median min/task | Tokens/s | Attempts cut off |",
           "|---|---|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|"]
    for r in rows:
        mean = f"{r['mean_pass3']:.1f}" if r["mean_pass3"] is not None else "-"
        out.append(f"| {r['label']}{'' if r['n_full'] else ' *(partial)*'} | {params_text(r['meta'])} | "
                   f"{(str(r['size_gb']) + ' GB') if r['size_gb'] else '-'} | {per_sample_text(r, n_tasks)} | {mean} | "
                   f"{r['tasks_any']}/{n_tasks} | {r['pass1']}/{r['n']} | {r['render1']}/{r['n']} | "
                   f"{r['mean_best_score']:.2f} | {r['median_task_min']:.1f} | "
                   f"{('%.1f' % r['gen_tok_s']) if r['gen_tok_s'] else '-'} | {r['truncated']}/{r['n_attempts']} |")
    return "\n".join(out)


def table_think(think_rows, box_rows, n_tasks):
    """The thinking ablation next to the same model's main-protocol samples."""
    off = {r["model"]: r for r in box_rows}
    out = ["| Model | Thinking off, 2,048 tokens: passed per sample | Thinking on, 16,384 tokens: passed per sample | "
           "Replies with reasoning | Median reasoning per reply (characters) | Replies cut off | Median min/task |",
           "|---|---|---|---:|---:|---:|---:|"]
    for r in think_rows:
        o = off.get(r["model"])
        out.append(f"| {r['label']}{'' if r['n_full'] else ' *(partial)*'} | "
                   f"{per_sample_text(o, n_tasks) if o else '-'} | {per_sample_text(r, n_tasks)} | "
                   f"{r['reasoned']}/{r['n_attempts']} | {r['median_think_chars']:,} | "
                   f"{r['truncated']}/{r['n_attempts']} | {r['median_task_min']:.1f} |")
    return "\n".join(out)


def write_box_csv(path, rows, recs):
    """One row per (model, sample) for runs with several samples per task."""
    with open(path, "w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh)
        w.writerow(["model", "label", "sample", "n_tasks", "pass3", "pass1", "render1", "mean_best_score",
                    "minutes", "gen_tok_s", "attempts", "cut_off", "think"])
        for row in rows:
            for s, _, _ in row["per_sample"]:
                rs = [r for r in recs if r["model"] == row["model"] and r["sample"] == s]
                att = [a for r in rs for a in r["attempts"]]
                gs = sum((a.get("usage") or {}).get("gen_s") or 0 for a in att)
                w.writerow([row["model"], row["label"], s, len(rs),
                            sum(any(a.get("passed") for a in r["attempts"][:3]) for r in rs),
                            sum(bool(r["attempts"] and r["attempts"][0].get("passed")) for r in rs),
                            sum(bool(r["attempts"] and r["attempts"][0].get("render", {}).get("ok")) for r in rs),
                            round(sum(max((a.get("score") or 0) for a in r["attempts"]) if r["attempts"] else 0
                                      for r in rs) / len(rs), 3),
                            round(sum(r["wall_s"] for r in rs) / 60, 1),
                            round(sum((a.get("usage") or {}).get("gen_tokens") or 0 for a in att) / gs, 1) if gs else "",
                            len(att),
                            sum((a.get("usage") or {}).get("done_reason") in ("length", "repetition") for a in att),
                            "/".join(sorted({str(r.get("think")) for r in rs}))])


def table_prints():
    path = os.path.join(FIG, "print_estimates.csv")
    if not os.path.exists(path):
        return "*Run `python tools/slice_library.py` to generate this table.*"
    rows = list(csv.DictReader(open(path, encoding="utf-8")))
    out = ["| Part | Kind | Print time | PLA (g) | Material cost (US$) |", "|---|---|---:|---:|---:|"]
    for r in rows:
        out.append(f"| {r['title']} | {CAT_LABEL[r['category']]} | {r['print_time']} | {float(r['filament_g']):.1f} | "
                   f"{float(r['cost_usd']):.2f} |")
    h = sum(float(r["hours"]) for r in rows)
    g = sum(float(r["filament_g"]) for r in rows)
    c = sum(float(r["cost_usd"]) for r in rows)
    out.append(f"| **All {len(rows)} parts** | | **{h:.1f} h** | **{g:.0f}** | **{c:.2f}** |")
    return "\n".join(out)


def replace_block(text, name, content):
    """Replace what sits between the whole-line markers <!-- AUTO:name --> and <!-- /AUTO:name -->.
    A missing, repeated or reversed pair is reported and left alone."""
    starts = [m.start() for m in re.finditer(rf"^<!-- AUTO:{re.escape(name)} -->$", text, re.M)]
    ends = [m.start() for m in re.finditer(rf"^<!-- /AUTO:{re.escape(name)} -->$", text, re.M)]
    if len(starts) != 1 or len(ends) != 1 or ends[0] < starts[0]:
        print(f"warning: README.md needs exactly one AUTO:{name} block ({len(starts)} start and {len(ends)} end "
              "markers found) - left unchanged", file=sys.stderr)
        return text
    body = text.index("\n", starts[0]) + 1
    return text[:body] + content + "\n" + text[ends[0]:]


def picture(name, alt):
    return (f'<picture>\n  <source media="(prefers-color-scheme: dark)" srcset="figures/{name}_dark.png">\n'
            f'  <img src="figures/{name}_light.png" alt="{alt}">\n</picture>')


# --------------------------------------------------------------------------- main

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-readme", action="store_true")
    ap.add_argument("--runs", nargs="+", default=["main", "main-claude"],
                    help="run folders for the main tables (e.g. your own --run name)")
    ap.add_argument("--lang-runs", nargs="+", default=["lang", "lang-claude"])
    ap.add_argument("--box-runs", nargs="+", default=["main-tiiny"],
                    help="run folders with several samples per task (Tiiny NPU box), reported per sample")
    ap.add_argument("--think-runs", nargs="+", default=["think-tiiny"],
                    help="thinking-on ablation folders, reported next to the same models' --box-runs")
    args = ap.parse_args()
    tasks = yaml.safe_load(open(os.path.join(HERE, "tasks.yaml"), encoding="utf-8"))
    models_meta = {m["id"]: m for m in yaml.safe_load(open(os.path.join(HERE, "models.yaml"), encoding="utf-8"))}
    runs = load_runs()
    for run in args.runs:  # a typo must not silently empty the paper's tables
        if run not in runs:
            ap.error(f"--runs: no results for {run!r} (expected bench/results/{run}/results.jsonl; folders "
                     "named smoke*, calib* or _* are ignored)")
    for opt in ("lang_runs", "box_runs", "think_runs"):
        given = getattr(args, opt)
        if given != ap.get_default(opt):
            for run in (r for r in given if r not in runs):
                print(f"warning: --{opt.replace('_', '-')}: no results for {run!r}", file=sys.stderr)

    main_recs = dedupe([r for run in args.runs for r in runs.get(run, [])])
    main_recs = [r for r in main_recs if r.get("lang", "en") == "en" and r.get("feedback", "report") == "report"]
    per_task = collections.Counter((r["model"], r["task"]) for r in main_recs)
    multi = sorted({m for (m, _), n in per_task.items() if n > 1})
    if multi:
        ap.error(f"--runs: {', '.join(multi)} {'has' if len(multi) == 1 else 'have'} several samples per task; "
                 "report such runs with --box-runs")
    rows = summarise(main_recs, models_meta, tasks)
    if not rows:
        sys.exit("no records in the --runs folders - nothing written")
    unknown = sorted({r["model"] for r in main_recs} - set(models_meta))
    if unknown:
        print(f"warning: not in bench/models.yaml (no size, licence or label): {', '.join(unknown)}", file=sys.stderr)

    with open(os.path.join(HERE, "results", "summary.csv"), "w", newline="", encoding="utf-8") as fh:
        fields = ["model", "label", "family", "hosted", "size_gb", "params_b", "licence", "n_tasks", "pass1",
                  "pass2", "pass3", "render1", "mean_best_score", "median_task_min", "total_min", "gen_tok_s"]
        w = csv.DictWriter(fh, fieldnames=fields, extrasaction="ignore")
        w.writeheader()
        for r in order_models(rows):
            w.writerow({k: (round(v, 3) if isinstance(v, float) else v) for k, v in r.items()})

    lang_recs = dedupe([r for run in args.lang_runs for r in runs.get(run, [])])
    lang_models = {r["model"] for r in lang_recs}  # English baselines for the same models come from the main run
    lang_recs += [r for r in main_recs if r["model"] in lang_models]
    has_lang = False
    for mode, th in THEMES.items():
        fig_heatmap(main_recs, rows, tasks, th, os.path.join(FIG, f"fig_outcomes_{mode}.png"),
                    "Outcome per task (number = attempt that passed)")
        fig_tiers(rows, th, os.path.join(FIG, f"fig_tiers_{mode}.png"),
                  "How far each model got: best outcome per task (blank = nothing rendered)")
        if lang_recs:
            has_lang = fig_lang(lang_recs, models_meta, th, os.path.join(FIG, f"fig_languages_{mode}.png"),
                                "Same parts, prompt written in another language")

    def box_records(names):
        recs = dedupe([r for run in names for r in runs.get(run, [])])
        return [r for r in recs if r.get("lang", "en") == "en" and r.get("feedback", "report") == "report"]

    box_recs, think_recs = box_records(args.box_runs), box_records(args.think_runs)
    box_rows = summarise_box(box_recs, models_meta, tasks)
    think_rows = summarise_box(think_recs, models_meta, tasks)
    if box_rows:
        write_box_csv(os.path.join(HERE, "results", "summary_tiiny.csv"), box_rows, box_recs)
        for mode, th in THEMES.items():
            fig_box_heatmap(box_recs, box_rows, tasks, th, os.path.join(FIG, f"fig_tiiny_outcomes_{mode}.png"),
                            "Tiiny NPU box: samples that passed each task")
            fig_scale(rows, box_rows, models_meta, th, os.path.join(FIG, f"fig_scale_{mode}.png"),
                      "Tasks passed vs model size, laptop and NPU box", len(tasks))
    if think_rows:
        write_box_csv(os.path.join(HERE, "results", "summary_tiiny_think.csv"), think_rows, think_recs)

    print(table_main(rows))
    print()
    if box_rows:
        print(table_box(box_rows, len(tasks)))
        print()
    if think_rows:
        print(table_think(think_rows, box_rows, len(tasks)))
        print()
    print(table_categories(main_recs, rows))
    print()
    print(table_failures(rows))
    print()
    print(table_graded(rows))
    if lang_recs:
        print()
        print(language_tests(lang_recs))

    if not args.no_readme:
        readme = os.path.join(ROOT, "README.md")
        if os.path.exists(readme):
            text = open(readme, encoding="utf-8").read()
            present = {r["model"] for r in main_recs + lang_recs + box_recs + think_recs}
            text = replace_block(text, "table-models", table_models(models_meta, present))
            text = replace_block(text, "table-prints", table_prints())
            text = replace_block(text, "table-main", table_main(rows))
            text = replace_block(text, "table-categories", table_categories(main_recs, rows))
            text = replace_block(text, "table-failures", table_failures(rows))
            text = replace_block(text, "table-graded", table_graded(rows))
            text = replace_block(text, "fig-tiers", picture("fig_tiers", "Stacked bars of the best outcome each model reached per task"))
            text = replace_block(text, "fig-outcomes", picture("fig_outcomes", "Grid of outcomes per model and task"))
            if has_lang:
                text = replace_block(text, "fig-languages", picture("fig_languages", "Pass rates for prompts in English, Spanish, Hindi and Swahili"))
            if box_rows:
                text = replace_block(text, "table-tiiny", table_box(box_rows, len(tasks)))
                text = replace_block(text, "fig-tiiny", picture("fig_tiiny_outcomes", "Grid of how many samples passed each task, per model on the Tiiny NPU box"))
                text = replace_block(text, "fig-scale", picture("fig_scale", "Scatter of tasks passed against total parameters for laptop and NPU-box models, with hosted models and the viability bar as reference lines"))
            if think_rows:
                text = replace_block(text, "table-tiiny-think", table_think(think_rows, box_rows, len(tasks)))
            tmp = readme + ".tmp"  # write-then-rename: an error can never leave a truncated paper
            with open(tmp, "w", encoding="utf-8") as fh:
                fh.write(text)
            os.replace(tmp, readme)
            print("README updated")


if __name__ == "__main__":
    main()
