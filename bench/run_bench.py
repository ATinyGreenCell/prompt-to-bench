#!/usr/bin/env python3
"""Run the Prompt-to-Bench benchmark: model writes OpenSCAD -> render -> hidden checks -> repair loop.

    python bench/run_bench.py --run main --models qwen2.5-coder:1.5b qwen3.5:4b-q4_K_M
    python bench/run_bench.py --run main --models claude:claude-haiku-4-5
    python bench/run_bench.py --run feedback-generic --feedback generic --models ...

Every (model, task, sample) is one conversation:
  attempt 0  system prompt + task prompt -> code
  attempt n  if the part failed the hidden checks, the model gets feedback and tries again
             (up to --max-repairs times). Feedback never contains the hidden checks:
               report  - OpenSCAD messages, or the generic scadreport geometry report
               generic - OpenSCAD messages, or "it does not match the spec, try again"
Results are appended to bench/results/<run>/results.jsonl (one line per conversation),
so an interrupted run can simply be restarted. Generated files go to .../code/.

Backends: Ollama (local, default) and "claude:<model-id>" via the Claude Code CLI (`claude -p`).
"""
import argparse
import datetime as dt
import fcntl
import hashlib
import json
import os
import platform
import re
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request

import yaml

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, "tools"))
from checks import evaluate  # noqa: E402
from scadreport import analyse, format_report, load_mesh, render  # noqa: E402

OLLAMA = os.environ.get("OLLAMA_HOST", "http://localhost:11434")
FENCE = re.compile(r"```[ \t]*([A-Za-z0-9_+-]*)[^\n]*\n(.*?)```", re.S)
SCAD_HINT = re.compile(r"\b(cube|cylinder|difference|union|module|linear_extrude|rotate_extrude|polygon)\s*\(")
ASK = "Reply with the complete corrected file in a single ```openscad code block."


# --------------------------------------------------------------------------- code extraction

def extract_code(text):
    """Return (code, how) from a model reply."""
    text = re.sub(r"<think>.*?</think>", "", text or "", flags=re.S)
    blocks = FENCE.findall(text)
    if blocks:
        labelled = [b for lang, b in blocks if lang.lower() in ("openscad", "scad")]
        cands = labelled or [b for _, b in blocks]
        return max(cands, key=len).strip(), "fenced"
    m = re.search(r"```[^\n]*\n(.*)$", text, re.S)
    if m:
        return m.group(1).strip(), "unterminated"
    if SCAD_HINT.search(text):
        return text.strip(), "bare"
    return None, "none"


# --------------------------------------------------------------------------- backends

def code_block_complete(text):
    """A closed ```...``` block containing OpenSCAD code has been emitted."""
    return any(SCAD_HINT.search(b) for _, b in FENCE.findall(re.sub(r"<think>.*?</think>", "", text, flags=re.S)))


def repeating(text, k=150, reps=3):
    """The last k characters already occur `reps` times: the model is looping."""
    return len(text) >= k * (reps + 1) and text.count(text[-k:]) >= reps


THINK = {}  # model -> False (thinking switched off) or None (model has no thinking switch)


class InfraError(RuntimeError):
    """The runtime (Ollama server, Claude CLI) failed - not the model. Never scored."""


def ollama_ready(model, wait_s=300):
    """Wait for the Ollama server (it may still be starting after a reboot) and check the model exists."""
    t0 = time.time()
    while True:
        try:
            tags = json.load(urllib.request.urlopen(f"{OLLAMA}/api/tags", timeout=10))
            names = {m["name"] for m in tags.get("models", [])}
            if model not in names and f"{model}:latest" not in names:
                raise SystemExit(f"model {model!r} is not installed - run: ollama pull {model}")
            return
        except (urllib.error.URLError, ConnectionError, TimeoutError, OSError):
            if time.time() - t0 > wait_s:
                raise SystemExit(f"Ollama is not reachable at {OLLAMA} - start it with `ollama serve`")
            time.sleep(5)


