#!/usr/bin/env python3
"""e2e.py - grammar-constrained generation with the PrismML llama-server, end to end.

    python -I -B bench/smallmodels/grammar/e2e.py --model /path/to/model.gguf --label qwen2.5-coder-1.5b

Starts llama-server (nice 10) on 127.0.0.1:18090 with -c 8192 -t 6 -np 1, then
  1. /v1/chat/completions without a grammar, and with "grammar": <openscad.gbnf> in the request body;
  2. /completion with the same grammar field (prompt from /apply-template), a short continuation;
  3. a request with a broken grammar, which must fail (proves the field is parsed, not ignored);
  4. optionally (--grammar-file-test) restarts the server with --grammar-file openscad.gbnf and sends a
     chat request with no grammar field, to show the server-wide default;
and stops the server. Each reply is checked with validate.py's acceptor, rendered with OpenSCAD and
described with tools/scadreport.py. Results go to e2e/<label>/ next to this file.
"""
from __future__ import annotations

import argparse
import json
import os
import pathlib
import re
import signal
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request

HERE = pathlib.Path(__file__).resolve().parent
REPO = HERE.parents[2]
sys.path.insert(0, str(HERE))
import validate  # noqa: E402  (the same acceptor as the corpus test)

SERVER = pathlib.Path.home() / "src/prismml-llama.cpp/build/bin/llama-server"
OPENSCAD = "/home/seb/.local/bin/openscad"
PY = str(REPO / ".venv/bin/python")
PROMPT = ("Design a 20 x 30 x 5 mm plate with four 3 mm holes 4 mm from each corner. "
          "Reply with a single complete OpenSCAD file.")


