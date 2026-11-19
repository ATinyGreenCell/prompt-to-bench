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

## Remaining official gates

1. Run repository-native `bench/build_refs.py --write` and compare the generated reference statistics.
2. Confirm reference passes the official task check suite including 3% rescaling and symmetry handling.
3. Validate that all branch mutants fail and that the new task does not accidentally match other tasks.
4. Run `make designs` and official CI, and obtain a technical review.
5. Fabrication/fit measurements are **not** claimed; no optical or microfluidic performance is claimed.

## Provenance

The original reference design is on the contributor branch `feature/microfluidic-imaging-holder-task`. Independent auditing scripts and results are available in the contributor's external verification package. AI assistance was used to prepare this report and validation script. No official acceptance, author-credit approval, or measured physical performance is asserted.