class Ollama:
    def __init__(self, model, temperature, seed, num_ctx=8192, num_predict=2048, think=False):
        self.model, self.think = model, THINK.get(model, think)
        self.opts = {"temperature": temperature, "top_p": 0.95, "seed": seed,
                     "num_ctx": num_ctx, "num_predict": num_predict}
        self.messages = []

    def _post(self, body):
        """Stream the reply; stop early once a complete OpenSCAD block has arrived or the
        model is stuck repeating itself (closing the stream makes Ollama stop generating)."""
        req = urllib.request.Request(f"{OLLAMA}/api/chat", data=json.dumps(body).encode(),
                                     headers={"Content-Type": "application/json"})
        parts, thinking, final, stop, n = [], [], None, None, 0
        t0, t_first = time.time(), None
        with urllib.request.urlopen(req, timeout=3600) as resp:
            for line in resp:
                if not line.strip():
                    continue
                ev = json.loads(line)
                msg = ev.get("message", {})
                if msg.get("content") or msg.get("thinking"):
                    n += 1
                    t_first = t_first or time.time()
                parts.append(msg.get("content") or "")
                thinking.append(msg.get("thinking") or "")
                if ev.get("done"):
                    final = ev
                    break
                if n % 16 == 0:
                    text = "".join(parts)
                    if code_block_complete(text):
                        stop = "code_block_complete"
                    elif repeating(text):
                        stop = "repetition"
                    if stop:
                        break
        text = "".join(parts)
        if final is None:  # we stopped the stream ourselves: estimate the stats
            now = time.time()
            final = {"eval_count": n, "eval_duration": int((now - (t_first or now)) * 1e9),
                     "prompt_eval_count": None, "prompt_eval_duration": int(((t_first or now) - t0) * 1e9),
                     "load_duration": 0, "done_reason": stop}
        final["message"] = {"content": text, "thinking": "".join(thinking)}
        return final

    def chat(self, system, user):
        msgs = (self.messages or [{"role": "system", "content": system}]) + [{"role": "user", "content": user}]
        body = {"model": self.model, "messages": msgs, "stream": True,
                "options": self.opts, "keep_alive": "30m"}
        if self.think is not None:
            body["think"] = self.think
        t0 = time.time()
        for attempt in range(4):  # server hiccups (restart, OOM, dropped socket) are retried
            try:
                r = self._post(body)
                break
            except urllib.error.HTTPError as e:
                msg = e.read().decode(errors="replace")
                if "think" in msg.lower() and "think" in body:
                    self.think = THINK[self.model] = None  # model has no thinking switch
                    body.pop("think")
                    continue
                if e.code < 500 or attempt == 3:
                    raise InfraError(f"Ollama HTTP {e.code}: {msg[:300]}") from e
            except (urllib.error.URLError, ConnectionError, TimeoutError, OSError, json.JSONDecodeError) as e:
                if attempt == 3:
                    raise InfraError(f"Ollama connection failed: {e}") from e
            time.sleep(15 * (attempt + 1))
            ollama_ready(self.model)
        self.messages = msgs  # commit the turn only once it succeeded
        wall = time.time() - t0
        msg = r.get("message", {})
        text = msg.get("content", "")
        self.messages.append({"role": "assistant", "content": text})
        return text, {
            "wall_s": round(wall, 2),
            "prompt_tokens": r.get("prompt_eval_count") or 0,
            "prompt_s": round(r.get("prompt_eval_duration", 0) / 1e9, 2),
            "gen_tokens": r.get("eval_count", 0),
            "gen_s": round(r.get("eval_duration", 0) / 1e9, 2),
            "load_s": round(r.get("load_duration", 0) / 1e9, 2),
            "thinking_chars": len(msg.get("thinking") or ""),
            "done_reason": r.get("done_reason"),
        }

    def close(self):
        try:
            body = {"model": self.model, "keep_alive": 0}
            req = urllib.request.Request(f"{OLLAMA}/api/generate", data=json.dumps(body).encode(),
                                         headers={"Content-Type": "application/json"})
            urllib.request.urlopen(req, timeout=60).read()
        except Exception:  # noqa: BLE001
            pass


