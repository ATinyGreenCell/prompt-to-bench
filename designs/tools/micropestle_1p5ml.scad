// Micropestle for grinding tissue in a 1.5 mL microcentrifuge tube
// Category: tools. Handle with grip grooves + cone matching the tube's conical tip
// (Eppendorf 1.5 mL: 8.7 mm inside, ~18 mm conical section).
// Print: PETG or PLA, standing upright, 0.12-0.15 mm layers, 100 % infill, 5 mm brim;
// print several at once so each thin layer can cool.
// Use: single use. Not RNase/DNase-free and not autoclavable; layer lines retain tissue.
// Not for phenol/chloroform (TRIzol) or acetone. Brittle in liquid nitrogen - grind gently.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Pestle] */
handle_d = 8;
handle_h = 45;
// rounded tip diameter
tip_d = 3;
// matches the conical bottom of a 1.5 mL tube
cone_h = 17;
// grip groove centres [mm]
groove_z = [10, 15, 20, 25];
groove_w = 2;
groove_depth = 1;

/* [Hidden] */
$fn = 64;
eps = 0.01;

// parameter checks: stop with a message instead of building a broken part
assert(groove_depth <= handle_d / 2 - 2 * 0.8, "the grip grooves cut too deep into the handle");
assert(min(groove_z) - groove_w / 2 > 0 && max(groove_z) + groove_w / 2 < handle_h, "every groove must lie on the handle");
assert(tip_d < handle_d, "tip_d must be smaller than handle_d");

difference() {
    union() {
        cylinder(d = handle_d, h = handle_h);
        translate([0, 0, handle_h]) cylinder(d1 = handle_d, d2 = tip_d, h = cone_h);
        translate([0, 0, handle_h + cone_h]) sphere(d = tip_d);
    }
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            difference() {
                cylinder(d = handle_d + 1, h = groove_w);
                translate([0, 0, -eps]) cylinder(d = handle_d - 2 * groove_depth, h = groove_w + 2 * eps);
            }
}
