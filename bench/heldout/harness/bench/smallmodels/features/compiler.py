#!/usr/bin/env python3
"""Idea 4 (bench/smallmodels/PROTOCOL.md): a part as a list of features, compiled to OpenSCAD by fixed code.

The feature set was drawn from the fine-tuning data engine's 34 seed families and batch C's 14 families (trays,
boxes, knobs, funnels, bushings, brackets, gears, wheels, nuts, risers, scoops, panels ...), not from the 16
benchmark tasks; its author (Claude) knows those tasks, which the paper states as a limitation.

A part is JSON:
  {"bodies": [BODY, ...]}            separate solid pieces (most parts have one)
  BODY = {"solids": [SOLID, ...],    unioned
          "cuts":   [CUT, ...]}      subtracted from this body
  SOLID  one of
    {"shape": "box",      "size": [x, y, z]}
    {"shape": "cylinder", "d": d, "h": h}
    {"shape": "cone",     "d_bottom": d1, "d_top": d2, "h": h}
    {"shape": "tube",     "d_outer": D, "d_inner": d, "h": h}
    {"shape": "revolve",  "profile": [[r, z], ...]}          closed outline in the r-z half plane, turned about z
    {"shape": "extrude",  "outline": [[x, y], ...], "h": h}  closed outline in x-y, raised along z
    each with "at": [x, y, z] - where its bottom centre sits (outline shapes: their own origin) - an optional
    "rotate": [rx, ry, rz] in degrees, applied about its own origin before moving it, and an optional array
    ("grid" or "circle", as for cuts) that places copies of it.
  CUT    one of
    {"cut": "hole",      "d": d, "depth": t | null}          round hole down from the top of the body (null: through)
    {"cut": "d_hole",    "d": d, "flat": f, "depth": t|null} round hole with one flat side f mm deep
    {"cut": "slot",      "width": w, "length": l, "depth": t|null, "angle": a}   rounded-end slot, long along x
    {"cut": "pocket",    "size": [x, y], "depth": t | null}  rectangular pocket down from the top
    {"cut": "side_hole", "d": d, "axis": "x" | "y", "z": z}  round hole straight through the body sideways
    {"cut": "box",       "size": [x, y, z]}                  any box-shaped cut (notches, openings, recesses)
    {"cut": "ring_groove", "d_outer": D, "depth": t, "width": w, "z": z}   a groove around a round body
    {"cut": "shell",     "wall": t, "open": "top" | "bottom" | "none"}     hollow the body
    with "at": [x, y] (or [x, y, z] for "box" cuts: their bottom centre) and an optional array:
    "grid":   {"nx": n, "ny": m, "pitch_x": px, "pitch_y": py}   copies centred on "at"
    "circle": {"count": n, "radius": r, "start_deg": a}           copies around "at", each turned to face out
Depths are measured from the top of the body; the body's top is the highest point of its solids.
"""
from __future__ import annotations

import json
import math

EPS = 0.01


def _num(v, default=0.0):
    try:
        return float(v)
    except (TypeError, ValueError):
        return default


def _vec(v, n, default=0.0):
    v = list(v) if isinstance(v, (list, tuple)) else []
    return [_num(v[i], default) if i < len(v) else default for i in range(n)]


def _f(x: float) -> str:
    return f"{x:.4f}".rstrip("0").rstrip(".") if x != int(x) else str(int(x))


def _pts(pts) -> str:
    return "[" + ", ".join(f"[{_f(_num(p[0]))}, {_f(_num(p[1]))}]" for p in pts if isinstance(p, (list, tuple)) and len(p) >= 2) + "]"


