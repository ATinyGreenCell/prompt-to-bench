# Pipeline hiccups & hardening backlog

Running log of friction/bugs hit during real paid runs, with the fix to fold back in so the next
run is iron-clad. Started 2026-10-15 (first full paid training run, pod i3ow2g7ks7caeb).

Format: **Symptom → Impact → Root cause → Fix** (check when the fix is in the scripts/RUNBOOK).

---

## From the 2026-10-15 run

### H1. Proxy SSH `-tt 'cmd; exit'` argument form hangs — [ ] fix in RUNBOOK
- **Symptom:** `ssh -tt host 'cmd; exit'` never returns (120 s timeout); the heredoc-stdin form
  `ssh -tt host <<'EOF' … exit EOF` returns fine.
- **Impact:** my first training monitor used the argument form → it hung every poll, emitted nothing,
  looked like "training silent" for 30 min. Wasted a monitor cycle; could have hidden a real failure.
- **Root cause:** the RunPod SSH proxy needs a PTY *and* reads the command from stdin; with the command
  as an argv it allocates the PTY and waits on stdin that never closes.
- **Fix:** RUNBOOK: all pod commands use the heredoc-stdin form with a trailing `exit`. Never the argv form.

### H2. Proxy SSH echoes every piped line + PTY control bytes — [ ] fix in RUNBOOK
- **Symptom:** command lines appear 2–3× in output, interleaved with `\r`, `[?2004h`, prompt strings.
- **Impact:** naive `grep`/`head` match the echoes, not the results; cost several confused polls.
- **Root cause:** PTY echo + bracketed-paste mode.
- **Fix:** always `tr -d '\r'` and grep for *value* tokens that can't appear in the command text
  (e.g. `MiB`, `cuda=True`, a filename in `ls` output), or write to a file on the pod and `cat` it.

### H3. Detached job stdout is block-buffered in its logfile — [ ] fix in scripts
- **Symptom:** `base_ab.log` stayed empty for minutes though the job was running fine.
- **Impact:** can't gauge progress from the log; looked stalled.
- **Root cause:** Python buffers stdout when redirected to a file (no TTY). Progress only flushes in chunks.
- **Fix:** run detached jobs whose log we tail with `python -u` / `PYTHONUNBUFFERED=1`; and/or monitor the
  job's *output artifact* (e.g. `results/<run>/results.jsonl` record count) rather than its stdout.

### H4. unsloth `save_pretrained_gguf("out/gguf")` writes to `out/gguf_gguf/`, not `out/gguf/` — [ ] fix in train_lora.py + RUNBOOK
- **Symptom:** `out/gguf/` held only a ~176 MB fp16 intermediate; the real 4.68 GB
  `Qwen2.5-Coder-7B-Instruct.Q4_K_M.gguf` was in `out/gguf_gguf/`. My retrieve tar grabbed the wrong dir.
- **Impact:** first transfer bundled the wrong file; had to re-locate and re-send. (Caught by a size check.)
- **Root cause:** unsloth appends `_gguf` to the target dir for the quantized output.
- **Fix:** retrieve by `find out -name '*.gguf'` (never assume the dir). In train_lora.py, after export,
  print the actual gguf path(s) + sizes so the retrieve is unambiguous; RUNBOOK notes the `_gguf` suffix.

### H5. preflight token-length estimate (chars/3.3) under-read the real max — [ ] fix in preflight.py
- **Symptom:** preflight estimated max ~1860 tokens; the pod's real tokenizer reported **2479**.
- **Impact:** had I trusted the estimate and set `--max-seq 2048`, train_lora's no-truncation gate would
  have **aborted the run** (caught, not silent — but it would have wasted pod spin-up).
- **Root cause:** char/token ratio for OpenSCAD is denser than 3.3; the estimate is optimistic.
- **Fix:** preflight should apply a safety factor (report estimate ×1.5 as the suggested `--max-seq`
  floor) and state clearly that the pod's exact tokenizer is authoritative. Default run stays at 4096.

### H6. ~15–20 min of GPU-idle billing during save/merge/gguf — [ ] decide/optimize
- **Symptom:** after the last training step, GPU util drops to 0% while CPU does merge + gguf (quantize);
  we still pay $0.59/hr for the idle GPU.
