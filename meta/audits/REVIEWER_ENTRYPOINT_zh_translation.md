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


## Exact-head CI acceptance update — 2026-11-20

A new independent fork GitHub Actions run completed **successfully** on commit `8fc78b0b8bd50ce8fc6a79faeb86529589ad0aa4`: [CI run #44736035699](https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44736035699). This exact-head result supersedes earlier references to candidate-only or obsolete-head CI receipts. It is the fork branch's executable validation and **not** an upstream Merge or a scientific-paper authorship acceptance.

The branch additionally fixes `bench/run_lang.sh` to propagate the first failed language evaluation (`set -euo pipefail`). A new isolated regression asserts that failure exits with code 7 and stops the next language, while the opt-in Chinese control exits 0. The branch's new `zh-labware-review-validation.yml` runs these checks without any paid model calls or hardware.

## Complete three-PR joint regression

- [GitHub Actions #44741030314](https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44741030314): **Completed / Success**, tested combined commit `651fad95a2987b9b3e0b8b4d52fb56e1b87130b7` from separate integration branch.
- Both proposed new 3D geometry tasks (#2, #3) and this 16-task Chinese localization (#4) coexist under one full 18-English-task harness, geometry mutants, and parametric design checks.
- **Translation coverage remains 16/18 English tasks.** The two new benchmark tasks do not have human-checked Chinese translations and are intentionally excluded from the existing localization claims.
- Individual PR may be merged in any order provided its shared manifest/metadata and checker integration are preserved. See [integration compatibility proof](https://github.com/lindicaphxag-tech/prompt-to-bench/blob/verification/tri-labware-translation-integration-20261120/meta/audits/TRI_CONTRIBUTION_18TASK_ZH_INTEGRATION_20261120.md).

### Explicit contributor-credit request

Please assess whether this substantive data-curation and evaluation infrastructure contribution qualifies for co-authorship on the **next tagged living-paper version** under the repository's published `CONTRIBUTING.md`. Suggested CRediT roles: Data curation, Software, Validation, Writing – review & editing. The contributor will maintain the translations and validators, and acknowledges that publication authorship requires corresponding-author decision. AI-assisted drafting is disclosed and the executed tests, not model-performance claims, substantiate the contribution.


## Exact-current-head engineering semantics review (2026-11-20)

The translation contribution has been strengthened beyond numeric-token parity. A **separate pinned review table** in `bench/prompts/validate_zh_semantics.py` asserts **48 domain-specific semantic anchors across all 16 original labware tasks**. Examples include blind versus through bores, open versus sealed floors, inverted print orientation, through-channel continuity, and open channel geometry. `bench/prompts/test_validate_zh_semantics.py` adds 10 tests, including nine adversarial fixtures where the numbers stay unchanged but the Chinese engineering meaning is changed.

- **Latest PR-head sha:** `1e95aa9006b654d91fe756bb531c6240b90a325b`.
- **Exact-head successful GitHub Actions:** https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44749564270
- **All tests actually executed in workflow:** both original numeric-validation tests and new semantics tests, plus shell fail-closed checks and both executable validators.
- **Independent human semantic review still required:** keyword anchors detect specific dangerous regressions but cannot certify every intended CAD constraint, synonym, native-language nuance or real model output. The evaluation remains static; no model comparison scores were produced.

This is a research methodology/quality contribution to the same PR rather than a claim of acceptance. Under the project author policy, final contributor and paper author credit must be confirmed by the corresponding author after review.
