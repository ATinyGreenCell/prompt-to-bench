#!/usr/bin/env bash
# Language ablation: the same 16 tasks with the request written in Spanish, Hindi or
# Swahili (bench/prompts/translations.yaml). The system prompt stays in English, as when
# a student pastes the tutorial's starter prompt and writes the spec in their own language.
# Usage: bash bench/run_lang.sh <run-name> <model> [<model> ...]
set -u
cd "$(dirname "$0")/.."
RUN=${1:?usage: run_lang.sh <run-name> <models...>}; shift
for lang in es hi sw; do
  .venv/bin/python bench/run_bench.py --run "$RUN" --lang "$lang" \
      --prompts bench/prompts/translations.yaml --models "$@"
done
