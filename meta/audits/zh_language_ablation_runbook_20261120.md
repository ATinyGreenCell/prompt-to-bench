# Simplified Chinese language-ablation runbook (`zh`)

This PR adds a **complete 16-task Simplified Chinese translation** and supports an **opt-in** language-run command. Existing default `make lang` behavior remains `es hi sw`; adding `zh` to published default figure generation would confound past frozen results and is intentionally not done.

## Static audit (no model needed)

```bash
python bench/prompts/validate_zh.py
python -m unittest bench.prompts.test_validate_zh
```

These checks establish token-preservation and regression coverage; they **do not prove the wording is semantically equivalent**. A bilingual CAD/labware reviewer should read all 16 tasks for feature direction, bore openness, X/Y row ordering, contact surfaces, and the intended 3D-printing orientation.

## Full 16-task language run (when model and OpenSCAD are available)

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
ollama pull qwen2.5-coder:7b
PTB_LANGUAGES=zh bash bench/run_lang.sh zh-local-laptop qwen2.5-coder:7b
```

Or use the unmodified Python runner directly:

```bash
.venv/bin/python bench/run_bench.py --run zh-local-laptop \
    --lang zh --prompts bench/prompts/translations.yaml \
    --models qwen2.5-coder:7b
```

For a short **connectivity smoke check** without treating it as publication evidence:

```bash
.venv/bin/python bench/run_bench.py --run zh-smoke \
    --lang zh --prompts bench/prompts/translations.yaml \
    --models qwen2.5-coder:7b --tasks tube_rack_1p5ml
```

## Reproducibility constraints

- State model name, exact tag and quantization, OS, CPU, RAM, GPU, OpenSCAD version, seeds, temperature and `--max-repairs` settings. Retain `bench/results/<run>/results.jsonl` plus the run's `meta_*.json`.
- Use one persistent run name per frozen configuration; do not silently mix changed settings into one resumable folder.
- Compare against English and other languages **only when backend, task IDs, hardware and run budgets are matched**. Report every task and failure, not only successful examples.
- The main system instruction is English by design, while the task request is translated: do not describe this as a fully Chinese system-prompt experiment.
- No agent model runs, paper score changes, 3D print measurements, or automatic authorship acceptance are claimed by this PR.

**AI-use disclosure:** Initial localization and lexical checks used AI assistance; any actual language study must report its own empirical methods, outcomes and limitations.

## Local shell-dispatch smoke check (2026-11-20)

Executed `bash -n bench/run_lang.sh` and used a stub `.venv/bin/python` to capture the runner arguments without invoking any model. The unmodified default selected **es, hi, sw** in order; `PTB_LANGUAGES=zh` selected **zh** only. **4/4 language dispatch invocations matched**. This is a shell-level mock and does not show model correctness, OpenSCAD rendering during an agent run, or any new benchmark score.
