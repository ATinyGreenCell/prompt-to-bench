#!/usr/bin/env bash
# R2 (PROTOCOL.md, round 2): resample instead of repair, with the frozen templates 1 and features 1. Eight fresh
# samples per task (--samples 8 --max-repairs 0) at temperature 0.2 and at 0.7. Waits for the laptop chain (the
# grammar runs) to finish; a method runs only while its manifest still checks.
set -u
PP=/home/seb/printpaper
SM=$PP/bench/smallmodels
PY=$PP/.venv/bin/python
log(){ echo "$(date +%T) [round2] $*"; }
while systemctl --user is-active --quiet smallmodels-chain; do sleep 60; done
log "laptop chain done"
cd "$PP" || exit 1
for spec in features:features:sm-features-r8:0.2 features:features:sm-features-r8t7:0.7 \
            template:templates:sm-template-r8:0.2 template:templates:sm-template-r8t7:0.7; do
  IFS=: read -r method dir run temp <<< "$spec"
  if ! sha256sum -c --quiet "$SM/$dir/FROZEN.sha256"; then
    log "$method: manifest does not check, $run not run"; continue
  fi
  model=$(cat "$SM/$dir/FROZEN.model")
  log "run $run $method:$model temperature $temp"
  OLLAMA_HOST=http://127.0.0.1:11434 OPENSCAD=/home/seb/.local/bin/openscad nice -n 5 "$PY" -I bench/run_bench.py \
    --run "$run" --models "$method:$model" --samples 8 --max-repairs 0 --temperature "$temp" >> "$SM/round2.log" 2>&1
done
log "ROUND 2 RESAMPLING DONE"
