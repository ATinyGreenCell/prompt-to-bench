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
