# Paid training run — de-footgunned runbook

The data pipeline is free (laptop); the **RunPod training run is the only step that spends money**.
This runbook is the GO/NO-GO checklist so a run can't fail in a way that wastes it. Work top to
bottom; don't skip the gate.

## Money footguns this guards against
1. **Shipping broken data** → `preflight.py` must print `GO` first.
2. **Silent truncation** → `train_lora.py` tokenizes every example and *aborts* if any exceeds `--max-seq`.
3. **Paying then losing the model** → `train_lora.py` saves adapter + merged16 + gguf; **retrieve before terminating**.
4. **Leaving the pod billing** → explicit terminate step, confirmed by an empty `list-pods`.
5. **Deploy skew** → the Ollama model must use the Qwen2.5 ChatML template; the benchmark passes the
   exact `bench/prompts/system.md` system prompt, same as training.
6. **An uncomparable number** → the authoritative eval is the real `bench/run_bench.py` (3-attempt),
   not the pod's attempt-1 A/B (that's only a quick "did it learn" signal).

## 0. GO gate (laptop, free)
```
~/printpaper/.venv/bin/python -I finetune/scripts/preflight.py --max-seq 4096 --render-sample 30
```
Must end in `GO`. Note the `LENGTH` line's `p99`/`max`: set the run's `--max-seq` to the next
multiple of 256 above `max` (validation fit in 2048; feedback examples may push higher).

## 1. Pod (≈$0.59/hr, A40 48 GB, SECURE, CA-MTL-1)
- Create via RunPod MCP `create-pod`, image `runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404`,
  **`gpu.minCudaVersion: "12.8"`** (a modern image on a CUDA-11 host silently fails).
- Cost: training ≈ $0.000051/example-epoch → ~7k ex × 3 ep ≈ $1.1; whole session (setup + train + A/B gen +
  save/merge + download) ≈ $1.3–1.5. (Balance $15.) Wall-clock ≈ 1.5–2 h (training alone ≈ 1.8 h on the A40;
  drop to 2 epochs for ≈ 1.2 h / ≈ $0.9 if you want it faster). Do NOT terminate until step 4 confirms the download.

## 2. Send data + script to the pod (runpodctl; MCP can't move files)
```
cd ~/printpaper/finetune
runpodctl send data/train.jsonl data/eval_prompts.json scripts/train_lora.py
# on the pod: runpodctl receive <code>  ; then
pip install -q "unsloth[cu121] @ git+https://github.com/unslothai/unsloth.git" trl datasets
```
(Use the same Unsloth/TRL versions as the validation run if pinned.)

## 3. Train (on the pod)
```
python train_lora.py --data train.jsonl --eval eval_prompts.json --epochs 3 --max-seq <from preflight> --out out
```
Watch for: `LENGTHS: ... over_max_seq=0` (no `ABORT`), `SAVED adapter`, `SAVED merged16`,
`SAVED gguf`, then `DONE`. If `gguf export failed`, that's fine — convert from `merged16` on the laptop.
Optional `--completion-only` trains only on the assistant turn; it self-checks the mask and aborts if
the template isn't found. Default (off) is the exact recipe that validated.

## 4. RETRIEVE before terminating (the irreversible step)
```
# on the pod:
runpodctl send out
# on the laptop:
cd ~/printpaper/finetune && runpodctl receive <code>
ls out/{adapter,merged16,gguf,outputs_base.json,outputs_ft.json,meta.json}   # must all exist
```
Do **not** proceed until every path is present locally.

## 5. Terminate the pod (stop billing)
RunPod MCP `delete-pod` (or `pod-action` stop→terminate). Confirm with `list-pods` → the pod is gone.

