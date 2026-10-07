// Clearance coupon: find the fit tolerances of YOUR printer + material
// Category: calibration. Prints in about 35 minutes. A plate with six holes for a nominal
// 10 mm peg, each larger by 0.0-1.0 mm on the DIAMETER (engraved next to it; clearance
// per side = label / 2), plus a loose 10 mm test peg printed next to it.
// How to use: print with the settings you normally use. Push the peg's top end into each
// hole from the plate's top face (both first layers flare slightly):
//   - the smallest hole it enters with firm pressure = your PRESS fit
//   - the smallest hole it slides through freely      = your SLIDING fit
//   - the smallest hole it drops through by itself    = your LOOSE fit (tubes in racks)
// Write these down on your "printer facts" card and give them to the model in every
// design request (see tutorial/SETUP.md). Repeat for each material.
// Print: the material you want to test, 0.2 mm layers, 3 perimeters, no supports.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Coupon] */
// nominal peg diameter [mm]
peg_d = 10;
// added to the hole diameter [mm]
extra = [0, 0.2, 0.4, 0.6, 0.8, 1.0];
pitch = 16;
label_depth = 0.6; // 0.1
peg_h = 12;

/* [Hidden] */
$fn = 96;
eps = 0.01;
plate = [len(extra) * pitch + 4, 26, 4];  // X, Y, Z [mm]

// parameter checks: stop with a message instead of building a broken part
assert(peg_d + max(extra) <= pitch - 0.8, "holes overlap: increase pitch");
assert(peg_d + max(extra) <= 2 * (plate.y / 2 + 2) - 2 * 0.8, "holes are too big for the 26 mm plate");

difference() {
    translate([0, -plate.y / 2, 0]) cube(plate);
    for (i = [0 : len(extra) - 1]) {
        translate([2 + pitch / 2 + i * pitch, 2, -eps]) cylinder(d = peg_d + extra[i], h = plate.z + 2 * eps);
        translate([2 + pitch / 2 + i * pitch, -plate.y / 2 + 3.5, plate.z - label_depth])
            linear_extrude(label_depth + eps)
                text(str(extra[i]), size = 3.5, halign = "center", valign = "center");
    }
}
// the test peg, printed standing up next to the plate
translate([plate.x + 2 + peg_d / 2 + 4, 0, 0]) {
    cylinder(d1 = peg_d - 1, d2 = peg_d, h = 0.5);  // chamfer offsets the first-layer flare
    translate([0, 0, 0.5]) cylinder(d = peg_d, h = peg_h - 0.5);
}
