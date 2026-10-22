#!/usr/bin/env python3
"""A check built from the request, not the answer key: a model (or the user) writes down what the finished part
must measure, and the part `scadreport` measures is compared with it (bench/smallmodels/PROTOCOL.md, idea 1).

The spec holds only what a request states or implies and `scadreport` can measure:
  - the overall size in the print orientation (x and y in either order, z the height), including sizes that are
    sums of stated ones;
  - the number of separate pieces;
  - groups of round holes that run vertically (along z): how many, and their diameter.
A value the request leaves open is null and is not checked.

    from spec import write_spec, measure, gate
    s = write_spec("gemma4:e4b-it-q4_K_M", request_text)     # via Ollama, JSON-schema-constrained
    ok, why = gate(s, measure(scad_path))
"""
from __future__ import annotations

import json
import math
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request

ROOT = "/home/seb/printpaper"
sys.path[:0] = [os.path.join(ROOT, "tools")]
os.environ.setdefault("OPENSCAD", "/home/seb/.local/bin/openscad")
OLLAMA = os.environ.get("OLLAMA_HOST", "http://127.0.0.1:11434")
if "://" not in OLLAMA:  # as run_bench.py: the ollama CLI also accepts OLLAMA_HOST=host:port
    OLLAMA = "http://" + OLLAMA

SCHEMA = {
    "type": "object",
    "properties": {
        "size_x_mm": {"type": ["number", "null"]},
        "size_y_mm": {"type": ["number", "null"]},
        "height_z_mm": {"type": ["number", "null"]},
        "separate_pieces": {"type": ["integer", "null"]},
        "vertical_round_hole_groups": {
            "type": "array",
            "items": {"type": "object",
                      "properties": {"count": {"type": "integer"}, "diameter_mm": {"type": "number"}},
                      "required": ["count", "diameter_mm"]}},
    },
    "required": ["size_x_mm", "size_y_mm", "height_z_mm", "separate_pieces", "vertical_round_hole_groups"],
}

OUTLINE = {"anyOf": [{"type": "null"},
                      {"type": "array", "items": {"type": "number"}, "minItems": 2, "maxItems": 2}]}
SCHEMA_V3 = {"type": "object", "properties": {**SCHEMA["properties"], "bottom_size_mm": OUTLINE, "top_size_mm": OUTLINE},
             "required": SCHEMA["required"] + ["bottom_size_mm", "top_size_mm"]}

SYSTEM = """You read a request for a 3D-printed part and write down what the finished part must measure, so that a \
program can check a design against it. You do not design the part.

Answer with JSON only:
- size_x_mm, size_y_mm, height_z_mm: the overall size of the whole part as it sits on the print bed (the smallest \
box around everything). height_z_mm is the total height. If the request gives sizes of parts that are stacked or \
placed side by side, add them up. If the request does not determine a size, use null.
- separate_pieces: how many separate solid pieces the file builds (usually 1).
- vertical_round_hole_groups: the round holes or bores that run up and down (along z), grouped by diameter: how many \
holes of each diameter. Use the hole's own diameter as the request gives it. Leave out holes that run sideways, \
slots, notches and grooves. Use [] if there are none."""

SYSTEM_V2 = """You read a request for a 3D-printed part and write down what the finished part must measure, so that a \
program can check a design against it. You do not design the part.

Answer with JSON only:
- size_x_mm, size_y_mm, height_z_mm: the overall size of the whole part as it sits on the print bed. If the request \
states a total size ("120 mm long in total", "overall height 40 mm"), copy it. If a size is a plain sum of stated sizes \
along the same direction (a 10 mm base with a 15 mm block on top: height 25), add them. Otherwise - when the size \
depends on curves, angles, knuckles, ribs or anything you would have to work out - use null. A null is checked by \
nobody; a wrong number rejects a correct part.
- separate_pieces: how many separate solid pieces the file builds (usually 1).
- vertical_round_hole_groups: round holes or bores that the request says run vertically - down from the top, up from \
the bottom, or through a part lying flat on the bed - grouped by diameter. Leave out holes that run along X or Y, \
slots, notches and grooves. Use [] if there are none."""

