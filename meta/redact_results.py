#!/usr/bin/env python3
"""Redact the NPU box's provenance records before they are committed, as meta/build_log.py redacts the build log.

The sweep writes a `box_*.json` next to each run's results at the start of every pass. Its `tiiny_status` and
connection fields carry the box's private network address, and its harness path the user's home directory. Every
string in those files, keys included, goes through the build log's patterns (private IPs, MAC addresses, device ids,
tokens, e-mail addresses) plus carrier-grade NAT and link-local addresses and the home directory as a whole path
component, and the strings listed in meta/redact.txt. Only the matches change: unlike the build log, whose text is
trimmed, whitespace and everything else is kept, and the sweep's own JSON format is written back. Idempotent: run it
before every commit of bench/results.

    python meta/redact_results.py            # all box_*.json under bench/results/ and the held-out harness's results/
    python meta/redact_results.py --check    # list the files that need it, change nothing (exit 1 if any)
"""
import glob
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from build_log import PATTERNS, load_extra  # noqa: E402

MORE_IPS = re.compile(r"\b(?:100\.(?:6[4-9]|[7-9]\d|1[01]\d|12[0-7])(?:\.\d{1,3}){2}|169\.254(?:\.\d{1,3}){2})\b")


def patterns(home=None):
    """The build log's patterns, except its home-directory one, which would also turn /home/sebastian into ~astian."""
    home = (os.path.expanduser("~") if home is None else home).rstrip("/")
    pats = [(p, r) for p, r in PATTERNS if r != "~"] + [(MORE_IPS, "[private-ip]")]
    if len(home) > 1:  # with HOME=/ (or empty) there is no home to redact, and an empty pattern would match everywhere
        pats.append((re.compile(r"(?<![\w.-])" + re.escape(home) + r"(?![\w.-])"), "~"))  # not /data/home/x
    return pats


def redact_str(s, pats, extra=()):
    for p, r in pats:
        s = p.sub(r, s)
    for x in extra:
        s = re.sub(re.escape(x), "[redacted]", s, flags=re.I)
    return s


def walk(x, pats, extra=()):
    if isinstance(x, str):
        return redact_str(x, pats, extra)
    if isinstance(x, list):
        return [walk(v, pats, extra) for v in x]
    if isinstance(x, dict):
        out = {}
        for k, v in x.items():
            nk = redact_str(k, pats, extra) if isinstance(k, str) else k
            if nk in out:  # two keys that redact alike would lose a value silently; the message names neither key
                raise ValueError(f"two keys both redact to {nk!r}")
            out[nk] = walk(v, pats, extra)
        return out
    return x


def main() -> None:
    check = "--check" in sys.argv[1:]
    pats, extra = patterns(), load_extra()
    changed = 0
    root = os.path.dirname(HERE)
    paths = sorted(glob.glob(os.path.join(root, "bench", "results", "*", "box_*.json"))
                   + glob.glob(os.path.join(root, "bench", "heldout", "harness", "bench", "results", "*", "box_*.json")))
    for path in paths:
        d = json.load(open(path, encoding="utf-8"))
        try:
            new = walk(d, pats, extra)
        except ValueError as e:
            raise SystemExit(f"{path}: {e} - nothing written for it")
        if new != d:
            changed += 1
            if check:  # names only: the matches themselves are what must not be printed
                print(f"needs redaction: {os.path.relpath(path, root)}")
                continue
            tmp = path + ".tmp"
            with open(tmp, "w", encoding="utf-8") as fh:
                fh.write(json.dumps(new, indent=1))  # the sweep's format (scripts/sweep.py provenance)
            os.replace(tmp, path)
    print(f"{'would redact' if check else 'redacted'} {changed} of {len(paths)} box provenance file(s)"
          + ("" if extra else " (no meta/redact.txt terms loaded)"))
    if check and changed:
        sys.exit(1)


if __name__ == "__main__":
    main()
