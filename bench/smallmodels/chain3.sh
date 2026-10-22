#!/usr/bin/env bash
# chain2 with the template and features test runs moved before the grammar runs (2026-10-20 ~04:50).
# After features development the chain waits up to 3 h for both methods to be frozen. Each freeze writes
# <dir>/FROZEN.sha256 (a manifest of the method's files) and <dir>/FROZEN.model (the chosen Ollama model), after
# the development results have been reviewed. A method is tested only if its manifest still checks; a method not
# frozen in time is tested later, by hand.
set -u
SM=/home/seb/printpaper/bench/smallmodels
PP=/home/seb/printpaper
PY=$PP/.venv/bin/python
log(){ echo "$(date +%T) [chain] $*"; }
# Qwen3.5 4B is left out of both methods (2026-10-20 ~05:45): Ollama 0.30.11 does not apply the JSON schema to it,
# so it writes free text up to the token cap and no reply parses (PROTOCOL.md, notes).
cd "$SM/templates" || exit 1
log "template development (two passes)"
nice -n 5 "$PY" -I -u dev_templates.py --per-family 2 --outside 2 \
  --models gemma4:e4b-it-q4_K_M qwen2.5-coder:7b >> dev_templates.log 2>&1
cd "$SM/features" || exit 1
log "features development"
nice -n 5 "$PY" -I -u dev_features.py --per-family 2 --models gemma4:e4b-it-q4_K_M qwen2.5-coder:7b \
  >> dev_features.log 2>&1
log "waiting for the template and features freezes"
for _ in $(seq 1 180); do
  [ -f "$SM/templates/FROZEN.sha256" ] && [ -f "$SM/features/FROZEN.sha256" ] && break
  sleep 60
done
cd "$PP" || exit 1
for pair in template:templates features:features; do
  method=${pair%%:*}; dir=$SM/${pair#*:}
  if [ -f "$dir/FROZEN.sha256" ] && [ -f "$dir/FROZEN.model" ] && sha256sum -c --quiet "$dir/FROZEN.sha256"; then
    model=$(cat "$dir/FROZEN.model")
    log "test run $method:$model"
    OLLAMA_HOST=http://127.0.0.1:11434 OPENSCAD=/home/seb/.local/bin/openscad nice -n 5 "$PY" -I bench/run_bench.py \
      --run "sm-$method" --models "$method:$model" --samples 1 --max-repairs 2 >> "$dir/test_run.log" 2>&1
  else
    log "$method: not frozen, or its files changed since: no test run now"
  fi
done
log "grammar test runs"
bash "$SM/grammar/run_grammar.sh" >> "$SM/grammar/run_grammar.log" 2>&1
log "CHAIN DONE"
