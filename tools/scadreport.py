#!/usr/bin/env python3
"""scadreport - render an OpenSCAD file and describe the solid it produces.

    python tools/scadreport.py part.scad              # plain-text report
    python tools/scadreport.py part.scad --z 3 12.5   # add slices at these heights (mm)
    python tools/scadreport.py part.scad --json       # machine-readable

The report says what OpenSCAD actually built: errors and warnings, whether the
result is a single printable (watertight) solid, its bounding box and volume,
how it sits on the print bed, and horizontal slices listing every hole with
its size and grid spacing. Paste the report back into your LLM chat so the
model can compare what it made with what you asked for -- that is the single
most useful thing you can do to help a small model fix its own mistakes.

Requirements: OpenSCAD on PATH (or set $OPENSCAD) and the Python packages
trimesh, shapely, networkx, numpy (pip install trimesh shapely networkx numpy).
"""
import argparse
import json
import math
import os
import re
import subprocess
import sys
import tempfile
import time

import numpy as np
import shapely
import trimesh

OPENSCAD = os.environ.get("OPENSCAD", "openscad")
PLA_DENSITY = 1.24  # g/cm^3
MSG_RE = re.compile(r"^\s*(ERROR|WARNING|DEPRECATED|TRACE)\b|top level object|not a 3D object")


# --------------------------------------------------------------------------- render

def render(scad_path, out_path, defines=(), timeout=180):
    """Run OpenSCAD headless. Returns dict(ok, returncode, messages, log, seconds)."""
    cmd = [OPENSCAD, "-o", os.path.abspath(out_path)]
    if out_path.endswith(".stl"):
        cmd += ["--export-format", "binstl"]
    for d in defines:
        cmd += ["-D", d]
    cmd.append(os.path.basename(scad_path))
    t0 = time.time()
    try:  # run next to the file so messages show only its name
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout,
                           cwd=os.path.dirname(os.path.abspath(scad_path)))
        log, rc = (p.stdout or "") + (p.stderr or ""), p.returncode
    except subprocess.TimeoutExpired:
        log, rc = f"ERROR: OpenSCAD timed out after {timeout} s (simplify the model, avoid minkowski)", -1
    name = os.path.basename(scad_path)
    for p_ in (os.path.abspath(scad_path), os.path.relpath(scad_path), scad_path):
        log = log.replace(p_, name)
    msgs = []
    for line in log.splitlines():
        if MSG_RE.search(line) and line.strip() not in msgs:
            msgs.append(line.strip())
    ok = rc == 0 and os.path.exists(out_path) and os.path.getsize(out_path) > 84
    return {"ok": ok, "returncode": rc, "messages": msgs[:20], "log": log[-4000:],
            "seconds": round(time.time() - t0, 2)}


def load_mesh(path):
    m = trimesh.load(path, force="mesh")
    if not isinstance(m, trimesh.Trimesh) or len(m.faces) == 0:
        raise ValueError("empty mesh")
    return m


# --------------------------------------------------------------------------- slicing

def section(mesh, z):
    """Material cross-section of `mesh` at height z as a list of shapely Polygons (with holes)."""
    try:
        s = mesh.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
    except Exception:
        return []
    if s is None:
        return []
    T = np.eye(4)
    T[2, 3] = -z
    try:
        p2, _ = s.to_2D(to_2D=T)
        return [p for p in p2.polygons_full if p.area > 1e-6]
    except Exception:
        return []


def shape_info(poly):
    """Classify a hole/outline polygon (no interiors) as circle / rect / other with sizes."""
    a = poly.area
    mrr = poly.minimum_rotated_rectangle
    xs, ys = mrr.exterior.coords.xy
    e = sorted(math.dist((xs[i], ys[i]), (xs[i + 1], ys[i + 1])) for i in range(2))
    w, l = e
    fill = a / (w * l) if w * l > 0 else 0.0
    c = poly.centroid
    d = 2 * math.sqrt(a / math.pi)
    if l > 0 and w / l > 0.92 and 0.74 < fill < 0.83:
        kind = "circle"
    elif fill > 0.97:
        kind = "rect"
    else:
        kind = "other"
    return {"kind": kind, "area": a, "d": d, "w": w, "l": l, "cx": c.x, "cy": c.y,
            "minx": poly.bounds[0], "miny": poly.bounds[1], "maxx": poly.bounds[2], "maxy": poly.bounds[3]}


def slice_info(mesh, z):
    polys = section(mesh, z)
    islands, holes = [], []
    for p in polys:
        outline = shapely.Polygon(p.exterior)
        info = shape_info(outline)
        info["material_area"] = p.area
        info["n_holes"] = len(p.interiors)
        islands.append(info)
        for ring in p.interiors:
            holes.append(shape_info(shapely.Polygon(ring)))
    return {"z": z, "islands": islands, "holes": holes,
            "material_area": sum(i["material_area"] for i in islands)}