def solid_scad(s: dict) -> tuple[str, float]:
    """(OpenSCAD for one solid, its top z)."""
    at = _vec(s.get("at"), 3)
    rot = _vec(s.get("rotate"), 3)
    shape = s.get("shape")
    if shape == "box":
        x, y, z = _vec(s.get("size"), 3, 1.0)
        body, top = f"translate([{_f(-x / 2)}, {_f(-y / 2)}, 0]) cube([{_f(x)}, {_f(y)}, {_f(z)}]);", z
    elif shape == "cylinder":
        d, h = _num(s.get("d"), 1), _num(s.get("h"), 1)
        body, top = f"cylinder(d = {_f(d)}, h = {_f(h)});", h
    elif shape == "cone":
        d1, d2, h = _num(s.get("d_bottom"), 1), _num(s.get("d_top"), 0), _num(s.get("h"), 1)
        body, top = f"cylinder(d1 = {_f(d1)}, d2 = {_f(d2)}, h = {_f(h)});", h
    elif shape == "tube":
        D, d, h = _num(s.get("d_outer"), 2), _num(s.get("d_inner"), 1), _num(s.get("h"), 1)
        body = (f"difference() {{ cylinder(d = {_f(D)}, h = {_f(h)}); "
                f"translate([0, 0, -{EPS}]) cylinder(d = {_f(min(d, D - 0.2))}, h = {_f(h + 2 * EPS)}); }}")
        top = h
    elif shape == "revolve":
        prof = [p for p in (s.get("profile") or []) if isinstance(p, (list, tuple)) and len(p) >= 2]
        prof = [[max(0.0, _num(p[0])), _num(p[1])] for p in prof]
        if len(prof) < 3:
            return "", 0.0
        body, top = f"rotate_extrude() polygon({_pts(prof)});", max(p[1] for p in prof)
        if min(p[0] for p in prof) == 0:  # points on the axis: the exported mesh is not watertight unless a 3D
            # boolean merges them, so intersect with a box around everything (the shape is unchanged)
            body = f"intersection() {{ {body[:-1]}; translate([-1e4, -1e4, -1e4]) cube(2e4); }}"
    elif shape == "extrude":
        out = [p for p in (s.get("outline") or []) if isinstance(p, (list, tuple)) and len(p) >= 2]
        h = _num(s.get("h"), 1)
        if len(out) < 3:
            return "", 0.0
        body, top = f"linear_extrude(height = {_f(h)}) polygon({_pts(out)});", h
    else:
        return "", 0.0
    if any(rot):
        body = f"rotate([{_f(rot[0])}, {_f(rot[1])}, {_f(rot[2])}]) {body}"
        top = None  # unknown after a rotation; the caller measures the body's top another way
    if isinstance(s.get("grid"), dict) or isinstance(s.get("circle"), dict):  # copies of the solid
        cps = copies({**s, "at": at[:2]})
        body = " ".join(f"translate([{_f(x)}, {_f(y)}, {_f(at[2])}]) rotate([0, 0, {_f(a)}]) {body}" for x, y, a in cps)
        return body, (None if top is None else at[2] + top)
    return f"translate([{_f(at[0])}, {_f(at[1])}, {_f(at[2])}]) {body}", (None if top is None else at[2] + top)


def copies(c: dict) -> list[tuple[float, float, float]]:
    """(x, y, angle) of every copy of a cut, from its "at" and optional grid / circle array."""
    x0, y0 = _vec(c.get("at"), 2)
    g, ci = c.get("grid"), c.get("circle")
    if isinstance(g, dict):
        nx, ny = max(1, int(_num(g.get("nx"), 1))), max(1, int(_num(g.get("ny"), 1)))
        px, py = _num(g.get("pitch_x")), _num(g.get("pitch_y"))
        return [(x0 + (i - (nx - 1) / 2) * px, y0 + (j - (ny - 1) / 2) * py, 0.0) for j in range(ny) for i in range(nx)]
    if isinstance(ci, dict):
        n, r, a0 = max(1, int(_num(ci.get("count"), 1))), _num(ci.get("radius")), _num(ci.get("start_deg"))
        return [(x0 + r * math.cos(math.radians(a0 + 360 * k / n)), y0 + r * math.sin(math.radians(a0 + 360 * k / n)),
                 a0 + 360 * k / n) for k in range(n)]
    return [(x0, y0, 0.0)]


def cut_scad(c: dict, top: float, height: float) -> str:
    kind = c.get("cut")
    depth = c.get("depth")
    through = depth is None
    t = height + 2 if through else _num(depth, 1)
    z0 = top - t if not through else -1
    out = []
    for x, y, ang in copies(c):
        a = ang + _num(c.get("angle"))
        if kind == "hole":
            d = _num(c.get("d"), 1)
            geo = f"cylinder(d = {_f(d)}, h = {_f(t + EPS * 2 if not through else t)});"
        elif kind == "d_hole":
            d, fl = _num(c.get("d"), 1), _num(c.get("flat"), 0)
            hh = t + EPS * 2 if not through else t
            geo = (f"difference() {{ cylinder(d = {_f(d)}, h = {_f(hh)}); "
                   f"translate([{_f(d / 2 - fl)}, -{_f(d)}, -1]) cube([{_f(d)}, {_f(2 * d)}, {_f(hh + 2)}]); }}")
        elif kind == "slot":
            w, ln = _num(c.get("width"), 1), _num(c.get("length"), 2)
            hh = t + EPS * 2 if not through else t
            geo = (f"hull() {{ for (s = [-1, 1]) translate([s * {_f(max(0.0, (ln - w) / 2))}, 0, 0]) "
                   f"cylinder(d = {_f(w)}, h = {_f(hh)}); }}")
        elif kind == "pocket":
            px, py = _vec(c.get("size"), 2, 1.0)
            hh = t + EPS * 2 if not through else t
            geo = f"translate([{_f(-px / 2)}, {_f(-py / 2)}, 0]) cube([{_f(px)}, {_f(py)}, {_f(hh)}]);"
        elif kind == "side_hole":
            d, z = _num(c.get("d"), 1), _num(c.get("z"))
            L = 4 * max(height, 1) + 1000
            rot = "rotate([0, 90, 0])" if c.get("axis", "x") == "x" else "rotate([90, 0, 0])"
            out.append(f"translate([{_f(x)}, {_f(y)}, {_f(z)}]) rotate([0, 0, {_f(a)}]) {rot} "
                       f"cylinder(d = {_f(d)}, h = {_f(L)}, center = true);")
            continue
        elif kind == "box":
            bx, by, bz = _vec(c.get("size"), 3, 1.0)
            zz = _vec(c.get("at"), 3)[2]
            out.append(f"translate([{_f(x)}, {_f(y)}, {_f(zz)}]) rotate([0, 0, {_f(a)}]) "
                       f"translate([{_f(-bx / 2)}, {_f(-by / 2)}, 0]) cube([{_f(bx)}, {_f(by)}, {_f(bz)}]);")
            continue
        elif kind == "ring_groove":
            D, dep, w, z = _num(c.get("d_outer"), 2), _num(c.get("depth"), 0.5), _num(c.get("width"), 1), _num(c.get("z"))
            out.append(f"translate([{_f(x)}, {_f(y)}, {_f(z - w / 2)}]) difference() {{ "
                       f"cylinder(d = {_f(D + 2)}, h = {_f(w)}); translate([0, 0, -1]) "
                       f"cylinder(d = {_f(max(0.1, D - 2 * dep))}, h = {_f(w + 2)}); }}")
            continue
        else:
            continue
        zstart = z0 - (EPS if not through else 0)
        out.append(f"translate([{_f(x)}, {_f(y)}, {_f(zstart)}]) rotate([0, 0, {_f(a)}]) {geo}")
    return "\n    ".join(out)


