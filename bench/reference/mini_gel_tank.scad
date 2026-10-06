// Buffer tank for a mini horizontal gel-electrophoresis box
// Category: full hardware. Raised gel platform between two buffer chambers and
// 2 mm holes for platinum/stainless electrode wires.
// Print: PETG, 0.2 mm layers, 4+ perimeters; leak-test with water before use.
// SAFETY: electrophoresis runs at ~50-150 V DC - a closed lid with an interlock and
// a proper power supply are required. Never run it open.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Tank] */
outer = [120, 70, 40]; // X, Y, Z
wall = 3;
floor_t = 3;
platform_len = 60;     // along X, centred
platform_h = 10;       // above the inner floor
wire_d = 2;
wire_z = 30;

/* [Hidden] */
eps = 0.01;

difference() {
    translate([-outer.x / 2, -outer.y / 2, 0]) cube(outer);
    difference() {
        translate([-outer.x / 2 + wall, -outer.y / 2 + wall, floor_t])
            cube([outer.x - 2 * wall, outer.y - 2 * wall, outer.z]);
        translate([-platform_len / 2, -outer.y / 2, 0])
            cube([platform_len, outer.y, floor_t + platform_h]);
    }
    for (sx = [-1, 1])
        translate([sx * (outer.x / 2 - wall / 2), 0, wire_z])
            rotate([0, 90, 0]) cylinder(d = wire_d, h = wall + 2, center = true, $fn = 24);
}
