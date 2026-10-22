#!/usr/bin/env bash
# Test runs of intervention 2b (bench/smallmodels/PROTOCOL.md): grammar-constrained decoding, frozen grammar v1
# (openscad.gbnf, sha256 ffade52b...). Paper protocol on the laptop CPU (16 tasks, temperature 0.2, top-p 0.95, a
# seed per attempt, 8,192-token context, 2,048-token replies, thinking off, report feedback, 3 attempts), with the
# model served by PrismML's llama.cpp fork through bench/ollama_openai_shim.py - the same path with and without
# the grammar, so the grammar is the only difference:
#   1. Qwen2.5-Coder 7B (the Ollama Q4_K_M file), no grammar  -> results/grammar-off
#   2. Qwen2.5-Coder 7B, grammar                              -> results/grammar-on
#   3. Bonsai 2 27B ternary, grammar                           -> results/grammar-on (its baseline is main-bonsai,
#      run on this same server path without a grammar)
# Waits until the development runs that use Ollama have finished, and unloads Ollama's models first: a 7B GGUF and
# Ollama's resident model do not both fit in the laptop's memory.
set -u
PP=/home/seb/printpaper
G=$PP/bench/smallmodels/grammar
LS=/home/seb/src/prismml-llama.cpp/build/bin/llama-server
log(){ echo "$(date +%T) [grammar] $*"; }
cleanup(){
  pkill -f "[o]llama_openai_shim.py --upstream http://127.0.0.1:18020" 2>/dev/null
  systemctl --user stop smallmodels-llama 2>/dev/null
}
trap cleanup EXIT
trap 'exit 1' TERM INT HUP
cd "$PP" || exit 1
for u in smallmodels-spec-dev smallmodels-template-dev smallmodels-features-dev; do
  while systemctl --user is-active --quiet "$u"; do sleep 60; done
done
for m in $(curl -s http://127.0.0.1:11434/api/ps | python3 -c "import json,sys; print(' '.join(x['name'] for x in json.load(sys.stdin).get('models', [])))"); do
  curl -s http://127.0.0.1:11434/api/generate -d "{\"model\": \"$m\", \"keep_alive\": 0}" > /dev/null
done
log "Ollama models unloaded"

serve(){  # serve(gguf, alias, extra args...)
  local gguf=$1 alias=$2; shift 2
  systemctl --user reset-failed smallmodels-llama 2>/dev/null
  systemd-run --user --unit=smallmodels-llama -p StandardOutput=append:$G/llama_server.log \
    -p StandardError=append:$G/llama_server.log -- \
    "$LS" -m "$gguf" -c 8192 -t 12 -np 1 --jinja --cache-ram 0 --host 127.0.0.1 --port 18020 --alias "$alias" "$@"
  for _ in $(seq 1 90); do
    curl -s --max-time 3 http://127.0.0.1:18020/v1/models | grep -q "\"$alias\"" && return 0
    sleep 5
  done
  log "FAILED: llama-server did not come up for $alias"; return 1
}
shim(){  # shim(port, grammar file or "")
  pkill -f "[o]llama_openai_shim.py --upstream http://127.0.0.1:18020" 2>/dev/null; sleep 1
  local extra=(); [ -n "$2" ] && extra=(--grammar "$2")
  setsid nohup .venv/bin/python -I bench/ollama_openai_shim.py --upstream http://127.0.0.1:18020 --port "$1" "${extra[@]}" \
    >> "$G/shim.log" 2>&1 < /dev/null &
  for _ in $(seq 1 30); do curl -s --max-time 3 "http://127.0.0.1:$1/api/tags" > /dev/null && return 0; sleep 1; done
  log "FAILED: shim did not come up on $1"; return 1
}
bench(){  # bench(port, run, model)
  log "run $2 $3"
  OLLAMA_HOST=http://127.0.0.1:$1 OPENSCAD=/home/seb/.local/bin/openscad .venv/bin/python -I bench/run_bench.py \
    --run "$2" --models "$3" --samples 1 --max-repairs 2
}

CODER=$(ollama show --modelfile qwen2.5-coder:7b | awk '/^FROM /{print $2; exit}')
serve "$CODER" qwen2.5-coder-7b-llamacpp || exit 1
shim 11520 "" && bench 11520 grammar-off qwen2.5-coder-7b-llamacpp
shim 11521 "$G/openscad.gbnf" && bench 11521 grammar-on qwen2.5-coder-7b-llamacpp
systemctl --user stop smallmodels-llama; sleep 3

serve /home/seb/models/bonsai2-27b/Ternary-Bonsai-2-27B-PQ2_0.gguf bonsai2-27b-pq2_0 || exit 1
shim 11521 "$G/openscad.gbnf" && bench 11521 grammar-on bonsai2-27b-pq2_0
log "GRAMMAR RUNS DONE"