class ClaudeCLI:
    """Claude via Claude Code print mode: replaced system prompt, no tools, no MCP, no settings."""

    def __init__(self, model, **_):
        self.model, self.session = model, None
        self.cwd = tempfile.mkdtemp(prefix="p2b_claude_")
        self.think = None

    def chat(self, system, user):
        cmd = ["claude", "-p", "--model", self.model, "--system-prompt", system, "--tools", "",
               "--strict-mcp-config", "--setting-sources", "", "--output-format", "json"]
        if self.session:
            cmd += ["--resume", self.session]
        cmd.append(user)
        t0 = time.time()
        for attempt in range(4):  # rate limits and network errors: back off, never score
            try:
                p = subprocess.run(cmd, capture_output=True, text=True, timeout=1800, cwd=self.cwd)
                d = json.loads(p.stdout)
            except (json.JSONDecodeError, subprocess.TimeoutExpired, FileNotFoundError) as e:
                d = {"is_error": True, "result": str(e)[-500:]}
            if not d.get("is_error"):
                break
            time.sleep(60 * (attempt + 1))
        if d.get("is_error"):
            raise InfraError(f"claude CLI error: {d.get('result')}")
        self.session = d.get("session_id")
        u = d.get("usage", {})
        return d.get("result", ""), {
            "wall_s": round(time.time() - t0, 2),
            "prompt_tokens": u.get("input_tokens", 0) + u.get("cache_read_input_tokens", 0) + u.get("cache_creation_input_tokens", 0),
            "gen_tokens": u.get("output_tokens", 0),
            "thinking_tokens": (u.get("output_tokens_details") or {}).get("thinking_tokens"),
            "api_ms": d.get("duration_api_ms"),
        }

    def close(self):
        """Delete this conversation's Claude Code session files so they don't clutter `claude --resume`."""
        enc = re.sub(r"[^A-Za-z0-9]", "-", self.cwd)
        shutil.rmtree(os.path.join(os.path.expanduser("~/.claude/projects"), enc), ignore_errors=True)
        shutil.rmtree(self.cwd, ignore_errors=True)


def make_backend(name, temperature, seed, num_predict=2048, think=False):
    if name.startswith("claude:"):
        return ClaudeCLI(name.split(":", 1)[1])
    return Ollama(name, temperature, seed, num_predict=num_predict, think=think)


# --------------------------------------------------------------------------- one conversation

def feedback_message(kind, render_res, report_text, how):
    if how == "none":
        return "I could not find any OpenSCAD code in your reply. " + ASK
    if not render_res["ok"]:
        msgs = "\n".join(render_res["messages"][:15]) or render_res["log"][-800:]
        return ("OpenSCAD could not build a printable part from your file. Its messages were:\n"
                f"{msgs}\nFix the problem. " + ASK)
    if kind == "report":
        return ("Your file rendered. This is a measurement report of the part it produces:\n\n"
                f"{report_text}\n\nCompare every number in the report with the specification. "
                "Find what does not match and fix it. " + ASK)
    return ("Your file rendered, but the part does not match the specification. "
            "Re-read the specification carefully and fix the design. " + ASK)


