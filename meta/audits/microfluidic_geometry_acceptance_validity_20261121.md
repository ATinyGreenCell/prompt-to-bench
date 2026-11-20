# Independent 3-D validation: microfluidic-holder negative-control coverage (2026-11-21)

**Contributor:** Zhibo Zhang. **Method:** OpenSCAD 2021.01 CGAL render + independent trimesh 4.11.1 / Shapely 2.1.2 mesh analysis. This is deterministic CAD scoring research; no physical printing, chip-fit test, sterility experiment or imaging-performance measurement is claimed.

| CAD | Rendered volume (mm³) | Δ vs reference | Voids z=0.15 | Voids z=3 | Optical aperture z=3 (mm²) | Typical mount bore z=3 (mm²) |
|---|---:|---:|---:|---:|---:|---:|
| Reference | 32363.3592 | 0 | 5 | 5 | 1800 | 19.61 |
| Wrong 8 mm mounting holes (specified 5 mm) | 31629.1582 | -2.2686% | 5 | 5 | 1800 | 50.20 |
| Wrong 64 mm optical window (specified 60 mm) | 31643.3592 | -2.2247% | 5 | 5 | 1920 | 19.61 |
| Wrong 0.9 mm skin under four mounting bores | 32433.9553 | +0.2181% | 1 | 5 | 1800 | 19.61 |

All geometries are watertight, 100×70×10 mm, have 5 voids at the prior single reference height (z=3), and remain within 4% relative total volume tolerance. Thus these coarse criteria are *insufficient* to establish the specification's hole diameters, aperture size or through-penetration. This is an independent **weak-criteria analysis**, not a full-harness false-positive claim.

**Actual PR changes:** Added permanent red-control mutants `__oversized_mount_bores.scad`, `__oversized_window.scad`, `__blind_mount_bores.scad`. Added built-in `watertight`, `bores` along the central optical aperture and all 4 mounting holes (z=0.15–5.85), two `line` checks measuring the exact 60×30 mm window through 6 mm side margins, and two `line` checks measuring 5 mm bores through 2.5 mm side margins. No custom checker library was introduced. The PR's existing full `bench/build_refs.py` CI tests reference, variants, scaling, cross-task negatives and all mutant files. The **latest-head CI**, not this report alone, establishes integrated correctness.

**Scientific scope:** reproducible task-rubric validity and targeted false-acceptance reduction. No live microscopy performance, manufacturing tolerance, or statistical false-acceptance rate claims. **CRediT:** Methodology, Software, Validation, Writing—review and editing; AI assistance disclosed.