SYSTEM_V3 = SYSTEM_V2 + """
- bottom_size_mm, top_size_mm: the outline of the whole part just above the bed and just below its highest point, \
as [x, y] in mm ([d, d] for a round outline). Give them when the request states them: a part that tapers goes from \
its bottom size to its top size; a block with a smaller block on top has the smaller block's size on top. Use null \
when that face is rounded, chamfered, pointed or domed, or when the request does not say."""

EXAMPLES = [  # from the seed families' prompt templates, never from the 16 benchmark tasks
    ("Design a rectangular plate in OpenSCAD: 80 mm by 50 mm, 4 mm thick, with a 3.4 mm through-hole 6 mm in from "
     "each corner. Reply with a single complete OpenSCAD file.",
     {"size_x_mm": 80, "size_y_mm": 50, "height_z_mm": 4, "separate_pieces": 1,
      "vertical_round_hole_groups": [{"count": 4, "diameter_mm": 3.4}]}),
    ("Design a stepped riser: a 60 x 40 mm block 10 mm tall, with a 30 x 20 mm block 15 mm tall centred on top of "
     "it. Print it as it stands.",
     {"size_x_mm": 60, "size_y_mm": 40, "height_z_mm": 25, "separate_pieces": 1,
      "vertical_round_hole_groups": []}),
]
EXAMPLES_V2 = EXAMPLES + [
    ("Design a cable hook: a 25 mm wide strip 3 mm thick bent into a J with an inner radius of 12 mm, its straight "
     "back 60 mm tall, and a 4 mm screw hole through the back 10 mm below its top.",
     {"size_x_mm": None, "size_y_mm": 25, "height_z_mm": None, "separate_pieces": 1,
      "vertical_round_hole_groups": []}),
]
_OUTLINES = [([80, 50], [80, 50]), ([60, 40], [30, 20]), (None, None)]
EXAMPLES_V3 = [(q, {**a, "bottom_size_mm": b, "top_size_mm": t}) for (q, a), (b, t) in zip(EXAMPLES_V2, _OUTLINES)]
# The examples avoid the kinds of part the 16 tasks are (racks, combs, pestles, funnels, hole-grid discs, knobs,
# sleeve adapters, barbs, clips, housings, brackets, boxes, tanks), as batch C's generator does.
VERSIONS = {"v1": (SYSTEM, EXAMPLES, SCHEMA), "v2": (SYSTEM_V2, EXAMPLES_V2, SCHEMA),
            "v3": (SYSTEM_V3, EXAMPLES_V3, SCHEMA_V3)}


