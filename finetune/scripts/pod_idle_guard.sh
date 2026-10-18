#!/usr/bin/env bash
# pod_idle_guard.sh - run INSIDE a RunPod pod; stops the pod after it has been idle for IDLE_MIN minutes.
#
# A pod bills by the second whether or not it works. A chain script that dies (a laptop reboot, a lost
# session) leaves a finished pod billing for hours (H32: ~4.5 h once). This guard needs no credentials
# from the laptop: RunPod injects RUNPOD_POD_ID and a pod-scoped RUNPOD_API_KEY into every pod, and
# `runpodctl stop pod $RUNPOD_POD_ID` stops it from the inside.
#
# Idle = GPU utilisation below GPU_PCT on every GPU AND no busy work process (training, pip, an HF
# download/upload) AND network traffic below NET_KBPS - checked every minute; any busy minute resets
# the clock. A `runpodctl send` that is actively transferring counts as busy (network); one that has
# waited IDLE_MIN minutes with no receiver does not.
#
# NOTE: stopping clears the container disk (RunPod: "container disk data is lost on stop and restart"),
# so a merged model that was never retrieved is gone. That is the deliberate trade: retrieve within
# IDLE_MIN of the run finishing (the chain scripts do it in minutes), or touch /workspace/KEEP_ALIVE to
# hold the pod (delete the file to re-arm).
#
# usage (on the pod):  setsid nohup bash pod_idle_guard.sh > /workspace/idle_guard.log 2>&1 &
# knobs: IDLE_MIN (45), GPU_PCT (5), NET_KBPS (200), DRY_RUN=1 (log only)
set -u
IDLE_MIN=${IDLE_MIN:-45}
GPU_PCT=${GPU_PCT:-5}
NET_KBPS=${NET_KBPS:-200}
# work that can run with an idle GPU; a vLLM server is NOT listed - serving shows up as GPU use, and an idle
# server (bench finished) must not hold the pod
BUSY_RE='train_vlm|train_lora|rft_generate|pip install|hf download|hf upload|huggingface-cli'
log(){ echo "$(date -u +%FT%TZ) $*"; }

# an SSH session does not carry the container's environment; RunPod's injected variables live in PID 1's
if [ -z "${RUNPOD_POD_ID:-}" ] || [ -z "${RUNPOD_API_KEY:-}" ]; then
  while IFS='=' read -r k v; do
    case "$k" in RUNPOD_POD_ID|RUNPOD_API_KEY) export "$k=$v" ;; esac
  done < <(tr '\0' '\n' < /proc/1/environ 2>/dev/null)
fi
exec 9>/tmp/pod_idle_guard.lock
flock -n 9 || { log "another guard is running; exiting"; exit 0; }

net_bytes(){ awk 'NR>2 && $1 !~ /^lo:/ {sub(/:/," "); rx+=$2; tx+=$10} END {print rx+tx}' /proc/net/dev; }

idle=0
prev=$(net_bytes)
log "guard armed: pod ${RUNPOD_POD_ID:-?} stops after ${IDLE_MIN} idle minutes (gpu<${GPU_PCT}%, no work process, net<${NET_KBPS} KB/s)"
while sleep 60; do
  now=$(net_bytes); kbps=$(( (now - prev) / 1024 / 60 )); prev=$now
  gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | sort -n | tail -1)
  gpu=${gpu:-0}
  busy=$(pgrep -fa "$BUSY_RE" | grep -v -e pgrep -e pod_idle_guard | head -1)
  if [ -e /workspace/KEEP_ALIVE ] || [ "$gpu" -ge "$GPU_PCT" ] || [ -n "$busy" ] || [ "$kbps" -ge "$NET_KBPS" ]; then
    [ "$idle" -gt 0 ] && log "busy again (gpu ${gpu}%, net ${kbps} KB/s, proc: ${busy:0:60}) - idle clock reset"
    idle=0
    continue
  fi
  idle=$((idle + 1))
  [ $((idle % 15)) -eq 0 ] && log "idle ${idle}/${IDLE_MIN} min"
  if [ "$idle" -ge "$IDLE_MIN" ]; then
    log "idle ${IDLE_MIN} min - stopping pod ${RUNPOD_POD_ID:-?}"
    if [ "${DRY_RUN:-0}" = "1" ]; then log "DRY_RUN: would run runpodctl stop pod ${RUNPOD_POD_ID:-?}"; idle=0; continue; fi
    runpodctl stop pod "${RUNPOD_POD_ID:?no RUNPOD_POD_ID in this environment}" && exit 0
    log "runpodctl stop failed; retrying in a minute"
  fi
done
