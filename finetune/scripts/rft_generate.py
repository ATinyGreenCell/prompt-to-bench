#!/usr/bin/env python3
"""Generate rejection-sampling candidates on a RunPod GPU: load the fine-tuned model and, for each
prompt, sample K OpenSCAD files. The laptop then verifies them with rft_harvest (rft_score) and keeps
the correct ones to train on. Single-turn here; multi-turn repair is a second round once these are
scored (feed the non-matches their real checker feedback and sample an attempt 2).

The K candidates for a prompt are drawn in ONE batched generate (num_return_sequences), chunked into
micro-batches so a large K can't OOM the GPU - far cheaper per pod-hour than sampling one at a time.

Runs with `-u` so the log streams (hiccup H3). Prints per-prompt timing + a running ETA so the pod
cost is visible while it runs.

usage (pod):
  python -u rft_generate.py --adapter out/adapter --prompts rft_prompts.jsonl \
      -o rft_gen.jsonl --k 8 --micro-batch 8 --temperature 0.8 --system system.md
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time


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
    ap.add_argument("--micro-batch", type=int, default=8, help="max candidates per generate call (caps VRAM)")
    ap.add_argument("--temperature", type=float, default=0.8)
    ap.add_argument("--top-p", type=float, default=0.95)
    ap.add_argument("--max-new", type=int, default=2048)
    ap.add_argument("--max-seq", type=int, default=4096)
    a = ap.parse_args()
    if a.k < 1 or a.micro_batch < 1:
        sys.exit("--k and --micro-batch must be >= 1")

    import torch
    from unsloth import FastLanguageModel

    system = open(a.system).read().strip()
    model, tok = FastLanguageModel.from_pretrained(a.base, max_seq_length=a.max_seq, load_in_4bit=True, dtype=None)
    if a.adapter:
        from peft import PeftModel
        model = PeftModel.from_pretrained(model, a.adapter)   # apply the fine-tune
    FastLanguageModel.for_inference(model)

    def sample_k(ids, k):
        """Draw k samples of one prompt in micro-batched generate calls."""
        cands, remaining = [], k
        while remaining > 0:
            n = min(a.micro_batch, remaining)
            with torch.no_grad():
                g = model.generate(input_ids=ids, max_new_tokens=a.max_new, do_sample=True,
                                   temperature=a.temperature, top_p=a.top_p,
                                   pad_token_id=tok.eos_token_id, num_return_sequences=n)
            cands.extend(extract_scad(tok.decode(g[j][ids.shape[1]:], skip_special_tokens=True))
                         for j in range(g.shape[0]))
            remaining -= n
        return cands

    recs = [json.loads(l) for l in open(a.prompts) if l.strip()]
    print(f"START {len(recs)} prompts x {a.k} candidates (micro-batch {a.micro_batch}), temp {a.temperature}", flush=True)
    t0, truncated = time.time(), 0
    with open(a.o, "w") as fh:
        for i, r in enumerate(recs):
            msgs = [{"role": "system", "content": system}, {"role": "user", "content": r["prompt"]}]
            ids = tok.apply_chat_template(msgs, tokenize=True, add_generation_prompt=True, return_tensors="pt").to("cuda")
            if ids.shape[1] + a.max_new > a.max_seq:
                truncated += 1   # generation may be cut short; the harvester still verifies what came out
            pt = time.time()
            cands = sample_k(ids, a.k)
            fh.write(json.dumps({"prompt": r["prompt"], "ref_scad": r["ref_scad"], "candidates": cands}) + "\n")
            fh.flush()
            done, dt = i + 1, time.time() - pt
            if done % 10 == 0 or done == len(recs):
                rate = (time.time() - t0) / done
                eta = rate * (len(recs) - done)
                print(f"{done}/{len(recs)} prompts | {dt:.1f}s last | {rate:.1f}s/prompt | ETA {eta/60:.1f} min", flush=True)
    if truncated:
        print(f"WARN {truncated} prompts had prompt+max_new > max_seq ({a.max_seq}); raise --max-seq if candidates look cut off", flush=True)
    print(f"DONE {len(recs)} prompts x {a.k} candidates in {(time.time()-t0)/60:.1f} min -> {a.o}", flush=True)


if __name__ == "__main__":
    sys.exit(main())
