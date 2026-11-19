# Simplified Chinese benchmark prompt integrity — independent check

**Date:** 2026-11-20  
**Scope:** the 16 translated task prompts in `bench/prompts/translations.yaml` versus `bench/tasks.yaml`.

## Checks carried out

- Parsed all 16 benchmark task identifiers and 16 Simplified Chinese translations independently of the branch's `validate_zh.py` script.
- Confirmed exact task ID set equality: no missing or additional identifiers.
- Compared multisets of numeric tokens (including repeated dimension and coordinate values) for each task: **16/16 matched**.
- Compared explicit signed-axis tokens of the form `+X/-X/+Y/-Y/+Z/-Z` where present: **no mismatches detected** in these patterns.

The last two checks are **lexical integrity tests only**. They do not verify that all dimensions are attached to the correct nouns or that specialist CAD terminology is natural. Human technical-language review remains required before any new-language empirical benchmark run.

## Reproduction

```bash
python bench/prompts/validate_zh.py
```

The branch validator enforces task-ID and numeric-token consistency. The independent audit also inspected signed axis references; these additional checks are not a claim that the validator proves full semantic fidelity.

## Review checklist

A Chinese-speaking geometry/labware reviewer should check: coordinate frame (print bed at z=0); orientation after inversion; through versus blind holes; X/Y row/column order; cavity versus solid; integer quantities/units; asymmetric orientation markers; spatial inequalities and signed directions. The author can address edits in this PR without changing the English task or hidden grading.

**AI use:** the translation draft and verification were AI-assisted. We request technical-language review and claim no additional experimental results or automatic co-authorship eligibility.
