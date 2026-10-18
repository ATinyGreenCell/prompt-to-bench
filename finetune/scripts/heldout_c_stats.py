#!/usr/bin/env python3
"""Batch C by part family: first attempts and repairs on v11's four held-out families, for every model.

v11 trained on ten of batch C's 14 families (build_v11.py); the other four (data/v11_holdout.json) test it on new
kinds of parts. The earlier models answered all of batch C, so their rates on the same four families come from
their own outcome files, split by each description's family, with nothing rendered again: onpolicy_repairs.py
build wrote a conversation for every failed first attempt (its stats show every attempt scored), and build-rft kept
each passing repair, one repair per failure. Every total is checked against both stats files.

usage: ~/printpaper/.venv/bin/python -I finetune/scripts/heldout_c_stats.py v5 v5s1 v9 v9s1 v11 v11s1
"""
from __future__ import annotations

import json
import pathlib
import sys

FT = pathlib.Path("/home/seb/printpaper/finetune")
OP = FT / "rft" / "onpolicy"
sys.path[:0] = ["/home/seb/printpaper/bench", "/home/seb/printpaper/tools"]
from run_bench import extract_code  # noqa: E402

rows = lambda p: [json.loads(line) for line in open(p) if line.strip()]  # noqa: E731
user = lambda msgs: next(m["content"] for m in msgs if m["role"] == "user").strip()  # noqa: E731
family = {d["user"].strip(): d["family"] for d in rows(FT / "rft" / "distill" / "prompts_clean_c.jsonl")}
family_of_id = {p["id"]: family[user(p["messages"])] for p in rows(OP / "prompts_c.jsonl")}
HELD = sorted(json.load(open(FT / "data" / "v11_holdout.json"))["held_out_families"])


def counts(m: str) -> dict:
    """family -> attempts, failed, no_render, repairs, changed, fixed for model m (v11's runs: held-out files)."""
    tag = "ch" if (OP / f"attempts_{m}_ch.jsonl").exists() else "c"
    s: dict = {}
    add = lambda fam, k, n=1: s.setdefault(fam, dict.fromkeys(  # noqa: E731
        ("attempts", "failed", "no_render", "repairs", "changed", "fixed"), 0)).__setitem__(k, s[fam][k] + n)
    for a in rows(OP / f"attempts_{m}_{tag}.jsonl"):
        add(family_of_id[a["id"]], "attempts")
    for r in rows(FT / "data" / f"onpolicy_repairs_{m}{tag}.jsonl"):
        fam = family[user(r["messages"])]
        add(fam, "failed")
        add(fam, "no_render", not r["messages"][3]["content"].startswith("Your file rendered"))
    prompts = {p["id"]: p for p in rows(OP / f"repair_prompts_{m}{tag}.jsonl")}
    for t in rows(OP / f"repair_t02_{m}{tag}.jsonl"):
        p = prompts[t["id"]]
        before, code = extract_code(p["messages"][2]["content"] or "")[0], extract_code(t["reply"] or "")[0]
        add(family[user(p["messages"])], "repairs")
        add(family[user(p["messages"])], "changed", bool(code) and code.strip() != (before or "").strip())
    for r in rows(OP / f"rft_t02_{m}{tag}.jsonl"):
        add(family[user(r["messages"])], "fixed")
    b = json.load(open(FT / "data" / f"onpolicy_repairs_{m}{tag}.stats.json"))
    rs = json.load(open(OP / f"rft_t02_{m}{tag}.stats.json"))
    tot = lambda k: sum(v[k] for v in s.values())  # noqa: E731
    assert b["attempts"] == b["scored"] == tot("attempts") and b["repairs_written"] == tot("failed"), (m, b)
    assert b["outcomes"].get("pass", 0) == tot("attempts") - tot("failed"), (m, b)
    assert rs["repairs_scored"] == tot("repairs") and rs["changed_file"] == tot("changed"), (m, rs)
    assert rs["outcomes"].get("pass", 0) == rs["rows_written"] == tot("fixed"), (m, rs)
    return s


def main() -> None:
    pct = lambda a, b: f"{100 * a / b:.1f}%" if b else "-"  # noqa: E731
    print(f"held-out families: {', '.join(HELD)}")
    print(f"{'model':7} {'first attempts passed':>22} {'built':>7} {'repairs changed':>16} {'fixed':>11}   "
          + "  ".join(f"{f:>13}" for f in HELD) + "   all families passed")
    for m in sys.argv[1:]:
        s = counts(m)
        h = {k: sum(s[f][k] for f in HELD if f in s) for k in ("attempts", "failed", "no_render", "repairs", "changed", "fixed")}
        allp = sum(v["attempts"] - v["failed"] for v in s.values())
        print(f"{m:7} {h['attempts'] - h['failed']:>6}/{h['attempts']:<4} {pct(h['attempts'] - h['failed'], h['attempts']):>9}"
              f" {pct(h['attempts'] - h['no_render'], h['attempts']):>7} {pct(h['changed'], h['repairs']):>16}"
              f" {h['fixed']:>4}/{h['repairs']:<4}   "
              + "  ".join(f"{pct(s[f]['attempts'] - s[f]['failed'], s[f]['attempts']) if f in s else '-':>13}" for f in HELD)
              + f"   {allp}/{sum(v['attempts'] for v in s.values())}")


if __name__ == "__main__":
    main()
