// Small lab funnel, 60 mm, with straight spout
// Category: tools. Cone walls stay below 45 deg from vertical, so it prints upright
// without supports.
// Print: PETG or PP for chemical resistance, 0.2 mm layers, 3+ perimeters.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Funnel] */
top_od = 60;           // outer diameter at the rim
spout_od = 10;         // outer diameter of the spout
wall = 1.6;
spout_h = 20;          // spout from z = 0 to z = spout_h
cone_h = 30;           // cone from z = spout_h to the rim

/* [Hidden] */
$fn = 96;
eps = 0.01;

difference() {
    union() {
        cylinder(d = spout_od, h = spout_h + eps);
        translate([0, 0, spout_h]) cylinder(d1 = spout_od, d2 = top_od, h = cone_h);
    }
    translate([0, 0, -eps]) cylinder(d = spout_od - 2 * wall, h = spout_h + 2 * eps);
    translate([0, 0, spout_h]) cylinder(d1 = spout_od - 2 * wall, d2 = top_od - 2 * wall, h = cone_h + eps);
}
