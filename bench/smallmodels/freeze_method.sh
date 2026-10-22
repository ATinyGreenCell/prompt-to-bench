#!/usr/bin/env bash
# Freeze a method for its test run (PROTOCOL.md, "Choosing the model to freeze"). Writes <dir>/FROZEN.sha256, a
# manifest of the files the method's backend runs (paths from the repo root, where chain3.sh checks it), and
# <dir>/FROZEN.model, the chosen Ollama model. Prints the manifest's own sha256 and the model's Ollama ID for the
# frozen-artefacts table.
#   usage: bash freeze_method.sh templates|features <ollama model>
set -eu
PP=/home/seb/printpaper
SM=bench/smallmodels
method=$1
model=$2
cd "$PP"
case $method in
  templates) files=("$SM/templates/backend.py" "$SM/templates/library.py" finetune/seeds/*.scad) ;;
  features) files=("$SM/features/compiler.py" "$SM/features/fbackend.py") ;;
  *) echo "unknown method: $method" >&2; exit 1 ;;
esac
files+=("$SM/common.py" "$SM/plugins.py" bench/run_bench.py)
id=$(curl -sf http://127.0.0.1:11434/api/tags | python3 -I -c '
import json, sys
d = [m for m in json.load(sys.stdin)["models"] if m["name"] == sys.argv[1]]
print(d[0]["digest"][:12] if d else "")' "$model")
[ -n "$id" ] || { echo "no such Ollama model: $model" >&2; exit 1; }
sha256sum "${files[@]}" > "$SM/$method/FROZEN.sha256"
echo "$model" > "$SM/$method/FROZEN.model"
echo "$method: ${#files[@]} files, manifest sha256 $(sha256sum "$SM/$method/FROZEN.sha256" | cut -c1-64)"
echo "model $model, Ollama ID $id, frozen $(date '+%Y-%m-%d %H:%M')"
