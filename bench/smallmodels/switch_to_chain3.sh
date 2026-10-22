#!/usr/bin/env bash
# When chain2 reaches features development (the template run is complete), replace it with chain3, which runs the
# template and features tests before the grammar runs. dev_features.py resumes; at most its first item is redone.
SM=/home/seb/printpaper/bench/smallmodels
until grep -q "features development" "$SM/chain.log"; do sleep 10; done
systemctl --user stop smallmodels-chain
sleep 2
systemctl --user reset-failed smallmodels-chain 2>/dev/null
echo "$(date +%T) [chain] switching to chain3.sh" >> "$SM/chain.log"
systemd-run --user --unit=smallmodels-chain -p StandardOutput=append:$SM/chain.log -p StandardError=append:$SM/chain.log \
  -- systemd-inhibit --what=sleep:idle:handle-lid-switch --who=prompt-to-bench --why="small-model methods chain" \
  bash "$SM/chain3.sh"
