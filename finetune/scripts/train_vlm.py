#!/usr/bin/env python3
"""Fine-tune Qwen3.5-9B (a vision-language model) on the OpenSCAD text data with the VISION ENCODER
PRESERVED, so the merged safetensors imports onto the Tiiny box (its importer accepts Qwen3.5-9B
fine-tunes, safetensors only).

Qwen3.5 always ships as Qwen3_5ForConditionalGeneration (has a vision_config even text-only), so we
load with unsloth FastVisionModel, put LoRA on the LANGUAGE layers only (vision frozen), train on
text-only conversations (converted to the vision message format), and save a merged-16bit safetensors
in which the vision tensors pass through unchanged. bf16 LoRA (QLoRA 4-bit is NOT recommended for
Qwen3.5).

--smoke : load + 2 steps + merge + verify the vision tensors survive -- proves the path before paying
          for the full run. Run it FIRST; only do the full run after it prints VISION_PRESERVED.

usage (pod): python -u train_vlm.py --smoke         # validate the path (~free)
             python -u train_vlm.py --epochs 2      # full run
"""
from __future__ import annotations

import argparse
import glob
import json
import os
import time


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default="Qwen/Qwen3.5-9B")
    ap.add_argument("--data", default="train.jsonl")
    ap.add_argument("--epochs", type=float, default=2.0)
    ap.add_argument("--max-seq", type=int, default=4096)
    ap.add_argument("--rank", type=int, default=16)
    ap.add_argument("--lora-dropout", type=float, default=0.1)
    ap.add_argument("--lr", type=float, default=2e-4)
    ap.add_argument("--batch", type=int, default=2, help="per-device batch (effective batch = batch x accum)")
    ap.add_argument("--accum", type=int, default=4, help="gradient accumulation steps")
    ap.add_argument("--last-turn-only", action="store_true",
                    help="loss on the final assistant turn only (multi-turn repair data: the flawed earlier "
                         "turn is context, never a target). Default: loss on every token, as v1-v4 trained")
    ap.add_argument("--mask-earlier-assistant", action="store_true",
                    help="keep v1-v4's every-token loss but mask every assistant turn except the last (a no-op "
                         "on single-turn data), so multi-turn repair data adds no flawed targets")
    ap.add_argument("--out", default="out_vlm")
    ap.add_argument("--drop-over-max", action="store_true", help="drop examples over --max-seq instead of aborting (for a hard model context cap)")
    ap.add_argument("--seed", type=int, default=0,
                    help="LoRA init + data order (the default 0 is what every Table 8 model used; another value replicates a run)")
    ap.add_argument("--smoke", action="store_true")
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)

    import torch  # noqa: F401
    from unsloth import FastVisionModel
    from unsloth.trainer import UnslothVisionDataCollator
    from datasets import Dataset
    from trl import SFTConfig, SFTTrainer

    # pass max_seq_length so unsloth doesn't silently cap at its 2048 default (H19); the model itself
    # supports 262144, so 4096 keeps all examples. Defensive: older unsloth may not accept the kwarg.
    try:
        model, tok = FastVisionModel.from_pretrained(a.base, load_in_4bit=False,
                                                     use_gradient_checkpointing=True,  # True (HF), not "unsloth": the smart offload crawls here despite free VRAM
                                                     max_seq_length=a.max_seq)
    except TypeError:
        model, tok = FastVisionModel.from_pretrained(a.base, load_in_4bit=False,
                                                     use_gradient_checkpointing=True)
    print("LOADED base", a.base, flush=True)
    model = FastVisionModel.get_peft_model(
        model, finetune_vision_layers=False, finetune_language_layers=True,
        finetune_attention_modules=True, finetune_mlp_modules=True,
        r=a.rank, lora_alpha=a.rank, lora_dropout=a.lora_dropout, bias="none", random_state=a.seed)
    print(f"PEFT ready (language layers only), seed {a.seed}", flush=True)

    raw = [json.loads(l) for l in open(a.data) if l.strip()]
    if a.smoke:
        raw = raw[:8]

    def to_vision(msgs):  # our content is a plain string; the vision collator wants a typed-part list
        return [{"role": m["role"], "content": [{"type": "text", "text": m["content"]}]} for m in msgs]
    data = [{"messages": to_vision(r["messages"])} for r in raw]

    # no-truncation gate (tokenise the text-rendered chat template)
    def seqlen(msgs):
        enc = tok.apply_chat_template(msgs, tokenize=True, add_generation_prompt=False)
        if isinstance(enc, dict):            # processor may return a BatchEncoding
            enc = enc.get("input_ids")
        if hasattr(enc, "shape"):            # tensor [1, N] -> take N
            return int(enc.shape[-1])
        if enc and isinstance(enc[0], (list, tuple)):  # batched [[...]] -> inner length
            return len(enc[0])
        return len(enc)
    try:
        lens = [seqlen(d["messages"]) for d in data]
        mx, over = max(lens), sum(1 for L in lens if L > a.max_seq)
        print(f"LENGTHS: n={len(lens)} max={mx} over_max_seq={over}", flush=True)
        if over and not a.smoke:
            if a.drop_over_max:
                data = [d for d, L in zip(data, lens) if L <= a.max_seq]
                print(f"DROPPED {over} over-length example(s); kept {len(data)}", flush=True)
            else:
                raise SystemExit(f"ABORT: {over} example(s) exceed --max-seq {a.max_seq} (max {mx})")
    except SystemExit:
        raise
    except Exception as e:  # noqa: BLE001
        print(f"LENGTHS: gate skipped ({type(e).__name__}: {str(e)[:100]})", flush=True)

    ds = Dataset.from_list(data)
    FastVisionModel.for_training(model)
    collator = UnslothVisionDataCollator(model, tok)
    if a.last_turn_only:
        base_collator = collator
        inner = getattr(tok, "tokenizer", tok)
        head = inner.encode("<|im_start|>assistant\n", add_special_tokens=False)

        def collator(examples):  # mask every label up to the end of the LAST assistant header
            b = base_collator(examples)
            ids, lab = b["input_ids"], b["labels"]
            n = len(head)
            for r in range(ids.shape[0]):
                row = ids[r].tolist()
                last = max((i for i in range(len(row) - n + 1) if row[i:i + n] == head), default=None)
                lab[r, : (last + n) if last is not None else len(row)] = -100
            b["labels"] = lab
            return b
        print(f"LAST_TURN_ONLY: assistant header ids {head}", flush=True)
    elif a.mask_earlier_assistant:
        base_collator = collator
        inner = getattr(tok, "tokenizer", tok)
        head = inner.encode("<|im_start|>assistant\n", add_special_tokens=False)
        im_end = inner.convert_tokens_to_ids("<|im_end|>")

        def collator(examples):  # mask each non-final assistant turn, header through its <|im_end|>
            b = base_collator(examples)
            ids, lab = b["input_ids"], b["labels"]
            n = len(head)
            for r in range(ids.shape[0]):
                row = ids[r].tolist()
                starts = [i for i in range(len(row) - n + 1) if row[i:i + n] == head]
                for st in starts[:-1]:
                    end = next((j for j in range(st + n, len(row)) if row[j] == im_end), len(row) - 1)
                    lab[r, st:end + 1] = -100
            b["labels"] = lab
            return b
        print(f"MASK_EARLIER_ASSISTANT: header ids {head}, im_end {im_end}", flush=True)
    # DATA CHECK: prove the text-only vision collation yields a real, loss-bearing batch -- otherwise a
    # full run would "succeed" while training on garbage (the LENGTHS=1 bug showed this is a live risk).
    try:
        b = collator([ds[i] for i in range(min(2, len(ds)))])
        ids, lab = b["input_ids"], b.get("labels")
        nlab = int((lab != -100).sum()) if lab is not None else -1
        print(f"DATA_CHECK: input_ids={tuple(ids.shape)} non_masked_labels={nlab}", flush=True)
        if ids.shape[-1] < 50 or nlab == 0:
            raise SystemExit("ABORT: degenerate collation (text not tokenised or all labels masked)")
    except SystemExit:
        raise
    except Exception as e:  # noqa: BLE001
        print(f"DATA_CHECK: skipped ({type(e).__name__}: {str(e)[:120]})", flush=True)
    if a.last_turn_only or a.mask_earlier_assistant:  # MASK CHECK on a multi-turn example, if any
        idx = next((i for i, d in enumerate(data) if sum(m["role"] == "assistant" for m in d["messages"]) > 1), None)
        if idx is not None:
            b = collator([ds[idx]])
            row, lab = b["input_ids"][0].tolist(), b["labels"][0]
            inner = getattr(tok, "tokenizer", tok)
            head = inner.encode("<|im_start|>assistant\n", add_special_tokens=False)
            im_end = inner.convert_tokens_to_ids("<|im_end|>")
            starts = [i for i in range(len(row) - len(head) + 1) if row[i:i + len(head)] == head]
            spans = [(st, next((j for j in range(st + len(head), len(row)) if row[j] == im_end), len(row) - 1))
                     for st in starts]
            live = [int((lab[st + len(head):en + 1] != -100).sum()) for st, en in spans]
            print(f"MASK_CHECK: assistant spans {len(spans)} unmasked per span {live}", flush=True)
            if len(spans) < 2 or any(live[:-1]) or live[-1] == 0:
                raise SystemExit("ABORT: multi-turn masking wrong (an earlier assistant turn trains, or the last does not)")
    cfg = SFTConfig(per_device_train_batch_size=a.batch, gradient_accumulation_steps=a.accum,
                    num_train_epochs=a.epochs, max_steps=(2 if a.smoke else -1),
                    learning_rate=a.lr, warmup_ratio=0.05, logging_steps=10, optim="adamw_8bit",
                    weight_decay=0.01, lr_scheduler_type="cosine", seed=a.seed, bf16=True, save_strategy="no",
                    output_dir=a.out, report_to="none", remove_unused_columns=False,
                    dataset_kwargs={"skip_prepare_dataset": True}, max_seq_length=a.max_seq)
    trainer = SFTTrainer(model=model, tokenizer=tok, train_dataset=ds,
                         data_collator=collator, args=cfg)
    t0 = time.time()
    trainer.train()
    print(f"TRAIN_DONE {time.time() - t0:.0f}s", flush=True)

    model.save_pretrained_merged(f"{a.out}/merged16", tok, save_method="merged_16bit")
    print("SAVED merged16", flush=True)

    # verify the vision tensors survived into the merged safetensors (what the box importer needs)
    keys = []
    idx = glob.glob(f"{a.out}/merged16/*.index.json")
    if idx:
        keys = list(json.load(open(idx[0]))["weight_map"].keys())
    else:
        from safetensors import safe_open
        for f in glob.glob(f"{a.out}/merged16/*.safetensors"):
            with safe_open(f, framework="pt") as sf:
                keys += list(sf.keys())
    nvis = sum(1 for k in keys if "visual" in k or "vision" in k)
    print(f"MERGED: total_tensors={len(keys)} vision_tensors={nvis}", flush=True)
    print("VISION_PRESERVED" if nvis > 0 else "WARN_NO_VISION_TENSORS", flush=True)
    print("DONE", flush=True)


if __name__ == "__main__":
    main()
