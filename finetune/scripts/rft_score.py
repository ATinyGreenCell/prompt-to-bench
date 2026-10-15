#!/usr/bin/env python3
"""The reward for rejection-sampling fine-tuning: does a generated OpenSCAD file build the SAME part
as a known-correct reference?

For a training prompt we already have a verified-correct file (the baked seed) and can measure it.
A generated candidate "matches" when it renders to a watertight solid whose bounding box (per axis),
volume and separate-body count agree with the reference inside tolerance. That is an automatic,
check-only verifier (no hand-written per-task checks): keep the candidates that match, train on them.

It reuses the benchmark's own `tools/scadreport.py`, so "renders" means exactly what the eval means.

usage:
  from rft_score import measure, matches
  m = measure(scad_text); ok, score, detail = matches(cand_text, ref_text)      # or ref_measure=measure(ref)
  python -I rft_score.py cand.scad ref.scad          # prints the verdict
"""
from __future__ import annotations

import os
import pathlib
import sys
import tempfile

ROOT = pathlib.Path("/home/seb/printpaper")
sys.path[:0] = [str(ROOT / "tools"), str(ROOT / "bench")]
from scadreport import analyse, load_mesh, render  # noqa: E402

# tolerances: a candidate counts as the same part within these bounds
BBOX_ABS = 1.0    # mm of slack per axis, whichever is larger
BBOX_REL = 0.03   # or 3% of the reference size
VOL_REL = 0.08    # volume within 8%


def measure(scad_text: str, timeout: int = 60) -> dict:
    """Render an OpenSCAD string and return {ok, watertight, bbox:[x,y,z], volume, bodies} (ok False if it
    does not render to a watertight solid)."""
    with tempfile.TemporaryDirectory() as d:
        sp, stl = os.path.join(d, "p.scad"), os.path.join(d, "p.stl")
        open(sp, "w").write(scad_text)
        rr = render(sp, stl, timeout=timeout)
        if not rr["ok"]:
            return {"ok": False, "reason": "render failed"}
        try:
            mesh = load_mesh(stl)
            a = analyse(mesh)
        except Exception as e:  # noqa: BLE001
            return {"ok": False, "reason": f"mesh/analyse failed: {e}"}
        if not a["watertight"]:
            return {"ok": False, "reason": "not watertight"}
        size = (mesh.bounds[1] - mesh.bounds[0])
        return {"ok": True, "watertight": True, "bbox": [float(v) for v in size],
                "volume": float(a["volume"]), "bodies": int(a["bodies"])}


def matches(cand_text: str, ref_text: str | None = None, ref_measure: dict | None = None,
            timeout: int = 60) -> tuple[bool, float, dict]:
    """Return (pass, score 0-1, detail). `pass` means the candidate built the same part as the reference;
    `score` is the fraction of the four sub-checks met (watertight, bbox, volume, body count), a smoother
    reward than pass/fail. Pass ref_measure to skip re-rendering a cached reference."""
    ref = ref_measure or measure(ref_text, timeout)
    if not ref.get("ok"):
        return False, 0.0, {"reason": f"reference does not render ({ref.get('reason')})"}
    cand = measure(cand_text, timeout)
    if not cand.get("ok"):
        return False, 0.0, {"reason": f"candidate: {cand.get('reason')}", "ref": ref}

    checks, detail = [], {}
    detail["watertight"] = True
    checks.append(True)  # cand.ok already implies watertight

    bbox_ok = all(abs(c - r) <= max(BBOX_ABS, BBOX_REL * r)
                  for c, r in zip(cand["bbox"], ref["bbox"]))
    checks.append(bbox_ok)
    detail["bbox"] = {"cand": [round(v, 2) for v in cand["bbox"]],
                      "ref": [round(v, 2) for v in ref["bbox"]], "ok": bbox_ok}

    vol_ok = ref["volume"] > 0 and abs(cand["volume"] - ref["volume"]) <= VOL_REL * ref["volume"]
    checks.append(vol_ok)
    detail["volume"] = {"cand": round(cand["volume"], 1), "ref": round(ref["volume"], 1), "ok": vol_ok}

    body_ok = cand["bodies"] == ref["bodies"]
    checks.append(body_ok)
    detail["bodies"] = {"cand": cand["bodies"], "ref": ref["bodies"], "ok": body_ok}

    score = sum(checks) / len(checks)
    return (score == 1.0), round(score, 3), detail


def main() -> None:
    import argparse, json
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("candidate")
    ap.add_argument("reference")
    ap.add_argument("--timeout", type=int, default=60)
    a = ap.parse_args()
    ok, score, detail = matches(open(a.candidate).read(), open(a.reference).read(), timeout=a.timeout)
    print(f"{'MATCH' if ok else 'no match'}  score={score}")
    print(json.dumps(detail, indent=2))
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
