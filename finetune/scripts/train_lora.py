#!/usr/bin/env python3
"""Hardened QLoRA training for the real (paid) run, on a RunPod GPU pod.

Differences from the validation script (train_and_eval.py), all aimed at not wasting money:
  * SAVES the model - LoRA adapter, a merged 16-bit model, and a best-effort GGUF - so a paid run
    can never finish with nothing to download. (train_and_eval.py saved only eval outputs.)
  * REFUSES to truncate - tokenizes every example first and aborts if any exceeds --max-seq, instead
    of letting TRL silently cut the target and train the model to emit half-finished files.
  * ROBUST - per-task try/except in generation, full seeding, and a meta.json describing the run.
  * Optional --completion-only loss (mask everything up to the assistant turn) with a self-check that
    the mask was actually applied; default off = the exact recipe that validated.

The authoritative 3-attempt eval is NOT done here: deploy the model to Ollama on the laptop and run
the real bench/run_bench.py against it. The attempt-1 A/B here is only a quick "did it learn" signal.

usage: python train_lora.py --data train.jsonl --eval eval_prompts.json --epochs 3 --out out
"""
from __future__ import annotations

import argparse
import json
import os
import re
import time


def extract_scad(text: str) -> str:
    for pat in (r"```(?:openscad|scad)\s*\n(.*?)```", r"```\s*\n(.*?)```"):
        m = re.findall(pat, text, re.S | re.I)
        if m:
            return max(m, key=len).strip()
    return text.strip()


