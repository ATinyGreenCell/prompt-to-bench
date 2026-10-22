#!/usr/bin/env python3
"""Ollama-API front for an OpenAI-compatible server (e.g. vLLM on a rented GPU), so
bench/run_bench.py can drive a model served there without any change to the harness.

run_bench.py speaks the Ollama API (/api/tags, streamed /api/chat, /api/generate to unload).
This shim answers those calls and forwards each chat turn to `<upstream>/v1/chat/completions`
(streamed), translating the reply back into Ollama's NDJSON stream. Mapping:

    options.temperature / top_p / seed   -> temperature / top_p / seed
    options.num_predict                  -> max_tokens
    think: false                         -> chat_template_kwargs.enable_thinking = false (Qwen3.x)

When run_bench closes the stream early (code block complete, or the model is looping), the
shim closes the upstream request too, so the server stops generating. Model names are listed
with a ":latest" tag, as Ollama does; the tag is stripped before forwarding.

With --grammar FILE (a GBNF grammar such as bench/smallmodels/grammar/openscad.gbnf), every
forwarded request also carries "grammar": <the file's text>, which llama-server applies to the
whole reply (grammar-constrained decoding). This is a llama.cpp field; vLLM does not read it.

    python bench/ollama_openai_shim.py --upstream http://127.0.0.1:18000 --port 11500
    OLLAMA_HOST=http://127.0.0.1:11500 python bench/run_bench.py --run gpu-x --models <served-name> ...
    python bench/ollama_openai_shim.py --upstream http://127.0.0.1:18090 --port 11501 \\
        --grammar bench/smallmodels/grammar/openscad.gbnf
"""
from __future__ import annotations

import argparse
import http.server
import json
import socketserver
import sys
import time
import urllib.error
import urllib.request

UPSTREAM = "http://127.0.0.1:8000"
GRAMMAR = None  # GBNF text sent as "grammar" with every request (--grammar), or None


def upstream_models() -> list[str]:
    with urllib.request.urlopen(f"{UPSTREAM}/v1/models", timeout=10) as r:
        return [m["id"] for m in json.load(r).get("data", [])]


class Handler(http.server.BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.0"  # streamed replies end when the connection closes

    def log_message(self, fmt, *args):  # one line per request on stderr
        sys.stderr.write("%s %s\n" % (time.strftime("%H:%M:%S"), fmt % args))

    def _json(self, code: int, obj) -> None:
        data = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path.startswith("/api/tags"):
            try:
                names = upstream_models()
            except Exception as e:  # noqa: BLE001 - 5xx makes run_bench wait and retry
                return self._json(503, {"error": f"upstream not ready: {e}"})
            return self._json(200, {"models": [{"name": f"{n}:latest", "model": f"{n}:latest",
                                                "size": 0, "details": {}} for n in names]})
        if self.path in ("/", "/api/version"):
            return self._json(200, {"version": "0.0.0-openai-shim"})
        self._json(404, {"error": "not found"})

    def do_POST(self):
        n = int(self.headers.get("Content-Length") or 0)
        body = json.loads(self.rfile.read(n) or b"{}")
        if self.path == "/api/generate":  # run_bench's unload call (keep_alive 0): nothing to do
            return self._json(200, {"model": body.get("model"), "response": "", "done": True})
        if self.path == "/api/chat":
            return self.chat(body)
        self._json(404, {"error": "not found"})

    def chat(self, body: dict) -> None:
        o = body.get("options") or {}
        model = str(body.get("model", "")).removesuffix(":latest")
        req = {"model": model, "messages": body.get("messages", []), "stream": True,
               "stream_options": {"include_usage": True},
               "max_tokens": int(o.get("num_predict") or 2048)}
        for k in ("temperature", "top_p", "seed"):
            if o.get(k) is not None:
                req[k] = o[k]
        if body.get("think") is False:
            req["chat_template_kwargs"] = {"enable_thinking": False}
        if GRAMMAR:
            req["grammar"] = GRAMMAR
        up = urllib.request.Request(f"{UPSTREAM}/v1/chat/completions", data=json.dumps(req).encode(),
                                    headers={"Content-Type": "application/json"})
        t0 = time.time()
        try:
            resp = urllib.request.urlopen(up, timeout=3600)
        except urllib.error.HTTPError as e:
            msg = e.read().decode(errors="replace")[:500]
            return self._json(e.code if e.code >= 500 else 400, {"error": f"upstream HTTP {e.code}: {msg}"})
        except Exception as e:  # noqa: BLE001
            return self._json(503, {"error": f"upstream unreachable: {e}"})
        self.send_response(200)
        self.send_header("Content-Type", "application/x-ndjson")
        self.end_headers()
        t_first, n_out, usage, reason = None, 0, {}, None
        try:
            with resp:
                for raw in resp:
                    line = raw.decode(errors="replace").strip()
                    if not line.startswith("data:"):
                        continue
                    data = line[5:].strip()
                    if data == "[DONE]":
                        break
                    ev = json.loads(data)
                    if ev.get("usage"):
                        usage = ev["usage"]
                    for ch in ev.get("choices") or []:
                        reason = ch.get("finish_reason") or reason
                        piece = (ch.get("delta") or {}).get("content") or ""
                        if piece:
                            t_first = t_first or time.time()
                            n_out += 1
                            self.wfile.write((json.dumps({"model": body.get("model"), "done": False,
                                                          "message": {"role": "assistant", "content": piece}})
                                              + "\n").encode())
                            self.wfile.flush()
            now = time.time()
            final = {"model": body.get("model"), "done": True, "done_reason": reason or "stop",
                     "message": {"role": "assistant", "content": ""},
                     "eval_count": usage.get("completion_tokens", n_out),
                     "eval_duration": int((now - (t_first or now)) * 1e9),
                     "prompt_eval_count": usage.get("prompt_tokens"),
                     "prompt_eval_duration": int(((t_first or now) - t0) * 1e9),
                     "load_duration": 0}
            self.wfile.write((json.dumps(final) + "\n").encode())
            self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError):
            pass  # run_bench stopped reading early; leaving the `with` closed the upstream request


class Server(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


def main() -> None:
    global UPSTREAM, GRAMMAR
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--upstream", default=UPSTREAM, help="OpenAI-compatible base URL (no /v1)")
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--port", type=int, default=11500)
    ap.add_argument("--grammar", metavar="FILE",
                    help="GBNF grammar sent as \"grammar\" with every request (llama-server only)")
    a = ap.parse_args()
    UPSTREAM = a.upstream.rstrip("/")
    if a.grammar:
        with open(a.grammar, encoding="utf-8") as f:
            GRAMMAR = f.read()
    print(f"ollama-openai shim on http://{a.host}:{a.port} -> {UPSTREAM}"
          + (f" (grammar {a.grammar}, {len(GRAMMAR)} chars)" if GRAMMAR else ""), flush=True)
    Server((a.host, a.port), Handler).serve_forever()


if __name__ == "__main__":
    main()
