// KNOWN-WRONG PART (must fail): the hinge is 2 mm thick (inner radius 6) instead of 0.8
// Pinch clamp for silicone tubing (up to 6.4 mm OD) with a living hinge and a snap latch
// Category: quick fixes. One flat profile: two jaws joined by a 0.8 mm half-ring hinge, a
// half-round pinch ridge on each jaw, and a hook on the upper jaw whose nose snaps under the
// lower jaw's thin tongue when the jaws are squeezed together.
// Print: PETG or PP (PLA hinges crack), lying flat, 0.2 mm layers, 100 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Clamp] */
thickness = 8;            // extrusion along Z
lower_jaw = [50, 4];      // x 0..50, y 0..4
tongue = [50, 56, 2.5];   // x from, x to, y bottom (top at y = 4)
upper_jaw = [60, 12, 16]; // x 0..60, y 12..16
hinge_c = [0, 8];         // half-ring on the x < 0 side
hinge_r = [6, 8];         // inner, outer radius (0.8 mm thick)
ridge_x = 27.5;
ridge_r = 1.5;
leg = [57, 60, 4.5, 12];  // hook leg x from, x to, y from, y to
nose = [54.5, 57, 4.5, 5.5];

/* [Hidden] */
eps = 0.01;

linear_extrude(thickness) union() {
    square(lower_jaw);
    translate([tongue[0], tongue[2]]) square([tongue[1] - tongue[0], lower_jaw.y - tongue[2]]);
    translate([0, upper_jaw[1]]) square([upper_jaw[0], upper_jaw[2] - upper_jaw[1]]);
    intersection() {
        translate(hinge_c) difference() { circle(r = hinge_r[1], $fn = 128); circle(r = hinge_r[0], $fn = 128); }
        translate([-hinge_r[1] - 1, -1]) square([hinge_r[1] + 1 + eps, 2 * hinge_r[1] + 2]);
    }
    translate([ridge_x, lower_jaw.y]) circle(r = ridge_r, $fn = 48);
    translate([ridge_x, upper_jaw[1]]) circle(r = ridge_r, $fn = 48);
    translate([leg[0], leg[2]]) square([leg[1] - leg[0], leg[3] - leg[2] + eps]);
    translate([nose[0], nose[2]]) square([nose[1] - nose[0] + eps, nose[3] - nose[2]]);
}
