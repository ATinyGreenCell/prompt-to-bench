# Reviewer entrypoint — microfluidic imaging-chip holder

**Upstream pull request:** https://github.com/ATinyGreenCell/prompt-to-bench/pull/3

## Submitted research contribution
One new benchmark problem for parametric 3D-printable labware with an optical field-of-view constraint, deterministic reference geometry and four targeted wrong-answer mutants (window blocked, marker missing, rails obstruct window, wrong mounting pitch). The branch also adds tests and checker integration.

## Full-head technical evidence
[GitHub Actions success #44595458590](https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44595458590) executed on exact PR head `e2828536833423dee75d681d0540874ef8f23d4a`. See [independent geometry audit](microfluidic_chip_holder_independent_geometry_20261120.md) and [red/green checks](microfluidic_chip_holder_redgreen_20261120.md).

### Run locally
```bash
python bench/build_refs.py
python tools/check_designs.py
python bench/test_harness.py
```

No physical print, microscopy accuracy, sterility, biosafety, or clinical suitability was validated. The task's code and audit were AI-assisted; the human contributor remains accountable for tests and corrective review.

## Paper contribution discussion
This submission is offered as a substantive "new task with reference and validation" under the repository's [authorship policy](https://github.com/ATinyGreenCell/prompt-to-bench/blob/main/CONTRIBUTING.md). Proposed CRediT roles: Conceptualization; Software; Validation; Writing—original draft. Any authorship on a later tagged paper must be separately confirmed by its corresponding author, and no acceptance is implied by mergeability or this report.