def gen_all(FastLanguageModel, model, tok, prompts, system, max_new=3072):
    import torch
    FastLanguageModel.for_inference(model)
    out = {}
    for p in prompts:
        try:
            msgs = [{"role": "system", "content": system}, {"role": "user", "content": p["user"]}]
            ids = tok.apply_chat_template(msgs, tokenize=True, add_generation_prompt=True, return_tensors="pt").to("cuda")
            with torch.no_grad():
                g = model.generate(input_ids=ids, max_new_tokens=max_new, do_sample=False,
                                   pad_token_id=tok.eos_token_id)
            out[p["id"]] = extract_scad(tok.decode(g[0][ids.shape[1]:], skip_special_tokens=True))
        except Exception as e:  # one bad task must not throw away the whole (paid) generation pass
            out[p["id"]] = f"// generation error: {e}\n"
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default="unsloth/Qwen2.5-Coder-7B-Instruct-bnb-4bit")
    ap.add_argument("--data", default="train.jsonl")
    ap.add_argument("--eval", default="eval_prompts.json")
    ap.add_argument("--epochs", type=float, default=3.0)
    ap.add_argument("--max-seq", type=int, default=4096)
    ap.add_argument("--rank", type=int, default=16)
    ap.add_argument("--lora-dropout", type=float, default=0.0, help="LoRA dropout; >0 regularises (reduces the determinism overfit)")
    ap.add_argument("--bf16-lora", action="store_true", help="load base in bf16 instead of 4-bit (required for Qwen3.5 - QLoRA not recommended)")
    ap.add_argument("--lr", type=float, default=2e-4)
    ap.add_argument("--out", default="out")
    ap.add_argument("--completion-only", action="store_true", help="mask loss up to the assistant turn")
    ap.add_argument("--gguf-quant", default="q4_k_m")
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)

    from unsloth import FastLanguageModel
    from datasets import load_dataset
    from trl import SFTConfig, SFTTrainer

    ev = json.load(open(a.eval))
    system, prompts = ev["system"], ev["tasks"]

    import torch
    model, tok = FastLanguageModel.from_pretrained(a.base, max_seq_length=a.max_seq,
                                                    load_in_4bit=(not a.bf16_lora),
                                                    dtype=(torch.bfloat16 if a.bf16_lora else None))

    # ---- no-truncation gate: tokenize everything FIRST, abort if any example would be cut ----
    ds = load_dataset("json", data_files=a.data, split="train")
    def to_text(ex):
        return {"text": tok.apply_chat_template(ex["messages"], tokenize=False, add_generation_prompt=False)}
    ds = ds.map(to_text, remove_columns=[c for c in ds.column_names if c != "messages"])
    lens = [len(tok(t, add_special_tokens=False)["input_ids"]) for t in ds["text"]]
    over = [i for i, L in enumerate(lens) if L > a.max_seq]
    mx = max(lens)
    print(f"LENGTHS: n={len(lens)} max={mx} p95={sorted(lens)[int(0.95*len(lens))]} over_max_seq={len(over)}")
    if over:
        raise SystemExit(f"ABORT: {len(over)} example(s) exceed --max-seq={a.max_seq} (max={mx}). "
                         f"Raise --max-seq to >= {mx} (next multiple of 256) and re-run; do NOT truncate.")

    model = FastLanguageModel.get_peft_model(
        model, r=a.rank, lora_alpha=a.rank, lora_dropout=a.lora_dropout, bias="none",
        target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"],
        use_gradient_checkpointing="unsloth", random_state=0)

    # base baseline: LoRA B is zero-initialised, so the model == base here (identical-protocol A/B)
    json.dump(gen_all(FastLanguageModel, model, tok, prompts, system), open(f"{a.out}/outputs_base.json", "w"))
    print("BASE_DONE")

    FastLanguageModel.for_training(model)
    cfg = SFTConfig(dataset_text_field="text", max_seq_length=a.max_seq,
                    per_device_train_batch_size=4, gradient_accumulation_steps=2,
                    num_train_epochs=a.epochs, learning_rate=a.lr, warmup_ratio=0.05,
                    logging_steps=20, optim="adamw_8bit", weight_decay=0.01,
                    lr_scheduler_type="cosine", seed=0, bf16=True, output_dir=a.out, report_to="none")
    collator = None
    if a.completion_only:
        from trl import DataCollatorForCompletionOnlyLM
        collator = DataCollatorForCompletionOnlyLM(response_template="<|im_start|>assistant\n", tokenizer=tok)
        # self-check: the mask must actually split prompt (-100) from completion, else bail loudly
        import torch
        batch = collator([tok(ds[0]["text"], add_special_tokens=False)])
        lab = batch["labels"][0]
        masked, kept = int((lab == -100).sum()), int((lab != -100).sum())
        print(f"COMPLETION_ONLY self-check: masked={masked} kept={kept}")
        if masked == 0 or kept == 0:
            raise SystemExit("ABORT: completion-only mask not applied (response template not found). "
                             "Fix the response_template or drop --completion-only.")

    t0 = time.time()
    SFTTrainer(model=model, tokenizer=tok, train_dataset=ds, data_collator=collator, args=cfg).train()
    train_seconds = time.time() - t0

    # ---- SAVE (the whole point of paying): adapter, merged-16bit, best-effort GGUF ----
    model.save_pretrained(f"{a.out}/adapter"); tok.save_pretrained(f"{a.out}/adapter")
    print("SAVED adapter")
    try:
        model.save_pretrained_merged(f"{a.out}/merged16", tok, save_method="merged_16bit")
        print("SAVED merged16")
    except Exception as e:
        print(f"WARN merged16 save failed ({e}); adapter is still saved - merge on the laptop")
    try:
        model.save_pretrained_gguf(f"{a.out}/gguf", tok, quantization_method=a.gguf_quant)
        print(f"SAVED gguf ({a.gguf_quant})")
    except Exception as e:
        print(f"WARN gguf export failed ({e}); convert merged16 -> gguf on the laptop with llama.cpp")

    json.dump(gen_all(FastLanguageModel, model, tok, prompts, system), open(f"{a.out}/outputs_ft.json", "w"))
    json.dump({"train_seconds": round(train_seconds, 1), "n_examples": len(ds), "epochs": a.epochs,
               "base": a.base, "max_seq": a.max_seq, "max_len_seen": mx, "rank": a.rank,
               "completion_only": a.completion_only}, open(f"{a.out}/meta.json", "w"))
    print(f"DONE train_seconds={train_seconds:.1f}")
    print(f"*** DOWNLOAD {a.out}/ (adapter, merged16, gguf, outputs_*.json, meta.json) BEFORE TERMINATING THE POD ***")


if __name__ == "__main__":
    main()
