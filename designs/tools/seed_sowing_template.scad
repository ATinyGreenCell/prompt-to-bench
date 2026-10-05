// Seed-sowing / colony-picking template for a 90 mm Petri dish (7 x 7 grid)
// Category: tools. Disc that lies on the agar; drop seeds through the holes.
// Print: PLA or PETG, 0.2 mm layers; disinfect with 70 % ethanol before use.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Template] */
disc_d = 85;           // fits inside a 90 mm dish
thickness = 2;
n = 7;                 // n x n grid
pitch = 9;             // 10 mm would push the corner holes through the rim
hole_d = 3;
notch = [10, 4];       // orientation notch, width x depth [mm], on the +Y edge

/* [Hidden] */
eps = 0.01;

difference() {
    cylinder(d = disc_d, h = thickness, $fn = 180);
    for (i = [0 : n - 1], j = [0 : n - 1])
        translate([(i - (n - 1) / 2) * pitch, (j - (n - 1) / 2) * pitch, -eps])
            cylinder(d = hole_d, h = thickness + 2 * eps, $fn = 32);
    translate([-notch.x / 2, disc_d / 2 - notch.y, -eps])
        cube([notch.x, notch.y + 1, thickness + 2 * eps]);
}
