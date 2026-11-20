# Standard-budget paired pilot: Qwen2.5-Coder 7B

**Status: exploratory model/runtime diagnostic, not evidence of a language effect.** This run completes a standard-budget paired execution for the Chinese prompt path. It should be read alongside the separate first-pass Qwen2.5 1.5B pilot, not pooled with it.

## Question

Under matched per-task settings, can Qwen2.5-Coder 7B produce valid benchmark parts from the English prompts and their Chinese translations, with the same system prompt, task IDs, seeds, and repair budget?

## Protocol

- Tasks: all 16 benchmark tasks; one sample per task and language.
- Model: Ollama `qwen2.5-coder:7b`, Q4_K_M, model digest `dae161e27b0e90dd` (7.6B parameters).
- Matched conditions: same model, English system prompt, task IDs, temperature (0.2), seed base (1,000), context (8,192), generation cap (2,048 tokens), report feedback, and up to two repair rounds. Each task therefore had up to three attempts.
- Language: English source prompts versus the `zh` entries in `bench/prompts/translations.yaml`.
- Source: PR branch commit `9f4b46c786e099ad6a78ff8291fbddfb1f293d70`; at run time, the PR branch was two commits ahead; the intervening diff added only the earlier pilot report.
- Environment: NVIDIA GeForce RTX 3080 Ti (12 GiB), x86_64 Linux container, Python 3.12.3, Ollama 0.40.16, OpenSCAD 2021.01. The OpenSCAD AppImage SHA-256 was `f758528f2cd213f773c7a105fb63bf3b45bf754b0f586fbb7c9cd653ffcd0882`.
- Task-set SHA-256: `96a89073be9af221e78b3b40de70c8e74f27f33c002e458a5b1f22257a4fa1e5`.
- Translation SHA-256: `1e55ed5ed113e3856071ee81668758098accdd61ba9951c127a06543b5860536`.
- System-prompt SHA-256: `81b3df188aa51b8567a9b5fad184ea287b0d6b5566d6a7e700e30fc033991f88`.

Commands (run separately, with the local Ollama server available):

```bash
.venv/bin/python bench/run_bench.py --run en-qwen25-coder-7b-standard \
  --models qwen2.5-coder:7b --samples 1 --max-repairs 2 --feedback report \
  --temperature 0.2 --seed-base 1000 --num-ctx 8192 --num-predict 2048 --lang en

.venv/bin/python bench/run_bench.py --run zh-qwen25-coder-7b-standard \
  --models qwen2.5-coder:7b --samples 1 --max-repairs 2 --feedback report \
  --temperature 0.2 --seed-base 1000 --num-ctx 8192 --num-predict 2048 \
  --lang zh --prompts bench/prompts/translations.yaml
```

## Results

| Prompt language | Tasks | Full passes | Valid first-pass renders | Tasks with any non-zero best-attempt score | Mean best-attempt score |
|---|---:|---:|---:|---:|---:|
| English | 16 | 0/16 | 0/16 | 0/16 | 0.0000 |
| Chinese | 16 | 0/16 | 1/16 | 1/16 | 0.0170 |

All 48 attempts in each language condition were consumed. Fifteen tasks in each condition returned OpenSCAD parser errors. The Chinese `slide_drying_rack` candidate rendered but passed only 3 of 11 checks (score 0.2727); its bounding box and body count were wrong and it omitted all ten required slots. The same candidate hash was returned on all three attempts for that task, so repair did not change that output.

The descriptive difference in mean best-attempt score (Chinese minus English) is +0.0170. With one sample per task, both conditions at the floor, and no run-to-run estimate, this is not an inferential comparison.

## Interpretation and limits

This is a completed standard-budget run, but it does not establish that Chinese prompts improve or reduce performance. The dominant failure was invalid OpenSCAD syntax in both conditions; the only Chinese render was geometrically far from specification. The result diagnoses this model/runtime combination and does not validate translation quality, benchmark sensitivity, or general language effects.

No raw candidate files or per-task hidden-check outputs are included in this report. No physical prints or fit checks were performed. OpenSCAD 2021.01 was used; results may differ under the newer geometry engine recommended by the project.

## AI-use disclosure

AI assistance was used for execution orchestration and report drafting; Qwen2.5-Coder generated the candidate OpenSCAD replies. The benchmark harness performed rendering and hidden checks. No claim is made that the user's personal computer or a physical lab was used.
