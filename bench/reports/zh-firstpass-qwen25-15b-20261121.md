# English–Chinese first-pass pilot: Qwen2.5 1.5B

**Status: exploratory pilot, not a standard benchmark result.** This report records an initial paired run for the Chinese prompt path. It is retained as a transparent execution check and must not be interpreted as evidence that either language is better.

## Question

Can the translated prompts in this PR be executed through the same 16-task harness in Chinese and English, with the model and per-task seed held constant?

## Protocol

- Tasks: all 16 Prompt-to-Bench-16 tasks; one sample per task and language.
- Model: local Ollama `qwen2.5:1.5b`, model digest prefix `65ec06548149`.
- Matched conditions: same model, system prompt, task IDs, temperature (0.2), context (8,192), seed base (1,000), and report feedback.
- Language: English source prompts versus `bench/prompts/translations.yaml` (`zh` section).
- Budget: first response only (`--max-repairs 0`); generation capped at 1,024 tokens (`--num-predict 1024`).
- Execution environment: shared CPU sandbox, x86_64 Intel Xeon Platinum 8573C, 9 logical CPUs, about 9.7 GiB RAM, Debian 13; no GPU was exposed. Python 3.12.14, Ollama 0.40.16, OpenSCAD 2021.01.
- No paid model API, paid compute, physical lab visit, or user-device performance claim.

Commands (run separately, with the local Ollama server available):

```bash
.venv/bin/python bench/run_bench.py --run zh-firstpass-en-qwen25-15b \
  --models qwen2.5:1.5b --samples 1 --max-repairs 0 --feedback report \
  --temperature 0.2 --seed-base 1000 --num-ctx 8192 --num-predict 1024 --lang en

.venv/bin/python bench/run_bench.py --run zh-firstpass-zh-qwen25-15b \
  --models qwen2.5:1.5b --samples 1 --max-repairs 0 --feedback report \
  --temperature 0.2 --seed-base 1000 --num-ctx 8192 --num-predict 1024 \
  --lang zh --prompts bench/prompts/translations.yaml
```

## Results

| Prompt language | Tasks | Full passes | Valid first-pass renders | Mean runner-reported partial score | Median wall time |
|---|---:|---:|---:|---:|---:|
| English | 16 | 0/16 | 1/16 | 0.0104 | 27.0 s |
| Chinese | 16 | 0/16 | 1/16 | 0.0066 | 25.55 s |

The descriptive paired difference in mean partial score (Chinese minus English) is -0.0038. With one sample per task and only one valid render per language, this is not an inferential comparison. No per-task hidden-check outputs or generated candidate files are published here.

## Interpretation and limits

This run confirms that all 16 Chinese prompts can be passed through the benchmark harness and scored with the same model/task seed schedule. It does **not** establish a language effect: both conditions are near the floor, there is no run-to-run estimate, and the 1,024-token first-pass budget is below the harness's usual 2,048-token/repair protocol. Several replies ended with unclosed code fences or otherwise failed to produce a valid render, so the pilot primarily exposes a budget-sensitive failure mode.

A separate attempt to start a standard-budget paired run (2,048-token cap and up to two repair rounds) was interrupted by execution-environment recovery after three English task records. No complete standard-budget result was produced, and no score from that incomplete attempt is reported.

The project guide lists a **full** benchmark run on new hardware or in a new language as an example of substantial work. This first-pass pilot is supporting evidence for the existing translation/validation contribution, but it does not by itself claim that authorship threshold.

## AI-use disclosure

The harness setup, execution orchestration and result summary were AI-assisted in a shared CPU environment. The Qwen model generated the candidate OpenSCAD replies. No claim is made that the user's personal computer or a physical lab was used.
