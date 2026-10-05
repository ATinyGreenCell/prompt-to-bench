"""Hidden geometric checks for the Prompt-to-Bench tasks.

These checks are never shown to the model under test. A model's mesh is
normalised (bounding-box centre in XY at the origin, lowest point at z = 0) and
compared with the task spec in the *design frame* of the reference solution.
Rotations by 90 degrees about Z and mirroring are allowed - they do not change
how a part prints or works - so every transform-dependent check is evaluated
for all 8 symmetries of the bed and the best one is kept.

Check types (see tasks.yaml):
  bbox, bodies, body_sizes, watertight, volume,
  slice (islands, holes, hole_d, hole_area, hole_rect, hole_rects, hole_centers,
         hole_grid, island_d, island_rects, material_area),
  probes, line, arc
"""
import math
import os
import sys

import numpy as np
import shapely
from shapely.ops import unary_union

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "tools"))
from scadreport import load_mesh, section, shape_info  # noqa: E402

NUDGE = 0.0137  # keep slice planes off exact face heights
TRANSFORMS = [(k, m) for m in (False, True) for k in range(4)]


class Slices:
    """Cached cross-sections of a normalised mesh."""

    def __init__(self, mesh):
        self.mesh = mesh
        self.cache = {}

    def get(self, z):
        if z not in self.cache:
            polys = section(self.mesh, z + NUDGE)
            region = unary_union(polys) if polys else shapely.Polygon()
            islands, holes = [], []
            for p in polys:
                s = shape_info(shapely.Polygon(p.exterior))
                s["material_area"] = p.area
                islands.append(s)
                holes += [shape_info(shapely.Polygon(r)) for r in p.interiors]
            self.cache[z] = {"region": region, "islands": islands, "holes": holes,
                             "material_area": sum(p.area for p in polys)}
        return self.cache[z]


def normalise(mesh):
    m = mesh.copy()
    b = m.bounds
    m.apply_translation([-(b[0][0] + b[1][0]) / 2, -(b[0][1] + b[1][1]) / 2, -b[0][2]])
    return m


def to_model(pts, k, mirror, dc):
    """Map design-frame XY points into the normalised model frame for symmetry (k, mirror)."""
    q = np.atleast_2d(np.asarray(pts, float))[:, :2] - np.asarray(dc, float)
    a = -k * math.pi / 2
    c, s = math.cos(a), math.sin(a)
    p = np.stack([c * q[:, 0] - s * q[:, 1], s * q[:, 0] + c * q[:, 1]], axis=1)
    if mirror:
        p[:, 0] = -p[:, 0]
    return p


def _match_points(expected, found, tol):
    """Every expected point has a distinct found point within tol."""
    found = [tuple(f) for f in found]
    for e in expected:
        if not found:
            return False
        d = [math.dist(e, f) for f in found]
        i = int(np.argmin(d))
        if d[i] > tol:
            return False
        found.pop(i)
    return True


def _rects_match(shapes, expected, tol):
    got = sorted(((s["l"], s["w"]) for s in shapes), key=lambda t: -t[0] * t[1])
    exp = sorted((tuple(sorted(e, reverse=True)) for e in expected), key=lambda t: -t[0] * t[1])
    if len(got) != len(exp):
        return False, f"{len(got)} shapes vs {len(exp)} expected"
    for (gl, gw), (el, ew) in zip(got, exp):
        if abs(gl - el) > tol or abs(gw - ew) > tol:
            return False, f"got {gl:.2f}x{gw:.2f}, expected {el}x{ew}"
    return True, "ok"


def _runs(mask):
    """Lengths (in samples) of consecutive True runs in a 1-D boolean array."""
    runs, n = [], 0
    for v in mask:
        if v:
            n += 1
        elif n:
            runs.append(n)
            n = 0
    if n:
        runs.append(n)
    return runs


# --------------------------------------------------------------------------- items

