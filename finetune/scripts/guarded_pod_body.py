#!/usr/bin/env python3
"""Print a RunPod create-pod body (REST v2 / the MCP's create-pod) for a pod that guards itself from boot.

The container's command is replaced by a short bash script that first starts a backstop - a plain sleeper that
stops the pod at MAX_HOURS and needs nothing downloaded - then downloads pod_idle_guard.sh from this repo, pinned
to a commit and checked against its SHA-256 so what runs is exactly the audited file, runs it under a supervisor
loop that restarts it within 30 s if it ever dies, and finally execs the image's own /start.sh (sshd,
PUBLIC_KEY, ...). The image's ENTRYPOINT is kept. So the guard runs from the pod's first minute, before any of
our scripts, and again after a container restart: a pod that is never used, or whose job finished and was never
collected, stops itself after IDLE_MIN idle minutes, and no pod outlives MAX_HOURS (pod_idle_guard.sh; RUNBOOK
B7). If the download or the checksum fails, the pod still boots, the failure is logged to
/workspace/idle_guard.log, and the backstop still stops it at MAX_HOURS. Both clocks restart with the container.

Every pod for this project is created through this body:

    python finetune/scripts/guarded_pod_body.py --name scadcoder-v9 --gpu "NVIDIA H100 80GB HBM3" > body.json

The pinned commit defaults to the newest pushed commit that touched pod_idle_guard.sh (it must be on
origin, or the download 404s); the checksum is computed from that commit's file.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import subprocess

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
REPO = "ATinyGreenCell/prompt-to-bench"
PATH = "finetune/scripts/pod_idle_guard.sh"
BOOT = r"""L=/workspace/idle_guard.log; G=/usr/local/bin/pod_idle_guard.sh
mkdir -p /workspace /usr/local/bin
# backstop: the hard cap is also kept by a plain sleeper that needs nothing downloaded, so it holds even if the
# guard never starts, or dies together with its supervisor
S=$(awk -v h="${MAX_HOURS:-12}" 'BEGIN {h += 0; if (h <= 0) h = 12; printf "%d", h * 3600}')
# shellcheck disable=SC2016  # the inner scripts take their values as positional arguments
(setsid nohup bash -c 'sleep "$1"; echo "$(date -u +%FT%TZ) backstop: $1 s cap reached, stopping the pod"; timeout 60 runpodctl stop pod "$2" || timeout 60 runpodctl pod stop "$2"' _ "$S" "${RUNPOD_POD_ID:-}" >> "$L" 2>&1 < /dev/null &)
ok=0
for _ in 1 2 3 4 5 6; do
  rm -f "$G"
  curl -fsSL --max-time 20 "$GUARD_URL" -o "$G" 2>/dev/null \
    || wget -q -T 20 -O "$G" "$GUARD_URL" 2>/dev/null \
    || python3 -c 'import sys, urllib.request; urllib.request.urlretrieve(sys.argv[1], sys.argv[2])' "$GUARD_URL" "$G" 2>/dev/null
  if [ -s "$G" ] && echo "$GUARD_SHA256  $G" | sha256sum -c --status -; then ok=1; break; fi
  sleep 10
done
if [ "$ok" = 1 ]; then
  # supervised: if the guard ever dies it is back within 30 s (its lock keeps it to one copy)
  # shellcheck disable=SC2016
  (setsid nohup bash -c 'while :; do bash "$1"; sleep 30; done' _ "$G" >> "$L" 2>&1 < /dev/null &)
else
  echo "$(date -u +%FT%TZ) GUARD NOT STARTED (download or checksum failed); only the backstop applies: stop after ${S}s" >> "$L"
fi
if [ -x /start.sh ]; then exec /start.sh; fi
echo "$(date -u +%FT%TZ) no /start.sh in this image - keeping PID 1 alive so the guard can stop the pod" >> "$L"
exec sleep infinity"""


def git(*args: str) -> str:
    return subprocess.run(["git", "-C", str(ROOT), *args], capture_output=True, text=True, check=True).stdout.strip()


def pinned() -> tuple[str, str]:
    """(commit, sha256) of the newest commit on origin/main that touched the guard."""
    git("fetch", "-q", "origin", "main")
    commit = git("log", "-1", "--format=%H", "origin/main", "--", PATH)
    blob = subprocess.run(["git", "-C", str(ROOT), "show", f"{commit}:{PATH}"], capture_output=True, check=True).stdout
    return commit, hashlib.sha256(blob).hexdigest()


def body(name: str, gpu: str, image: str, disk: int, idle_min: int, max_hours: float, min_cuda: str,
         vcpu_per_gpu: int | None, dcs: list[str] | None = None) -> dict:
    commit, digest = pinned()
    g = {"id": gpu, "count": 1, "minCudaVersion": min_cuda}
    if vcpu_per_gpu:
        g["minVcpuCountPerGpu"] = vcpu_per_gpu
    b = {
        "name": name, "image": image, "cloud": "SECURE", "gpu": g, "disk": disk,
        "ports": ["22/tcp"], "startSsh": True,
        "env": {"GUARD_URL": f"https://raw.githubusercontent.com/{REPO}/{commit}/{PATH}", "GUARD_SHA256": digest,
                "IDLE_MIN": str(idle_min), "MAX_HOURS": str(max_hours)},
        "cmd": ["bash", "-c", BOOT],
    }
    if dcs:
        b["dataCenterIds"] = dcs
    return b


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--name", required=True)
    ap.add_argument("--gpu", required=True, help='catalog GPU id, e.g. "NVIDIA H100 80GB HBM3"')
    ap.add_argument("--image", default="runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404")
    ap.add_argument("--disk", type=int, default=100)
    ap.add_argument("--idle-min", type=int, default=45)
    ap.add_argument("--max-hours", type=float, default=12)
    ap.add_argument("--min-cuda", default="12.8")
    ap.add_argument("--vcpu-per-gpu", type=int, default=None)
    ap.add_argument("--dc", default="", help="preferred data centers, comma-separated (e.g. US-MO-1,US-GA-2): "
                    "pushes from the laptop to an EU pod ran at ~50 KB/s (H43); list-data-centers shows stock")
    a = ap.parse_args()
    dcs = [d.strip() for d in a.dc.split(",") if d.strip()]
    print(json.dumps(body(a.name, a.gpu, a.image, a.disk, a.idle_min, a.max_hours, a.min_cuda, a.vcpu_per_gpu, dcs),
                     indent=1))


if __name__ == "__main__":
    main()
