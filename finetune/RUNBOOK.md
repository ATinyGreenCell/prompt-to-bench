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
