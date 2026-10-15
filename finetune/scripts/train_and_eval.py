#!/usr/bin/env python3
"""Validation run (on a RunPod GPU pod): QLoRA-train on the OpenSCAD pairs, and generate attempt-1
outputs for the 16 eval tasks BOTH before training (base baseline) and after (fine-tuned), so the
before/after is an identical-protocol A/B. Writes outputs_base.json, outputs_ft.json ({id: scad})
and meta.json; the laptop renders and checks them with the real checker.

usage: python train_and_eval.py --data train.jsonl --eval eval_prompts.json --epochs 2
"""
from __future__ import annotations

import argparse
import json
import re
import time


def extract_scad(text: str) -> str:
    for pat in (r"```(?:openscad|scad)\s*\n(.*?)```", r"```\s*\n(.*?)```"):
        m = re.findall(pat, text, re.S | re.I)
        if m:
            return max(m, key=len).strip()
    return text.strip()


def gen_all(model, tok, prompts, system, max_new=2048):
    import torch
    out = {}
    for p in prompts:
        msgs = [{"role": "system", "content": system}, {"role": "user", "content": p["user"]}]
        ids = tok.apply_chat_template(msgs, tokenize=True, add_generation_prompt=True, return_tensors="pt").to("cuda")
        with torch.no_grad():
            g = model.generate(input_ids=ids, max_new_tokens=max_new, do_sample=True,
                               temperature=0.2, top_p=0.95, pad_token_id=tok.eos_token_id)
        out[p["id"]] = extract_scad(tok.decode(g[0][ids.shape[1]:], skip_special_tokens=True))
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default="unsloth/Qwen2.5-Coder-7B-Instruct-bnb-4bit")
    ap.add_argument("--data", default="train.jsonl")
    ap.add_argument("--eval", default="eval_prompts.json")
    ap.add_argument("--epochs", type=float, default=2.0)
    ap.add_argument("--max-seq", type=int, default=2048)
    ap.add_argument("--rank", type=int, default=16)
    a = ap.parse_args()

    from unsloth import FastLanguageModel
    from datasets import load_dataset
    from trl import SFTConfig, SFTTrainer

    ev = json.load(open(a.eval))
    system, prompts = ev["system"], ev["tasks"]

    model, tok = FastLanguageModel.from_pretrained(a.base, max_seq_length=a.max_seq, load_in_4bit=True, dtype=None)
    model = FastLanguageModel.get_peft_model(
        model, r=a.rank, lora_alpha=a.rank, lora_dropout=0.0, bias="none",
        target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"],
        use_gradient_checkpointing="unsloth", random_state=0)

    # base baseline: the LoRA is zero-initialised, so the model == base here
    FastLanguageModel.for_inference(model)
    json.dump(gen_all(model, tok, prompts, system), open("outputs_base.json", "w"))
    print("BASE_DONE")

    FastLanguageModel.for_training(model)
    ds = load_dataset("json", data_files=a.data, split="train")
    ds = ds.map(lambda ex: {"text": tok.apply_chat_template(ex["messages"], tokenize=False, add_generation_prompt=False)},
                remove_columns=[c for c in ds.column_names if c != "messages"])
    t0 = time.time()
    SFTTrainer(
        model=model, tokenizer=tok, train_dataset=ds,
        args=SFTConfig(dataset_text_field="text", max_seq_length=a.max_seq,
                       per_device_train_batch_size=4, gradient_accumulation_steps=2,
                       num_train_epochs=a.epochs, learning_rate=2e-4, warmup_ratio=0.05,
                       logging_steps=20, optim="adamw_8bit", weight_decay=0.01,
                       lr_scheduler_type="cosine", seed=0, bf16=True,
                       output_dir="out", report_to="none")).train()
    train_seconds = time.time() - t0

    FastLanguageModel.for_inference(model)
    json.dump(gen_all(model, tok, prompts, system), open("outputs_ft.json", "w"))

    json.dump({"train_seconds": round(train_seconds, 1), "n_examples": len(ds),
               "epochs": a.epochs, "base": a.base}, open("meta.json", "w"))
    print(f"DONE train_seconds={train_seconds:.1f}")


if __name__ == "__main__":
    main()
