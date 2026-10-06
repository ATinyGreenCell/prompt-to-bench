// Clearance coupon: find the fit tolerances of YOUR printer + material
// Category: calibration. Prints in ~15 minutes. A plate with six holes for a nominal
// 10 mm peg, each larger by 0.0-0.5 mm (per diameter), engraved with its clearance,
// plus a loose 10 mm test peg printed next to it.
// How to use: print with the settings you normally use. Push the peg into each hole:
//   - the smallest hole it enters with firm pressure = your PRESS fit
//   - the smallest hole it slides through freely      = your SLIDING fit
//   - the smallest hole it drops through by itself    = your LOOSE fit (tubes in racks)
// Write these down on your "printer facts" card and give them to the model in every
// design request (see tutorial/SETUP.md). Repeat for each material.
// Print: the material you want to test, 0.2 mm layers, 3 perimeters, no supports.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Coupon] */
peg_d = 10;                          // nominal peg diameter [mm]
extra = [0, 0.1, 0.2, 0.3, 0.4, 0.5]; // added to the hole diameter [mm]
pitch = 16;
plate = [6 * 16 + 4, 26, 4];        // X, Y, Z [mm]
label_depth = 0.6;
peg_h = 12;

/* [Hidden] */
$fn = 96;
eps = 0.01;

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
translate([plate.x + 2 + peg_d / 2 + 4, 0, 0]) cylinder(d = peg_d, h = peg_h);
