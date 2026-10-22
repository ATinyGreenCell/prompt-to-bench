"""Idea 3 as a run_bench backend: model name `template:<ollama model>`. The local model never writes OpenSCAD.
It picks a parametric design from the seed library (or "none") and sets its parameters as JSON; the file is built
from the design. Feedback turns ask for corrected parameters. The reply carries the built file in an ```openscad
block, so run_bench's extraction, rendering, checks, feedback and records are unchanged."""
from __future__ import annotations

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, os.path.dirname(HERE)]
import library as L  # noqa: E402
from common import add_usage, ollama_json, unload  # noqa: E402

CHOOSE = ("You match a request for a 3D-printed part to a library of parametric OpenSCAD designs. Pick the one "
          "design that builds the requested part once its numbers are set, or \"none\" if no design builds it - a "
          "different kind of part, or one with features the design lacks. Answer with JSON only.")
FILL = ("You set the parameters of a parametric OpenSCAD design so that it builds the requested part. Take every "
        "number from the request; where the request does not give a parameter, choose a sensible value within its "
        "range. Answer with JSON only: one number for every parameter.")
NONE_REPLY = "No design in the template library builds this part, so there is no file."


class TemplateBackend:
    def __init__(self, model, temperature, seed, num_ctx=8192, think=False):
        self.model, self.think = model, False
        self.opts = {"temperature": temperature, "top_p": 0.95, "seed": seed, "num_ctx": num_ctx, "num_predict": 600}
        self.lib = L.load()
        self.request = self.family = self.values = None

    def _choose(self, usage):
        names = list(self.lib)
        schema = {"type": "object", "properties": {"design": {"type": "string", "enum": names + ["none"]}},
                  "required": ["design"]}
        msgs = [{"role": "system", "content": CHOOSE},
                {"role": "user", "content": f"Library:\n{L.catalog_text(self.lib)}\n\nRequest:\n{self.request}"}]
        out, _, u = ollama_json(self.model, msgs, schema, self.opts)
        add_usage(usage, u)
        d = (out or {}).get("design")
        return d if d in self.lib else None

    def _fill(self, usage, feedback=None):
        fam = self.lib[self.family]
        schema = {"type": "object", "required": [p["name"] for p in fam["params"]],
                  "properties": {p["name"]: {"type": "integer" if p["integer"] else "number"} for p in fam["params"]}}
        plist = "\n".join(f"- {p['name']}: {p['meaning']}, from {p['lo']:g} to {p['hi']:g}"
                          + (", a whole number" if p["integer"] else "") for p in fam["params"])
        msgs = [{"role": "system", "content": FILL},
                {"role": "user", "content": f"Design {fam['name']}: {fam['desc']}.\nHow its parameters appear in a "
                                            f"request: {fam['prompt']}\nParameters:\n{plist}\n\nRequest:\n{self.request}"}]
        if feedback is not None:
            msgs += [{"role": "assistant", "content": json.dumps(self.values)},
                     {"role": "user", "content": "The part built with those parameters was checked. "
                                                 f"{feedback}\n\nGive corrected parameters as JSON."}]
        out, _, u = ollama_json(self.model, msgs, schema, self.opts)
        add_usage(usage, u)
        return L.clamp(fam, out or {})

    def chat(self, system, user):
        usage = {}
        if self.request is None:
            self.request = user
            self.family = self._choose(usage)
            if self.family is not None:
                self.values = self._fill(usage)
        elif self.family is not None:
            self.values = self._fill(usage, feedback=user)
        if self.family is None:
            text = NONE_REPLY
        else:
            scad = L.build(self.lib[self.family], self.values)
            text = (f"Design: {self.family}\nParameters: {json.dumps(self.values)}\n\n```openscad\n{scad}\n```\n")
        usage.update({"thinking_chars": 0, "done_reason": "stop", "template": self.family, "params": self.values})
        return text, usage

    def close(self):
        unload(self.model)
