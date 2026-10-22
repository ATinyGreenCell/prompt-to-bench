"""Shared helpers for bench/smallmodels: one JSON-schema-constrained call to a local model through Ollama."""
from __future__ import annotations

import json
import os
import time
import urllib.request

OLLAMA = os.environ.get("OLLAMA_HOST", "http://127.0.0.1:11434")
if "://" not in OLLAMA:  # as run_bench.py: the ollama CLI also accepts OLLAMA_HOST=host:port
    OLLAMA = "http://" + OLLAMA
USAGE_KEYS = ("wall_s", "prompt_tokens", "prompt_s", "gen_tokens", "gen_s", "load_s")


def ollama_json(model: str, messages: list[dict], schema: dict, opts: dict, timeout: int = 1800) -> tuple[dict | None, str, dict]:
    """(parsed JSON or None, raw text, usage in run_bench's fields). Thinking off; the schema constrains decoding."""
    body = {"model": model, "messages": messages, "stream": False, "format": schema, "think": False,
            "options": opts, "keep_alive": "30m"}
    t0 = time.time()
    req = urllib.request.Request(f"{OLLAMA}/api/chat", data=json.dumps(body).encode(),
                                 headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            d = json.load(r)
    except urllib.error.HTTPError as e:
        if b"think" in (msg := e.read()) and "think" in body:  # a model without a thinking switch
            body.pop("think")
            req = urllib.request.Request(f"{OLLAMA}/api/chat", data=json.dumps(body).encode(),
                                         headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=timeout) as r:
                d = json.load(r)
        else:
            raise RuntimeError(f"Ollama HTTP {e.code}: {msg[:200]!r}") from e
    raw = (d.get("message") or {}).get("content") or ""
    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        parsed = None
    usage = {"wall_s": round(time.time() - t0, 2), "prompt_tokens": d.get("prompt_eval_count"),
             "prompt_s": round((d.get("prompt_eval_duration") or 0) / 1e9, 2), "gen_tokens": d.get("eval_count") or 0,
             "gen_s": round((d.get("eval_duration") or 0) / 1e9, 2), "load_s": round((d.get("load_duration") or 0) / 1e9, 2)}
    return parsed, raw, usage


def add_usage(total: dict, u: dict) -> dict:
    for k in USAGE_KEYS:
        if u.get(k) is not None:
            total[k] = round((total.get(k) or 0) + u[k], 2)
    return total


def unload(model: str) -> None:
    try:
        body = {"model": model, "keep_alive": 0}
        req = urllib.request.Request(f"{OLLAMA}/api/generate", data=json.dumps(body).encode(),
                                     headers={"Content-Type": "application/json"})
        urllib.request.urlopen(req, timeout=60).read()
    except Exception:  # noqa: BLE001
        pass