- **Impact:** ~$0.15–0.20 of idle GPU per run.
- **Root cause:** merge/quantize are CPU-bound but run on the GPU pod.
- **Fix (optional):** export only the adapter on the pod (tiny), terminate immediately, and do the
  merge + gguf on the laptop from adapter + base. Trade-off: laptop merge is slow (CPU). Keep as-is
  unless we do many runs; note the option.

### H7. runpodctl on the pod prints "config file not found" — [ ] note (benign)
- **Symptom:** `runpodctl receive/send` prints `Runpod config file not found, please run runpodctl config`.
- **Impact:** none — send/receive use the relay and work without account config. Just alarming.
- **Fix:** RUNBOOK: note this line is benign for send/receive.

### H8. Training wall-clock underestimated — [ ] fix RUNBOOK estimate
- **Symptom:** told the user ~1.8–2 h; real training was 2.85 h (10262 s) + gen ≈ 3.3 h total.
- **Root cause:** estimate didn't multiply steps × s/it. 3 epochs × 7238 ex / (batch4×grad2=8) = 2715 steps;
  A40 ≈ 3.7 s/it → ~2.8 h just training.
- **Fix:** RUNBOOK estimate = steps × measured s/it + ~20 min gen/save; show the formula.

### H10. Ollama ignored the gguf's chat template (defaulted to `{{ .Prompt }}`) — [ ] fix in RUNBOOK/deploy  **(critical)**
- **Symptom:** `ollama create scadcoder` from the unsloth q4_k_m gguf produced `TEMPLATE {{ .Prompt }}`
  (raw passthrough), not ChatML — caught only by `ollama show --modelfile`.
- **Impact:** the deployed model would receive prompts with NO `<|im_start|>` role structure → garbage
  output, while the gguf itself is fine. The single most dangerous deploy skew.
- **Root cause:** the gguf didn't carry `chat_template` in metadata (or Ollama 0.30.11 didn't apply it).
- **Fix:** build the Modelfile from the stock `qwen2.5-coder:7b` template: `ollama show --modelfile qwen2.5-coder:7b`,
  swap the `FROM` to our gguf and set our `SYSTEM`, keep its TEMPLATE/PARAMETER. RUNBOOK step 6 MUST run
  `ollama show --modelfile <model> | grep im_start` and refuse to proceed if it's absent. (Done this run.)

### H9. runpodctl send/receive code coordination is manual & fiddly — [ ] optional helper
- **Symptom:** send blocks printing a code; must capture it and run receive on the other end; the
  pod→laptop direction needs a backgrounded send + log scrape.
- **Fix (optional):** a small `pod_xfer.sh` that scripts the send (bg, scrape code) and prints the exact
  receive command, both directions.

---

## From the 2026-10-15 RFT generation run (pod lf7kowa2qnyrp0)

### H11. Proxy SSH refuses a no-PTY session ("Your SSH client doesn't support PTY") — [ ] fix in RUNBOOK (refines H1)
- **Symptom:** the heredoc-stdin form *without* `-tt` returns instantly with `Error: Your SSH client
  doesn't support PTY` and runs nothing; add `-tt` and the same heredoc works.
- **Impact:** a first probe did nothing (exit 0, no output) — looks like success but ran no command.
- **Root cause:** the proxy requires a PTY; H1's hang was specifically the `-tt 'cmd;exit'` *argv* form.
  The two combine: you need `-tt` **and** the command on stdin (heredoc or `printf … | ssh`).
- **Fix:** canonical pod call = `timeout <n> ssh -tt … <<'EOF' … exit EOF` (or `printf … | timeout <n> ssh -tt …`).
  Always wrap in `timeout` so a hang can't eat a turn. RUNBOOK should show exactly this one form.

### H12. Background `sleep`-loop watchers exit silently/early — [ ] use Monitor instead
- **Symptom:** two `run_in_background` bash watchers (a pod-log poller and a sweep job-done watcher)
  both "completed exit 0" almost immediately; the sweep one produced *no output at all*. A foreground
  `sleep 3` works fine, so `sleep` itself isn't fully blocked.
- **Impact:** false "generation process dead" signal (see H13); nearly terminated a healthy $0.59/hr run.
- **Root cause:** not fully diagnosed — long-lived background bash loops here don't behave like a normal
  detached process; the harness's blessed wait primitive is the **Monitor tool** (and single-shot
  `run_in_background` with an `until grep` that exits on the condition), not hand-rolled `sleep` loops.