## 6. Deploy on the laptop (Ollama)
```
cd ~/printpaper/finetune/out
# if gguf/ has a .gguf: use it; else convert merged16:
#   python ~/llama.cpp/convert_hf_to_gguf.py merged16 --outfile scadcoder.gguf --outtype q8_0
printf 'FROM ./%s\nSYSTEM """%s"""\n' "$(ls gguf/*.gguf | head -1 2>/dev/null || echo scadcoder.gguf)" \
  "$(cat ~/printpaper/bench/prompts/system.md)" > Modelfile
ollama create scadcoder -f Modelfile
ollama show --modelfile scadcoder | grep -A2 TEMPLATE   # must be Qwen2.5 ChatML; if blank, set it explicitly
```
The benchmark passes its own system prompt per request, so the Modelfile SYSTEM is only a default;
the **TEMPLATE (ChatML) is the thing that must be right** or every prompt is malformed.

## 7. Authoritative eval (laptop, the comparable number)
```
# fine-tuned vs the stock base, both in Ollama, real 3-attempt protocol on the 16 held-out tasks:
~/printpaper/.venv/bin/python -I bench/run_bench.py --model scadcoder     --run ft-scad   --samples 3
~/printpaper/.venv/bin/python -I bench/run_bench.py --model qwen2.5-coder:7b --run base-scad --samples 3
```
Quick signal meanwhile: `python -I finetune/scripts/score_outputs.py out/outputs_base.json out/outputs_ft.json`.

## Validation-run reference (already done, A40)
base 2/16 render · 0/16 pass → fine-tune 13/16 render · 1/16 pass (attempt-1), 1464 ex / 2 ep, 15 min, $0.15.
This run scales data to ~7k and uses the full 3-attempt eval, so expect a higher pass rate.

---

# RFT round — rejection-sampling fine-tune (STaR)

Teach scadcoder from its OWN correct generations: sample K per prompt, keep only the ones that build
the right part (verified against a known-correct reference by `rft_score.py`), retrain on those,
iterate. ~$4/iteration (~$2 generate + ~$2 retrain); the verify + harvest + eval are free (laptop).
Budget ceiling **$112.59** (spend to date $2.41 → ~$110 headroom).

## Money footguns this round adds
7. **Rewarding a wrong part** → `rft_score.py` is validated on 18 parts (self-match 18/18, wrong-dim
   18/18 rejected, low-$fn 17/17 rejected via the triangle floor). Don't loosen its tolerances.
