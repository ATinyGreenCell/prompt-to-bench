#!/usr/bin/env python3
"""Table 8 of the paper: the box-model fine-tunes compared on a rented GPU, 8 samples per task.

The 16 tasks are split by how closely v3's distilled training prompts followed each task's own
wording: IN_FAMILY = tasks whose nearest v3-distilled prompt has token Jaccard >= 0.5 with the task
prompt (0.56-0.86); OUT_OF_FAMILY = the other eight (<= 0.41). The split is fixed, so every model is read
on the same two halves (only v3 saw in-family templates).

usage: python bench/finetune_table.py gpu-base gpu-v2 gpu-v3 gpu-v4
"""
from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # also under python -I
from sample_stats import rows_for, stats  # noqa: E402

IN_FAMILY = ["tube_rack_1p5ml", "gel_comb_10well", "lab_funnel_60mm", "pcr_tube_adapter",
             "enclosure_box_and_lid", "dshaft_knob_6mm", "rod_tubing_clip", "seed_sowing_template"]
OUT_OF_FAMILY = ["conical_rack_50ml", "slide_drying_rack", "pcr_tube_rack_sbs", "micropestle_1p5ml",
            "hose_barb_reducer_8_5", "stirrer_fan_housing", "nema17_motor_bracket", "mini_gel_tank"]


def row(run: str) -> dict:
    rows = rows_for(run)
    st = stats(rows)
    get = lambda ts, f: [f(st[t]) for t in ts if t in st]  # noqa: E731
    return {
        "run": run, "tasks": len(st),
        "pass1": sum(bool(v["pass1"]) for v in st.values()),
        "pass8_in": sum(get(IN_FAMILY, lambda v: v["passes"] > 0)),
        "pass8_out": sum(get(OUT_OF_FAMILY, lambda v: v["passes"] > 0)),
        "samples_in": (sum(get(IN_FAMILY, lambda v: v["passes"])), sum(get(IN_FAMILY, lambda v: v["n"]))),
        "samples_out": (sum(get(OUT_OF_FAMILY, lambda v: v["passes"])), sum(get(OUT_OF_FAMILY, lambda v: v["n"]))),
        "first_render": (sum(bool((r["attempts"][0].get("render") or {}).get("ok")) for r in rows if r.get("attempts")),
                         len(rows)),
        "mean_best_in": round(sum(get(IN_FAMILY, lambda v: v["mean_best"])) / max(1, len(get(IN_FAMILY, lambda v: 1))), 2),
        "mean_best_out": round(sum(get(OUT_OF_FAMILY, lambda v: v["mean_best"])) / max(1, len(get(OUT_OF_FAMILY, lambda v: 1))), 2),
        "passed_tasks": sorted(t for t, v in st.items() if v["passes"] > 0),
    }


def main() -> None:
    print("| Run | pass@1 (16) | pass@8 in-family (8) | pass@8 out-of-family (8) | samples passed in / out | "
          "first attempt renders | mean best in / out |")
    print("|---|---:|---:|---:|---:|---:|---:|")
    for run in sys.argv[1:]:
        r = row(run)
        print(f"| {r['run']} | {r['pass1']} | {r['pass8_in']} | {r['pass8_out']} | "
              f"{r['samples_in'][0]}/{r['samples_in'][1]} · {r['samples_out'][0]}/{r['samples_out'][1]} | "
              f"{r['first_render'][0] / max(1, r['first_render'][1]):.0%} | {r['mean_best_in']:.2f} / {r['mean_best_out']:.2f} |")
    for run in sys.argv[1:]:
        print(run, "passed:", ", ".join(row(run)["passed_tasks"]) or "-")


if __name__ == "__main__":
    main()
