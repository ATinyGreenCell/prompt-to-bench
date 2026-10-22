// KNOWN-WRONG PART (must fail): the foot is 30 mm long instead of 40
// L-shaped ("hockey-stick") cell spreader for plating bacteria
// Category: tools. A flat handle and a thinner spreading foot at 120 degrees, joined by a round
// boss; the foot's bed side is the smooth spreading face. Hanging hole at the handle end.
// Print: PETG or PP, lying flat, 0.15 mm layers, 100 % infill; sterilise with 70 % ethanol
// (or autoclave only if printed in PP).
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Spreader] */
handle = [150, 6, 4];     // length (X), width (Y), thickness (Z)
foot = [30, 5, 2.5];      // length along its centre line, width, thickness
foot_angle = 120;         // counter-clockwise from +X, seen from above
boss_d = 6;               // joins the bars at the origin, full handle thickness
hole_d = 4;
hole_x = 143;

/* [Hidden] */
eps = 0.01;

difference() {
    union() {
        translate([0, -handle.y / 2, 0]) cube(handle);
        rotate([0, 0, foot_angle]) translate([0, -foot.y / 2, 0]) cube(foot);
        cylinder(d = boss_d, h = handle.z, $fn = 48);
    }
    translate([hole_x, 0, -1]) cylinder(d = hole_d, h = handle.z + 2, $fn = 32);
}
