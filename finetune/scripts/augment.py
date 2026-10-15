#!/usr/bin/env python3
"""Turn one parametric seed into many verified training variants.

Reads a seed's `// @param name ... [lo:hi]` or `[lo:hi:step]` ranges, samples parameter
combinations, renders each through the quality gate (verify.py / scadreport), and emits only the
valid, watertight ones as (prompt -> scad) pairs. Valid-by-construction *and* verified, so the
dataset never contains a part that doesn't render.

Range syntax:
  [lo:hi]        continuous - sampled uniformly, rounded to 1 decimal (dimensions)
  [lo:hi:step]   discrete grid lo, lo+step, ... <= hi (counts use step 1; e.g. half-modules step 0.5)

Each emitted record: {seed, params, prompt, scad (baked, annotations stripped), geometry}.
The `// @prompt` template in the seed is filled with the sampled values; `// @desc` is a label.

Hardening (so a broken family can never silently reach a paid training run):
  - every sampled param MUST substitute into a top-level assignment, else we raise (prompt/code skew);
  - a family that yields zero verified variants exits non-zero.

Run it low-priority while the sweep renders too:
  nice -n 19 ~/printpaper/.venv/bin/python -I augment.py SEED.scad -n 200 -o ../data/<name>.jsonl
"""
from __future__ import annotations

import argparse
import json
import pathlib
import random
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from verify import verify  # noqa: E402

PARAM_RE = re.compile(r"//\s*@param\s+(\w+)\s+(.*?)\s*\[\s*([-\d.]+)\s*:\s*([-\d.]+)\s*(?::\s*([-\d.]+)\s*)?\]")
DESC_RE = re.compile(r"//\s*@desc\s+(.*)")
PROMPT_RE = re.compile(r"//\s*@prompt\s+(.*)")


def parse_seed(text: str):
    params = {}
    for m in PARAM_RE.finditer(text):
        name, _desc, lo, hi, step = m.groups()
        params[name] = (float(lo), float(hi), float(step) if step else None)
    desc = m.group(1) if (m := DESC_RE.search(text)) else ""
    prompt = m.group(1) if (m := PROMPT_RE.search(text)) else ""
    return params, desc, prompt


def fmt(v: float) -> str:
    if abs(v - round(v)) < 1e-9:
        return str(int(round(v)))
    return f"{v:.2f}".rstrip("0").rstrip(".")


def bake(text: str, combo: dict) -> str:
    """Substitute the sampled values into the seed's top-level assignments and drop @-annotations.

    Raises if a sampled param has no top-level assignment to rewrite: that would leave the seed
    default in the code while the prompt advertises the sampled value - a silent prompt/code skew.
    """
    for k, v in combo.items():
        text, n = re.subn(rf"(?m)^({k}\s*=\s*)[^;]+;", rf"\g<1>{fmt(v)};", text, count=1)
        if n != 1:
            raise ValueError(f"param {k!r} has no top-level `{k} = ...;` assignment to bake into")
    return "\n".join(ln for ln in text.splitlines() if not re.match(r"\s*//\s*@(param|desc|prompt)\b", ln)).strip() + "\n"


def sample(lo: float, hi: float, step: float | None = None) -> float:
    if step and step > 0:
        n = max(0, int(round((hi - lo) / step)))
        return round(lo + random.randint(0, n) * step, 4)
    return round(random.uniform(lo, hi), 1)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("seed", type=pathlib.Path)
    ap.add_argument("-n", type=int, default=100, help="parameter combinations to try")
    ap.add_argument("-o", type=pathlib.Path, help="output JSONL (default: data/<seed>.jsonl)")
    ap.add_argument("--rng", type=int, default=0, help="random seed, for reproducibility")
    ap.add_argument("--timeout", type=int, default=60)
    a = ap.parse_args()
    random.seed(a.rng)

    text = a.seed.read_text()
    params, desc, prompt_tmpl = parse_seed(text)
    if not params or not prompt_tmpl:
        sys.exit(f"{a.seed}: need @param ranges and a @prompt template")
    # Fail loudly up front if the prompt references anything we will not sample (else KeyError mid-run).
    ph = set(re.findall(r"\{(\w+)\}", prompt_tmpl))
    if ph - params.keys():
        sys.exit(f"{a.seed}: @prompt uses {sorted(ph - params.keys())} with no matching @param")

    out = a.o or (a.seed.resolve().parents[1] / "data" / (a.seed.stem + ".jsonl"))
    out.parent.mkdir(parents=True, exist_ok=True)

    kept, tried, seen = 0, 0, set()
    with out.open("w") as fh:
        for _ in range(a.n):
            combo = {k: sample(lo, hi, step) for k, (lo, hi, step) in params.items()}
            key = tuple(sorted(combo.items()))
            if key in seen:
                continue
            seen.add(key)
            tried += 1
            res = verify(a.seed, [f"{k}={fmt(v)}" for k, v in combo.items()], a.timeout)
            if res["ok"] and res.get("watertight"):
                rec = {"seed": a.seed.stem, "desc": desc, "params": combo,
                       "prompt": prompt_tmpl.format(**{k: fmt(v) for k, v in combo.items()}),
                       "scad": bake(text, combo),
                       "geometry": {k: res[k] for k in ("bbox_mm", "volume_mm3", "triangles") if k in res}}
                fh.write(json.dumps(rec) + "\n")
                kept += 1
    print(f"{a.seed.stem}: kept {kept}/{tried} verified variants -> {out}")
    if kept == 0:
        sys.exit(f"{a.seed.stem}: ZERO verified variants - seed is broken, not writing it into the dataset")


if __name__ == "__main__":
    main()
