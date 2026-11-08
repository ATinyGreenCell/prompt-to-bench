#!/usr/bin/env bash
set -euo pipefail
model_file=$1
run_name=$2
root=$(git rev-parse --show-toplevel)
cd "$root"
export QT_QPA_PLATFORM=offscreen
export OMP_NUM_THREADS=4
export OPENBLAS_NUM_THREADS=4

CUDA_VISIBLE_DEVICES=0 OMP_NUM_THREADS=4 python -m llama_cpp.server \
  --model "$model_file" --model_alias qwen3.5:2b-q4_K_M \
  --host 127.0.0.1 --port 18539 --n_gpu_layers -1 \
  --n_ctx 8192 --n_threads 4 --seed 1000 \
  --chat_template_kwargs '{"enable_thinking":false}' > llama_server.log 2>&1 &
model_pid=$!
python bench/ollama_openai_shim.py \
  --upstream http://127.0.0.1:18539 --port 18540 > shim.log 2>&1 &
adapter_pid=$!
trap 'kill "$model_pid" "$adapter_pid"' EXIT

python bench/build_refs.py
OMP_NUM_THREADS=4 OPENBLAS_NUM_THREADS=4 OLLAMA_HOST=http://127.0.0.1:18540 \
  python bench/run_bench.py --run "$run_name" --models qwen3.5:2b-q4_K_M \
  --samples 8 --max-repairs 2 --feedback report --temperature 0.2 \
  --seed-base 1000 --num-predict 2048 --num-ctx 8192
python bench/sample_stats.py "$run_name" --json "bench/results/$run_name/task_stats.json"
cp bench/results/hoyantsu-h100-qwen35-2b/summarize.py "bench/results/$run_name/summarize.py"
python "bench/results/$run_name/summarize.py"
