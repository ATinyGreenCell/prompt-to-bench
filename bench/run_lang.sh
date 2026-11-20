#!/usr/bin/env bash
# Language ablation: the same tasks with localized requests. Default languages are
# Spanish, Hindi and Swahili, preserving the original paper's runner behavior.
# Opt in to Chinese with PTB_LANGUAGES=zh before the command.
# Prompts live in bench/prompts/translations.yaml. The system prompt stays in English, as when
# a student pastes the tutorial's starter prompt and writes the spec in their own language.
# Usage: bash bench/run_lang.sh <run-name> <model> [<model> ...]
# Stop the multi-language evaluation on its first failed language; never
# report success because a later language happened to pass.
set -euo pipefail
cd "$(dirname "$0")/.."
# Keep the laptop awake (no suspend on idle or lid close) while the benchmark runs.
INHIBIT=()
if command -v systemd-inhibit >/dev/null 2>&1; then
  INHIBIT=(systemd-inhibit --what=sleep:idle:handle-lid-switch --who=prompt-to-bench --why="benchmark running")
fi
RUN=${1:?usage: run_lang.sh <run-name> <models...>}; shift
[ $# -ge 1 ] || { echo "usage: run_lang.sh <run-name> <model> [<model> ...]" >&2; exit 2; }
# Reject empty, repeated or unknown languages before launching any model.
# This prevents a zero-run 'success' and accidental duplicate paid evaluations.
# Use Bash read -a (rather than unquoted expansion) to avoid filename globs.
LANG_SPEC=${PTB_LANGUAGES:-es hi sw}
if [[ "$LANG_SPEC" == *  ${INHIBIT[@]+"${INHIBIT[@]}"} .venv/bin/python bench/run_bench.py --run "$RUN" --lang "$lang" \
      --prompts bench/prompts/translations.yaml --models "$@"
done
\n'* || "$LANG_SPEC" == *  ${INHIBIT[@]+"${INHIBIT[@]}"} .venv/bin/python bench/run_bench.py --run "$RUN" --lang "$lang" \
      --prompts bench/prompts/translations.yaml --models "$@"
done
\r'* ]]; then
  echo "PTB_LANGUAGES must contain space-separated language IDs on one line" >&2
  exit 2
fi
read -r -a LANGS <<< "$LANG_SPEC"
if (( ${#LANGS[@]} == 0 )); then
  echo "PTB_LANGUAGES contains no language IDs" >&2
  exit 2
fi
SEEN_LANGS=" "
for lang in "${LANGS[@]}"; do
  case "$lang" in
    es|hi|sw|zh) ;;
    *)
      echo "Unsupported language: $lang (expected es, hi, sw or zh)" >&2
      exit 2
      ;;
  esac
  if [[ "$SEEN_LANGS" == *" $lang "* ]]; then
    echo "Duplicate language in PTB_LANGUAGES: $lang" >&2
    exit 2
  fi
  SEEN_LANGS+="$lang "
done
# Example: PTB_LANGUAGES="zh" bash bench/run_lang.sh zh-local qwen2.5-coder:7b
for lang in "${LANGS[@]}"; do
  ${INHIBIT[@]+"${INHIBIT[@]}"} .venv/bin/python bench/run_bench.py --run "$RUN" --lang "$lang" \
      --prompts bench/prompts/translations.yaml --models "$@"
done
