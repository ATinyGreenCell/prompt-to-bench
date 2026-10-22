"""Backends for run_bench.py that put a local model inside a method (bench/smallmodels/PROTOCOL.md): the model
name is `<method>:<ollama model>`, e.g. `template:gemma4:e4b-it-q4_K_M`."""
from __future__ import annotations

import http.client
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
METHODS = ("template", "features")


def split(name: str) -> tuple[str | None, str]:
    """('template', 'gemma4:e4b-it-q4_K_M') for a method model name, (None, name) otherwise."""
    head, _, rest = name.partition(":")
    return (head, rest) if head in METHODS and rest else (None, name)


def make(name: str, temperature: float, seed: int, num_ctx: int = 8192, think: bool = False, infra_error=None):
    method, inner = split(name)
    if method == "template":
        sys.path.insert(0, os.path.join(HERE, "templates"))
        from backend import TemplateBackend
        b = TemplateBackend(inner, temperature, seed, num_ctx=num_ctx, think=think)
    elif method == "features":
        sys.path.insert(0, os.path.join(HERE, "features"))
        from fbackend import FeaturesBackend
        b = FeaturesBackend(inner, temperature, seed, num_ctx=num_ctx, think=think)
    else:
        raise ValueError(f"not a method model name: {name}")
    return guard(b, infra_error) if infra_error else b


def guard(backend, infra_error):
    """A runtime failure (Ollama down or answering with an error, a timeout) raises the harness's InfraError, as its
    own Ollama backend does: the conversation is redone later and never scored."""
    chat = backend.chat

    def guarded(system, user):
        try:
            return chat(system, user)
        except (OSError, RuntimeError, http.client.HTTPException) as e:  # URLError and timeouts are OSErrors
            raise infra_error(f"{type(e).__name__}: {e}") from e
    backend.chat = guarded
    return backend