- **Fix:** wait on pod conditions with Monitor streaming `tail -f gen.log` (no `sleep` dependence), or a
  single-shot background `until` loop that keys on a **log marker**, never a PID. Grep must cover success
  *and* failure signatures (coverage rule) so a crash isn't silent.

### H13. `kill -0 <pid>` liveness check raced → false "DEAD" — [ ] don't gate on PID
- **Symptom:** the poller read `kill -0 169` as DEAD on its first poll while the detached job was in fact
  alive and already writing `rft_gen.jsonl`; a later direct check showed `PROC: ALIVE`.
- **Impact:** poller aborted the watch on a nonexistent failure.
- **Root cause:** racing the nohup'd wrapper during the pip→python handoff (and/or PID semantics across
  separate proxy login sessions). The detached bash wrapper's PID is not a reliable readiness signal.
- **Fix:** decide "done/failed" only from the job's own log lines (`candidate lines:` = done; `Traceback`/
  `Error:`/`Killed`/`CUDA out of memory`/`No space` = fail). Never from a cross-session PID probe.

### H14. Monitor/grep patterns get echoed by the PTY and self-match — [ ] keep filters laptop-side (refines H2)
- **Symptom:** putting the grep pattern *inside* the SSH heredoc makes the PTY echo the pattern text,
  which the monitor's own filter then matches as a false event.
- **Impact:** false "done"/"error" events from the command echo, not the log.
- **Root cause:** PTY echoes the whole remote command line (H2) including any literal markers in it.
- **Fix:** the remote command is only `tail -n 0 -f gen.log` (no markers in it); do the `tr -d '\r'` +
  `grep -E '<markers>'` on the **laptop** side of the pipe, so the echoed command can't contain them.

### H15. unsloth generate warns "Both max_new_tokens and max_length set" — [ ] note (benign)
- **Symptom:** every generate call logs `Both max_new_tokens (=2048) and max_length (=32768) seem to
  have been set. max_new_tokens will take precedence.`
- **Impact:** none — `max_new_tokens` wins, which is what we want; just alarming and it matches a naive
  `max_length` error-grep.
- **Root cause:** unsloth sets a default `max_length=32768`; we pass `max_new_tokens`. Both present → warning.
- **Fix:** note as benign; don't let a log-monitor's error pattern match the word `max_length`.

### H16. Backgrounded `runpodctl send` returns exit 0 right after printing the code — [ ] note (benign)
- **Symptom:** `runpodctl send … &` to a logfile "completes (exit 0)" within a second, before any receiver
  connects; the code line is already in the log and the transfer still succeeds when the pod runs `receive`.
- **Impact:** confusing — the quick "completed" looks like the send died.
- **Root cause:** send prints the code and backgrounds its relay daemon; the foreground returns.
- **Fix:** treat the printed `receive <code>` line, not the foreground exit, as the signal to proceed; the
  relay stays serveable. (Transfer this run: 145 MB at ~78 MB/s, ~2 s, RECV_EXIT=0.)

---

## From the 2026-10-16 Qwen3.5-9B box fine-tune (vision-language model)

### H17. A catalog model can be a VLM — `FastLanguageModel` would drop the vision encoder — [x] fixed in train_vlm.py
- **Symptom:** Qwen3.5-9B (the only arch the Tiiny box imports) ships as `Qwen3_5ForConditionalGeneration`
  with a `vision_config` even for text use.
- **Impact:** training it with `FastLanguageModel` (our text trainer) would load/merge only the LLM and
  drop `visual.*` tensors → the merged safetensors fails the box's "Qwen3.5-9B fine-tune" import.
- **Fix:** `train_vlm.py` loads with `FastVisionModel`, LoRA on language layers only, converts our
  string `content` to the typed-part vision format, trains via `UnslothVisionDataCollator`, saves
  `merged_16bit`, and **verifies `visual.*` tensors are in the output** (`VISION_PRESERVED`).

### H18. Length gate measured the batch dim, not the sequence length — [x] fixed
- **Symptom:** `LENGTHS max=1` (and a standalone check gave `max=2`) though real examples are ~700-2500 tokens.
- **Root cause:** a VLM processor's `apply_chat_template(tokenize=True)` returns a `BatchEncoding`/batched
  `[[...]]`, so `len()` counted keys/batch, not tokens.
- **Fix:** a robust `seqlen()` that unwraps dict→`input_ids`, tensor→`shape[-1]`, batched-list→inner len;
  cross-check the distribution with `tok(apply_chat_template(..., tokenize=False))` before trusting it.

