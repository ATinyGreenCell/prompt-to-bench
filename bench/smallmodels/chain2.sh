#!/usr/bin/env bash
# The rest of chain.sh from the template step (2026-10-20 ~03:40): dev_templates.py now makes every pick before any
# fill, so Ollama reuses the cached catalog prompt. Then features development and the grammar test runs.
set -u
SM=/home/seb/printpaper/bench/smallmodels
PY=/home/seb/printpaper/.venv/bin/python
log(){ echo "$(date +%T) [chain] $*"; }
cd "$SM/templates" || exit 1
log "template development (two passes)"
nice -n 5 "$PY" -I -u dev_templates.py --per-family 2 --outside 2 \
  --models gemma4:e4b-it-q4_K_M qwen3.5:4b-q4_K_M qwen2.5-coder:7b >> dev_templates.log 2>&1
cd "$SM/features" || exit 1
log "features development"
nice -n 5 "$PY" -I -u dev_features.py --per-family 2 >> dev_features.log 2>&1
log "grammar test runs"
bash "$SM/grammar/run_grammar.sh" >> "$SM/grammar/run_grammar.log" 2>&1
log "CHAIN DONE"