def post(url: str, body: dict, timeout: float = 3600) -> tuple[int, dict]:
    req = urllib.request.Request(url, data=json.dumps(body).encode(), headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, json.load(r)
    except urllib.error.HTTPError as e:
        txt = e.read().decode(errors="replace")
        try:
            return e.code, json.loads(txt)
        except json.JSONDecodeError:
            return e.code, {"raw": txt[:2000]}


def start_server(model: str, port: int, threads: int, ctx: int, log: pathlib.Path, extra: list[str]):
    cmd = ["nice", "-n", "10", str(SERVER), "-m", model, "--host", "127.0.0.1", "--port", str(port),
           "-c", str(ctx), "-t", str(threads), "-np", "1"] + extra
    fh = open(log, "w")
    proc = subprocess.Popen(cmd, stdout=fh, stderr=subprocess.STDOUT, start_new_session=True)
    t0 = time.time()
    while time.time() - t0 < 600:
        if proc.poll() is not None:
            raise RuntimeError(f"llama-server exited with {proc.returncode}; see {log}")
        try:
            with urllib.request.urlopen(f"http://127.0.0.1:{port}/health", timeout=5) as r:
                if json.load(r).get("status") == "ok":
                    return proc, cmd, time.time() - t0
        except Exception:  # noqa: BLE001 - still loading
            pass
        time.sleep(1)
    raise RuntimeError("llama-server did not become ready in 600 s")


def stop_server(proc) -> None:
    if proc is None or proc.poll() is not None:
        return
    os.killpg(proc.pid, signal.SIGTERM)
    try:
        proc.wait(timeout=60)
    except subprocess.TimeoutExpired:
        os.killpg(proc.pid, signal.SIGKILL)
        proc.wait(timeout=30)


def extract(reply: str) -> str | None:
    m = re.search(r"```[ \t]*(?:openscad|scad)?[^\n]*\n(.*?)```", reply, re.S)
    return m.group(1) if m else None


def check_reply(reply: str, name: str, out: pathlib.Path, G: validate.Grammar) -> dict:
    res: dict = {}
    g = G.run(reply)
    res["grammar_accepts_reply"] = g["ok"]
    if not g["ok"]:
        ln, col, src = validate.locate(reply, g["pos"])
        res["grammar_rejects_at"] = f"line {ln} col {col}: {g['why']} in {src.strip()[:80]!r}"
    code = extract(reply)
    res["has_code_block"] = code is not None
    if code is None:
        return res
    scad = out / f"{name}.scad"
    scad.write_text(code)
    with tempfile.TemporaryDirectory() as td:
        stl = pathlib.Path(td) / "x.stl"
        t0 = time.time()
        p = subprocess.run(["nice", "-n", "10", OPENSCAD, "-o", str(stl), str(scad)],
                           capture_output=True, text=True, errors="replace", timeout=600)
        msgs = [ln for ln in (p.stdout + p.stderr).splitlines()
                if re.match(r"\s*(ERROR|WARNING)", ln) or "Parser error" in ln]
        res["openscad_renders"] = p.returncode == 0 and stl.exists() and stl.stat().st_size > 0
        res["openscad_messages"] = msgs[:10]
        res["render_sec"] = round(time.time() - t0, 1)
    env = dict(os.environ, OPENSCAD=OPENSCAD)
    p = subprocess.run(["nice", "-n", "10", PY, "-I", "-B", str(REPO / "tools/scadreport.py"), str(scad), "--json"],
                       capture_output=True, text=True, errors="replace", timeout=900, env=env)
    try:
        rep = json.loads(p.stdout)
        geo = rep.get("geometry") or {}
        sl = max(geo.get("slices") or [{"holes": []}], key=lambda s: len(s["holes"]))
        res["scadreport"] = {
            "render_ok": rep["render"]["ok"], "messages": rep["render"].get("messages", [])[:6],
            "size": [round(x, 2) for x in geo.get("size", [])], "watertight": geo.get("watertight"),
            "bodies": geo.get("bodies"), "volume": round(geo["volume"], 1) if geo.get("volume") else None,
            "holes_in_one_slice": len(sl["holes"]),
            "holes": [f"{h['kind']} d={h['d']:.2f} at ({h['cx']:.2f}, {h['cy']:.2f})" for h in sl["holes"][:8]]}
    except (json.JSONDecodeError, KeyError, TypeError) as e:
        res["scadreport"] = {"raw": (p.stdout + p.stderr)[-1500:], "parse_error": str(e)}
    return res


def chat(base: str, grammar: str | None, a, label: str) -> dict:
    body = {"messages": [{"role": "user", "content": PROMPT}], "temperature": 0.2, "top_p": 0.95,
            "seed": a.seed, "max_tokens": a.max_tokens, "stream": False}
    if grammar is not None:
        body["grammar"] = grammar
    t0 = time.time()
    code, r = post(f"{base}/v1/chat/completions", body)
    wall = time.time() - t0
    if code != 200:
        return {"http": code, "error": r, "wall_sec": round(wall, 1)}
    msg = r["choices"][0]["message"]
    tm = r.get("timings", {})
    return {"http": code, "reply": msg.get("content") or "", "finish_reason": r["choices"][0].get("finish_reason"),
            "completion_tokens": r.get("usage", {}).get("completion_tokens"),
            "prompt_tokens": r.get("usage", {}).get("prompt_tokens"),
            "tokens_per_sec": round(tm.get("predicted_per_second", 0.0), 2),
            "prompt_tokens_per_sec": round(tm.get("prompt_per_second", 0.0), 1),
            "gen_ms": round(tm.get("predicted_ms", 0.0)), "wall_sec": round(wall, 1)}


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model", required=True)
    ap.add_argument("--label", required=True)
    ap.add_argument("--port", type=int, default=18090)
    ap.add_argument("--threads", type=int, default=6)
    ap.add_argument("--ctx", type=int, default=8192)
    ap.add_argument("--max-tokens", type=int, default=1536)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--repeats", type=int, default=1, help="alternate free/grammar requests this many times")
    ap.add_argument("--grammar", default=str(HERE / "openscad.gbnf"))
    ap.add_argument("--server-checks", action="store_true", help="also /completion and a broken grammar")
    ap.add_argument("--grammar-file-test", action="store_true", help="also restart with --grammar-file")
    ap.add_argument("--logdir", default=tempfile.gettempdir())
    a = ap.parse_args()

    for p in (11434, 11435, 18010, 11510):
        assert a.port != p, "port reserved for other servers"
    out = HERE / "e2e" / a.label
    out.mkdir(parents=True, exist_ok=True)
    gtext = pathlib.Path(a.grammar).read_text()
    G = validate.Grammar(gtext)
    base = f"http://127.0.0.1:{a.port}"
    summary: dict = {"model": a.model, "label": a.label, "prompt": PROMPT, "port": a.port, "threads": a.threads,
                     "ctx": a.ctx, "max_tokens": a.max_tokens, "seed": a.seed, "temperature": 0.2, "top_p": 0.95,
                     "grammar_sha256": __import__("hashlib").sha256(gtext.encode()).hexdigest(),
                     "date": time.strftime("%Y-%m-%d %H:%M %Z")}
    logdir = pathlib.Path(a.logdir)
    proc = None
    try:
        proc, cmd, load = start_server(a.model, a.port, a.threads, a.ctx, logdir / f"llama-server-{a.label}.log", [])
        summary["server_cmd"] = " ".join(cmd)
        summary["load_sec"] = round(load, 1)
        speeds: dict = {"free": [], "grammar": []}
        for rep in range(a.repeats):  # same seed: identical replies, so repeats only sample speed noise
            for name, gr in (("free", None), ("grammar", gtext)):
                r = chat(base, gr, a, a.label)
                print(f"[{a.label}] chat {name} #{rep + 1}: http {r['http']} tokens {r.get('completion_tokens')} "
                      f"{r.get('tokens_per_sec')} tok/s finish {r.get('finish_reason')}", flush=True)
                speeds[name].append(r.get("tokens_per_sec"))
                if rep == 0:
                    if "reply" in r:
                        (out / f"reply_{name}.txt").write_text(r["reply"])
                        r.update(check_reply(r["reply"], f"reply_{name}", out, G))
                        r.pop("reply")
                    summary[f"chat_{name}"] = r
                elif "reply" in r:
                    summary[f"chat_{name}"]["identical_on_repeat_%d" % (rep + 1)] = (
                        r["reply"] == (out / f"reply_{name}.txt").read_text())
        summary["tokens_per_sec_runs"] = speeds
        if a.server_checks:
            code, tpl = post(f"{base}/apply-template", {"messages": [{"role": "user", "content": PROMPT}]})
            prompt = tpl.get("prompt", "")
            code, r = post(f"{base}/completion", {"prompt": prompt, "grammar": gtext, "n_predict": 48,
                                                   "temperature": 0.2, "top_p": 0.95, "seed": a.seed})
            txt = r.get("content", "")
            summary["completion_endpoint"] = {
                "http": code, "first_48_tokens": txt, "starts_with_fence": txt.startswith("```openscad"),
                "grammar_in_settings": bool((r.get("generation_settings") or {}).get("grammar"))}
            print(f"[{a.label}] /completion with grammar: http {code} {txt[:60]!r}", flush=True)
            code, r = post(f"{base}/v1/chat/completions",
                           {"messages": [{"role": "user", "content": "hi"}], "max_tokens": 8,
                            "grammar": 'root ::= "a" undefined-rule'})
            summary["broken_grammar"] = {"http": code, "error": r.get("error", r)}
            print(f"[{a.label}] broken grammar: http {code}", flush=True)
        stop_server(proc)
        proc = None
        if a.grammar_file_test:
            proc, cmd, load = start_server(a.model, a.port, a.threads, a.ctx,
                                           logdir / f"llama-server-{a.label}-gf.log", ["--grammar-file", a.grammar])
            r = chat(base, None, a, a.label)
            print(f"[{a.label}] chat with --grammar-file, no grammar field: http {r['http']} "
                  f"{r.get('tokens_per_sec')} tok/s", flush=True)
            if "reply" in r:
                (out / "reply_grammar_file.txt").write_text(r["reply"])
                r.update(check_reply(r["reply"], "reply_grammar_file", out, G))
                r.pop("reply")
            r["server_cmd"] = " ".join(cmd)
            summary["chat_grammar_file_flag"] = r
    finally:
        stop_server(proc)
    (out / "summary.json").write_text(json.dumps(summary, indent=1, default=str))
    print(json.dumps(summary, indent=1, default=str))


if __name__ == "__main__":
    main()
