#!/usr/bin/env python3
"""Independent OpenSCAD/trimesh check of hidden microfluidic CAD score validity.

Physically rendered deterministic negative controls, NOT a real chip-fit,
sterility, imaging performance or statistical error-rate experiment.
"""
from pathlib import Path
import subprocess
import tempfile

import trimesh
from shapely.geometry import Polygon

ROOT = Path(__file__).resolve().parent.parent
CASES = (
    ('reference', 'reference/microfluidic_chip_imaging_holder.scad', True),
    ('oversized_mount_bores', 'mutants/microfluidic_chip_imaging_holder__oversized_mount_bores.scad', False),
    ('oversized_window', 'mutants/microfluidic_chip_imaging_holder__oversized_window.scad', False),
    ('blind_mount_bores', 'mutants/microfluidic_chip_imaging_holder__blind_mount_bores.scad', False),
)


def measure(scad_path, mesh_path):
    r = subprocess.run(['openscad', '-o', str(mesh_path), str(scad_path)],
                       capture_output=True, text=True, timeout=90, check=False)
    if r.returncode:
        raise RuntimeError(f'{scad_path.name}: {r.stderr[-900:]}')
    mesh = trimesh.load(mesh_path, force='mesh')
    if not mesh.is_watertight or mesh.is_empty:
        raise AssertionError('expected printable watertight mesh')

    def horizontal_voids(z):
        s = mesh.section(plane_origin=[0., 0., z],
                         plane_normal=[0., 0., 1.])
        if s is None:
            raise AssertionError(f'missing z={z} slice')
        return sorted((Polygon(loop[:, :2]) for loop in s.discrete),
                      key=lambda polygon: polygon.area, reverse=True)

    low, mid = horizontal_voids(.15), horizontal_voids(3.)
    return dict(volume=float(mesh.volume), height=float(mesh.extents[2]),
                low_voids=len(low)-1, mid_voids=len(mid)-1,
                window_area=float(mid[1].area), bore_area=float(mid[2].area))


def main():
    with tempfile.TemporaryDirectory(prefix='microfluidic-metamorphic-') as temp:
        measured = {label: measure(ROOT / 'bench' / path, Path(temp) / f'{label}.stl')
                    for label, path, _ in CASES}
    base = measured['reference']
    for label, _, correct in CASES:
        m = measured[label]
        old_coarse = (abs(m['volume']/base['volume']-1) <= .04
                      and m['mid_voids'] == 5 and abs(m['height']-10) <= .5)
        independent_geometry = (m['low_voids'] == 5
                                and abs(m['window_area'] - 1800) <= 60
                                and abs(m['bore_area'] - 19.61) <= 3)
        assert old_coarse, f'{label}: old coarse-criteria premise violated'
        assert independent_geometry is correct, f'{label}: red/green separation failed'
        print(f"{label}: volume={m['volume']:.2f} mm3, low={m['low_voids']},"
              f" mid={m['mid_voids']}, window_area={m['window_area']:.2f} mm2,"
              f" bore_area={m['bore_area']:.2f} mm2")
    print('PASS: genuine reference accepted and 3 manufactured CAD defects rejected')


if __name__ == '__main__':
    main()
