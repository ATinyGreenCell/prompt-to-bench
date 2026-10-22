"""Idea 4 as a run_bench backend: model name `features:<ollama model>`. The local model lists the part's features
as JSON (constrained by a schema, so it always parses); compiler.py turns them into OpenSCAD. Feedback turns ask for
a corrected list. The reply carries the compiled file in an ```openscad block, so run_bench is unchanged."""
from __future__ import annotations

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, os.path.dirname(HERE)]
import compiler as C  # noqa: E402
from common import add_usage, ollama_json, unload  # noqa: E402

NUM = {"type": "number"}
P2 = {"type": "array", "items": NUM, "minItems": 2, "maxItems": 2}
P3 = {"type": "array", "items": NUM, "minItems": 3, "maxItems": 3}
GRID = {"type": "object", "properties": {"nx": {"type": "integer"}, "ny": {"type": "integer"}, "pitch_x": NUM,
                                         "pitch_y": NUM}, "required": ["nx", "ny", "pitch_x", "pitch_y"]}
CIRCLE = {"type": "object", "properties": {"count": {"type": "integer"}, "radius": NUM, "start_deg": NUM},
          "required": ["count", "radius", "start_deg"]}
DEPTH = {"type": ["number", "null"]}


def _obj(kind_key, kind, props, req, arrays=True):
    props = {kind_key: {"type": "string", "enum": [kind]}, **props}
    if arrays:
        props |= {"grid": GRID, "circle": CIRCLE}
    return {"type": "object", "properties": props, "required": [kind_key] + req}


SOLID = {"anyOf": [
    _obj("shape", "box", {"size": P3, "at": P3}, ["size", "at"]),
    _obj("shape", "cylinder", {"d": NUM, "h": NUM, "at": P3}, ["d", "h", "at"]),
    _obj("shape", "cone", {"d_bottom": NUM, "d_top": NUM, "h": NUM, "at": P3}, ["d_bottom", "d_top", "h", "at"]),
    _obj("shape", "tube", {"d_outer": NUM, "d_inner": NUM, "h": NUM, "at": P3}, ["d_outer", "d_inner", "h", "at"]),
    _obj("shape", "revolve", {"profile": {"type": "array", "items": P2, "minItems": 3}, "at": P3}, ["profile", "at"]),
    _obj("shape", "extrude", {"outline": {"type": "array", "items": P2, "minItems": 3}, "h": NUM, "at": P3,
                              "rotate": P3}, ["outline", "h", "at"]),
]}
CUT = {"anyOf": [
    _obj("cut", "hole", {"d": NUM, "depth": DEPTH, "at": P2}, ["d", "depth", "at"]),
    _obj("cut", "d_hole", {"d": NUM, "flat": NUM, "depth": DEPTH, "at": P2}, ["d", "flat", "depth", "at"]),
    _obj("cut", "slot", {"width": NUM, "length": NUM, "depth": DEPTH, "angle": NUM, "at": P2},
         ["width", "length", "depth", "at"]),
    _obj("cut", "pocket", {"size": P2, "depth": DEPTH, "at": P2}, ["size", "depth", "at"]),
    _obj("cut", "side_hole", {"d": NUM, "axis": {"type": "string", "enum": ["x", "y"]}, "z": NUM, "at": P2},
         ["d", "axis", "z", "at"], arrays=False),
    _obj("cut", "box", {"size": P3, "at": P3}, ["size", "at"]),
    _obj("cut", "ring_groove", {"d_outer": NUM, "depth": NUM, "width": NUM, "z": NUM}, ["d_outer", "depth", "width", "z"],
         arrays=False),
    _obj("cut", "shell", {"wall": NUM, "open": {"type": "string", "enum": ["top", "bottom", "none"]}}, ["wall", "open"],
         arrays=False),
]}
SCHEMA = {"type": "object", "required": ["bodies"], "properties": {"bodies": {
    "type": "array", "minItems": 1, "items": {
        "type": "object", "required": ["solids", "cuts"],
        "properties": {"solids": {"type": "array", "items": SOLID, "minItems": 1},
                       "cuts": {"type": "array", "items": CUT}}}}}}

