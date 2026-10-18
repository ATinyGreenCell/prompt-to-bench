#!/usr/bin/env python3
"""On-policy first attempts, in bulk (runs on a GPU pod with vLLM): the model answers training prompts the way
it answers the benchmark, so the repair data built from its failures shows it its OWN mistakes.

Input:  JSONL of {"id", "messages": [system, user], ...} (build_onpolicy_prompts.py; never eval tasks).
Output: JSONL of {"id", "sample", "reply"}, n samples per prompt, thinking off, the bench's sampling
        (temperature 0.2, top-p 0.95, 2,048 tokens) unless overridden.

    python onpolicy_generate.py --model /workspace/v5 --prompts prompts.jsonl --out attempts.jsonl --n 2
"""
from __future__ import annotations

import argparse
import json
import time


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model", required=True)
    ap.add_argument("--prompts", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--n", type=int, default=2)
    ap.add_argument("--temperature", type=float, default=0.2)
    ap.add_argument("--top-p", type=float, default=0.95)
    ap.add_argument("--max-tokens", type=int, default=2048)
    ap.add_argument("--seed", type=int, default=20261018)
    a = ap.parse_args()

    from vllm import LLM, SamplingParams
    rows = [json.loads(l) for l in open(a.prompts) if l.strip()]
    llm = LLM(model=a.model, max_model_len=8192, gpu_memory_utilization=0.90,
              limit_mm_per_prompt={"image": 0, "video": 0})
    params = SamplingParams(n=a.n, temperature=a.temperature, top_p=a.top_p, max_tokens=a.max_tokens, seed=a.seed)
    t0 = time.time()
    outs = llm.chat([r["messages"] for r in rows], params, chat_template_kwargs={"enable_thinking": False})
    with open(a.out, "w", encoding="utf-8") as fh:
        for r, o in zip(rows, outs):
            for k, c in enumerate(o.outputs):
                fh.write(json.dumps({"id": r["id"], "sample": k, "reply": c.text}, ensure_ascii=False) + "\n")
    print(f"GENERATED {len(rows)} prompts x {a.n} in {time.time() - t0:.0f}s -> {a.out}", flush=True)


if __name__ == "__main__":
    main()
