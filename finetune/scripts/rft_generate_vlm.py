#!/usr/bin/env python3
"""Rejection-sampling GENERATION for the Qwen3.5-9B box model (the merged VLM) -- the FastVisionModel
counterpart of rft_generate.py. Draws K diverse candidates per RFT prompt so rft_harvest.py can keep
the ones that build the right part (its input/output format is identical to rft_generate.py).

Differences from rft_generate.py (which is FastLanguageModel + a LoRA adapter):
  * loads the MERGED model (no separate adapter) with FastVisionModel in bf16 (QLoRA 4-bit not used).
  * reasoning OFF (enable_thinking=False) -- matches how the model is trained and deployed.

Config note: if the model dir carries the box's stock-4.57 config.json (from box_import_fix.py),
transformers 5.x may refuse it; pass --config-from Qwen/Qwen3.5-9B to pull a loadable config over it
first (a LoRA-merge keeps the base architecture, so the base config fits the merged weights).

usage (pod): python -u rft_generate_vlm.py --model ATinyGreenCell/scadcoder-qwen3.5-9b-3ep \
                 --prompts rft_prompts.jsonl --system system.md -o rft_gen.jsonl --k 8
"""
from __future__ import annotations
import argparse, json, re, sys, time


def extract_scad(text: str) -> str:
    for pat in (r"```(?:openscad|scad)\s*\n(.*?)```", r"```\s*\n(.*?)```"):
        m = re.findall(pat, text, re.S | re.I)
        if m:
            return max(m, key=len).strip()
    return text.strip()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", required=True, help="merged model: HF id or local dir")
    ap.add_argument("--config-from", default="", help="if set, copy this repo's config.json over the "
                    "model's before loading (fixes a box-4.57 config under transformers 5.x)")
    ap.add_argument("--prompts", required=True, help="JSONL of {prompt, ref_scad}")
    ap.add_argument("--system", default="system.md")
    ap.add_argument("-o", default="rft_gen.jsonl")
    ap.add_argument("--k", type=int, default=8)
    ap.add_argument("--micro-batch", type=int, default=4)
    ap.add_argument("--temperature", type=float, default=0.8)
    ap.add_argument("--top-p", type=float, default=0.95)
    ap.add_argument("--max-new", type=int, default=2048)
    ap.add_argument("--max-seq", type=int, default=4096)
    a = ap.parse_args()

    import torch
    from unsloth import FastVisionModel

    model_path = a.model
    if a.config_from:
        # pull a transformers-loadable config over the merged model (download the model first if it's an HF id)
        from huggingface_hub import snapshot_download, hf_hub_download
        import shutil, os
        local = a.model if os.path.isdir(a.model) else snapshot_download(a.model)
        cfg = hf_hub_download(a.config_from, "config.json")
        shutil.copy(cfg, os.path.join(local, "config.json"))
        model_path = local
        print(f"copied {a.config_from}/config.json over {local}/config.json", flush=True)

    model, tok = FastVisionModel.from_pretrained(model_path, load_in_4bit=False, max_seq_length=a.max_seq)
    FastVisionModel.for_inference(model)
    system = open(a.system).read().strip()
    print(f"LOADED {a.model}", flush=True)

    def encode(prompt: str):
        msgs = [{"role": "system", "content": system}, {"role": "user", "content": prompt}]
        for kw in ({"enable_thinking": False}, {}):  # reasoning off if the template supports it
            try:
                return tok.apply_chat_template(msgs, tokenize=True, add_generation_prompt=True,
                                               return_tensors="pt", **kw).to("cuda")
            except TypeError:
                continue
        raise RuntimeError("apply_chat_template failed")

    def sample_k(ids, k):
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
    t0 = time.time()
    with open(a.o, "w") as fh:
        for i, r in enumerate(recs):
            ids = encode(r["prompt"])
            pt = time.time()
            cands = sample_k(ids, a.k)
            fh.write(json.dumps({"prompt": r["prompt"], "ref_scad": r["ref_scad"], "candidates": cands}) + "\n")
            fh.flush()
            done = i + 1
            if done % 5 == 0 or done == len(recs):
                rate = (time.time() - t0) / done
                print(f"{done}/{len(recs)} | {time.time()-pt:.1f}s last | {rate:.1f}s/prompt | "
                      f"ETA {rate*(len(recs)-done)/60:.1f} min", flush=True)
    print(f"DONE {len(recs)} prompts x {a.k} in {(time.time()-t0)/60:.1f} min -> {a.o}", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