def build_items(task, ref):
    """Expand the YAML checks into (name, fn(ctx, k, mirror) -> (ok, msg), transform_dependent)."""
    items = []
    dc = ref["design_center"]

    for chk in task["checks"]:
        kind = next(iter(chk))
        spec = chk[kind]

        if kind == "bbox":
            size, tol = spec["size"], spec.get("tol", 0.5)

            def f(ctx, k, m, size=size, tol=tol):
                sx, sy, sz = ctx["size"]
                okz = abs(sz - size[2]) <= tol
                okxy = (abs(sx - size[0]) <= tol and abs(sy - size[1]) <= tol) or \
                       (abs(sx - size[1]) <= tol and abs(sy - size[0]) <= tol)
                return okz and okxy, f"size {sx:.2f} x {sy:.2f} x {sz:.2f} vs {size}"
            items.append(("bbox", f, False))

        elif kind == "bodies":
            items.append(("bodies", lambda ctx, k, m, n=spec: (ctx["bodies"] == n, f"{ctx['bodies']} bodies vs {n}"), False))

        elif kind == "watertight":
            items.append(("watertight", lambda ctx, k, m: (ctx["watertight"], "watertight" if ctx["watertight"] else "not watertight"), False))

        elif kind == "volume":
            rel = spec.get("rel_tol", 0.05)

            def f(ctx, k, m, rel=rel):
                v, vr = ctx["volume"], ref["volume"]
                if v is None:
                    return False, "volume undefined (not watertight)"
                return abs(v - vr) <= rel * vr, f"volume {v:.0f} vs ref {vr:.0f} (+-{rel:.0%})"
            items.append(("volume", f, False))

        elif kind == "body_sizes":
            exp, tol = spec["sizes"], spec.get("tol", 0.4)

            def f(ctx, k, m, exp=exp, tol=tol):
                got = sorted((sorted(s[:2], reverse=True) + [s[2]] for s in ctx["body_sizes"]), key=lambda s: -s[2])
                e = sorted((sorted(s[:2], reverse=True) + [s[2]] for s in exp), key=lambda s: -s[2])
                if len(got) != len(e):
                    return False, f"{len(got)} bodies"
                ok = all(abs(a - b) <= tol for g, x in zip(got, e) for a, b in zip(g, x))
                return ok, f"body sizes {[[round(v, 2) for v in g] for g in got]}"
            items.append(("body_sizes", f, False))

        elif kind == "slice":
            z = spec["z"]
            tag = f"slice z={z}"
            if "islands" in spec:
                items.append((f"{tag} islands", lambda ctx, k, m, z=z, n=spec["islands"]:
                              (len(ctx["S"].get(z)["islands"]) == n, f"{len(ctx['S'].get(z)['islands'])} vs {n}"), False))
            if "holes" in spec:
                items.append((f"{tag} holes", lambda ctx, k, m, z=z, n=spec["holes"]:
                              (len(ctx["S"].get(z)["holes"]) == n, f"{len(ctx['S'].get(z)['holes'])} vs {n}"), False))
            if "hole_d" in spec:
                d, tol = spec["hole_d"]

                def f(ctx, k, m, z=z, d=d, tol=tol):
                    hs = ctx["S"].get(z)["holes"]
                    bad = [round(h["d"], 2) for h in hs if abs(h["d"] - d) > tol]
                    return bool(hs) and not bad, f"hole d off: {bad[:5]}" if bad else "ok"
                items.append((f"{tag} hole_d", f, False))
            if "hole_area" in spec:
                a, rel = spec["hole_area"]

                def f(ctx, k, m, z=z, a=a, rel=rel):
                    hs = ctx["S"].get(z)["holes"]
                    bad = [round(h["area"], 1) for h in hs if abs(h["area"] - a) > rel * a]
                    return bool(hs) and not bad, f"hole areas {[round(h['area'], 1) for h in hs][:5]} vs {a}"
                items.append((f"{tag} hole_area", f, False))
            if "hole_rect" in spec:
                l, w, ltol, wtol = spec["hole_rect"]

                def f(ctx, k, m, z=z, l=l, w=w, ltol=ltol, wtol=wtol):
                    hs = ctx["S"].get(z)["holes"]
                    bad = [(round(h["l"], 2), round(h["w"], 2)) for h in hs if abs(h["l"] - l) > ltol or abs(h["w"] - w) > wtol]
                    return bool(hs) and not bad, f"off: {bad[:3]}" if bad else "ok"
                items.append((f"{tag} hole_rect", f, False))
            if "hole_rects" in spec:
                items.append((f"{tag} hole_rects", lambda ctx, k, m, z=z, e=spec["hole_rects"], t=spec.get("rect_tol", 0.4):
                              _rects_match(ctx["S"].get(z)["holes"], e, t), False))
            if "island_rects" in spec:
                items.append((f"{tag} island_rects", lambda ctx, k, m, z=z, e=spec["island_rects"], t=spec.get("island_tol", 0.4):
                              _rects_match(ctx["S"].get(z)["islands"], e, t), False))
            if "island_d" in spec:
                d, tol = spec["island_d"]

                def f(ctx, k, m, z=z, d=d, tol=tol):
                    isl = ctx["S"].get(z)["islands"]
                    got = [round(i["d"], 2) for i in isl]
                    return len(isl) >= 1 and all(abs(g - d) <= tol for g in got), f"outer d {got} vs {d}"
                items.append((f"{tag} island_d", f, False))
            if "material_area" in spec:
                rel = spec["material_area"]

                def f(ctx, k, m, z=z, rel=rel):
                    a, ar = ctx["S"].get(z)["material_area"], ref["material_area"][str(z)]
                    return abs(a - ar) <= rel * ar, f"area {a:.1f} vs ref {ar:.1f}"
                items.append((f"{tag} material_area", f, False))
            if "hole_centers" in spec or "hole_grid" in spec:
                if "hole_grid" in spec:
                    g = spec["hole_grid"]
                    cx, cy = g.get("center", [0, 0])
                    exp = [(cx + (i - (g["nx"] - 1) / 2) * g["px"], cy + (j - (g["ny"] - 1) / 2) * g["py"])
                           for i in range(g["nx"]) for j in range(g["ny"])]
                else:
                    exp = [tuple(p) for p in spec["hole_centers"]]
                tol = spec.get("tol", 0.5)

                def f(ctx, k, m, z=z, exp=exp, tol=tol):
                    hs = ctx["S"].get(z)["holes"]
                    e = to_model(exp, k, m, dc)
                    ok = len(hs) == len(exp) and _match_points(e, [(h["cx"], h["cy"]) for h in hs], tol)
                    return ok, f"{len(hs)} holes; positions {'match' if ok else 'do not match'}"
                items.append((f"{tag} hole_positions", f, True))

        elif kind == "probes":
            solid, empty = spec.get("solid", []), spec.get("empty", [])

            def f(ctx, k, m, solid=solid, empty=empty):
                bad = []
                for pts, want in ((solid, True), (empty, False)):
                    for p in pts:
                        region = ctx["S"].get(p[2])["region"]
                        x, y = to_model([p], k, m, dc)[0]
                        if bool(shapely.contains_xy(region, x, y)) != want:
                            bad.append(("solid" if want else "empty", p))
                return not bad, f"wrong at {bad[:4]}" if bad else f"{len(solid) + len(empty)} probes ok"
            items.append(("probes", f, True))

        elif kind == "line":
            z, a, b = spec["z"], spec["from"], spec["to"]
            n_exp, (L, ltol) = spec["intervals"], spec.get("length", [None, None])

            def f(ctx, k, m, z=z, a=a, b=b, n_exp=n_exp, L=L, ltol=ltol):
                step = 0.02
                n = int(math.dist(a, b) / step) + 1
                t = np.linspace(0, 1, n)
                pts = np.stack([a[0] + t * (b[0] - a[0]), a[1] + t * (b[1] - a[1])], axis=1)
                p = to_model(pts, k, m, dc)
                mask = shapely.contains_xy(ctx["S"].get(z)["region"], p[:, 0], p[:, 1])
                runs = [r * step for r in _runs(mask)]
                ok = len(runs) == n_exp and (L is None or all(abs(r - L) <= ltol for r in runs))
                return ok, f"{len(runs)} solid intervals {[round(r, 2) for r in runs[:6]]}"
            items.append((f"line z={z}", f, True))

        elif kind == "arc":
            z, c, r, gaps = spec["z"], spec["center"], spec["r"], spec["gaps"]

            def f(ctx, k, m, z=z, c=c, r=r, gaps=gaps):
                th = np.linspace(0, 2 * math.pi, 2880, endpoint=False)
                pts = np.stack([c[0] + r * np.cos(th), c[1] + r * np.sin(th)], axis=1)
                p = to_model(pts, k, m, dc)
                mask = shapely.contains_xy(ctx["S"].get(z)["region"], p[:, 0], p[:, 1])
                if mask.all():
                    n = 0
                else:
                    i0 = int(np.argmax(mask)) if mask.any() else 0  # start inside material
                    n = len(_runs(~np.roll(mask, -i0)))
                return n == gaps, f"{n} gaps vs {gaps}"
            items.append((f"arc z={z}", f, True))
        else:
            raise ValueError(f"unknown check {kind}")
    return items


