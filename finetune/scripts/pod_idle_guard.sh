#!/usr/bin/env bash
# pod_idle_guard.sh - runs INSIDE a RunPod pod and stops the pod when it sits idle, or outlives a hard cap.
#
# Why: a pod bills by the second whether or not it works. A laptop-side watcher that dies (reboot, lost
# session) once left a finished pod billing ~4.5 h, and a stuck helper another ~3.6 h (H32). This guard
# lives in the pod itself, so it needs no laptop, no session and no laptop credentials: RunPod injects
# RUNPOD_POD_ID and a pod-scoped RUNPOD_API_KEY into every pod (PID 1's environment; an SSH shell does not
# carry them, so they are read from /proc/1/environ when missing).
#
# Two independent stop conditions, checked every minute:
#   1. IDLE  - for IDLE_MIN consecutive minutes: every GPU below GPU_PCT, the container using fewer than
#              CPU_CORES cores (cgroup accounting, not the host's /proc/stat), no work process matching
#              BUSY_RE, and network traffic below NET_KBPS. Any busy minute resets the clock.
#              /workspace/KEEP_ALIVE holds the pod against this condition (delete the file to re-arm).
#   2. CAP   - the pod is older than MAX_HOURS (PID 1's age). Applies even with KEEP_ALIVE and even when
#              busy: a runaway or forgotten job cannot bill forever. MAX_HOURS=0 disables it.
# A stop clears the container disk (RunPod: container-disk data is lost on stop), so anything not retrieved
# is gone - the deliberate trade. Stopping keeps no compute charge; a pod without a volume disk costs
# nothing while stopped.
#
# Stop path, in order (images differ): `runpodctl stop pod <id>` (runpodctl 1.x), `runpodctl pod stop <id>`
# (2.x), then the GraphQL podStop mutation with the pod's key. Retried every minute until one succeeds.
#
# usage:  setsid nohup bash pod_idle_guard.sh >> /workspace/idle_guard.log 2>&1 < /dev/null &
#         bash pod_idle_guard.sh --self-test     # print what it measures and which stop paths exist; no action
# knobs:  IDLE_MIN (45)  MAX_HOURS (12)  GPU_PCT (5)  CPU_CORES (0.5)  NET_KBPS (200)  DRY_RUN=1 (log only)
# From boot: finetune/scripts/guarded_pod_body.py builds a create-pod body that starts this guard before
# the image's own /start.sh, so every pod is guarded from its first second (RUNBOOK B7).
set -u
# An SSH shell carries none of the container's environment: take RunPod's variables and the guard's own
# knobs (set at pod creation by guarded_pod_body.py) from PID 1 wherever this shell lacks them.
while IFS='=' read -r k v; do
  case "$k" in
    RUNPOD_POD_ID|RUNPOD_API_KEY|IDLE_MIN|MAX_HOURS|GPU_PCT|CPU_CORES|NET_KBPS)
      [ -z "${!k:-}" ] && export "$k=$v" ;;
  esac
