#!/usr/bin/env bash
# Pod-side driver for RFT candidate generation. Transferred + run on the RunPod A40; everything it
# needs (rft_generate.py, rft_prompts.jsonl, system.md, adapter/) sits beside it in the extracted
# bundle. One command, non-interactive, so the SSH session can't hang on a half-typed pipeline (H1/H2).
# Reuses the exact unsloth install that the training run proved.
set -euo pipefail
cd "$(dirname "$0")"

echo "== GPU =="
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader || true

echo "== install unsloth (same recipe as the training run) =="
pip install -q "unsloth[cu121] @ git+https://github.com/unslothai/unsloth.git" peft 2>&1 | tail -4

echo "== sanity: bundle contents =="
ls -la rft_generate.py rft_prompts.jsonl system.md adapter/adapter_model.safetensors
echo "prompts: $(wc -l < rft_prompts.jsonl)"

echo "== generate (K=${K:-8}, micro-batch=${MB:-8}, temp=${TEMP:-0.8}) =="
python -u rft_generate.py --adapter adapter --prompts rft_prompts.jsonl \
    -o rft_gen.jsonl --k "${K:-8}" --micro-batch "${MB:-8}" \
    --temperature "${TEMP:-0.8}" --system system.md

echo "== DONE =="
echo "candidate lines: $(wc -l < rft_gen.jsonl)"
echo "send back with:  runpodctl send rft_gen.jsonl"