def write_spec(model: str, request: str, seed: int = 1000, timeout: int = 900, version: str = "v1") -> dict:
    """Ask a local model (Ollama) for the spec; returns {'spec': dict|None, 'raw': str, 'usage': {...}}."""
    system, examples, schema = VERSIONS[version]
    msgs = [{"role": "system", "content": system}]
    for q, a in examples:
        msgs += [{"role": "user", "content": q}, {"role": "assistant", "content": json.dumps(a)}]
    msgs.append({"role": "user", "content": request})
    body = {"model": model, "messages": msgs, "stream": False, "format": schema, "think": False,
            "options": {"temperature": 0.2, "top_p": 0.95, "seed": seed, "num_ctx": 4096, "num_predict": 400}}
    req = urllib.request.Request(f"{OLLAMA}/api/chat", data=json.dumps(body).encode(),
                                 headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        d = json.load(r)
    raw = (d.get("message") or {}).get("content") or ""
    try:
        spec = json.loads(raw)
    except json.JSONDecodeError:
        spec = None
    usage = {k: d.get(k) for k in ("total_duration", "prompt_eval_count", "eval_count", "eval_duration")}
    return {"spec": spec, "raw": raw, "usage": usage}


def write_spec_claude(model: str, request: str, version: str = "v1", timeout: int = 900) -> dict:
    """The same spec from Claude through Claude Code print mode, as run_bench.py's ClaudeCLI calls it (no tools, no
    MCP, no settings): a reference writer only (PROTOCOL.md). The examples go into the system prompt; the reply's
    JSON object is parsed and must have the schema's fields."""
    system, examples, schema = VERSIONS[version]
    system += "\n\nExamples:\n" + "\n\n".join(f"Request: {q}\nJSON: {json.dumps(a)}" for q, a in examples)
    cwd = tempfile.mkdtemp(prefix="p2b_spec_")
    cmd = ["claude", "-p", "--model", model, "--system-prompt", system, "--tools", "", "--strict-mcp-config",
           "--setting-sources", "", "--output-format", "json", request]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, cwd=cwd)
        d = json.loads(p.stdout)
    finally:  # leave no Claude Code session files behind (as ClaudeCLI.close)
        shutil.rmtree(os.path.join(os.path.expanduser("~/.claude/projects"), re.sub(r"[^A-Za-z0-9]", "-", cwd)),
                      ignore_errors=True)
        shutil.rmtree(cwd, ignore_errors=True)
    if d.get("is_error"):
        raise RuntimeError(f"claude CLI error: {str(d.get('result'))[:200]}")
    raw = d.get("result") or ""
    g = re.search(r"\{.*\}", raw, re.S)
    try:
        spec = json.loads(g.group(0)) if g else None
    except json.JSONDecodeError:
        spec = None
    if not isinstance(spec, dict) or not set(schema["required"]) <= spec.keys():
        spec = None
    u = d.get("usage", {})
    return {"spec": spec, "raw": raw, "usage": {"input_tokens": u.get("input_tokens"),
                                                 "output_tokens": u.get("output_tokens"),
                                                 "api_ms": d.get("duration_api_ms")}}


MEASURE_VERSION = 3  # 2 added the outline sizes just above the bed and just below the top; 3 their region counts


def _outline(mesh, z):
    """[x, y, regions]: the size of the part's cross-section at height z and its number of separate regions, or
    None if there is none."""
    from scadreport import section
    b = [p.bounds for p in section(mesh, z)]
    if not b:
        return None
    return [round(max(v[2] for v in b) - min(v[0] for v in b), 2), round(max(v[3] for v in b) - min(v[1] for v in b), 2),
            len(b)]


def measure(path: str) -> dict | None:
    """Render a .scad file; overall size [x, y, z] as built, pieces, per horizontal slice its round holes, and the
    outline sizes 0.1 mm above the bottom and below the top."""
    from scadreport import analyse, load_mesh, render
    with tempfile.TemporaryDirectory() as d:
        stl = os.path.join(d, "p.stl")
        try:
            if not render(path, stl, timeout=120)["ok"]:
                return None
            mesh = load_mesh(stl)
            an = analyse(mesh)
            z0, z1 = float(mesh.bounds[0][2]), float(mesh.bounds[1][2])
            bottom, top = _outline(mesh, z0 + 0.1), _outline(mesh, z1 - 0.1)
        except Exception:  # noqa: BLE001
            return None
    if not an["watertight"]:
        return None
    slices = []
    for s in an["slices"]:
        round_d = [round(float(h["d"]), 2) for h in s["holes"] if h["l"] > 0 and h["w"] / h["l"] > 0.85]
        slices.append({"z": s["z"], "round_holes_d": round_d})
    return {"size": [round(float(v), 2) for v in an["size"]], "bodies": int(an["bodies"]), "slices": slices,
            "bottom": bottom, "top": top, "mv": MEASURE_VERSION}


