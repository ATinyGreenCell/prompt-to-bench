// Rack for six 50 mL conical tubes (2 x 3), printed upside down
// Category: benchware. A perforated plate on two long walls. It prints with the
// plate on the bed and the walls growing upward (no bridges, no supports); flip
// it over after printing so it stands on the walls with the tube tips on the bench.
// Print: PLA or PETG, 0.2 mm layers, 15 % infill.
// Fit: Falcon 50 mL tubes are 30 mm O.D. (Corning 352070); 31 mm holes = 0.5 mm per side.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
// plate thickness [mm]
plate_t = 4;
// overall height = height of the plate when in use
height = 70;
// thickness of the two long walls
wall_t = 4;
// holes along X
cols = 3;
// holes along Y
rows = 2;
// centre-to-centre spacing [mm]
pitch = 40;
// 30 mm tube + 0.5 mm per side
hole_d = 31.0; // 0.1

/* [Hidden] */
$fn = 96;
eps = 0.01;
plate = [cols * pitch + 10, rows * pitch + 10, plate_t];  // 130 x 90 by default

// parameter checks: stop with a message instead of building a broken part
assert(cols >= 1 && rows >= 1, "cols and rows must be at least 1");
assert(pitch - hole_d >= 0.8, "holes overlap: pitch must exceed hole_d by at least 0.8 mm");
assert((pitch + 10 - hole_d) / 2 >= wall_t, "holes cut into the walls: increase pitch or reduce hole_d or wall_t");

difference() {
    translate([-plate.x / 2, -plate.y / 2, 0]) cube(plate);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([(i - (cols - 1) / 2) * pitch, (j - (rows - 1) / 2) * pitch, -eps])
            cylinder(d = hole_d, h = plate.z + 2 * eps);
}
// long walls, flush with the plate's long edges
for (s = [-1, 1])
    translate([-plate.x / 2, s > 0 ? plate.y / 2 - wall_t : -plate.y / 2, 0])
        cube([plate.x, wall_t, height]);
