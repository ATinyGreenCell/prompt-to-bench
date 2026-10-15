#!/usr/bin/env python3
"""The quality gate for synthetic fine-tune data: render an OpenSCAD file and measure it.

It reuses the benchmark's own tooling (`tools/scadreport.py`), so "valid" means exactly
what it means in the eval - same OpenSCAD, same render, same mesh checks. Every candidate
and every augmented variant must pass this before it can become a training example.

Exit 0 and (with --json) print one JSON line when the file renders to a sane watertight
mesh; exit 1 otherwise. Importable as `verify(scad_path, defines=...)`.

usage: ~/printpaper/.venv/bin/python -I verify.py FILE.scad [-D name=val ...] [--json]
"""
from __future__ import annotations

import argparse
import json
import pathlib
import sys

ROOT = pathlib.Path("/home/seb/printpaper")
sys.path[:0] = [str(ROOT / "tools"), str(ROOT / "bench")]
from scadreport import openscad_missing, report  # noqa: E402


def verify(scad_path, defines=(), timeout: int = 120) -> dict:
    """Render + measure. Returns dict(ok, seconds, messages, [bbox_mm, volume_mm3, triangles, watertight], report)."""
    miss = openscad_missing()
    if miss:
        return {"ok": False, "error": miss, "messages": [miss]}
    text, data, mesh = report(str(scad_path), defines=tuple(defines), timeout=timeout)
    r = data["render"]
    out = {"ok": bool(r["ok"]), "seconds": r["seconds"], "messages": r["messages"]}
    if mesh is not None:
        size = mesh.bounds[1] - mesh.bounds[0]
        out["bbox_mm"] = [round(float(v), 2) for v in size]
        out["volume_mm3"] = round(float(mesh.volume), 1)
        out["triangles"] = int(len(mesh.faces))
        out["watertight"] = bool(mesh.is_watertight)
    out["report"] = text
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("scad", help="the OpenSCAD file to render and measure")
    ap.add_argument("-D", action="append", default=[], metavar="name=val", help="OpenSCAD variable override (repeatable)")
    ap.add_argument("--timeout", type=int, default=120, help="render timeout in seconds (default 120, as the eval)")
    ap.add_argument("--json", action="store_true", help="print one machine-readable JSON line (no geometry report)")
    a = ap.parse_args()
    res = verify(a.scad, a.D, a.timeout)
    if a.json:
        print(json.dumps({k: v for k, v in res.items() if k != "report"}))
    else:
        print(res.get("report") or res.get("error") or "")
        tail = f'{res.get("bbox_mm")}  {res.get("volume_mm3", "?")} mm^3  {res.get("triangles", "?")} tris'
        print(("OK   " if res["ok"] else "FAIL ") + (tail if res["ok"] else "; ".join(res.get("messages", []))[:200]))
    sys.exit(0 if res["ok"] else 1)


if __name__ == "__main__":
    main()
