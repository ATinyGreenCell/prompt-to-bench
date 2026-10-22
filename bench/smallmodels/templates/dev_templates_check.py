#!/usr/bin/env python3
"""Development check for idea 3: when a model picks a design for a batch-C description (where the expected pick was
"none"), does the built file match the description's verified file? Three batch-C families have a counterpart in
the library (t_slot_nut; pull_handle and drawer_pull; spoked_wheel and fan_guard), so such a pick can be right.
No model calls: the saved picks and parameters are built and compared (finetune/scripts/rft_score.py).

    ~/printpaper/.venv/bin/python -I dev_templates_check.py
"""
import collections
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, "/home/seb/printpaper/finetune/scripts"]
import library as L  # noqa: E402
from rft_score import matches  # noqa: E402

DISTILL = "/home/seb/printpaper/finetune/rft/distill"


def refs_for(ids):
    prompts = {}
    for line in open(os.path.join(DISTILL, "prompts_clean_c.jsonl")):
        r = json.loads(line)
        if r["id"] in ids:
            prompts[r["user"].strip()] = r["id"]
    out = {}
    for k in range(8):
        for line in open(os.path.join(DISTILL, f"clean_c_shard{k}.jsonl")):
            m = json.loads(line)["messages"]
            pid = prompts.get(m[1]["content"].strip())
            g = re.search(r"```(?:openscad)?\s*\n(.*?)```", m[2]["content"], re.S) if pid else None
            if g:
                out[pid] = g.group(1)
    return out


def main():
    lib = L.load()
    rs = [json.loads(line) for line in open(os.path.join(HERE, "dev_templates.jsonl"))]
    picked = [r for r in rs if r["kind"] == "out" and r["pick"] != "none" and r.get("params")]
    refs = refs_for({r["id"] for r in picked})
    tot = collections.Counter()
    for r in picked:
        ok, score, _ = matches(L.build(lib[r["pick"]], r["params"]), refs[r["id"]])
        tot[(r["model"], ok)] += 1
        print(f"{r['model']:24s} {r['id']:22s} -> {r['pick']:18s} {'MATCHES' if ok else 'differs'} (score {score})")
    for (model, ok), n in sorted(tot.items()):
        print(f"{model}: {n} picks {'build the described part' if ok else 'build a different part'}")


if __name__ == "__main__":
    main()
