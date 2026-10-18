#!/usr/bin/env python3
"""Harness search on batch C: one model, several harnesses (system prompt x feedback), scored against each
description's reference file - never against the benchmark's 16 tasks, which see the chosen harness once,
in its final run (§6.4).

Every conversation is run_bench.run_one's: up to three attempts with the benchmark's sampling (temperature
0.2, top-p 0.95, seed 1000 + attempt, thinking off, 2,048-token replies), its code extraction and its feedback
builder. A reply passes when the part it builds matches the reference with the tolerances batch C uses in
§6.4 (onpolicy_repairs.ref_ok: watertight, bounding box per axis, volume, bodies, triangle floor). Every
harness sees the same descriptions with the same seeds, so two harnesses that differ only in feedback write
the same first attempts, and harnesses are compared description by description.

The harness adopted for the benchmark is fixed here, before its run: the one that passes the most
descriptions within three attempts, ties going to the harness with fewer changes.

    python bench/harness_search.py subset --per-family 16 --out subset_c.jsonl
    OLLAMA_HOST=http://127.0.0.1:11501 python bench/harness_search.py run --model qwen3.5-9b \
        --subset subset_c.jsonl --out hs_base.jsonl --workers 40 \
        --harness h0=system.md:report h1=system_idioms.md:report h2=system_examples.md:report \
                  h3=system.md:checklist h4=system_idioms_examples.md:checklist
    python bench/harness_search.py summary hs_base.jsonl
"""
from __future__ import annotations

import argparse
import collections
import hashlib
import json
import os
import random
import sys
import tempfile
import threading
import time
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor, as_completed

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
sys.path[:0] = [os.path.join(ROOT, "tools"), HERE, os.path.join(ROOT, "finetune", "scripts")]
from scadreport import analyse, format_report, load_mesh, render  # noqa: E402
import onpolicy_repairs  # noqa: E402
import rft_score  # noqa: E402
import run_bench  # noqa: E402  (reads OLLAMA_HOST)


def cmd_subset(a) -> None:
    """A stratified batch-C subset: --per-family descriptions from each family, with the reference measured."""
    family = {}
    for line in open(os.path.join(ROOT, "finetune", "rft", "distill", "prompts_clean_c.jsonl")):
        d = json.loads(line)
        family[d["user"].strip()] = d["family"]
    by = collections.defaultdict(list)
    for line in open(a.prompts):
        p = json.loads(line)
        user = onpolicy_repairs.user_of(p["messages"])
        by[family.get(user.strip(), "?")].append({"id": p["id"], "user": user, "ref": p["ref"]})
    if "?" in by:
        raise SystemExit(f"{len(by['?'])} descriptions have no family in prompts_clean_c.jsonl")
    rng = random.Random(a.seed)
    items = [{**x, "family": k} for k in sorted(by) for x in rng.sample(by[k], min(a.per_family, len(by[k])))]
    with ProcessPoolExecutor(a.workers) as ex:
        refs = list(ex.map(rft_score.measure, [x["ref"] for x in items]))
    n = 0
    with open(a.out, "w", encoding="utf-8") as fh:
        for x, m in zip(items, refs):
            if m.get("ok"):
                fh.write(json.dumps({**x, "refm": m}, ensure_ascii=False) + "\n")
                n += 1
    print(f"{n} descriptions from {len(by)} families -> {a.out} ({len(items) - n} references did not measure)")


def converse(model, system, feedback, item, max_repairs=2, seed_base=1000) -> list[dict]:
    """One conversation, as run_bench.run_one, scored against the description's reference."""
    backend = run_bench.make_backend(model, 0.2, seed_base, num_predict=2048, think=False, num_ctx=8192)
    user, attempts = item["user"], []
    with tempfile.TemporaryDirectory() as d:
        for a in range(max_repairs + 1):
            backend.opts["seed"] = seed_base + a
            text, usage = backend.chat(system, user)
            code, how = run_bench.extract_code(text or "")
            rec = {"attempt": a, "extract": how, "reply_chars": len(text or ""), "usage": usage,
                   "code_sha1": hashlib.sha1(code.encode(errors="surrogatepass")).hexdigest()[:12] if code else None}
            rr, mesh, an = {"ok": False, "messages": ["no code"], "log": ""}, None, None
            if code:
                sp, stl = os.path.join(d, f"a{a}.scad"), os.path.join(d, f"a{a}.stl")
                with open(sp, "w", encoding="utf-8", errors="replace") as fh:
                    fh.write(code)
                rr = render(sp, stl, timeout=120)
                if rr["ok"]:
                    try:
                        mesh = load_mesh(stl)
                        an = analyse(mesh)
                    except Exception as e:  # noqa: BLE001
                        rr = {**rr, "ok": False, "messages": rr["messages"] + [f"ERROR: mesh analysis failed: {e}"]}
                        mesh = an = None
            rec["render"] = bool(rr["ok"])
            rec["passed"] = bool(an is not None and onpolicy_repairs.ref_ok(mesh, an, item["refm"]))
            attempts.append(rec)
            if rec["passed"] or a == max_repairs:
                break
            report_text = None
            if an is not None and feedback in ("report", "checklist"):
                try:
                    report_text = format_report(rr, an)
                except Exception:  # noqa: BLE001
                    pass
            kind = "generic" if feedback in ("report", "checklist") and rr["ok"] and report_text is None else feedback
            unchanged = a > 0 and rec["code_sha1"] is not None and rec["code_sha1"] == attempts[-2]["code_sha1"]
            user = run_bench.feedback_message(kind, rr, report_text, how, unchanged)
    return attempts


