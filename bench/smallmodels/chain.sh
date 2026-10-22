#!/usr/bin/env bash
# One ordered chain for the laptop, so that no two Ollama jobs ever run at once. It replaces the separate units
# smallmodels-spec-dev, -template-dev, -features-dev and -grammar-runs (2026-10-20 ~01:20), to bring the Gemma
# v3 spec run forward:
#   1. spec v1 on Qwen3.5 9B (resuming the interrupted run; Qwen2.5-Coder 7B was dropped as a spec writer);
#   2. spec v2 and v3 on Gemma 4 E4B;
#   3. template development; 4. features development; 5. the grammar test runs.
set -u
SM=/home/seb/printpaper/bench/smallmodels
PY=/home/seb/printpaper/.venv/bin/python
log(){ echo "$(date +%T) [chain] $*"; }
cd "$SM/spec" || exit 1
log "spec v1 qwen3.5:9b"
nice -n 5 "$PY" -I -u dev_specs.py --per-family 4 --models qwen3.5:9b-q4_K_M >> dev_specs.log 2>&1
for v in v2 v3; do
  log "spec $v gemma4:e4b"
  nice -n 5 "$PY" -I -u dev_specs.py --per-family 4 --prompt "$v" --models gemma4:e4b-it-q4_K_M >> dev_specs.log 2>&1
done
cd "$SM/templates" || exit 1
log "template development"
nice -n 5 "$PY" -I -u dev_templates.py --per-family 2 --outside 2 \
  --models gemma4:e4b-it-q4_K_M qwen3.5:4b-q4_K_M qwen2.5-coder:7b >> dev_templates.log 2>&1
cd "$SM/features" || exit 1
log "features development"
nice -n 5 "$PY" -I -u dev_features.py --per-family 2 >> dev_features.log 2>&1
log "grammar test runs"
bash "$SM/grammar/run_grammar.sh" >> "$SM/grammar/run_grammar.log" 2>&1
log "CHAIN DONE"
