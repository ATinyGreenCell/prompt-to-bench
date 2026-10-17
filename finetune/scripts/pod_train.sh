#!/usr/bin/env bash
# Pod-side driver for the (re)training run. Transferred + run on the RunPod A40 beside train.jsonl,
# eval_prompts.json and train_lora.py. One hardened command (SSH footguns H1/H2/H11/H14).
# Env knobs: EPOCHS (default 3), MAXSEQ (default 4096 — set to preflight's p99-rounded value),
# COMPLETION_ONLY=1 to mask loss to the assistant turn.
set -euo pipefail
cd "$(dirname "$0")"

echo "== GPU =="
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader || true

echo "== install unsloth + trl + datasets (same recipe as the training run) =="
pip install -q "unsloth[cu121] @ git+https://github.com/unslothai/unsloth.git" trl datasets 2>&1 | tail -4

echo "== sanity: bundle contents =="
ls -la train_lora.py train.jsonl eval_prompts.json
echo "train examples: $(wc -l < train.jsonl)"

EXTRA=""
[ "${COMPLETION_ONLY:-0}" = "1" ] && EXTRA="--completion-only"
[ "${BF16LORA:-0}" = "1" ] && EXTRA="$EXTRA --bf16-lora"
[ -n "${BASE:-}" ] && EXTRA="$EXTRA --base ${BASE}"
echo "== train (base=${BASE:-default}, epochs=${EPOCHS:-3}, max-seq=${MAXSEQ:-4096}, dropout=${DROPOUT:-0}) $EXTRA =="
python -u train_lora.py --data train.jsonl --eval eval_prompts.json \
    --epochs "${EPOCHS:-3}" --max-seq "${MAXSEQ:-4096}" --lora-dropout "${DROPOUT:-0}" --out out $EXTRA

echo "== DONE; saved artifacts =="
ls -la out/ 2>/dev/null || true
echo "gguf files:"; find out -name '*.gguf' -exec ls -la {} \; 2>/dev/null || true
echo "retrieve with:  runpodctl send out"