def parse_harness(spec: str):
    """name=system_file:feedback -> (name, system text, system file, feedback)."""
    name, rest = spec.split("=", 1)
    path, feedback = rest.rsplit(":", 1)
    if feedback not in ("report", "generic", "checklist"):
        raise SystemExit(f"unknown feedback {feedback!r} in {spec!r}")
    full = path if os.path.isabs(path) else os.path.join(HERE, "prompts", path)
    return name, open(full, encoding="utf-8").read(), os.path.relpath(full, ROOT), feedback


def cmd_run(a) -> None:
    harness = {n: (text, path, fb) for n, text, path, fb in map(parse_harness, a.harness)}
    items = [json.loads(line) for line in open(a.subset)]
    done = set()
    if os.path.exists(a.out):
        done = {(r["harness"], r["id"]) for r in map(json.loads, open(a.out))}
    # description-major order: a run cut short still holds every harness on the same descriptions
    jobs = [(h, it) for it in items for h in harness if (h, it["id"]) not in done]
    print(f"{len(jobs)} conversations to run ({len(done)} already in {a.out}); model {a.model} via {run_bench.OLLAMA}",
          flush=True)
    lock, t0, failed = threading.Lock(), time.time(), 0
    with ThreadPoolExecutor(a.workers) as ex, open(a.out, "a", encoding="utf-8") as fh:
        futs = {ex.submit(converse, a.model, harness[h][0], harness[h][2], it, a.max_repairs, a.seed_base): (h, it)
                for h, it in jobs}
        for n, fut in enumerate(as_completed(futs), 1):
            h, it = futs[fut]
            try:
                att = fut.result()
            except Exception as e:  # noqa: BLE001  (left out of the file: a rerun redoes it)
                failed += 1
                print(f"FAILED {h} {it['id']}: {e!r}"[:300], flush=True)
                continue
            row = {"harness": h, "system": harness[h][1], "feedback": harness[h][2], "model": a.model,
                   "id": it["id"], "family": it["family"], "attempts": att}
            with lock:
                fh.write(json.dumps(row, ensure_ascii=False) + "\n")
                fh.flush()
            if n % 100 == 0 or n == len(jobs):
                print(f"{n}/{len(jobs)} conversations, {time.time() - t0:.0f} s, {failed} failed", flush=True)
    summary(a.out)
    if failed:
        raise SystemExit(f"{failed} conversations failed; rerun the same command to redo them")


def summary(path) -> None:
    rows = [json.loads(line) for line in open(path)]
    by = collections.defaultdict(dict)
    for r in rows:
        by[r["harness"]][r["id"]] = r
    print(f"\n{rows[0]['model'] if rows else ''}: {path}")
    print("| Harness | System prompt | Feedback | Descriptions | Pass, first attempt | Pass within three | "
          "First attempt renders | Feedback messages | File changed | Passes won by repair |")
    print("|---|---|---|---:|---:|---:|---:|---:|---:|---:|")
    for h in sorted(by):
        rs = list(by[h].values())
        n = len(rs)
        first = sum(r["attempts"][0]["passed"] for r in rs)
        anyp = sum(any(x["passed"] for x in r["attempts"]) for r in rs)
        rend = sum(r["attempts"][0]["render"] for r in rs)
        fb = sum(len(r["attempts"]) - 1 for r in rs)
        changed = sum(x["code_sha1"] is not None and x["code_sha1"] != p["code_sha1"]
                      for r in rs for p, x in zip(r["attempts"], r["attempts"][1:]))
        wins = sum(any(x["passed"] for x in r["attempts"][1:]) for r in rs)
        pct = lambda k, d: f"{k} ({100 * k / d:.0f}%)" if d else "-"  # noqa: E731
        print(f"| {h} | {os.path.basename(rs[0]['system'])} | {rs[0]['feedback']} | {n} | {pct(first, n)} | "
              f"{pct(anyp, n)} | {pct(rend, n)} | {fb} | {pct(changed, fb)} | {wins} |")
    if "h0" in by:  # paired against h0 on the descriptions both ran: (only this harness passed, only h0 passed)
        for h in sorted(by):
            if h == "h0":
                continue
            ids = by[h].keys() & by["h0"].keys()
            ok = lambda r: any(x["passed"] for x in r["attempts"])  # noqa: E731
            b = sum(ok(by[h][i]) and not ok(by["h0"][i]) for i in ids)
            c = sum(ok(by["h0"][i]) and not ok(by[h][i]) for i in ids)
            print(f"{h} vs h0 on {len(ids)} descriptions: only {h} passed {b}, only h0 passed {c}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p1 = sub.add_parser("subset")
    p1.add_argument("--prompts", default=os.path.join(ROOT, "finetune", "rft", "onpolicy", "prompts_c.jsonl"))
    p1.add_argument("--per-family", type=int, default=16)
    p1.add_argument("--seed", type=int, default=20261018)
    p1.add_argument("--workers", type=int, default=8)
    p1.add_argument("--out", required=True)
    p2 = sub.add_parser("run")
    p2.add_argument("--model", required=True)
    p2.add_argument("--subset", required=True)
    p2.add_argument("--harness", nargs="+", required=True, help="name=system_file:feedback (files in bench/prompts/)")
    p2.add_argument("--workers", type=int, default=40)
    p2.add_argument("--max-repairs", type=int, default=2)
    p2.add_argument("--seed-base", type=int, default=1000)
    p2.add_argument("--out", required=True)
    p3 = sub.add_parser("summary")
    p3.add_argument("results")
    a = ap.parse_args()
    if a.cmd == "subset":
        cmd_subset(a)
    elif a.cmd == "run":
        cmd_run(a)
    else:
        summary(a.results)


if __name__ == "__main__":
    main()
