# Independent geometry red/green test — microfluidic chip imaging holder

**2026-11-20** · Supplement to the task's first audit; an independent local smoke test, not official upstream CI, fabrication, or optical validation.

## Reproduction

I rendered the branch's reference geometric construction with **OpenSCAD 2021.01** and inspected STL water-tightness, disjoint bodies, bounds, volume and z-slices using trimesh. The reference was a watertight single body of **100 × 70 × 10 mm**, volume **32,363.35923 mm³**, with six closed contours at z=3 mm (outer boundary, a 60 × 30 mm optical window, and four mounting bores) and three distinct contours at z=7.5 mm (two guide rails and the asymmetric fiducial).

I also re-created the **four intentionally incorrect mechanisms** independently from the reference geometry, then rerendered and inspected each:

| Case | Independent discriminating observation | Outcome |
| --- | --- | --- |
| Reference | Four mount centers (±40, ±25) mm; rails at ±20.5 mm; fiducial centered at Y=0 | PASS |
| Window filled | Five z=3 contours instead of six | REJECT |
| Fiducial absent | Two z=7.5 contours instead of three | REJECT |
| Mounting pitch corrupted | Mount centers at (±30, ±25) mm, not (±40, ±25) mm | REJECT |
| Rails overlap optical window | Rail centers at ±14 mm, not ±20.5 mm | REJECT |

**Local red/green outcome: 1 valid reference accepted and 4 faulty designs rejected** by one or more independent geometric invariants. No official `bench/checks.py` or `bench/build_refs.py` run is implied. A separate local smoke suite checks both this task and the slide jig references (4/4 cases pass), but those cases are independent of upstream CI.

## Pending official acceptance gates

Run `python bench/build_refs.py`, `make test`, and `make designs` in the complete project checkout. In particular verify the 3% scaling failure, eight bed symmetries, all official mutants, and cross-task rejection. Any test discrepancy must be resolved on this PR branch before the task can be considered accepted.

A water-tight mesh is **not** proof of physical printing suitability, bioinstrument compatibility, sterile use, chip fit, or imaging repeatability. AI assistance was used for building the local adversarial audit; original experiment measurements are not claimed.