### H19. unsloth silently caps `max_seq_length` to the model's native max → silent truncation — [x] fixed  **(money/quality)**
- **Symptom:** `Unsloth: You set max_seq_length as 4096 but the maximum the model supports is 2048. We shall
  reduce it.` — so the no-truncation gate (which passed at 4096, max 2530) was defeated; 139/7238 (1.9%)
  examples silently truncated at 2048, cutting the tails off the longest repair examples.
- **Fix:** set `--max-seq` to the model's **effective** cap (2048 here) and `--drop-over-max` to DROP the
  over-length examples instead of truncating; never assume the requested max_seq is the one used.

### H20. unsloth "smartly offload gradients" crawls at 315 s/step despite free VRAM — [x] fixed  **(money, critical)**
- **Symptom:** GPU at 100% but `315.79s/it`, ETA **77:43:09** (~78 h, ~$46) for an 888-step run; log says
  `Unsloth: Will smartly offload gradients to save VRAM!` while only **20/48 GB** VRAM was used.
- **Root cause:** `use_gradient_checkpointing="unsloth"` triggered CPU gradient offload even with ~28 GB free.
- **Fix:** `use_gradient_checkpointing=True` (HF-standard checkpointing, no offload) → **6.69 s/step**, ETA
  ~1.6 h — 47× faster. Lesson in H23.

### H21. gguf export fails on a 60 GB pod disk — [ ] provision ≥80 GB / convert separately
- **Symptom:** de-overfit run: `WARN gguf export failed (Unsloth: Not enough disk space to convert to GGUF.)`
  — adapter + merged16 saved, no gguf.
- **Root cause:** base (~5 GB) + merged16 (~15 GB fp16) + the gguf fp16 intermediate + q4 all at once > free space.
- **Fix:** give training pods that save merged16 **+** gguf ≥80 GB disk; or convert merged16→gguf separately
  after freeing the base cache; or skip gguf on the pod and convert from merged16 on the laptop (llama.cpp).

### H22. 1 epoch under-trains render (the overfit fix overshot) — [ ] tuning note
- **Symptom:** de-overfit Qwen2.5-7B at **1 epoch** rendered only 8/16 at attempt-1 vs scadcoder's 14/16 (3 ep).
- **Fix:** ~2 epochs is the likely sweet spot — enough OpenSCAD syntax to render, dropout to avoid the
  determinism overfit ([[scadcoder-overfit-determinism]]).

### H23. Always read the steady-state s/it before committing a long run — [x] practice
- **Symptom:** the 315 s/step run (H20) would have been 78 h / $46; caught at step 2 for pennies.
- **Fix:** after a run starts, let it pass warmup (~step 5-10), read `s/it`, project `steps × s/it`, and
  ABORT if unreasonable — before arming the long completion watch. GPU 100% + huge s/it ⇒ suspect offload.

### H24. Nested heredocs over the proxy PTY break — [x] use b64 (refines H1/H2/H11/H14)
- **Symptom:** a `python3 - <<'PY' … PY` inside an `ssh <<'EOF' … EOF` ran as shell, not python (garbled,
  wrong results).
- **Fix:** base64-encode the script locally, `echo "$B64" | base64 -d > file.py` on the pod, run the file.

### H25. RunPod HTTP proxy 403s the Python-urllib User-Agent — [x] fixed in run_bench.py
- **Symptom:** driving a pod's Ollama via `OLLAMA_HOST=https://<pod>-11434.proxy.runpod.net`, the bench got
  `HTTP 403` though `curl` to the same URL worked.
- **Root cause:** the proxy bot-blocks the default `Python-urllib` UA (curl/browser UAs pass).
- **Fix:** install a global urllib opener with a `curl/8.5.0` User-Agent (transport only, same requests).
  SSH `-L` port-forwarding through the RunPod proxy does **not** work (exits 144), so the UA fix is the way.

### H26. pip refuses to install on the runpod/pytorch image (PEP 668) — [x] use `--break-system-packages`
- **Symptom:** on `runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404`, `pip install unsloth …` exits 1 with
  "externally-managed-environment"; the smoke then dies `ModuleNotFoundError: No module named 'unsloth'`.
