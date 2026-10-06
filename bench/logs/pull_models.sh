#!/usr/bin/env bash
# Pull the open-weight model ladder used in the benchmark (smallest first).
set -u
MODELS=(
  qwen2.5-coder:0.5b
  qwen2.5-coder:1.5b
  qwen3.5:2b-q4_K_M
  granite4.2:3b
  llama3.2:3b
  qwen2.5-coder:3b
  ministral-3:3b
  qwen3.5:4b-q4_K_M
  gemma4:e2b-it-q4_K_M
  qwen2.5-coder:7b
  lfm2.5:8b-a1b-q4_K_M
  gemma4:e4b-it-q4_K_M
  qwen3.5:9b-q4_K_M
)
for m in "${MODELS[@]}"; do
  echo "$(date +%T) pulling $m"
  ollama pull "$m" >/dev/null 2>&1 && echo "$(date +%T) OK $m" || echo "$(date +%T) FAIL $m"
done
echo "$(date +%T) ALL DONE"
