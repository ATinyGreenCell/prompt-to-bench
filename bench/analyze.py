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

def load_runs():
    """All runs; damaged lines are skipped and repeated conversations keep only the newest record."""
    runs = {}
    for path in sorted(glob.glob(os.path.join(HERE, "results", "*", "results.jsonl"))):
        run = os.path.basename(os.path.dirname(path))
        if run.startswith(("smoke", "calib", "_")):
            continue
        latest = {}
        for line in open(path):
            try:
                r = json.loads(line)
            except json.JSONDecodeError:
                continue
            r["_run"] = run
            latest[(r["model"], r["task"], r["sample"], r.get("lang", "en"), r.get("feedback", "report"))] = r
        runs[run] = list(latest.values())
    return runs


def dedupe(records):
    """One record per conversation key across run folders (newest wins)."""
    latest = {}
    for r in sorted(records, key=lambda r: r.get("finished", "")):
        latest[(r["model"], r["task"], r["sample"], r.get("lang", "en"), r.get("feedback", "report"))] = r
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
    1 rendered but never matched the spec, 0 never produced a printable part."""
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
            "geom_as_value": sum(1 for r in recs if r["attempts"] and GEOM_AS_VALUE.search(first_code(r) or "")),
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


def fig_dumbbell(rows, th, path, title):
    rows = order_models(rows)
    fig, ax = plt.subplots(figsize=(8.2, 0.42 * len(rows) + 1.5), dpi=150)
    fig.patch.set_facecolor(th["surface"])
    style(ax, th)
    y = list(range(len(rows)))[::-1]
    for yi, r in zip(y, rows):
        a, b = 100 * r["pass1"] / r["n_tasks"], 100 * r["pass3"] / r["n_tasks"]
        ax.plot([a, b], [yi, yi], color=th["axis"], linewidth=2, solid_capstyle="round", zorder=1)
        ax.scatter([a], [yi], s=60, color=th["first"], edgecolor=th["surface"], linewidth=2, zorder=3)
        ax.scatter([b], [yi], s=60, color=th["after"], edgecolor=th["surface"], linewidth=2, zorder=4)
        note = f"{r['pass3']}/{r['n_tasks']}" + ("" if r["complete"] else " (partial)")
        ax.text(102, yi, note, va="center", ha="left", fontsize=8.5, color=th["ink2"])
    ax.set_yticks(y)
    ax.set_yticklabels([f"{r['label']}" + (f"  ·  {r['size_gb']:.1f} GB" if r["size_gb"] else "") for r in rows],
                       fontsize=9, color=th["ink"])
    if any(r["hosted"] for r in rows):
        nh = sum(r["hosted"] for r in rows)
        ax.axhline(y[nh - 1] - 0.5, color=th["grid"], linewidth=1)
    ax.set_xlim(-2, 112)
    ax.set_xticks([0, 25, 50, 75, 100])
    ax.set_xticklabels(["0%", "25%", "50%", "75%", "100%"])
    ax.set_ylim(-0.7, len(rows) - 0.3)
    ax.scatter([], [], s=60, color=th["first"], label="first attempt")
    ax.scatter([], [], s=60, color=th["after"], label="after up to 2 rounds of feedback")
    leg = ax.legend(loc="lower center", bbox_to_anchor=(0.45, 1.0), ncol=2, frameon=False, fontsize=9,
                    labelcolor=th["ink2"], handletextpad=0.3, columnspacing=1.5)
    leg.set_in_layout(True)
    fig.suptitle(title, x=0.01, ha="left", fontsize=11.5, color=th["ink"], fontweight="bold")
    fig.tight_layout()
    fig.savefig(path, facecolor=th["surface"])
    plt.close(fig)


def fig_heatmap(records, rows, tasks, th, path, title):
    rows = order_models(rows)
    tids = [t["id"] for t in sorted(tasks, key=lambda t: CATS.index(t["category"]))]
    res = {(r["model"], r["task"]): outcome(r) for r in records}
    H = 0.36 * len(rows) + 2.2
    fig, ax = plt.subplots(figsize=(10.5, H), dpi=150)
    fig.subplots_adjust(left=2.0 / 10.5, right=0.99, top=1 - 0.72 / H, bottom=1.3 / H)
    fig.patch.set_facecolor(th["surface"])
    ax.set_facecolor(th["surface"])
    cols = th["ramp"]
    for yi, r in enumerate(rows):
        for xi, tid in enumerate(tids):
            o = res.get((r["model"], tid))
            x0, y0 = xi, len(rows) - 1 - yi
            if o is None:
                continue
            level, att = o
            if level >= 1:
                ax.add_patch(plt.Rectangle((x0 + 0.04, y0 + 0.06), 0.92, 0.88, color=cols[level - 1], linewidth=0))
            txt = str(att) if att else ("·" if level == 1 else "×")
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
    labels = ["passed, 1st attempt (1)", "passed after feedback (2, 3)", "rendered but wrong (·)",
              "nothing rendered (×)"]
    fig.legend(handles, labels, loc="lower center", bbox_to_anchor=(0.55, 0.0), ncol=4, frameon=False,
               fontsize=8.5, labelcolor=th["ink2"], handlelength=1.2)
    fig.suptitle(title, x=0.01, y=1 - 0.08 / H, ha="left", va="top", fontsize=11.5, color=th["ink"],
                 fontweight="bold")
    fig.savefig(path, facecolor=th["surface"])
    plt.close(fig)


def fig_frontier(rows, th, path, title):
    """Pass rate vs download size and vs CPU time per task (two panels, one y-scale each)."""
    local = [r for r in rows if not r["hosted"] and r["size_gb"]]
    hosted = [r for r in rows if r["hosted"]]
    fig, axes = plt.subplots(1, 2, figsize=(10.5, 4.3), dpi=150, sharey=True)
    fig.patch.set_facecolor(th["surface"])
    for ax, key, xlabel in ((axes[0], "size_gb", "download size (GB, 4-bit)"),
                            (axes[1], "median_task_min", "median minutes per task on a laptop CPU")):
        style(ax, th, xgrid=False)
        ax.grid(axis="y", color=th["grid"], linewidth=1)
        for r in local:
            x = r[key]
            if x is None:
                continue
            yv = 100 * r["pass3_rate"]
            ax.scatter([x], [yv], s=55, color=th["cat"][0], edgecolor=th["surface"], linewidth=2, zorder=3)
            ax.annotate(r["label"].replace(" (general)", "*").replace(" (MoE)", ""), (x, yv),
                        textcoords="offset points", xytext=(5, 4), fontsize=7.5, color=th["ink2"])
        for h in hosted:
            yv = 100 * h["pass3_rate"]
            ax.axhline(yv, color=th["axis"], linewidth=1, zorder=1)
            ax.text(0.99, yv, f"{h['label'].replace(' (hosted)', '')}: {yv:.0f}%",
                    transform=ax.get_yaxis_transform(), ha="right", va="bottom", fontsize=7.5, color=th["muted"])
        ax.set_xlabel(xlabel, color=th["ink2"], fontsize=9)
        ax.set_ylim(-3, 108)
        ax.set_yticks([0, 25, 50, 75, 100])
        ax.set_yticklabels(["0%", "25%", "50%", "75%", "100%"])
    axes[0].set_xscale("log")
    axes[0].set_xticks([0.4, 1, 2, 4, 7])
    axes[0].set_xticklabels(["0.4", "1", "2", "4", "7"])
    axes[0].set_ylabel("tasks passed (≤3 attempts)", color=th["ink2"], fontsize=9)
    fig.suptitle(title, x=0.01, ha="left", fontsize=11.5, color=th["ink"], fontweight="bold")
    fig.tight_layout()
    fig.savefig(path, facecolor=th["surface"])
    plt.close(fig)


def fig_lang(records, models_meta, th, path, title):
    langs = ["en", "es", "hi", "sw"]
    lang_label = {"en": "English", "es": "Spanish", "hi": "Hindi", "sw": "Swahili"}
    by = collections.defaultdict(lambda: [0, 0])
    for r in records:
        k = (r["model"], r["lang"])
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
            f"{(str(r['size_gb']) + ' GB') if r['size_gb'] else 'hosted'} | {r['licence']} | "
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


def table_models(models_meta):
    out = ["| Model | Family | Parameters | Download | Licence |", "|---|---|---|---:|---|"]
    for m in models_meta.values():
        params = m.get("params_note") or (f"{m['params_b']:g}B" if m.get("params_b") else "-")
        size = f"{m['size_gb']:g} GB" if m.get("size_gb") else "hosted"
        out.append(f"| {m['label']} (`{m['id']}`) | {m['family']} | {params} | {size} | {m.get('licence', '')} |")
    return "\n".join(out)


def table_prints():
    path = os.path.join(FIG, "print_estimates.csv")
    if not os.path.exists(path):
        return "*Run `python tools/slice_library.py` to generate this table.*"
    rows = list(csv.DictReader(open(path)))
    out = ["| Part | Kind | Print time | PLA (g) | Material cost (US$) |", "|---|---|---:|---:|---:|"]
    for r in rows:
        out.append(f"| {r['title']} | {CAT_LABEL[r['category']]} | {r['print_time']} | {float(r['filament_g']):.1f} | "
                   f"{float(r['cost_usd']):.2f} |")
    h = sum(float(r["hours"]) for r in rows)
    g = sum(float(r["filament_g"]) for r in rows)
    c = sum(float(r["cost_usd"]) for r in rows)
    out.append(f"| **All 16 parts** | | **{h:.1f} h** | **{g:.0f}** | **{c:.2f}** |")
    return "\n".join(out)


def replace_block(text, name, content):
    pat = re.compile(rf"(<!-- AUTO:{name} -->).*?(<!-- /AUTO:{name} -->)", re.S)
    if not pat.search(text):
        return text
    return pat.sub(lambda m: m.group(1) + "\n" + content + "\n" + m.group(2), text)


def picture(name, alt):
    return (f'<picture>\n  <source media="(prefers-color-scheme: dark)" srcset="figures/{name}_dark.png">\n'
            f'  <img src="figures/{name}_light.png" alt="{alt}">\n</picture>')


# --------------------------------------------------------------------------- main

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-readme", action="store_true")
    args = ap.parse_args()
    tasks = yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))
    models_meta = {m["id"]: m for m in yaml.safe_load(open(os.path.join(HERE, "models.yaml")))}
    runs = load_runs()
    os.makedirs(FIG, exist_ok=True)

    main_recs = dedupe(runs.get("main", []) + runs.get("main-claude", []))
    main_recs = [r for r in main_recs if r.get("lang", "en") == "en" and r.get("feedback", "report") == "report"]
    rows = summarise(main_recs, models_meta, tasks)

    with open(os.path.join(HERE, "results", "summary.csv"), "w", newline="") as fh:
        fields = ["model", "label", "family", "hosted", "size_gb", "params_b", "licence", "n_tasks", "pass1",
                  "pass2", "pass3", "render1", "mean_best_score", "median_task_min", "total_min", "gen_tok_s"]
        w = csv.DictWriter(fh, fieldnames=fields, extrasaction="ignore")
        w.writeheader()
        for r in order_models(rows):
            w.writerow({k: (round(v, 3) if isinstance(v, float) else v) for k, v in r.items()})

    for mode, th in THEMES.items():
        if rows:
            fig_dumbbell(rows, th, os.path.join(FIG, f"fig_pass_rates_{mode}.png"),
                         "Lab parts that pass every geometric check (16 tasks)")
            fig_heatmap(main_recs, rows, tasks, th, os.path.join(FIG, f"fig_outcomes_{mode}.png"),
                        "Outcome per task (number = attempt that passed)")
            fig_tiers(rows, th, os.path.join(FIG, f"fig_tiers_{mode}.png"),
                      "How far each model got: best outcome per task (blank = nothing rendered)")
        lang_recs = dedupe(runs.get("lang", []) + runs.get("lang-claude", []))
        # English baselines for the same models come from the main run
        lang_models = {r["model"] for r in lang_recs}
        lang_recs += [r for r in main_recs if r["model"] in lang_models]
        has_lang = fig_lang(lang_recs, models_meta, th, os.path.join(FIG, f"fig_languages_{mode}.png"),
                            "Same parts, prompt written in another language") if lang_recs else False

    print(table_main(rows))
    print()
    print(table_categories(main_recs, rows))
    print()
    print(table_failures(rows))
    print()
    print(table_graded(rows))

    if not args.no_readme:
        readme = os.path.join(ROOT, "README.md")
        if os.path.exists(readme):
            text = open(readme).read()
            text = replace_block(text, "table-models", table_models(models_meta))
            text = replace_block(text, "table-prints", table_prints())
            text = replace_block(text, "table-main", table_main(rows))
            text = replace_block(text, "table-categories", table_categories(main_recs, rows))
            text = replace_block(text, "table-failures", table_failures(rows))
            text = replace_block(text, "table-graded", table_graded(rows))
            text = replace_block(text, "fig-tiers", picture("fig_tiers", "Stacked bars of the best outcome each model reached per task"))
            text = replace_block(text, "fig-pass-rates", picture("fig_pass_rates", "Dumbbell chart of pass rates per model, first attempt vs after feedback"))
            text = replace_block(text, "fig-outcomes", picture("fig_outcomes", "Grid of outcomes per model and task"))
            text = replace_block(text, "fig-frontier", picture("fig_frontier", "Pass rate versus model download size and CPU time per task"))
            if has_lang:
                text = replace_block(text, "fig-languages", picture("fig_languages", "Pass rates for prompts in English, Spanish, Hindi and Swahili"))
            open(readme, "w").write(text)
            print("README updated")


if __name__ == "__main__":
    main()
