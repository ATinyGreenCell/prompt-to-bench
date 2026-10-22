#!/usr/bin/env bash
# After the spec development run (unit smallmodels-spec-dev): the v2 spec prompt on Gemma 4 E4B (comparison with
# v1 on the same 56 descriptions), then the template development test - one after another, never sharing Ollama.
while systemctl --user is-active --quiet smallmodels-spec-dev; do sleep 60; done
cd /home/seb/printpaper/bench/smallmodels/spec || exit 1
nice -n 5 /home/seb/printpaper/.venv/bin/python -I -u dev_specs.py --per-family 4 --prompt v2 --models gemma4:e4b-it-q4_K_M >> dev_specs.log 2>&1
cd /home/seb/printpaper/bench/smallmodels/templates || exit 1
exec nice -n 5 /home/seb/printpaper/.venv/bin/python -I -u dev_templates.py --per-family 2 --outside 2 --models gemma4:e4b-it-q4_K_M qwen3.5:4b-q4_K_M qwen2.5-coder:7b