- **Root cause:** the image's torch lives in `/usr/local/bin/python`, which carries the PEP 668 marker.
- **Fix:** `pip install --break-system-packages …` (or `export PIP_BREAK_SYSTEM_PACKAGES=1`). Confirm with
  `python -c "import unsloth,torch;print(unsloth.__version__,torch.__version__)"` before the paid run.

### H27. Claude Code's scratchpad is tmpfs (~7.5 GB) — [x] pull big artifacts to /home  **(critical)**
- **Symptom:** `runpodctl receive` of the 18 GB merged model into the session scratchpad filled tmpfs,
  failed both transfer tasks, then EDQUOT'd so even command output could not be written.
- **Root cause:** the scratchpad (`/tmp/claude-…`) is RAM-backed tmpfs; only `/home` has the 741 GB.
- **Fix:** receive/unpack multi-GB artifacts under `/home` (e.g. `finetune/out-3ep/`), never the scratchpad;
  keep only small staging files (configs, a model card) in the scratchpad.

### H28. `runpodctl send <dir>` auto-zips; a stale zip blocks the retry — [x] clean `*.zip` first
- **Symptom:** after an aborted dir transfer, the next `runpodctl send out_vlm/merged16` printed a code then
  exited 1: `merged16.zip file already exists!`.
- **Root cause:** a directory send zips to `<name>.zip` on the sender first; the aborted run left it behind.
- **Fix:** `rm -f <name>.zip` on the pod before re-sending. (A dir send needs ~2× the size free for the zip on
  each end; transfer itself ran fast — ~80 MB/s for 19 GB.)

### H29. Box import = download **then a separate conversion** — [x] poll `status==downloaded`, not /api/tags
- **Symptom:** the model appeared in the bridge `/api/tags` right after download, but `t.load()` failed with
  `TiinyError: loading … failed: no success event`.
- **Root cause:** after the HF download the box runs a conversion phase (`import_phase: conversion`,
  `import_stage: replacing`, progress 0→100); it is listed but NOT loadable until that finishes.
- **Fix:** wait until the model's `tiiny` status shows `status == "downloaded"` (progress 100) — e.g. poll
  `t.models_raw("downloaded")` — before `t.load()`. The /api/tags presence is premature.

### H30. Box importer gates on HF-COMPUTED metadata, not raw config.json — [x] `box_import_fix.py`
- **Symptom:** a 5.x-transformers merge was rejected "This architecture is not supported yet" even after
  config.json's `architectures` matched the stock base.
- **Root cause:** the importer reads the repo *by HF URL* and keys off HF's computed `pipeline_tag` /
  `library_name` / `transformersInfo.auto_model`, which are null until the repo has a README with the right
  YAML frontmatter; it also wants the stock 4.57 config schema (`vision_config.model_type: qwen3_5`) plus the
  stock aux files (preprocessor_config, video_preprocessor_config, merges.txt, vocab.json).
- **Fix:** `finetune/scripts/box_import_fix.py MERGED_DIR` (downloads the stock files, writes the model card,
  verifies the merged tensor names match stock → IMPORT-READY), then `hf upload`. A LoRA-merge keeps the
  stock architecture, so the stock config fits the merged weights exactly.

### H31. Distilled training prompts copied the eval's wording — [x] Jaccard gate + category hygiene  **(critical)**
- **Symptom:** v3 passed 5 of 8 tasks in one half of the benchmark and 1 of 8 in the other (GPU tier, 8 samples).
- **Root cause:** `gen_prompts.py` wrote its families in the eval's own sentences (tube rack, funnel, gel comb, adapter
  sleeve, enclosure, D-shaft knob, rod clip, drill jig): token Jaccard 0.56-0.86 with 8 eval prompts, vs <= 0.22 for
  everything in v2's data. No eval dimensions leaked, but the template did — so v3's passes there are in-family.
- **Fix:** `gen_prompts_clean.py` gates every prompt at Jaccard <= 0.40 vs `bench/tasks.yaml` (max reached 0.364) and
  uses part types that are not eval tasks; `build_v4.py` reuses none of v3's distilled set (below the gate it still held
  L-brackets and tube couplers, the same kind of part as two tasks). Report results on the fixed in-family/held-out
  split (`bench/finetune_table.py`).

### H32. A watcher dies with its session; the pod bills on — [x] chain work, check list-pods at start
- **Symptom:** the v3 pod finished training, then idled ~4.5 h (~$2.70) after the laptop rebooted.
- **Fix:** put follow-on steps in ONE background script (retrieve -> next job), and run `list-pods` first thing in a
  new session. Pods created by an earlier session cannot be deleted by a later one in auto mode (the classifier
  blocks it) — put them to work, or ask the user to terminate.

