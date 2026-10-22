#!/usr/bin/env python3
"""The template library for idea 3 (bench/smallmodels/PROTOCOL.md): the 34 parametric seed families of the
fine-tuning data engine (finetune/seeds/*.scad). Each file declares, in its header,
  // @desc   a one-line description
  // @prompt the request template, with {param} placeholders
  // @param  name  meaning  [lo:hi] or [lo:hi:step]   (step 1 = a whole number)
and assigns every parameter near the top (`name = value;`). A design is built by rewriting those assignments.

    from library import load, build
    lib = load()                       # {name: family}
    scad = build(lib["grid_tray"], {"cols": 6, "rows": 4, ...})
"""
from __future__ import annotations

import glob
import os
import re

SEEDS = "/home/seb/printpaper/finetune/seeds"
PARAM = re.compile(r"^//\s*@param\s+(\w+)\s+(.*?)\s*\[\s*(-?[\d.]+)\s*:\s*(-?[\d.]+)\s*(?::\s*(-?[\d.]+)\s*)?\]\s*$", re.M)


def load(seeds_dir: str = SEEDS) -> dict:
    lib = {}
    for path in sorted(glob.glob(os.path.join(seeds_dir, "*.scad"))):
        text = open(path, encoding="utf-8").read()
        name = os.path.splitext(os.path.basename(path))[0]
        desc = re.search(r"^//\s*@desc\s+(.+?)\s*$", text, re.M)
        prompt = re.search(r"^//\s*@prompt\s+(.+?)\s*$", text, re.M)
        params = []
        for m in PARAM.finditer(text):
            pname, meaning, lo, hi, step = m.groups()
            dflt = re.search(rf"^\s*{pname}\s*=\s*([^;]+);", text, re.M)
            params.append({"name": pname, "meaning": meaning.strip(), "lo": float(lo), "hi": float(hi),
                           "integer": step is not None and float(step) == 1.0,
                           "default": dflt.group(1).strip() if dflt else None})
        if not (desc and prompt and params) or any(p["default"] is None for p in params):
            raise ValueError(f"{path}: header or parameter assignments missing")
        lib[name] = {"name": name, "desc": desc.group(1), "prompt": prompt.group(1), "params": params,
                     "scad": text}
    return lib


def clamp(fam: dict, values: dict) -> dict:
    """Every parameter, within its declared range (whole numbers where the range steps by 1); missing ones keep
    the family default."""
    out = {}
    for p in fam["params"]:
        v = values.get(p["name"])
        try:
            v = float(v)
        except (TypeError, ValueError):
            v = float(eval(p["default"], {"__builtins__": {}}))  # noqa: S307 - defaults are plain numbers
        v = min(max(v, p["lo"]), p["hi"])
        out[p["name"]] = int(round(v)) if p["integer"] else round(v, 3)
    return out


def build(fam: dict, values: dict) -> str:
    """The family's OpenSCAD with its parameter assignments set to `values` (clamped)."""
    text = fam["scad"]
    for k, v in clamp(fam, values).items():
        text, n = re.subn(rf"^(\s*{k}\s*=\s*)[^;]+;", lambda m: f"{m.group(1)}{v:g};", text, count=1, flags=re.M)
        if n != 1:
            raise ValueError(f"{fam['name']}: no assignment for {k}")
    return text


def catalog_text(lib: dict) -> str:
    return "\n".join(f"- {f['name']}: {f['desc']} (adjustable: {', '.join(p['meaning'] for p in f['params'])})"
                     for f in lib.values())


if __name__ == "__main__":
    lib = load()
    print(len(lib), "families,", sum(len(f["params"]) for f in lib.values()), "parameters")
    print(catalog_text(lib)[:1200])