def evaluate(mesh_or_path, task, ref):
    """Run all checks. Returns dict(passed, score, n, items=[...], transform)."""
    mesh = load_mesh(mesh_or_path) if isinstance(mesh_or_path, str) else mesh_or_path
    mesh = normalise(mesh)
    bodies = mesh.split(only_watertight=False)
    ctx = {
        "size": (mesh.bounds[1] - mesh.bounds[0]).tolist(),
        "bodies": len(bodies),
        "body_sizes": [(b.bounds[1] - b.bounds[0]).tolist() for b in bodies],
        "watertight": bool(mesh.is_watertight),
        "volume": float(mesh.volume) if mesh.is_watertight else None,
        "S": Slices(mesh),
    }
    items = build_items(task, ref)
    fixed = {}
    for name, f, dep in items:
        if not dep:
            try:
                fixed[name] = f(ctx, 0, False)
            except Exception as e:  # noqa: BLE001
                fixed[name] = (False, f"error: {e}")
    best = None
    for k, mir in TRANSFORMS:
        res = {}
        for name, f, dep in items:
            if dep:
                try:
                    res[name] = f(ctx, k, mir)
                except Exception as e:  # noqa: BLE001
                    res[name] = (False, f"error: {e}")
        score = sum(ok for ok, _ in res.values())
        if best is None or score > best[0]:
            best = (score, (k, mir), res)
        if score == len(res):
            break
    allres = {**fixed, **best[2]}
    out = [{"check": n, "ok": bool(allres[n][0]), "msg": allres[n][1]} for n, _, _ in items]
    n_ok = sum(i["ok"] for i in out)
    return {"passed": n_ok == len(out), "score": n_ok / len(out), "n_ok": n_ok, "n": len(out),
            "transform": {"rot90": best[1][0], "mirror": best[1][1]}, "items": out}


def reference_stats(mesh, task):
    """Reference values used by relative checks (volume, slice areas) + design-frame centre."""
    b = mesh.bounds
    dc = [(b[0][0] + b[1][0]) / 2, (b[0][1] + b[1][1]) / 2]
    m = normalise(mesh)
    S = Slices(m)
    areas = {}
    for chk in task["checks"]:
        if "slice" in chk and "material_area" in chk["slice"]:
            z = chk["slice"]["z"]
            areas[str(z)] = S.get(z)["material_area"]
    return {"design_center": dc, "zmin": float(b[0][2]), "volume": float(m.volume),
            "size": (b[1] - b[0]).tolist(), "material_area": areas}
