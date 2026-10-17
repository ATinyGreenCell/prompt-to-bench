#!/usr/bin/env python3
"""Import a Hugging Face fine-tune onto the Tiiny box through the two calls the TiinyOS app's
"Import Model" dialog makes, so no click in the app is needed (read from the app's bundle, TiinyOS 0.9.6):

  1. POST http://api.tiiny/api/v1/models/import/inspect   {"hf_url": ...}  -> inspection JSON
  2. POST http://api.tiiny/api/v1/models/import           (server-sent events, progress until done)
       {base_model_id, hf_url, hf_revision, toolkit_id, toolkit_revision, model_id,
        model_name, display_name, model_desc, reasoning_enabled}

The app fills (2) from (1): base_model_id / toolkit_id / toolkit_revision from the matched base model,
hf_revision from the inspected repo, model_id from its id suggestion. This script does the same, by key,
from wherever those keys sit in the inspection. Auth and routing are tiinykit's: the device key as a
Bearer token and the box's virtual hosts via the Host header.

The repo must already be importable (finetune/scripts/box_import_fix.py; PIPELINE_HICCUPS H30).
After the stream reports done, the box still converts the weights: wait for status == "downloaded" (H29).

usage: python box_import.py https://huggingface.co/ATinyGreenCell/<name> --name <display name>   # inspect only
       python box_import.py ... --go                                                              # import
"""
from __future__ import annotations

import argparse
import json
import sys
import time
import urllib.error
import urllib.request

sys.path.insert(0, "/home/seb/tiny")
from tiinykit import config  # noqa: E402


def find(obj, key, prefer=()):
    """First non-empty value of `key` anywhere in obj (breadth-first), looking inside `prefer` sub-objects first."""
    queue = [obj[p] for p in prefer if isinstance(obj, dict) and isinstance(obj.get(p), (dict, list))] + [obj]
    while queue:
        cur = queue.pop(0)
        if isinstance(cur, dict):
            v = cur.get(key)
            if v not in (None, "", [], {}):
                return v
            queue.extend(x for x in cur.values() if isinstance(x, (dict, list)))
        elif isinstance(cur, list):
            queue.extend(x for x in cur if isinstance(x, (dict, list)))
    return None


def post(host, key, path, body, accept="application/json", timeout=30):
    req = urllib.request.Request(f"http://{host}{path}", data=json.dumps(body).encode(), method="POST",
                                 headers={"Host": "api.tiiny", "Content-Type": "application/json", "Accept": accept,
                                          "User-Agent": "Tiiny/1.0", "Authorization": f"Bearer {key}"})
    return urllib.request.urlopen(req, timeout=timeout)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("hf_url")
    ap.add_argument("--name", required=True, help="display name on the box")
    ap.add_argument("--desc", default="")
    ap.add_argument("--reasoning", action="store_true", help="enable reasoning (default off, as trained)")
    ap.add_argument("--go", action="store_true", help="start the import (default: inspect only)")
    a = ap.parse_args()
    cfg = config.load()
    host, key = cfg["host"], cfg["api_key"]

    try:
        insp = json.load(post(host, key, "/api/v1/models/import/inspect", {"hf_url": a.hf_url}))
    except urllib.error.HTTPError as e:
        raise SystemExit(f"inspect failed: HTTP {e.code}: {e.read().decode(errors='replace')[:500]}")
    print(json.dumps(insp, indent=1)[:4000])
    sup = ("support", "supported", "base_model", "matched_base_model", "toolkit")
    body = {
        "base_model_id": find(insp, "base_model_id", sup),
        "hf_url": a.hf_url,
        "hf_revision": find(insp, "hf_revision") or find(insp, "revision") or "main",
        "toolkit_id": find(insp, "toolkit_id", sup),
        "toolkit_revision": find(insp, "toolkit_revision", sup),
        "model_id": find(insp, "id_suggestion") or None,
        "model_name": a.name, "display_name": a.name, "model_desc": a.desc,
        "reasoning_enabled": bool(a.reasoning),
    }
    print("\nimport request:", json.dumps(body, indent=1))
    missing = [k for k in ("base_model_id", "toolkit_id") if not body[k]]
    if missing:
        raise SystemExit(f"inspection lacks {missing} - the box did not match a supported base; not importing")
    if not a.go:
        print("\n(inspect only; add --go to import)")
        return
    t0 = time.time()
    with post(host, key, "/api/v1/models/import", body, accept="text/event-stream, application/json",
              timeout=7200) as r:
        event = "progress"
        for raw in r:
            line = raw.decode(errors="replace").rstrip("\n")
            if line.startswith("event:"):
                event = line[6:].strip()
            elif line.startswith("data:"):
                print(f"{time.strftime('%H:%M:%S')} +{time.time() - t0:5.0f}s {event}: {line[5:].strip()[:300]}",
                      flush=True)
                if event in ("done", "error"):
                    break
    print("stream closed after", round(time.time() - t0), "s")


if __name__ == "__main__":
    main()
