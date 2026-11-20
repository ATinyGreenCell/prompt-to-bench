// Microscope-slide registration jig with two clamp holes
// Category: benchware; Purpose: repeatable origin when photographing a 75 x 25 mm microscope slide.
// Print: FDM, on the broad bottom face at z=0; no support required.
// This is a geometric reference design; no dimensional fit or lab use has been physically validated.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Platform] */
// Overall platform length, X (mm)
base_l = 100; // 0.5
// Overall platform width, Y (mm)
base_w = 40; // 0.5
// Platform thickness (mm)
base_h = 4; // 0.5

/* [Registration Edges] */
// Width of each perpendicular registration rail (mm)
rail_w = 3; // 0.1
// Height of rails above print bed (mm)
rail_top = 10; // 0.5

/* [Fasteners] */
// Diameter of each right-side mounting hole (mm)
bore_d = 4.5; // 0.1
// X coordinate of the mounting-hole centers (mm)
bore_x = 41; // 0.5
// Absolute Y coordinate of mounting-hole centers (mm)
bore_y = 8; // 0.5

/* [Hidden] */
$fn = 96;
eps = 0.1;
assert(base_l >= 90 && base_w >= 35);
assert(rail_w >= 1.6 && rail_top >= base_h + 2);
assert(bore_d > 0 && bore_d < 8);
assert(bore_x + bore_d/2 < base_l/2 - 1);
assert(bore_x - bore_d/2 > -base_l/2 + rail_w + 1);
assert(bore_y + bore_d/2 < base_w/2 - 1);
assert(bore_y - bore_d/2 > -base_w/2 + rail_w + 1);
assert(bore_d / 2 + 2 < bore_y);

difference() {
    union() {
        translate([-base_l/2, -base_w/2, 0])
            cube([base_l, base_w, base_h]);
        translate([-base_l/2, -base_w/2, base_h])
            cube([base_l, rail_w, rail_top-base_h]);
        translate([-base_l/2, -base_w/2, base_h])
            cube([rail_w, base_w, rail_top-base_h]);
    }
    for (sign=[-1,1])
        translate([bore_x, sign*bore_y, -eps])
            cylinder(h=base_h+2*eps, d=bore_d);
}
