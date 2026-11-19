# Slide registration jig — independent reference geometry verification

**Date:** 2026-11-20. **Scope:** `slide_registration_jig` reference from this PR; local geometry smoke checks only, not an upstream CI certification.

## Actual local reproducibility run

Environment: OpenSCAD **2021.01** CLI, Python **3.13**, trimesh. Rendered the submitted OpenSCAD source to STL using `openscad -o part.stl bench/reference/slide_registration_jig.scad` and analyzed the mesh independently.

| Criterion | Observed |
| --- | --- |
| Default reference STL | OpenSCAD exited 0, no warnings |
| 3D mesh | Watertight, **one** connected body |
| Bounding dimensions | **100 × 40 × 10 mm**; lowest Z = 0 |
| Measured volume | **18,338.85632 mm³** |
| Cross-section at z = 2 mm | **3** separate closed contours (outer boundary and two bores) |
| Cross-section at z = 6 mm | **1** closed contour (the L-shaped registration rails) |
| Valid Customizer case `-D rail_top=12` | Rendered, watertight, one body, Z extent 12 mm |
| Invalid Customizer case `-D bore_d=8.5` | OpenSCAD returned nonzero and emitted the intended `Assertion` error |

These tests were independently re-run with the reference geometric construction on 2026-11-20; all **4/4** local programmatic checks passed. The PR also adds the valid/invalid cases and a bore-section case to the repository-wide `tools/check_designs.py` gate.

## Suggested upstream commands

```bash
python bench/build_refs.py
python tools/check_designs.py
python bench/test_harness.py
```

The upstream commands should be executed by CI or maintainers on the complete current repository. This smoke run did **not** execute the full official benchmark reference, symmetry, 3% rescaling, cross-task rejection, or mutation suite; those remain merge gates. No printed jig, real microscope-slide fit, registration repeatability or microscopy accuracy was tested.

**Provenance:** AI assistance was used for the test harness and audit text. All quantitative claims above are outputs of the locally executed OpenSCAD/trimesh checks, not hypothetical results. The submitter remains responsible for the contribution and its maintenance.