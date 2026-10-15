#!/usr/bin/env python3
"""QLoRA fine-tune of a code model on the verified OpenSCAD pairs, with Unsloth.

Runs on a RunPod GPU pod. Trains a LoRA, merges it, and exports a Q4_K_M GGUF for Ollama.
Validation-run defaults (2 epochs, rank 16) - enough signal, ~30-60 min on a 24 GB GPU.

usage (on the pod):
  python train_qlora.py --data train.jsonl --epochs 2 --out openscad-coder
"""
from __future__ import annotations

import argparse


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--base", default="unsloth/Qwen2.5-Coder-7B-Instruct-bnb-4bit")
    ap.add_argument("--data", default="train.jsonl")
    ap.add_argument("--epochs", type=float, default=2.0)
    ap.add_argument("--max-seq", type=int, default=4096)
    ap.add_argument("--rank", type=int, default=16)
    ap.add_argument("--lr", type=float, default=2e-4)
    ap.add_argument("--out", default="openscad-coder")
    ap.add_argument("--gguf-quant", default="q4_k_m")
    a = ap.parse_args()

    from unsloth import FastLanguageModel  # import here so --help works without the GPU stack
    from datasets import load_dataset
    from trl import SFTConfig, SFTTrainer

    model, tok = FastLanguageModel.from_pretrained(
        a.base, max_seq_length=a.max_seq, load_in_4bit=True, dtype=None)
    model = FastLanguageModel.get_peft_model(
        model, r=a.rank, lora_alpha=a.rank, lora_dropout=0.0, bias="none",
        target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"],
        use_gradient_checkpointing="unsloth", random_state=0)

    ds = load_dataset("json", data_files=a.data, split="train")

    def to_text(ex):
        return {"text": tok.apply_chat_template(ex["messages"], tokenize=False, add_generation_prompt=False)}

    ds = ds.map(to_text, remove_columns=[c for c in ds.column_names if c != "messages"])

    trainer = SFTTrainer(
        model=model, tokenizer=tok, train_dataset=ds,
        args=SFTConfig(
            dataset_text_field="text", max_seq_length=a.max_seq,
            per_device_train_batch_size=2, gradient_accumulation_steps=4,
            num_train_epochs=a.epochs, learning_rate=a.lr, warmup_ratio=0.05,
            logging_steps=10, optim="adamw_8bit", weight_decay=0.01,
            lr_scheduler_type="cosine", seed=0, bf16=True,
            output_dir="out", report_to="none"))
    trainer.train()

    # merge LoRA into the base and write a GGUF Ollama can load
    model.save_pretrained_gguf(a.out, tok, quantization_method=a.gguf_quant)
    print(f"done -> {a.out} (GGUF {a.gguf_quant})")


if __name__ == "__main__":
    main()