def _cluster(vals, tol=0.3):
    vals = sorted(vals)
    groups = [[vals[0]]]
    for v in vals[1:]:
        if v - groups[-1][-1] <= tol:
            groups[-1].append(v)
        else:
            groups.append([v])
    return [sum(g) / len(g) for g in groups]


def _pitch(vals):
    if len(vals) < 2:
        return "-"
    d = np.diff(vals)
    return f"{d.mean():.2f}" if d.max() - d.min() < 0.05 else f"{d.min():.2f}-{d.max():.2f}"


def grid_text(holes):
    """Describe hole centres as a regular grid when they form one."""
    if len(holes) < 2:
        h = holes[0]
        return f"centre ({h['cx']:.2f}, {h['cy']:.2f})"
    xs = _cluster([h["cx"] for h in holes])
    ys = _cluster([h["cy"] for h in holes])
    cx = np.mean([h["cx"] for h in holes])
    cy = np.mean([h["cy"] for h in holes])
    if len(xs) * len(ys) == len(holes):
        return (f"{len(xs)} x {len(ys)} grid (X x Y), pitch X {_pitch(xs)} / Y {_pitch(ys)}, "
                f"grid centre ({cx:.2f}, {cy:.2f})")
    pts = ", ".join(f"({h['cx']:.1f}, {h['cy']:.1f})" for h in holes[:12])
    more = " ..." if len(holes) > 12 else ""
    return f"centres {pts}{more}"


def _shape_text(s):
    if s["kind"] == "circle":
        return f"circle d={s['d']:.2f}"
    if s["kind"] == "rect":
        return f"rectangle {s['l']:.2f} x {s['w']:.2f}"
    return f"shape {s['maxx'] - s['minx']:.2f} x {s['maxy'] - s['miny']:.2f} (area {s['area']:.1f} mm2)"


def describe_holes(holes):
    groups = {}
    for h in holes:
        key = (h["kind"], round(h["d"], 1)) if h["kind"] == "circle" else (h["kind"], round(h["l"], 1), round(h["w"], 1))
        groups.setdefault(key, []).append(h)
    parts = []
    for hs in sorted(groups.values(), key=lambda g: -len(g)):
        parts.append(f"{len(hs)} x {_shape_text(hs[0])} [{grid_text(hs)}]")
    return "; ".join(parts)


# --------------------------------------------------------------------------- report

def analyse(mesh, extra_z=()):
    b = mesh.bounds
    zmin, zmax = b[0][2], b[1][2]
    h = zmax - zmin
    bodies = mesh.split(only_watertight=False)
    data = {
        "bounds": b.tolist(),
        "size": (b[1] - b[0]).tolist(),
        "watertight": bool(mesh.is_watertight),
        "bodies": len(bodies),
        "body_sizes": [(bb.bounds[1] - bb.bounds[0]).round(2).tolist() for bb in bodies[:6]],
        "volume": float(mesh.volume) if mesh.is_watertight else None,
        "faces": int(len(mesh.faces)),
    }
    # bed contact and overhangs (FDM printability hints)
    contact = slice_info(mesh, zmin + min(0.05, h / 4))
    data["bed_contact_area"] = contact["material_area"]
    n, a, c = mesh.face_normals, mesh.area_faces, mesh.triangles_center
    over = (n[:, 2] < -math.cos(math.radians(45))) & (c[:, 2] > zmin + 0.2)
    flat = over & (n[:, 2] < -0.999)
    data["overhang_area"] = float(a[over].sum())
    data["flat_overhang_area"] = float(a[flat].sum())
    data["overhang_z"] = sorted({round(float(z), 2) for z in c[flat][:, 2]})[:8]
    # horizontal slices: one through the middle of every distinct "layer" of the design
    # (between consecutive vertex heights), keeping the 8 thickest layers
    levels = np.unique(np.round(mesh.vertices[:, 2], 2))
    layers = [(b - a, (a + b) / 2) for a, b in zip(levels[:-1], levels[1:]) if b - a >= 0.4]
    zs = [z for _, z in sorted(layers, reverse=True)[:8]] or [zmin + h / 2]
    for z in (zmin + 0.05 * h, zmin + 0.95 * h):  # always show near-bottom and near-top
        if all(abs(z - q) > 0.75 for q in zs):
            zs.append(z)
    zs += [zmin + float(z) for z in extra_z]
    data["slices"] = [slice_info(mesh, z + 0.0137) for z in sorted(set(round(z, 3) for z in zs))]
    for s in data["slices"]:
        s["z"] = round(s["z"] - zmin - 0.0137, 2)
    return data


