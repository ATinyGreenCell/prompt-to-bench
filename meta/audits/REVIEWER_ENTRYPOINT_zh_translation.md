# Reviewer entrypoint — 16-task Chinese labware prompt localization

**Upstream pull request:** https://github.com/ATinyGreenCell/prompt-to-bench/pull/4

## Submitted research contribution
A full **16/16 Simplified Chinese** translation of the original benchmark prompts, optional language ablation dispatch without modifying default runs, an independent lexical validator, and four negative test cases for incorrect dimensions/signs/axes. See [independent audit](zh_labware_lexical_integrity_20261120.md) and [ablation runbook](zh_language_ablation_runbook_20261120.md).

**Executed CI:** [fork verification branch #44593271429](https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44593271429) passed its independent lexical checks. This is a derived verification branch and not a direct CI receipt for the latest PR head.

```bash
python bench/prompts/validate_zh.py
python -m unittest bench.prompts.test_validate_zh
```

A bilingual CAD/labware reviewer must still verify that constraints attach to the correct features and that the orientation and through-hole semantics are preserved. No Chinese-language model evaluation or new benchmark result has been run; static lexical parity must not be described as semantic validation or empirical model performance.

## Paper contribution discussion
The contribution is a reviewable complete translation and associated evaluation infrastructure, not a completed full-language experimental study. Proposed CRediT roles: Resources (translations), Software (validators), Validation (lexical controls), Writing—original draft (runbook). AI assisted drafting and checking. Under the project's [contribution policy](https://github.com/ATinyGreenCell/prompt-to-bench/blob/main/CONTRIBUTING.md), final recognition/co-authorship is decided by the corresponding author after substantive review and is never automatic.
