#!/usr/bin/env bash
# Run the features development test once the template development run has finished (they share Ollama).
while systemctl --user is-active --quiet smallmodels-spec-dev || systemctl --user is-active --quiet smallmodels-template-dev; do sleep 60; done
cd /home/seb/printpaper/bench/smallmodels/features || exit 1
exec nice -n 5 /home/seb/printpaper/.venv/bin/python -I -u dev_features.py --per-family 2