### H33. The build-log export leaked tokens pasted into the chat — [x] redact hf_/rpa_/UUID keys
- **Symptom:** `meta/BUILD_LOG.md` (regenerated by a Stop hook) contained an HF write token and the box's API key.
- **Fix:** `meta/build_log.py` now redacts `hf_…`, `rpa_…`/`rps_…` and UUID-shaped keys; grep staged files for token
  patterns before every push; never type token fragments in commands (they are exported too). Revoke anything pasted.

### H34. The box answered but every model call returned 502 for hours — [x] log in on the TiinyOS app
- **Symptom:** after a power cycle, `:39218/device.json` and nginx answered, but every vhost (`openai.api.tiiny`,
  `api.tiiny`, `p8800.api.tiiny`) returned HTTP 502 for 3+ hours. Sealed appliance: no remote fix.
- **Root cause (found 2026-10-17 evening):** after a power cycle the box keeps its model services down until an
  account **logs in on the TiinyOS app**; two power cycles changed nothing, the app login brought the services up
  within a minute (502 -> connection reset -> 401 for unauthenticated probes -> working with the device key).
- **Fix:** after any box power cycle, open the TiinyOS app and log in, then check `tk doctor`. While the box is down,
  the GPU tier still works: serve the merged weights with vLLM and drive the unchanged harness through
  `bench/ollama_openai_shim.py` (RUNBOOK B5). Label those results "GPU, 16-bit" — not box numbers.

### H35. Shell footguns on the pod — [x] noted
- `pkill -f "vllm serve"` over ssh kills the ssh shell itself (its command line matches): use `pkill -f "[v]llm serve"`.
- Never overwrite a bash script that is still running (bash reads it as it goes): stage the next run in a new folder.
- In `cd X && cmd &`, the `cd` happens in the background subshell only: use absolute paths for detached jobs.

### H36. An 80 GB card trains 6x faster at the same effective batch — [x] BATCH/ACCUM knobs
- A40 (48 GB) at batch 2 x accum 4: 6.3 s/step; H100 SXM at 4 x 2: 1.1 s/step (same effective batch 8). A 9k-row,
  3-epoch run is ~1 h (~$4-6) on the H100 vs ~6 h (~$3.50) on the A40 — pay for the H100 when time matters.
  Both spend ~9 min compiling before step 1.

### H37. The VLM trainer's loss covers every token — [x] documented; MASK_EARLIER for multi-turn data
- `UnslothVisionDataCollator(model, tok)` with no response masking trains on the system prompt and the user turn too
  (DATA_CHECK: non_masked_labels = all non-pad tokens). v1-v4 all trained this way, so they stay comparable.
- Multi-turn repair data must not train its flawed assistant turn: `--mask-earlier-assistant` (MASK_EARLIER=1) masks
  each non-final assistant turn and nothing else; `--last-turn-only` is the completion-only alternative. The trainer
  aborts unless its MASK_CHECK finds the earlier turn fully masked and the last one live.

### H38. `runpodctl send` prints its code BEFORE the zip exists — [x] wait for "Sending '" before receiving
- **Symptom:** an automated receive started the moment the code appeared and died at once:
  `croc: receive: room not ready`; the chain then reported 0 shards.
- **Root cause:** for a directory, `runpodctl send` prints the code first, then zips (an 18 GB merge takes ~1 min), and
  only opens the relay room once the zip is done (its log then says `Sending 'merged16.zip'`).
- **Fix:** poll the sender's log for `Sending '` before running `runpodctl receive`, and retry the receive (the
  sender keeps waiting after a "room not ready" refusal). Done in the chain scripts used for v5-v7.

### H39. Box import without the app — [x] `box_import.py` (proven 2026-10-17)
- The TiinyOS app's Import Model step is two API calls; `finetune/scripts/box_import.py` makes them with the device
  key: `POST api.tiiny/api/v1/models/import/inspect {hf_url}` (returns `import_support.base_model_id/toolkit_id`,
  storage needs, LoRA detection), then a streamed `POST /api/v1/models/import`. Leave empty fields out of the body
  (the app's JSON.stringify drops undefined ones). Run inspect-only first; `--go` imports. v5 and v6 went in this way.