def run_one(backend, system, task, ref, args, code_dir, tag):
    attempts = []
    user = task["prompt_used"]
    for a in range(args.max_repairs + 1):
        rec = {"attempt": a}
        if hasattr(backend, "opts"):  # fresh sampling noise for every attempt
            backend.opts["seed"] = args.seed_base + 100 * args.sample_idx + a
        text, usage = backend.chat(system, user)  # InfraError propagates: the task is retried later
        code, how = extract_code(text)
        rec.update({"usage": usage, "extract": how, "reply_chars": len(text),
                    "code_lines": code.count("\n") + 1 if code else 0,
                    "code_sha1": hashlib.sha1(code.encode()).hexdigest()[:12] if code else None,
                    # libraries make results machine-dependent (and break the starter prompt's rule 4)
                    "uses_library": bool(code and re.search(r"^\s*(include|use)\s*<", code, re.M))})
        path = os.path.join(code_dir, f"{tag}_a{a}.scad")
        with open(path, "w") as fh:
            fh.write(code or f"// no code found in reply\n/*\n{text[:4000]}\n*/\n")
        with open(path.replace(".scad", ".reply.txt"), "w") as fh:
            fh.write(text)
        stl = path.replace(".scad", ".stl")
        if code:
            try:
                rr = render(path, stl, timeout=args.render_timeout)
            except FileNotFoundError as e:
                raise SystemExit("OpenSCAD not found - put it on PATH or set $OPENSCAD") from e
        else:
            rr = {"ok": False, "messages": ["no code"], "log": "", "seconds": 0}
        rec["render"] = {"ok": rr["ok"], "messages": rr["messages"][:10], "seconds": rr["seconds"]}
        report_text, result = None, None
        if rr["ok"]:
            try:
                mesh = load_mesh(stl)
                result = evaluate(mesh, task, ref)
                if args.feedback == "report":
                    report_text = format_report(rr, analyse(mesh))
            except Exception as e:  # noqa: BLE001
                rr["ok"] = False
                rr["messages"].append(f"ERROR: mesh analysis failed: {e}")
                rec["render"]["ok"] = False
        if os.path.exists(stl):
            os.remove(stl)  # keep the repo small; .scad files are enough to reproduce
        rec["check"] = result
        rec["passed"] = bool(result and result["passed"])
        rec["score"] = result["score"] if result else 0.0
        attempts.append(rec)
        if rec["passed"] or a == args.max_repairs:
            break
        user = feedback_message(args.feedback, rr, report_text, how)
        rec["feedback"] = user
    return attempts