def body_scad(b: dict) -> str:
    solids = [solid_scad(s) for s in (b.get("solids") or []) if isinstance(s, dict)]
    solids = [(code, top) for code, top in solids if code]
    if not solids:
        return ""
    tops = [t for _, t in solids if t is not None]
    top = max(tops) if tops else 0.0
    height = top - min(_vec(s.get("at"), 3)[2] for s in b["solids"] if isinstance(s, dict)) if tops else 1000.0
    union = "union() {\n    " + "\n    ".join(c for c, _ in solids) + "\n  }"
    cuts = [c for c in (b.get("cuts") or []) if isinstance(c, dict)]
    shells = [c for c in cuts if c.get("cut") == "shell"]
    others = [c for c in cuts if c.get("cut") != "shell"]
    part = union
    first = next((s for s in b["solids"] if isinstance(s, dict) and s.get("shape") in ("box", "cylinder", "cone")), None)
    for sh in shells:  # hollow the body's first box, cylinder or cone, keeping a wall; open top, bottom or closed
        if first is None:
            continue
        w, side = _num(sh.get("wall"), 1), sh.get("open", "top")
        ax, ay, az = _vec(first.get("at"), 3)
        z_lo = az - 1 if side == "bottom" else az + w
        z_hi = top + 1 if side == "top" else top - w
        if z_hi <= z_lo:
            continue
        if first["shape"] == "box":
            x, y, _ = _vec(first.get("size"), 3, 1.0)
            inner = (f"translate([{_f(ax - x / 2 + w)}, {_f(ay - y / 2 + w)}, {_f(z_lo)}]) "
                     f"cube([{_f(x - 2 * w)}, {_f(y - 2 * w)}, {_f(z_hi - z_lo)}]);")
        elif first["shape"] == "cylinder":
            inner = (f"translate([{_f(ax)}, {_f(ay)}, {_f(z_lo)}]) "
                     f"cylinder(d = {_f(_num(first.get('d'), 1) - 2 * w)}, h = {_f(z_hi - z_lo)});")
        else:
            d1, d2 = _num(first.get("d_bottom"), 1) - 2 * w, _num(first.get("d_top"), 0) - 2 * w
            inner = (f"translate([{_f(ax)}, {_f(ay)}, {_f(z_lo)}]) "
                     f"cylinder(d1 = {_f(max(0.1, d1))}, d2 = {_f(max(0.1, d2))}, h = {_f(z_hi - z_lo)});")
        part = f"difference() {{\n  {part}\n  {inner}  // shell, wall {_f(w)}, open {side}\n}}"
    if others:
        part = (f"difference() {{\n  {part}\n  union() {{\n    "
                + "\n    ".join(cut_scad(c, top, height) for c in others) + "\n  }\n}")
    return part


HEADER = "// Built by bench/smallmodels/features/compiler.py from a list of features.\n$fn = 64;\n"


def compile_part(spec: dict) -> str:
    bodies = [body_scad(b) for b in (spec.get("bodies") or []) if isinstance(b, dict)]
    bodies = [b for b in bodies if b]
    return HEADER + "\n".join(bodies) + "\n"


if __name__ == "__main__":
    import sys
    print(compile_part(json.load(open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin)))
