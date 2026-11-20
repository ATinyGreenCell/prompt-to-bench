# Microfluidic imaging holder — independent geometry audit (2026-11-20)

**Scope:** supplementary geometric reproducibility check of `bench/reference/microfluidic_chip_imaging_holder.scad`; this does **not** replace the repository's official benchmark tests, model rollouts, or physical printing.

## Environment and method

- OpenSCAD CLI, headless STL export, followed by `trimesh` 4.11.1 and `shapely` 2.1.2 analysis.
- Mesh closure, independent connected-component count, bounding-box dimensions, volume, XY cross sections at z=3 and z=7.5, and solid/empty probes in the task definition were evaluated.
- Cross-section coordinates were mapped back from the library's 2D plane frame to avoid mistaken coordinate-shift failures.
- Four independent counterfactual variants were created from the reference by deliberately disabling the window cut, deleting the orientation marker, changing X hole pitch 80->60 mm, and moving rails into the optical window (for the last case, the protective parameter assertion was intentionally disabled).
- These are independent local replays of the stated failure mechanisms, **not** official mutant-harness or symmetry checks.

## Observed results

| Case | Watertight / 1 body | Bounding box (mm) | z=3 islands/holes | z=7.5 islands | Probe errors | Expected gate |
|---|---|---|---|---|---:|---|
| Reference | yes | 100 × 70 × 10 | 1 / 5 | 3 | 0 | PASS |
| Filled optical window | yes | 100 × 70 × 10 | 1 / 4 | 3 | 2 | FAIL |
| Missing fiducial marker | yes | 100 × 70 × 10 | 1 / 5 | 2 | 1 | FAIL |
| Wrong mounting-hole pitch | yes | 100 × 70 × 10 | 1 / 5 | 3 | 4 | FAIL |
| Rails obstruct the window | yes | 100 × 70 × 10 | 1 / 5 | 3 | 2 | FAIL |

The rendered reference volume was **32,363.35923 mm³**. Its min/max bounds were `[-50,-35,0]` and `[50,35,10]` mm. All 12 solid/empty probes in the task specification agreed with the reference. All four deliberately defective versions were rejected by at least one independent discriminating check.

## Additional fork-level official suite verification

The initial 17-task validation run identified three `bench/test_harness.py` assertions that hard-coded the original 16-task table size. The source PR branch was fixed in [commit df9ad958](https://github.com/lindicaphxag-tech/prompt-to-bench/commit/df9ad958f95ca9547f13e927c271a145a700a4dd), replacing those constants with `len(all_tasks)`. This is a harness-fixture correction, not a relaxation of the benchmark's geometry criteria.

A verification branch created from the same contribution was then rerun. [GitHub Actions run #44593935083](https://github.com/lindicaphxag-tech/prompt-to-bench/actions/runs/44593935083) completed with **Success** on 2026-11-20, covering:
- 17 distinct task IDs and a matching frozen reference-stat entry
- the full repository-native `bench/test_harness.py` regression suite
- frozen reference statistics, symmetry/rotation/mirroring, 3% scale discrimination, cross-task false positives, reference variants and mutants via `bench/build_refs.py`
- the library design and invalid parameter checks via `tools/check_designs.py`

This CI is a **fork-level** independent validation, not evidence of an upstream review, model benchmark improvement, or actual fabrication. `bench/build_refs.py --write` was not used by this run; the frozen stats were validated in place. The final technical design review and paper credit decision remain with project maintainers. Physical fit/optical function was not tested.

## Provenance

The original reference design is on the contributor branch `feature/microfluidic-imaging-holder-task`. Independent auditing scripts and results are available in the contributor's external verification package. AI assistance was used to prepare this report and validation script. No official acceptance, author-credit approval, or measured physical performance is asserted.