# --------------------------------------------------------------------------- main

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--run", required=True, help="results sub-directory name")
    ap.add_argument("--models", nargs="+", required=True)
    ap.add_argument("--tasks", nargs="*", help="task ids (default: all)")
    ap.add_argument("--samples", type=int, default=1)
    ap.add_argument("--max-repairs", type=int, default=2)
    ap.add_argument("--feedback", choices=["report", "generic"], default="report")
    ap.add_argument("--temperature", type=float, default=0.2)
    ap.add_argument("--prompts", default=None, help="YAML with translated prompts {lang: {task_id: prompt}}")
    ap.add_argument("--lang", default="en")
    ap.add_argument("--system", default=os.path.join(HERE, "prompts", "system.md"))
    ap.add_argument("--render-timeout", type=int, default=120)
    ap.add_argument("--seed-base", type=int, default=1000)
    ap.add_argument("--num-predict", type=int, default=2048, help="max reply tokens (local models)")
    ap.add_argument("--think", action="store_true", help="let local models think (default: thinking off)")
    args = ap.parse_args()

    tasks = yaml.safe_load(open(os.path.join(HERE, "tasks.yaml")))
    if args.tasks:
        tasks = [t for t in tasks if t["id"] in args.tasks]
    refs = json.load(open(os.path.join(HERE, "reference_stats.json")))
    system = open(args.system).read().strip()
    translated = yaml.safe_load(open(args.prompts))[args.lang] if args.prompts else {}
    if args.lang != "en":
        missing = [t["id"] for t in tasks if t["id"] not in translated]
        if missing:  # never silently fall back to English and call it another language
            raise SystemExit(f"no {args.lang} translation for: {', '.join(missing)}")
    for t in tasks:
        t["prompt_used"] = translated.get(t["id"], t["prompt"]) if args.lang != "en" else t["prompt"]

    out_dir = os.path.join(HERE, "results", args.run)
    os.makedirs(os.path.join(out_dir, "code"), exist_ok=True)
    res_path = os.path.join(out_dir, "results.jsonl")
    lock = open(os.path.join(out_dir, ".lock"), "w")
    try:  # two copies of the same run would duplicate work and interleave records
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        raise SystemExit(f"another run_bench.py is already writing {out_dir} - not starting a second one")
    done = set()
    if os.path.exists(res_path):
        lines = open(res_path).read().splitlines(keepends=True)
        good = []
        for line in lines:
            try:
                r = json.loads(line)
            except json.JSONDecodeError:  # half-written line from a crash or power loss
                continue
            good.append(line if line.endswith("\n") else line + "\n")
            done.add((r["model"], r["task"], r["sample"], r.get("lang", "en"), r.get("feedback", "report")))
        if len(good) != len(lines):
            print(f"dropped {len(lines) - len(good)} damaged line(s) from {res_path}; those tasks will rerun")
            open(res_path, "w").writelines(good)
    margs = {k: (os.path.relpath(v, ROOT) if isinstance(v, str) and v.startswith(ROOT) else v) for k, v in vars(args).items()}
    meta = {"started": dt.datetime.now().isoformat(timespec="seconds"), "args": margs,
            "host": platform.node(), "cpu": platform.processor() or platform.machine(),
            "python": platform.python_version()}
    try:
        meta["openscad"] = subprocess.run(["openscad", "--version"], capture_output=True, text=True).stderr.strip()
        meta["ollama"] = json.load(urllib.request.urlopen(f"{OLLAMA}/api/version", timeout=5))["version"]
    except Exception:  # noqa: BLE001
        pass
    with open(os.path.join(out_dir, f"meta_{dt.datetime.now():%Y%m%d_%H%M%S}.json"), "w") as fh:
        json.dump(meta, fh, indent=1)

    suffix = "".join(f"_{x}" for x, default in ((args.lang, "en"), (args.feedback, "report")) if x != default)
    infra_fails = 0
    for model in args.models:
        if not model.startswith("claude:"):
            ollama_ready(model)
        safe = re.sub(r"[^A-Za-z0-9._-]+", "_", model)
        code_dir = os.path.join(out_dir, "code", safe)
        os.makedirs(code_dir, exist_ok=True)
        for s in range(args.samples):
            for t in tasks:
                if (model, t["id"], s, args.lang, args.feedback) in done:
                    continue
                backend = make_backend(model, args.temperature, seed=args.seed_base + 100 * s,
                                       num_predict=args.num_predict, think=args.think)
                args.sample_idx = s
                t0 = time.time()
                try:
                    attempts = run_one(backend, system, t, refs[t["id"]], args, code_dir, f"{t['id']}_s{s}{suffix}")
                except InfraError as e:
                    infra_fails += 1
                    print(f"{dt.datetime.now():%H:%M:%S} {model:28s} {t['id']:24s} SKIPPED (runtime error, will rerun "
                          f"next time): {e}", flush=True)
                    if infra_fails >= 3:
                        raise SystemExit("3 runtime errors in a row - stopping; fix the runtime and rerun to resume")
                    continue
                finally:
                    backend.close() if model.startswith("claude:") else None
                infra_fails = 0
                rec = {"model": model, "task": t["id"], "category": t["category"], "sample": s,
                       "lang": args.lang, "feedback": args.feedback, "max_repairs": args.max_repairs,
                       "passed": any(a.get("passed") for a in attempts),
                       "first_pass": bool(attempts and attempts[0].get("passed")),
                       "attempts_used": len(attempts), "wall_s": round(time.time() - t0, 1),
                       "think": getattr(backend, "think", None), "attempts": attempts,
                       "finished": dt.datetime.now().isoformat(timespec="seconds")}
                with open(res_path, "a") as fh:  # one write + fsync: survives power loss
                    fh.write(json.dumps(rec) + "\n")
                    fh.flush()
                    os.fsync(fh.fileno())
                flag = "PASS" if rec["passed"] else "fail"
                print(f"{dt.datetime.now():%H:%M:%S} {model:28s} {t['id']:24s} s{s} {flag} "
                      f"after {len(attempts)} attempt(s), best score "
                      f"{max(a.get('score', 0) for a in attempts):.2f}, {rec['wall_s']:.0f}s", flush=True)
        if not model.startswith("claude:"):
            make_backend(model, 0, 0).close()


if __name__ == "__main__":
    main()
