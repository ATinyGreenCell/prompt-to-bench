# Reviewer entrypoint — microscope-slide registration jig

**Upstream pull request:** https://github.com/ATinyGreenCell/prompt-to-bench/pull/2

## Submitted research contribution
One new laboratory CAD benchmark task, with complete OpenSCAD reference, lab-ready design, three targeted incorrect mutants, a 90-degree orientation variant, task constraints, reference geometry and dynamic 17-task harness compatibility changes. The five original task-rendering constraints are not rewritten into new benchmark results.

## What was executed
The [geometry audit](slide_registration_jig_geometry_20261120.md) reports successful local OpenSCAD 2021.01 rendering, a watertight connected STL, 100 × 40 × 10 mm bounds, measured reference volume, z-section contour checks, one valid parameter variant and one rejected invalid variant. A [separate clean candidate CI run](https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44585478691) succeeded on commit `0c00b9e76390c75a95227ef3d358b801ebeff407`.

**Evidence boundary:** The candidate CI ran on a separately prepared branch, not the latest head of the upstream PR. No physical jig was printed; no slide fit or microscope registration accuracy was measured.

## Reproduce against the final PR head
```bash
python bench/build_refs.py
python tools/check_designs.py
python bench/test_harness.py
```

## CRediT and integrity
Work offered for review: Conceptualization (labware benchmark requirements), Software (OpenSCAD reference/mutants/harness), Validation (geometry checks), and Writing—original draft (test/protocol documentation). The contribution and checks were AI-assisted; the human contributor must verify every claim, respond to technical review and maintain merged artifacts. This is within the project's documented category "new task with reference and validation"; any future paper authorship depends on the corresponding author's explicit decision and the project's contribution policy. GitHub PR creation or CI success alone never confers authorship.


## Exact-head CI acceptance update — 2026-11-20

A new independent fork GitHub Actions run completed **successfully** on commit `5c80372e30208e261136afd3ff0630a1cad8ab74`: [CI run #44733835601](https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44733835601). This exact-head result supersedes earlier references to candidate-only or obsolete-head CI receipts. It is the fork branch's executable validation and **not** an upstream Merge or a scientific-paper authorship acceptance.
