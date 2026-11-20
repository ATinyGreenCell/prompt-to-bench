#!/usr/bin/env python3
"""Independent slice/volume audit of the slide-jig rubric's three red controls.

Uses OpenSCAD CGAL output, never Prompt-to-Bench checker functions.
Deterministic mesh validity, not fabrication-tolerance or population statistics.
"""
from pathlib import Path
import subprocess
import tempfile

import trimesh
from shapely.geometry import Polygon

ROOT = Path(__file__).resolve().parent.parent
CASES = (
    ('reference', 'reference/slide_registration_jig.scad', True),
    ('blind_bottom_skin', 'mutants/slide_registration_jig__blind_bottom_skin.scad', False),
    ('rail_too_thin', 'mutants/slide_registration_jig__rail_too_thin.scad', False),
    ('rail_too_wide', 'mutants/slide_registration_jig__rail_too_wide.scad', False),
)


def measure(input_file, out_stl):
    r = subprocess.run(['openscad', '-o', str(out_stl), str(input_file)],
                       capture_output=True, text=True, timeout=90, check=False)
    if r.returncode:
        raise RuntimeError(f'{input_file.name}: {r.stderr[-900:]}')
    mesh = trimesh.load(out_stl, force='mesh')
    if not mesh.is_watertight or mesh.is_empty:
        raise AssertionError(f'{input_file.name}: invalid watertight mesh')

    def polygons_at(z):
        s = mesh.section(plane_origin=[0., 0., z],
                         plane_normal=[0., 0., 1.])
        if s is None:
            raise AssertionError(f'missing z={z} cross-section')
        return sorted((Polygon(loop[:, :2]) for loop in s.discrete),
                      key=lambda p: p.area, reverse=True)

    return dict(volume=float(mesh.volume), height=float(mesh.extents[2]),
                low_holes=len(polygons_at(0.15)) - 1,
                mid_holes=len(polygons_at(2.0)) - 1,
                rail_area=float(polygons_at(6.0)[0].area))


def main():
    with tempfile.TemporaryDirectory(prefix='slide-jig-metamorphic-') as temp:
        measured = {label: measure(ROOT / 'bench' / rel, Path(temp) / f'{label}.stl')
                    for label, rel, _ in CASES}
    base = measured['reference']
    for label, _, correct in CASES:
        m = measured[label]
        old_coarse = (abs(m['volume'] / base['volume'] - 1) <= 0.03
                      and m['mid_holes'] == 2 and abs(m['height'] - 10) <= 0.4)
        new_geometry = (m['low_holes'] == 2 and abs(m['rail_area'] - 411) <= 8)
        assert old_coarse, f'{label}: old coarse-criteria premise violated'
        assert new_geometry is correct, f'{label}: independent red/green failure'
        print(f"{label}: volume={m['volume']:.3f} mm3, low={m['low_holes']},"
              f" mid={m['mid_holes']}, rail_area={m['rail_area']:.2f} mm2")
    print('PASS: genuine design accepted; 3 mutated physical constraints rejected')


if __name__ == '__main__':
    main()
