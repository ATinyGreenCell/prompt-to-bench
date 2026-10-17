#!/usr/bin/env bash
# Pod-side driver for the Qwen3.5-9B BOX-model training run. Transferred + run on a RunPod A40 beside
# train_vlm.py + train.jsonl. Hardened for the hiccups we hit (H19 max-seq, H20 grad-checkpoint, H26 pip).
#
# Env knobs: EPOCHS (default 3), RANK (default 32), DROPOUT (default 0.1), MAXSEQ (default 4096),
#            BATCH x ACCUM (default 2 x 4 = effective 8; on an 80 GB card 4 x 2 is the same batch, faster),
#            LAST_TURN_ONLY=1 for multi-turn repair data (loss on the final assistant turn only), or
#            MASK_EARLIER=1 (every-token loss as v1-v4, minus each non-final assistant turn),
#            DATA (default train.jsonl), SMOKE=1 to run the 2-step validation only (do this FIRST, H23).
#
# One-time, after creating the pod (image runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404, CUDA floor 12.8):
#   laptop: cd finetune && runpodctl send data/train.jsonl scripts/train_vlm.py scripts/pod_train_vlm.sh
#   pod:    runpodctl receive <code>  && SMOKE=1 bash pod_train_vlm.sh   # then  bash pod_train_vlm.sh
set -euo pipefail
cd "$(dirname "$0")"
export PIP_BREAK_SYSTEM_PACKAGES=1   # H26: the runpod/pytorch image python is PEP-668 externally-managed

echo "== GPU =="
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader || true

echo "== install unsloth + trl + datasets (proven recipe; H26) =="
pip install --break-system-packages -q "unsloth[cu121] @ git+https://github.com/unslothai/unsloth.git" trl datasets 2>&1 | tail -3
python -c "import unsloth,torch;print('unsloth',unsloth.__version__,'torch',torch.__version__)"

DATA="${DATA:-train.jsonl}"
LTO=""; [ "${LAST_TURN_ONLY:-0}" = "1" ] && LTO="--last-turn-only"
[ "${MASK_EARLIER:-0}" = "1" ] && LTO="--mask-earlier-assistant"
echo "== data: $DATA ($(wc -l < "$DATA") examples) =="
ls -la train_vlm.py "$DATA"

if [ "${SMOKE:-0}" = "1" ]; then
  echo "== SMOKE: validate the path + read steady-state s/it before paying (H23) =="
  python -u train_vlm.py --smoke --data "$DATA" --rank "${RANK:-32}" --max-seq "${MAXSEQ:-4096}" \
      --batch "${BATCH:-2}" --accum "${ACCUM:-4}" $LTO
  echo "== smoke done: require VISION_PRESERVED above + a sane s/it, then rerun with SMOKE=0 =="
  exit 0
fi

echo "== full run (epochs=${EPOCHS:-3} rank=${RANK:-32} dropout=${DROPOUT:-0.1} max-seq=${MAXSEQ:-4096}) =="
python -u train_vlm.py --data "$DATA" --epochs "${EPOCHS:-3}" --rank "${RANK:-32}" \
    --lora-dropout "${DROPOUT:-0.1}" --max-seq "${MAXSEQ:-4096}" --batch "${BATCH:-2}" --accum "${ACCUM:-4}" \
    $LTO --drop-over-max --out out_vlm

echo "== DONE; merged artifacts =="
ls -la out_vlm/merged16/*.safetensors 2>/dev/null || true
cat <<'NEXT'
RETRIEVE (do before terminating the pod):
  pod:    rm -f merged16.zip; runpodctl send out_vlm/merged16        # H28: clear any stale zip first
  laptop: mkdir -p ~/printpaper/finetune/out-3ep && cd $_ && runpodctl receive <code>   # /home, NOT scratchpad (H27)
IMPORT-READY + UPLOAD (laptop):
  python finetune/scripts/box_import_fix.py ~/printpaper/finetune/out-3ep/merged16 --repo ATinyGreenCell/<name>
  hf upload ATinyGreenCell/<name> ~/printpaper/finetune/out-3ep/merged16 . --repo-type=model
Then terminate the pod (confirm list-pods empty) and import on the box by HF URL.
NEXT
