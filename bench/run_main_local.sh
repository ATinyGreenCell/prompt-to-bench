#!/usr/bin/env bash
# Main benchmark, local open-weight models (CPU only, one model at a time; timings are
# indicative, because other work on the laptop overlapped some runs).
# 16 tasks x 1 sample, up to 2 repair rounds with geometry-report feedback.
# Replies are streamed and capped at 2048 tokens; a reply ends early once a complete
# ```openscad block has arrived or when the model is stuck repeating itself verbatim.
# Ordered so the most informative models finish first; the Qwen3.5 models (which, with
# thinking switched off, reason inside code comments until the cap) run last.
set -u
cd "$(dirname "$0")/.."
# Keep the laptop awake (no suspend on idle or lid close) while the benchmark runs.
INHIBIT=()
if command -v systemd-inhibit >/dev/null 2>&1; then
  INHIBIT=(systemd-inhibit --what=sleep:idle:handle-lid-switch --who=prompt-to-bench --why="benchmark running")
fi
MODELS=(
  qwen2.5-coder:1.5b
  qwen2.5-coder:7b
  gemma4:e4b-it-q4_K_M
  qwen2.5-coder:3b
  ministral-3:3b
  gemma4:e2b-it-q4_K_M
  granite4.2:3b
  llama3.2:3b
  lfm2.5:8b-a1b-q4_K_M
  qwen2.5-coder:0.5b
  qwen2.5:1.5b
  qwen3.5:2b-q4_K_M
  qwen3.5:4b-q4_K_M
  qwen3.5:9b-q4_K_M
)
"${INHIBIT[@]}" .venv/bin/python bench/run_bench.py --run main --models "${MODELS[@]}" "$@"