def _near(a: float, b: float, abs_tol: float, rel_tol: float) -> bool:
    return abs(a - b) <= max(abs_tol, rel_tol * abs(b))


SIZE_ABS, SIZE_REL = 0.5, 0.02      # overall size: 0.5 mm or 2%
HOLE_ABS, HOLE_REL = 0.3, 0.05      # hole diameter: 0.3 mm or 5%


def gate(spec: dict | None, m: dict | None) -> tuple[bool, list[str]]:
    """Does the measured part m satisfy the spec? Returns (ok, reasons it fails)."""
    if m is None:
        return False, ["does not build a watertight solid"]
    if not spec:
        return True, []  # no usable spec: nothing to check beyond building a solid
    why = []
    x, y, z = spec.get("size_x_mm"), spec.get("size_y_mm"), spec.get("height_z_mm")
    mx, my, mz = m["size"]
    if z is not None and not _near(mz, z, SIZE_ABS, SIZE_REL):
        why.append(f"height {mz:g} vs {z:g}")
    want = [v for v in (x, y) if v is not None]
    if len(want) == 2:
        if not (_near(mx, want[0], SIZE_ABS, SIZE_REL) and _near(my, want[1], SIZE_ABS, SIZE_REL)) and \
           not (_near(mx, want[1], SIZE_ABS, SIZE_REL) and _near(my, want[0], SIZE_ABS, SIZE_REL)):
            why.append(f"footprint {mx:g} x {my:g} vs {want[0]:g} x {want[1]:g}")
    elif len(want) == 1 and not any(_near(v, want[0], SIZE_ABS, SIZE_REL) for v in (mx, my)):
        why.append(f"footprint {mx:g} x {my:g} lacks {want[0]:g}")
    n = spec.get("separate_pieces")
    if n is not None and m["bodies"] != n:
        why.append(f"{m['bodies']} pieces vs {n}")
    for g in spec.get("vertical_round_hole_groups") or []:
        try:
            cnt, d = int(g["count"]), float(g["diameter_mm"])
        except (KeyError, TypeError, ValueError):
            continue
        if cnt <= 0 or d <= 0:
            continue
        best = max((sum(_near(h, d, HOLE_ABS, HOLE_REL) for h in s["round_holes_d"]) for s in m["slices"]), default=0)
        if best != cnt:
            why.append(f"{best} round holes of {d:g} mm vs {cnt}")
    for field, key, label in (("bottom_size_mm", "bottom", "bottom outline"), ("top_size_mm", "top", "top outline")):
        want = spec.get(field)
        if not (isinstance(want, list) and len(want) == 2 and all(isinstance(v, (int, float)) for v in want)):
            continue
        if m.get("mv", 1) < 3:
            raise ValueError("a measurement from before MEASURE_VERSION 3 (no outline regions): measure the part again")
        got = m[key]
        a, b = float(want[0]), float(want[1])
        if got is None:
            why.append(f"no {label}")
        elif got[2] > 1:
            continue  # several regions there (ribs, posts, teeth): a request rarely gives their overall outline
        elif not ((_near(got[0], a, SIZE_ABS, SIZE_REL) and _near(got[1], b, SIZE_ABS, SIZE_REL)) or
                  (_near(got[0], b, SIZE_ABS, SIZE_REL) and _near(got[1], a, SIZE_ABS, SIZE_REL))):
            why.append(f"{label} {got[0]:g} x {got[1]:g} vs {a:g} x {b:g}")
    return not why, why


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", required=True)
    ap.add_argument("--request", required=True, help="request text, or @file")
    ap.add_argument("scad", nargs="?")
    a = ap.parse_args()
    text = open(a.request[1:]).read() if a.request.startswith("@") else a.request
    out = write_spec(a.model, text)
    print(json.dumps(out["spec"], indent=1))
    if a.scad:
        print(gate(out["spec"], measure(a.scad)))
