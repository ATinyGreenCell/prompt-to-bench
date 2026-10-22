// KNOWN-WRONG PART (must fail): no stop: the 30.6 mm bore runs down to the plate
// Phone adapter for a microscope eyepiece with a 30 mm outer diameter
// Category: hardware. A phone plate with an off-centre camera hole and, on the same axis, a sleeve
// that slides over the eyepiece. The sleeve bore steps down to 22 mm near the plate (a stop that
// fixes the camera-to-eyepiece distance); three radial M3 holes take centring screws.
// Print: PLA or PETG, phone side (plate) on the bed, 0.2 mm layers; tap the 2.5 mm holes for M3
// nylon screws. Hold the phone on the plate with rubber bands.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Adapter] */
plate = [80, 60, 3];      // X, Y, thickness [mm], centred on the origin
cam = [-20, 10];          // camera-hole axis
cam_d = 12;
sleeve_od = 36.6;
stop_d = 30.6;             // bore from z = 3 to 11
stop_top = 11;
bore_d = 30.6;            // bore from z = 11 to the top (30 mm eyepiece + clearance)
sleeve_top = 31;
screw_d = 2.5;            // M3 tapping holes
screw_z = 21;
screw_angles = [0, 120, 240];  // first one points in +X

/* [Hidden] */
eps = 0.01;

difference() {
    union() {
        translate([-plate.x / 2, -plate.y / 2, 0]) cube(plate);
        translate([cam.x, cam.y, plate.z - eps]) cylinder(d = sleeve_od, h = sleeve_top - plate.z + eps, $fn = 128);
    }
    translate([cam.x, cam.y, -1]) cylinder(d = cam_d, h = plate.z + 2, $fn = 64);
    translate([cam.x, cam.y, plate.z - eps]) cylinder(d = stop_d, h = stop_top - plate.z + 2 * eps, $fn = 96);
    translate([cam.x, cam.y, stop_top]) cylinder(d = bore_d, h = sleeve_top - stop_top + 1, $fn = 128);
    for (a = screw_angles)
        translate([cam.x, cam.y, screw_z]) rotate([0, 0, a]) rotate([0, 90, 0])
            cylinder(d = screw_d, h = sleeve_od / 2 + 1, $fn = 24);
}
