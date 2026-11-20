# Independent 3-D validation: slide jig negative-control coverage (2026-11-21)

**Contributor:** Zhibo Zhang. **Method:** OpenSCAD 2021.01 CGAL mesh render followed by independent trimesh 4.11.1 / Shapely 2.1.2 volume and horizontal-section analysis. Original reference CAD and three source-level mutants were evaluated. No physical print or registration-accuracy study was performed.

| CAD | Rendered volume (mm³) | Δ vs reference | Voids z=0.15 | Voids z=2 | Rail section z=6 (mm²) |
|---|---:|---:|---:|---:|---:|
| Reference | 18338.8563 | 0 | 2 | 2 | 411 |
| Incorrect 0.9 mm blind-hole bottom skin | 18367.4636 | +0.1560% | 0 | 2 | 411 |
| Incorrect 2.5 mm registration rails | 17935.3563 | -2.2002% | 2 | 2 | 343.75 |
| Incorrect 3.5 mm registration rails | 18739.3563 | +2.1839% | 2 | 2 | 477.75 |

All four meshes are watertight and maintain a 100×40×10 mm bounding box. All three mutants satisfy the previous 3%-relative-volume limit and previous z=2 hole count. The bottom-skin mutant violates the *through-hole* requirement while retaining correct holes at z=2; altered rail widths violate the specified 3 mm thickness while staying inside coarse volume tolerance. **This is evidence of uncovered physical constraints in the previous rubric, not an independently executed full-checker false-positive measurement.**

**Actual PR changes:** New mutant files `__blind_bottom_skin.scad`, `__rail_too_thin.scad`, `__rail_too_wide.scad`; a native `bores` check along both clamp bores for z=0.15–3.85; and two native `line` thickness checks at z=6, separately for each perpendicular registration rail (3 mm ±0.25 mm). These avoid custom checker machinery and test the physical design requirements directly. The repo's `bench/build_refs.py` scans and tests all mutants; completion of the **new exact-head** CI run is needed to establish integrated red/green success.

**Scientific scope:** deterministic CAD benchmark validity / targeted false-acceptance reduction. No estimate of general-population false-positive rate, physical dimensional tolerance, biological validity or scientific-paper authorship is claimed. **CRediT contribution:** Methodology, Software, Validation, and Writing—review and editing. AI assistance in the code and evaluation audit is disclosed.
