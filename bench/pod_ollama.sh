#!/usr/bin/env bash
# Serve an open-weight model with Ollama on a rented GPU, so the laptop bench can drive it remotely.
# Model inference is remote; rendering + scoring stay on the laptop's canonical OpenSCAD, so the pass
# numbers are comparable with every other run. Expose 11434 at pod creation (ports: "11434/http").
# MODEL env sets the tag (default qwen2.5-coder:32b).
set -euo pipefail
export OLLAMA_HOST=0.0.0.0:11434
if ! command -v ollama >/dev/null 2>&1; then
  curl -fsSL https://ollama.com/install.sh | sh
fi
pkill -f "ollama serve" 2>/dev/null || true
nohup env OLLAMA_HOST=0.0.0.0:11434 ollama serve > /root/ollama.log 2>&1 &
for i in $(seq 1 60); do curl -sf http://localhost:11434/api/version >/dev/null 2>&1 && break; sleep 2; done
echo "server version: $(curl -s http://localhost:11434/api/version)"
ollama pull "${MODEL:-qwen2.5-coder:32b}"
echo "READY serving ${MODEL:-qwen2.5-coder:32b}"
ollama list
