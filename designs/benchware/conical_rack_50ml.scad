// Rack for six 50 mL conical tubes (2 x 3), printed upside down
// Category: benchware. A perforated plate on two long walls. It prints with the
// plate on the bed and the walls growing upward (no bridges, no supports); flip
// it over after printing so it stands on the walls with the tube tips on the bench.
// Print: PLA or PETG, 0.2 mm layers, 15 % infill.
// Fit: Falcon 50 mL tubes are 30 mm O.D. (Corning 352070); 31 mm holes = 0.5 mm per side.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
plate = [130, 90, 4];  // X, Y, thickness [mm]
height = 70;           // overall height = height of the plate when in use
wall_t = 4;            // thickness of the two long walls
cols = 3;              // holes along X
rows = 2;              // holes along Y
pitch = 40;            // centre-to-centre spacing [mm]
hole_d = 31.0;         // 30 mm tube + 0.5 mm per side

/* [Hidden] */
$fn = 96;
eps = 0.01;

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
