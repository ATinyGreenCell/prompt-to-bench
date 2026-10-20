# main-bonsai: the main protocol for a ternary 27B model on the laptop CPU

The same 16 tasks, prompts and checks as [`main`](../main/) (temperature 0.2, top-p 0.95, a seed per attempt, an
8,192-token context, replies up to 2,048 tokens, thinking off, up to 2 repairs with `scadreport` feedback), on the same
laptop (Intel Core i7-1260P, 16 GB RAM, no discrete GPU), for one model that Ollama cannot run.

- **Model:** Ternary Bonsai 2 27B from prism-ml (Apache-2.0): Qwen3.8-27B with all its language-model weights but 26.2M (0.1%:
  the normalisation weights and a recurrent path in its linear attention) in {-1, 0, +1} and a 16-bit scale per 128 weights, as the `PQ2_0` GGUF (7.21 GB, 2.13 bits per weight; Hugging Face revision `b072e1d`,
  sha256 `3907dc1658db1f78a9826bf8d5bcb8dc65db0d466388937af57f2294fae62ec1`). The smaller `PTQ1_0` file (5.95 GB) was
  ruled out first: on this CPU it read prompts at 1.29 and wrote at 0.88 tokens per second, against 6.55 and 2.60 for
  `PQ2_0` (`llama-bench`, 12 threads), because the fork has no fast x86 path for it.
- **Runtime:** PrismML's llama.cpp fork (https://github.com/PrismML-Eng/llama.cpp, commit `11809184`), built for the CPU
  only, serving `llama-server -c 8192 -t 12 -np 1 --jinja`, with `--cache-ram 0` added
  from 17:36 on 2026-10-19 (the first 8 tasks ran with the default cache; below). The unchanged harness drove it through
  [`bench/ollama_openai_shim.py`](../../ollama_openai_shim.py); its `think: false` became the chat template's
  `enable_thinking=false`, which we checked gives no reasoning (a test reply had none, against 231 characters of
  reasoning without the switch).
- **One server fault, one conversation redone.** From about 16:13 to 17:36 on 2026-10-19 the server's in-memory prompt
  cache (`--cache-ram`, 8 GB by default) grew until the laptop swapped the model weights in and out, and generation fell
  from about 2.5 to 0.3 tokens per second. It was restarted with `--cache-ram 0`. The conversation that ran during the
  fault (`seed_sowing_template`) has the right outputs but a wall time about seven times too long, so it is flagged
  `needs_rerun` with the reason. Under a rule fixed before the rerun, the new record supersedes it, for its outcome and
  its time. It was redone from 21:25 to 21:41, after the run, at 2.5 tokens per second: it failed again in three
  attempts, the first two files the same as before, in 16 minutes instead of 83. The old conversation's files are in
  `code/bonsai2-27b-pq2_0/superseded/20261019173556/`. With the old record, the median time per task would have been
  25.2 minutes instead of 23.9.
- Timings are measured on the laptop, which also ran the NPU-box sweep's controller and its OpenSCAD checks at the time.
