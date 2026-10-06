// Small lab funnel, 60 mm, with straight spout
// Category: tools. The wall is `wall` thick measured perpendicular to the cone (the
// cone is offset by wall / cos(cone angle)). Cone walls stay below 45 deg from
// vertical, so it prints upright without supports; use a brim (it stands on the
// 10 mm spout), or print it rim-down for a much larger bed contact.
// Print: PETG, 0.2 mm layers, 3+ perimeters.
// Chemicals: PETG is fine with water, buffers and ethanol; NOT acetone, phenol or
// chloroform. Polypropylene resists more solvents but needs a PP-tape bed to print.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Funnel] */
top_od = 60;           // outer diameter at the rim
spout_od = 10;         // outer diameter of the spout
wall = 1.6;            // true wall thickness
spout_h = 20;          // spout from z = 0 to z = spout_h
cone_h = 30;           // cone from z = spout_h to the rim

/* [Hidden] */
$fn = 96;
eps = 0.01;
half_angle = atan((top_od - spout_od) / 2 / cone_h);
wall_h = wall / cos(half_angle);   // horizontal wall that gives `wall` normal to the cone

difference() {
    union() {
        cylinder(d = spout_od, h = spout_h + eps);
        translate([0, 0, spout_h]) cylinder(d1 = spout_od, d2 = top_od, h = cone_h);
    }
    translate([0, 0, -eps]) cylinder(d = spout_od - 2 * wall, h = spout_h + 2 * eps);
    // inner cone, extended below the junction so it meets the spout bore without a ledge
    translate([0, 0, spout_h - 2]) cylinder(d1 = spout_od - 2 * wall_h - 2 * 2 * tan(half_angle),
                                            d2 = top_od - 2 * wall_h + 2 * eps * tan(half_angle), h = cone_h + 2 + eps);
}