def format_report(r, data=None):
    out = []
    if r["ok"]:
        w = [m for m in r["messages"] if m.startswith("WARNING")]
        out.append(f"OPENSCAD: rendered OK in {r['seconds']:.1f} s, " + (f"{len(w)} warning(s):" if w else "no warnings."))
        out += [f"  {m}" for m in r["messages"]]
    else:
        out.append("OPENSCAD: FAILED - no printable geometry was produced.")
        out += [f"  {m}" for m in r["messages"]] or [f"  {r['log'][-600:]}"]
        return "\n".join(out)
    if data is None:
        return "\n".join(out)
    (x0, y0, z0), (x1, y1, z1) = data["bounds"]
    wt = "watertight (valid solid)" if data["watertight"] else "NOT watertight (broken surface - check for zero-thickness walls or self-intersections)"
    vol = f"volume {data['volume']:,.0f} mm3 (~{data['volume'] / 1000 * PLA_DENSITY:.0f} g of PLA if printed solid)" if data["volume"] else "volume unknown"
    out.append(f"SOLID: {data['bodies']} separate bod{'y' if data['bodies'] == 1 else 'ies'}, {wt}; {vol}.")
    if 1 < data["bodies"] <= 6:
        out.append("  body sizes (X x Y x Z): " + "; ".join(" x ".join(f"{v:.2f}" for v in s) for s in data["body_sizes"]))
    out.append(f"BOUNDING BOX: X {x0:.2f} .. {x1:.2f} (size {x1 - x0:.2f}) | Y {y0:.2f} .. {y1:.2f} (size {y1 - y0:.2f}) | "
               f"Z {z0:.2f} .. {z1:.2f} (size {z1 - z0:.2f}) mm")
    bed = f"lowest point at z = {z0:.2f}; contact area with the bed {data['bed_contact_area']:,.0f} mm2"
    if abs(z0) > 0.01:
        bed += " (note: the part does not start at z = 0)"
    out.append(f"BED: {bed}.")
    if data["overhang_area"] > 1:
        extra = f"; flat downward-facing areas at z = {', '.join(str(z) for z in data['overhang_z'])}" if data["overhang_z"] else ""
        out.append(f"OVERHANGS: {data['overhang_area']:,.0f} mm2 of surface faces downward steeper than 45 deg{extra} (may need supports/bridging).")
    else:
        out.append("OVERHANGS: none steeper than 45 deg - prints without supports.")
    out.append("HORIZONTAL SLICES (cut through the part at height z above its lowest point):")
    for s in data["slices"]:
        isl = s["islands"]
        if not isl:
            out.append(f"  z={s['z']:.2f}: empty")
            continue
        if len(isl) <= 4:
            outl = "; ".join((f"circle d={i['l']:.2f}" if i["kind"] == "circle" else _shape_text(i))
                             + f" centred ({i['cx']:.2f}, {i['cy']:.2f})" for i in isl)
        else:
            outl = f"{len(isl)} pieces, e.g. " + _shape_text(isl[0])
        line = f"  z={s['z']:.2f}: {len(isl)} solid region{'s' if len(isl) != 1 else ''} [outline: {outl}]"
        line += f"; {len(s['holes'])} hole{'s' if len(s['holes']) != 1 else ''}" + (f": {describe_holes(s['holes'])}" if s["holes"] else "")
        line += f"; material area {s['material_area']:,.1f} mm2"
        out.append(line)
    return "\n".join(out)


def report(scad_path, extra_z=(), defines=(), stl_out=None, timeout=180):
    """Render + analyse. Returns (text, data dict, mesh or None)."""
    tmpdir = None
    if stl_out is None:
        tmpdir = tempfile.mkdtemp(prefix="scadreport_")
        stl_out = os.path.join(tmpdir, "part.stl")
    r = render(scad_path, stl_out, defines, timeout)
    data, mesh = None, None
    if r["ok"]:
        try:
            mesh = load_mesh(stl_out)
            data = analyse(mesh, extra_z)
        except Exception as e:  # noqa: BLE001
            r["ok"] = False
            r["messages"].append(f"ERROR: could not read the exported mesh ({e})")
    return format_report(r, data), {"render": r, "geometry": data}, mesh


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("scad")
    ap.add_argument("--z", type=float, nargs="*", default=[], help="extra slice heights (mm above lowest point)")
    ap.add_argument("-D", action="append", default=[], help="OpenSCAD variable override, e.g. -D pitch=18")
    ap.add_argument("--stl", help="also keep the exported STL here")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    text, data, _ = report(a.scad, a.z, a.D, a.stl)
    if a.json:
        print(json.dumps(data, indent=1, default=float))
    else:
        print(text)
    sys.exit(0 if data["render"]["ok"] else 1)


if __name__ == "__main__":
    main()
