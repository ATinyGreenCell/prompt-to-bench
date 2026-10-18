#!/usr/bin/env python3
"""Build the v11 training set: v9's rows plus batch C, as plain examples and as v9 seed 1's own failed attempts.

v11 repeats the two changes that held up, on parts the training set did not yet cover: breadth of part families
(v6 had the best clean in-family transfer) and the model's own failed attempts, each with the benchmark's report
and the reference file (v9: more feedback use in both of two training runs, §6.4). From batch C (674 descriptions
Claude Opus wrote, each with a verified file, 14 families) it adds, for ten of the families,
  - each description with its reference file (single turn), and
  - each of v9 seed 1's failed first attempts at it (onpolicy_repairs_v9s1c.jsonl: the description, its reply, the
    benchmark's feedback, then the reference file; train with MASK_EARLIER=1),
both twice, as v9's repairs were. Four families drawn from the 13 that no model here saw (T-slot nuts are also one
of the 34 training families) stay out, so v11 can still be measured on new kinds of parts (prompts_c_holdout.jsonl).
Deterministic.

usage: ~/printpaper/.venv/bin/python -I finetune/scripts/build_v11.py
"""
import glob
import json
import pathlib
import random

FT = pathlib.Path("/home/seb/printpaper/finetune")
OP = FT / "rft" / "onpolicy"
SEED = 20261022

family = {}
for f in glob.glob(str(FT / "rft" / "distill" / "prompts_clean_c_shard*.jsonl")):
    for line in open(f):
        d = json.loads(line)
        family[d["user"].strip()] = d["family"]
user = lambda msgs: next(m["content"] for m in msgs if m["role"] == "user").strip()  # noqa: E731
prompts = [json.loads(line) for line in open(OP / "prompts_c.jsonl")]
families = sorted({family[user(p["messages"])] for p in prompts})
held_out = sorted(random.Random(SEED).sample([f for f in families if f != "t_slot_nut"], 4))

single = [{"messages": [*p["messages"][:2], {"role": "assistant", "content": f"```openscad\n{p['ref']}\n```"}]}
          for p in prompts if family[user(p["messages"])] not in held_out]
reps = [{"messages": r["messages"]} for r in map(json.loads, open(FT / "data" / "onpolicy_repairs_v9s1c.jsonl"))
        if family[user(r["messages"])] not in held_out]
rows = [json.loads(line) for line in open(FT / "data" / "v9_train.jsonl") if line.strip()]
out = rows + single * 2 + reps * 2
random.Random(SEED).shuffle(out)
with open(FT / "data" / "v11_train.jsonl", "w", encoding="utf-8") as fh:
    for r in out:
        fh.write(json.dumps(r, ensure_ascii=False) + "\n")
with open(OP / "prompts_c_holdout.jsonl", "w", encoding="utf-8") as fh:
    for p in prompts:
        if family[user(p["messages"])] in held_out:
            fh.write(json.dumps(p, ensure_ascii=False) + "\n")
n_hold = sum(family[user(p["messages"])] in held_out for p in prompts)
json.dump({"held_out_families": held_out, "held_out_prompts": n_hold, "seed": SEED},
          open(FT / "data" / "v11_holdout.json", "w"), indent=1)
print(f"v9 rows {len(rows)} + batch C single-turn {len(single)} x2 + v9 seed 1's own failures {len(reps)} x2 "
      f"= {len(out)} -> {FT / 'data' / 'v11_train.jsonl'}; held out: {', '.join(held_out)} ({n_hold} descriptions)")
