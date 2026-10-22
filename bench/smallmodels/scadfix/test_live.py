#!/usr/bin/env python3
"""Tests for live_bench.py inside a harness copy's real conversation loop (run_one), with the model replaced by
scripted replies: no box, no Ollama; real OpenSCAD renders.

    ~/printpaper/.venv/bin/python -I test_live.py [harness dir, default the sweep's frozen copy]
"""
import json
import os
import sys
import tempfile
import types

HERE = os.path.dirname(os.path.abspath(__file__))
HARNESS = os.path.expanduser(sys.argv[1] if len(sys.argv) > 1 else "~/tiny/bench/20261014-sweep/harness")
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
sys.path.insert(0, os.path.join(HARNESS, "bench"))
sys.path.append(HERE)
import yaml  # noqa: E402
import run_bench as RB  # noqa: E402
from scadfix import fix  # noqa: E402
from live_bench import Scadfixed  # noqa: E402

FAILS = []
BROKEN = "Here is the comb.\n```openscad\ncomb = cube([70, 24, 1.5]);\ncomb;\n```\n"
VALID = "```openscad\ncube([70, 24, 1.5]);\n```\n"


def check(name, cond, detail=""):
    print(("PASS " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    if not cond:
        FAILS.append(name)


class Fake:
    """The harness's Ollama backend, minus the network: keeps messages the same way."""

    def __init__(self, replies):
        self.replies, self.messages, self.opts, self.think = list(replies), [], {"seed": 0}, False

    def chat(self, system, user):
        msgs = (self.messages or [{"role": "system", "content": system}]) + [{"role": "user", "content": user}]
        text = self.replies.pop(0)
        self.messages = msgs + [{"role": "assistant", "content": text}]
        return text, {"wall_s": 0.1}


def conversation(replies):
    tasks = {t["id"]: t for t in yaml.safe_load(open(os.path.join(HARNESS, "bench", "tasks.yaml")))}
    t = dict(tasks["gel_comb_10well"])
    t["prompt_used"] = t["prompt"]
    ref = json.load(open(os.path.join(HARNESS, "bench", "reference_stats.json")))["gel_comb_10well"]
    args = types.SimpleNamespace(max_repairs=1, seed_base=1000, sample_idx=0, render_timeout=120, feedback="report")
    inner = Fake(replies)
    b = Scadfixed(inner, RB.extract_code, fix)
    with tempfile.TemporaryDirectory() as d:
        attempts = RB.run_one(b, "system", t, ref, args, d, "x")
        saved = open(os.path.join(d, "x_a0.scad")).read()
    return attempts, inner, saved


def main():
    attempts, inner, saved = conversation([BROKEN, BROKEN])
    a0 = attempts[0]
    sf = (a0.get("usage") or {}).get("scadfix") or {}
    check("live: a shape assigned to a variable is repaired and the repaired file renders", a0["render"]["ok"],
          a0["render"])
    check("live: the saved file is the repaired one", "module comb" in saved, saved[:120])
    check("live: the record keeps the rules and the original reply",
          "geometry_to_module" in sf.get("rules", []) and sf.get("orig_reply") == BROKEN, sf)
    check("live: the conversation holds the repaired file as the model's own turn",
          sf.get("history_replaced") and "module comb" in inner.messages[2]["content"]
          and inner.messages[2]["content"].startswith("Here is the comb."), inner.messages[2]["content"][:120])
    check("live: the next user turn is the report on the repaired part",
          "measurement report" in inner.messages[3]["content"], inner.messages[3]["content"][:120])
    attempts, inner, saved = conversation([VALID, VALID])
    check("live: a valid file goes through unchanged, with no scadfix record",
          "scadfix" not in (attempts[0].get("usage") or {}) and inner.messages[2]["content"] == VALID
          and saved.strip() == "cube([70, 24, 1.5]);")
    print(f"\n{len(FAILS)} failed" if FAILS else "\nall passed")
    sys.exit(1 if FAILS else 0)


if __name__ == "__main__":
    main()