SYSTEM = """You describe a 3D-printed part as a list of features, in JSON, for a program that builds the OpenSCAD \
file. Millimetres. z is up; the part stands on z = 0 in the print orientation the request gives, centred on x = 0, \
y = 0 unless told otherwise.

A part has one or more bodies (separate pieces). A body is a union of solids minus cuts.
Solids (each "at" is where its bottom centre sits):
  box {size [x, y, z]}, cylinder {d, h}, cone {d_bottom, d_top, h}, tube {d_outer, d_inner, h},
  revolve {profile [[r, z], ...]} (a closed outline turned about the z axis),
  extrude {outline [[x, y], ...], h} (a closed outline raised along z; "rotate" [rx, ry, rz] turns it first).
Cuts (each "at" is [x, y]; depth is measured down from the top of the body, null = right through):
  hole {d, depth}, d_hole {d, flat, depth} (a hole with one flat side), slot {width, length, depth, angle},
  pocket {size [x, y], depth}, side_hole {d, axis "x" or "y", z} (straight through sideways),
  box {size [x, y, z], at [x, y, z]} (any box-shaped cut; at = its bottom centre),
  ring_groove {d_outer, depth, width, z} (a groove around a round body), shell {wall, open "top"/"bottom"/"none"}.
Any solid or cut except side_hole, ring_groove and shell can be repeated:
  "grid" {nx, ny, pitch_x, pitch_y} - copies in rows and columns centred on "at";
  "circle" {count, radius, start_deg} - copies evenly around "at", each turned to face outward.
Use the request's numbers exactly. Answer with JSON only."""

EXAMPLES = [  # batch-C kinds of part (ribbed panel, dial ring), never the 16 benchmark tasks
    ("Design a ribbed panel: a flat plate 100 mm long (X), 60 mm wide (Y) and 3 mm thick, with 5 straight ribs on "
     "top running along X, each 2 mm wide and 8 mm tall, spaced 12 mm apart and centred on the plate.",
     {"bodies": [{"solids": [{"shape": "box", "size": [100, 60, 3], "at": [0, 0, 0]},
                             {"shape": "box", "size": [100, 2, 8], "at": [0, 0, 3],
                              "grid": {"nx": 1, "ny": 5, "pitch_x": 0, "pitch_y": 12}}], "cuts": []}]}),
    ("Design a dial ring: a ring 40 mm across the outside and 30 mm across the inside, 6 mm tall, with 24 notches "
     "around its outer edge, each 1.5 mm wide and 1 mm deep, running the full height.",
     {"bodies": [{"solids": [{"shape": "tube", "d_outer": 40, "d_inner": 30, "h": 6, "at": [0, 0, 0]}],
                  "cuts": [{"cut": "box", "size": [2, 1.5, 8], "at": [0, 0, -1],
                            "circle": {"count": 24, "radius": 20, "start_deg": 0}}]}]}),
]


class FeaturesBackend:
    def __init__(self, model, temperature, seed, num_ctx=8192, think=False):
        self.model, self.think = model, False
        self.opts = {"temperature": temperature, "top_p": 0.95, "seed": seed, "num_ctx": num_ctx, "num_predict": 1500}
        self.msgs = None
        self.part = None

    def chat(self, system, user):
        usage = {}
        if self.msgs is None:
            self.msgs = [{"role": "system", "content": SYSTEM}]
            for q, a in EXAMPLES:
                self.msgs += [{"role": "user", "content": q}, {"role": "assistant", "content": json.dumps(a)}]
            self.msgs.append({"role": "user", "content": user})
        else:
            self.msgs.append({"role": "user", "content": "The part built from that list was checked. "
                                                         f"{user}\n\nGive the corrected feature list as JSON."})
        out, raw, u = ollama_json(self.model, self.msgs, SCHEMA, self.opts)
        add_usage(usage, u)
        self.msgs.append({"role": "assistant", "content": raw})
        self.part = out if isinstance(out, dict) else {"bodies": []}
        scad = C.compile_part(self.part)
        text = f"Features: {json.dumps(self.part)}\n\n```openscad\n{scad}```\n"
        usage.update({"thinking_chars": 0, "done_reason": "stop"})
        return text, usage

    def close(self):
        unload(self.model)
