#!/usr/bin/env python3
"""Generate rejection-sampling candidates on a RunPod GPU: load the fine-tuned model and, for each
prompt, sample K OpenSCAD files. The laptop then verifies them with rft_harvest (rft_score) and keeps
the correct ones to train on. Single-turn here; multi-turn repair is a second round once these are
scored (feed the non-matches their real checker feedback and sample an attempt 2).

Runs with `-u` so the log streams (hiccup H3). Prints progress every 20 prompts.

usage (pod):
  python -u rft_generate.py --adapter out/adapter --prompts rft_prompts.jsonl \
      -o rft_gen.jsonl --k 8 --temperature 0.8 --system system.md
"""
from __future__ import annotations

import argparse
import json
import re
import sys


def extract_scad(text: str) -> str:
    for pat in (r"```(?:openscad|scad)\s*\n(.*?)```", r"```\s*\n(.*?)```"):
        m = re.findall(pat, text, re.S | re.I)
        if m:
            return max(m, key=len).strip()
    return text.strip()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default="unsloth/Qwen2.5-Coder-7B-Instruct-bnb-4bit")
    ap.add_argument("--adapter", default="out/adapter", help="LoRA adapter dir; empty to sample the base model")
    ap.add_argument("--prompts", required=True, help="JSONL of {prompt, ref_scad}")
    ap.add_argument("--system", default="system.md")
    ap.add_argument("-o", default="rft_gen.jsonl")
    ap.add_argument("--k", type=int, default=8, help="candidates per prompt")
    ap.add_argument("--temperature", type=float, default=0.8)
    ap.add_argument("--top-p", type=float, default=0.95)
    ap.add_argument("--max-new", type=int, default=2048)
    ap.add_argument("--max-seq", type=int, default=4096)
    a = ap.parse_args()

    import torch
    from unsloth import FastLanguageModel

    system = open(a.system).read().strip()
    model, tok = FastLanguageModel.from_pretrained(a.base, max_seq_length=a.max_seq, load_in_4bit=True, dtype=None)
    if a.adapter:
        from peft import PeftModel
        model = PeftModel.from_pretrained(model, a.adapter)   # apply the fine-tune
    FastLanguageModel.for_inference(model)

    recs = [json.loads(l) for l in open(a.prompts) if l.strip()]
    print(f"START {len(recs)} prompts x {a.k} candidates, temp {a.temperature}", flush=True)
    with open(a.o, "w") as fh:
        for i, r in enumerate(recs):
            msgs = [{"role": "system", "content": system}, {"role": "user", "content": r["prompt"]}]
            ids = tok.apply_chat_template(msgs, tokenize=True, add_generation_prompt=True, return_tensors="pt").to("cuda")
            cands = []
            for _ in range(a.k):
                with torch.no_grad():
                    g = model.generate(input_ids=ids, max_new_tokens=a.max_new, do_sample=True,
                                       temperature=a.temperature, top_p=a.top_p, pad_token_id=tok.eos_token_id)
                cands.append(extract_scad(tok.decode(g[0][ids.shape[1]:], skip_special_tokens=True)))
            fh.write(json.dumps({"prompt": r["prompt"], "ref_scad": r["ref_scad"], "candidates": cands}) + "\n")
            fh.flush()
            if (i + 1) % 20 == 0:
                print(f"{i + 1}/{len(recs)} prompts", flush=True)
    print(f"DONE {len(recs)} prompts x {a.k} candidates -> {a.o}", flush=True)


if __name__ == "__main__":
    sys.exit(main())