8. **An RFT prompt file poisoning the dataset** → RFT files live in `finetune/rft/` (they carry
   `ref_scad`, which `build_dataset.py` can't format). Only the harvested `{messages}` file is copied
   into `finetune/data/`, and only at retrain time.
9. **Paying for idle GPU during the free harvest** → generation pod is TERMINATED right after
   `rft_gen.jsonl` comes back; harvest + gate run on the laptop with no pod up.

## R0. Build the prompt set (laptop, free)
```
~/printpaper/.venv/bin/python -I finetune/scripts/build_rft_prompts.py --per-family 8 --rng 20261015
```
Must end `GO`. Writes `finetune/rft/rft_prompts.jsonl` — {prompt, ref_scad}, fresh combos held out
from the training split, disjoint from the 16 eval tasks by construction.

## R1. Generate on a pod (≈$0.59/hr A40; the spend)
Bundle + send (MCP can't move files):
```
cd ~/printpaper/finetune && mkdir -p rft/send && cd rft/send
cp ../../scripts/rft_generate.py ../../scripts/pod_rft_gen.sh ../rft_prompts.jsonl \
   ../../../bench/prompts/system.md . && cp -r ../../out/adapter .
tar czf rft_bundle.tar.gz rft_generate.py pod_rft_gen.sh rft_prompts.jsonl system.md adapter/
runpodctl send rft_bundle.tar.gz          # note the receive code
```
Create pod (same image + `minCudaVersion 12.8` as training), then on the pod:
```
runpodctl receive <code> && tar xzf rft_bundle.tar.gz && bash pod_rft_gen.sh
```
`pod_rft_gen.sh` installs unsloth (proven recipe), prints a per-prompt ETA so the cost is visible,
and writes `rft_gen.jsonl`. ~250 prompts × K=8 ≈ a few hundred candidates; generation ≈ 15–30 min
(≈ $0.20–0.40). Send it back, then **terminate the pod** (confirm `list-pods` empty) before harvest.
```
# pod:   runpodctl send rft_gen.jsonl
# laptop: cd ~/printpaper/finetune/rft && runpodctl receive <code>
```

## R2. Harvest (laptop, free)
```
~/printpaper/.venv/bin/python -I finetune/scripts/rft_harvest.py finetune/rft/rft_gen.jsonl \
   -o finetune/rft/rft.jsonl --per-prompt 2
```
Prints yield (% of candidates that matched) + kept examples. A low yield is the signal to adjust K /
temperature before spending again.

## R3. Gate + retrain (the second spend)
```
cp finetune/rft/rft.jsonl finetune/data/rft.jsonl          # now it's a training source
~/printpaper/.venv/bin/python -I finetune/scripts/build_dataset.py
~/printpaper/.venv/bin/python -I finetune/scripts/preflight.py --max-seq 4096 --render-sample 30
```
`GO` required. Then retrain exactly as steps 1–5 above (this time `data/train.jsonl` includes the RFT
examples), retrieve, deploy, and run the authoritative 3-attempt eval (step 7). Compare pass@3 /
render / mean-score against scadcoder to decide whether to iterate.

---

# Box-deployable model (Qwen3.5-9B → Tiiny NPU)

Deploy a lab's OWN fine-tune on the box. The box runs only fine-tunes of the vendor base Qwen3.5-9B
(a vision-language model), imported via the APP (not the `tiiny import` CLI, which is image-only; not
trained on-device). Proven end-to-end 2026-10-16 (paper §6.4). Footguns: PIPELINE_HICCUPS.md H17-H30.

## B1. Train (RunPod A40 ≈ $0.59/hr; ~5 h for 3 epochs ≈ $3)
Pod: image `runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404`, `gpu.minCudaVersion 12.8`, disk ≥ 100 GB.
```
cd finetune && runpodctl send data/train.jsonl scripts/train_vlm.py scripts/pod_train_vlm.sh scripts/pod_idle_guard.sh
# pod: runpodctl receive <code>
SMOKE=1 bash pod_train_vlm.sh    # validate: VISION_PRESERVED + a sane s/it (H23), then:
bash pod_train_vlm.sh            # full run -> out_vlm/merged16 (bf16 safetensors, vision preserved)
```
`train_vlm.py` uses unsloth `FastVisionModel`, LoRA on the LANGUAGE layers only (vision frozen), merged
to 16-bit safetensors. QLoRA 4-bit is NOT used (not recommended for Qwen3.5). Knobs: EPOCHS/RANK/DROPOUT/MAXSEQ.

## B2. Retrieve to /home — NOT the scratchpad (tmpfs ~7.5 GB; H27/H28)
```
# pod:    rm -f merged16.zip; runpodctl send out_vlm/merged16
# laptop: mkdir -p ~/printpaper/finetune/out-3ep && cd "$_" && runpodctl receive <code>
```
Start the receive only after the pod's send log says `Sending 'merged16.zip'` - the code is printed before the
zip exists, and an early receive fails `room not ready` (H38). Verify all 4 shards + the index are present, then
terminate the pod (delete-pod; confirm list-pods empty).

## B3. Make it box-importable + upload (laptop; H30)
```
python finetune/scripts/box_import_fix.py ~/printpaper/finetune/out-3ep/merged16 --repo ATinyGreenCell/<name>
hf upload ATinyGreenCell/<name> ~/printpaper/finetune/out-3ep/merged16 . --repo-type=model   # cached token
```
`box_import_fix.py` swaps in the stock 4.57 config schema, adds the stock aux files, and writes the model
card whose frontmatter makes HF compute `pipeline_tag`/`transformersInfo` — what the importer ACTUALLY
reads. Sanity-check the HF API shows `pipeline_tag: image-text-to-text` and `transformersInfo.auto_model` set.

## B4. Import + load + bench (box)
- App → Model Store → Import Model → paste the HF URL. It downloads THEN converts (H29).
- Wait for `status == "downloaded"` (poll `t.models_raw("downloaded")`), not just /api/tags presence.
- Load: `t.load("ATinyGreenCell/<name>")` (tiinykit; pause the sweep first — it hogs the NPU).
- Bench: `OLLAMA_HOST=http://127.0.0.1:11435 run_bench.py --models tiiny/ATinyGreenCell/<name> --samples N` (reasoning off).

Reference runs: v1 (1 ep) 15/16 render · 0 pass · mean 0.40; v2 (3 ep) 16/16 · 0 pass · mean 0.48 (max 0.92).

## B5. GPU tier — bench a fine-tune without the box (H34)
When the box is down, or to compare fine-tunes quickly at many samples, serve the merged weights on a rented GPU:
```
# pod (has the merged16 dir, or `hf download ATinyGreenCell/<name> --local-dir /workspace/<name>`):
pip install --break-system-packages -U vllm
vllm serve /workspace/<name> --served-model-name <name> --max-model-len 16384 --gpu-memory-utilization 0.90 \
  --host 127.0.0.1 --port 8000 --limit-mm-per-prompt '{"image": 0, "video": 0}'
# laptop: tunnel + Ollama-API front, then the unchanged harness
ssh -N -L 18000:127.0.0.1:8000 -p <port> -i ~/.ssh/runpod_ft root@<pod-ip> &
python bench/ollama_openai_shim.py --upstream http://127.0.0.1:18000 --port 11500 &
OLLAMA_HOST=http://127.0.0.1:11500 python bench/run_bench.py --run gpu-<name>-g0 --models <name> \
  --tasks <two task ids> --samples 8 --max-repairs 2      # 8 such processes in parallel; vLLM batches them
python bench/finetune_table.py gpu-base gpu-v2 gpu-<name>  # in-family / held-out split (H31)
```
Same prompts, sampling, thinking-off and checker as the box runs; the numbers compare fine-tunes with each other,
not with the box's own quantised build. An A40 serves a 9B model at ~33 tok/s per stream; 16 tasks x 8 samples
takes ~20 min.

## B6. Training-data hygiene (H31)
Any new training prompt is gated against the 16 eval prompts before training:
`finetune/rft/distill/gen_prompts_clean.py` (max token Jaccard 0.40, part types that are not eval tasks). Reference
points: v2's data peaks at 0.22; same-style-different-part prompts sit at 0.25-0.40; paraphrases of a task 0.55+.

## B7. Never let a pod idle (H32) — every pod guards itself from boot
**Create every pod with `scripts/guarded_pod_body.py`** (pass its output as create-pod's `body`):
```
python finetune/scripts/guarded_pod_body.py --name <name> --gpu "NVIDIA H100 80GB HBM3" [--idle-min 45 --max-hours 12]
```
Its container command downloads `scripts/pod_idle_guard.sh` from this repo pinned to a commit (SHA-256 checked),
starts it, then execs the image's own `/start.sh`, so the guard runs from the pod's first minute and after any
container restart. The guard stops the pod when (a) for IDLE_MIN minutes the GPU is below 5%, the container uses
under 0.5 cores (cgroup accounting), no training/pip/HF-transfer process runs and the network is quiet, or (b)
the pod is older than MAX_HOURS - whatever it is doing. `touch /workspace/KEEP_ALIVE` holds it against (a) only.
A stop clears the container disk: retrieve the merged model within IDLE_MIN of the run ending.
Check a pod: `bash /usr/local/bin/pod_idle_guard.sh --self-test`, `cat /workspace/.idle_guard_state`,
`/workspace/idle_guard.log`. `pod_train_vlm.sh` also starts the guard if `pod_idle_guard.sh` sits beside it
(older pods). Backstops beyond the pod: Claude may stop/terminate any pod (allow rules for `delete-pod` and
`pod-action` in ~/.claude/settings.json), checks `list-pods` at the start of every session, and every chain
ends by terminating its pod; on the account, keep auto-pay off so the prepaid balance is a hard ceiling (at $0
RunPod stops every pod) and set a low-balance email alert.