done < <(tr '\0' '\n' < /proc/1/environ 2>/dev/null)
IDLE_MIN=${IDLE_MIN:-45}
MAX_HOURS=${MAX_HOURS:-12}
GPU_PCT=${GPU_PCT:-5}
CPU_CORES=${CPU_CORES:-0.5}
NET_KBPS=${NET_KBPS:-200}
num(){ [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]; }  # a knob set to garbage falls back to its default, logged
for kv in IDLE_MIN=45 MAX_HOURS=12 GPU_PCT=5 CPU_CORES=0.5 NET_KBPS=200; do
  k=${kv%%=*}; d=${kv#*=}
  num "${!k}" || { echo "$(date -u +%FT%TZ) WARN: $k='${!k}' is not a number - using $d"; printf -v "$k" '%s' "$d"; }
done
IDLE_MIN=${IDLE_MIN%.*}; GPU_PCT=${GPU_PCT%.*}; NET_KBPS=${NET_KBPS%.*}   # integer comparisons below
[ "$IDLE_MIN" -ge 1 ] 2>/dev/null || IDLE_MIN=1
STATE=${GUARD_STATE:-/workspace/.idle_guard_state}
# work that can run with an idle GPU; a vLLM server is not listed - serving shows up as GPU use, and an idle
# server must not hold the pod
BUSY_RE=${BUSY_RE:-'train_vlm|train_lora|rft_generate|pip install|hf download|hf upload|huggingface-cli'}
log(){ echo "$(date -u +%FT%TZ) $*"; }


# ---------------------------------------------------------------- measurements
net_bytes(){ awk 'NR>2 && $1 !~ /^lo:/ {sub(/:/," "); rx+=$2; tx+=$10} END {print rx+tx+0}' /proc/net/dev; }
cpu_usec(){  # container CPU time in microseconds (cgroup v2, else v1), empty if unavailable
  if [ -r /sys/fs/cgroup/cpu.stat ]; then awk '/^usage_usec/ {print $2}' /sys/fs/cgroup/cpu.stat
  elif [ -r /sys/fs/cgroup/cpuacct/cpuacct.usage ]; then echo $(( $(cat /sys/fs/cgroup/cpuacct/cpuacct.usage) / 1000 ))
  fi
}
gpu_max(){  # highest utilisation across GPUs, empty if no GPU telemetry
  timeout 15 nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | tr -d ' ' | grep -E '^[0-9]+$' | sort -n | tail -1
}
age_s(){  # PID 1's age in seconds from /proc (host-relative uptime minus PID 1's start tick); ps as fallback
  local hz up st
  hz=$(getconf CLK_TCK 2>/dev/null || echo 100)
  up=$(cut -d' ' -f1 /proc/uptime 2>/dev/null)
  st=$(sed 's/^.*) //' /proc/1/stat 2>/dev/null | awk '{print $20}')
  if [ -n "$up" ] && [ -n "$st" ]; then awk -v u="$up" -v s="$st" -v h="$hz" 'BEGIN {printf "%d", u - s / h}'
  else ps -o etimes= -p 1 2>/dev/null | tr -d ' '; fi
}
busy_proc(){ pgrep -fa "$BUSY_RE" 2>/dev/null | grep -v -e pgrep -e pod_idle_guard | head -1; }

stop_pod(){
  local id=${RUNPOD_POD_ID:-}
  [ -n "$id" ] || { log "ERROR: no RUNPOD_POD_ID - cannot stop"; return 1; }
  local out rc
  if command -v runpodctl >/dev/null 2>&1; then
    out=$(timeout 60 runpodctl stop pod "$id" 2>&1); rc=$?; log "runpodctl stop pod -> rc=$rc ${out:0:160}"
    [ "$rc" -eq 0 ] && return 0
    out=$(timeout 60 runpodctl pod stop "$id" 2>&1); rc=$?; log "runpodctl pod stop -> rc=$rc ${out:0:160}"
    [ "$rc" -eq 0 ] && return 0
  fi
  if [ -n "${RUNPOD_API_KEY:-}" ] && command -v curl >/dev/null 2>&1; then
    local q="{\"query\":\"mutation { podStop(input: {podId: \\\"$id\\\"}) { id desiredStatus } }\"}"
    out=$(curl -sS --max-time 30 -H 'Content-Type: application/json' -H "Authorization: Bearer ${RUNPOD_API_KEY}" \
      -d "$q" https://api.runpod.io/graphql 2>&1); log "graphql podStop -> ${out:0:160}"
    case "$out" in *desiredStatus*) return 0 ;; esac
  fi
  return 1
}

if [ "${1:-}" = "--self-test" ]; then
  a=$(cpu_usec); n=$(net_bytes); sleep 5; b=$(cpu_usec); m=$(net_bytes)
  echo "pod id:        ${RUNPOD_POD_ID:-MISSING}"
  echo "pod key:       $([ -n "${RUNPOD_API_KEY:-}" ] && echo present || echo MISSING)"
  echo "age:           $(age_s) s (cap ${MAX_HOURS} h)"
  echo "gpu max util:  $(gpu_max || true)$( [ -z "$(gpu_max)" ] && echo 'no GPU telemetry') %"
  echo "cpu cores:     $( [ -n "$a" ] && [ -n "$b" ] && awk -v d=$((b - a)) 'BEGIN {printf "%.2f", d / 5e6}' || echo unavailable)"
  echo "net:           $(( (m - n) / 1024 / 5 )) KB/s"
  echo "busy process:  $(busy_proc || true)"
  echo "keep-alive:    $([ -e /workspace/KEEP_ALIVE ] && echo yes || echo no)"
  syn=none; ver=absent
  if command -v runpodctl >/dev/null 2>&1; then
    ver=$(runpodctl version 2>/dev/null | head -1)
    if runpodctl stop pod --help >/dev/null 2>&1; then syn="stop pod"
    elif runpodctl pod stop --help >/dev/null 2>&1; then syn="pod stop"; fi
  fi
  echo "runpodctl:     ${ver}; stop syntax: ${syn}"
  echo "curl:          $(command -v curl || echo absent)"
  exit 0
fi

exec 9>/tmp/pod_idle_guard.lock
flock -n 9 || { log "another guard is running; exiting"; exit 0; }
# the sleeps run with the lock's descriptor closed: a guard killed mid-sleep would otherwise leave its orphaned
# sleep holding the lock, and the supervisor's restart would be refused until the sleep ended

idle=0; warned=0
prev_net=$(net_bytes); prev_cpu=$(cpu_usec)
[ -n "$prev_cpu" ] || log "WARN: no cgroup CPU accounting - CPU work is not seen"
[ -n "$(gpu_max)" ] || log "WARN: no GPU telemetry (CPU pod or driver issue) - GPU counted as idle"
log "guard armed: pod ${RUNPOD_POD_ID:-?} stops after ${IDLE_MIN} idle min (gpu<${GPU_PCT}%, cpu<${CPU_CORES} cores, no work process, net<${NET_KBPS} KB/s) or at ${MAX_HOURS} h old"
while sleep 60 9>&-; do
  net=$(net_bytes); cpu=$(cpu_usec); age=$(age_s); age=${age:-0}
  kbps=$(( (net - prev_net) / 1024 / 60 )); prev_net=$net
  cores=0
  if [ -n "$cpu" ] && [ -n "$prev_cpu" ]; then cores=$(awk -v d=$((cpu - prev_cpu)) 'BEGIN {printf "%.2f", d / 60e6}'); fi
  prev_cpu=$cpu
  gpu=$(gpu_max); gpu=${gpu:-0}
  proc=$(busy_proc)
  reason=""
  [ "$gpu" -ge "$GPU_PCT" ] && reason="gpu ${gpu}%"
  [ -z "$reason" ] && awk -v c="$cores" -v t="$CPU_CORES" 'BEGIN {exit !(c >= t)}' && reason="cpu ${cores} cores"
  [ -z "$reason" ] && [ -n "$proc" ] && reason="process: ${proc:0:60}"
  [ -z "$reason" ] && [ "$kbps" -ge "$NET_KBPS" ] && reason="net ${kbps} KB/s"
  [ -z "$reason" ] && [ -e /workspace/KEEP_ALIVE ] && reason="KEEP_ALIVE"

  if [ "$MAX_HOURS" != "0" ] && awk -v a="$age" -v h="$MAX_HOURS" 'BEGIN {exit !(a >= h * 3600)}'; then
    action="cap"
  elif [ -n "$reason" ]; then
    [ "$idle" -gt 0 ] && log "busy again (${reason}) - idle clock reset after ${idle} min"
    idle=0; warned=0; action=""
  else
    idle=$((idle + 1)); action=""
    [ "$idle" -ge "$IDLE_MIN" ] && action="idle"
    if [ "$warned" = 0 ] && [ "$idle" -ge $(( IDLE_MIN > 10 ? IDLE_MIN - 10 : IDLE_MIN / 2 + 1 )) ]; then
      log "idle ${idle} min - will stop at ${IDLE_MIN} (touch /workspace/KEEP_ALIVE to hold)"; warned=1
    fi
  fi
  printf 'updated %s idle_min=%s/%s age_h=%.2f/%s last=%s\n' "$(date -u +%FT%TZ)" "$idle" "$IDLE_MIN" \
    "$(awk -v a="$age" 'BEGIN {print a / 3600}')" "$MAX_HOURS" "${reason:-idle}" > "$STATE" 2>/dev/null

  if [ -n "$action" ]; then
    log "stopping pod ${RUNPOD_POD_ID:-?}: $([ "$action" = cap ] && echo "hard cap ${MAX_HOURS} h reached (age ${age} s)" || echo "idle ${IDLE_MIN} min")"
    if [ "${DRY_RUN:-0}" = "1" ]; then log "DRY_RUN: would stop the pod now"; idle=0; warned=0; continue; fi
    if stop_pod; then log "stop requested"; sleep 120 9>&-; log "still running 2 min after the stop request - retrying"; fi
    log "stop failed (all paths); retrying in a minute"
  fi
done
