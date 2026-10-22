// KNOWN-WRONG PART (must fail): two pipette holes instead of three
// Holder for 3 single-channel pipettes that clamps onto the front edge of an 18 mm shelf
// Category: quick fixes. A C-shaped clamp (spine, bottom jaw, top jaw) whose top jaw continues
// forward as an arm with three 20 mm holes; each pipette drops in and hangs by its handle.
// Modelled in print orientation: lying on its side, the profile in XY extruded along Z
// (in use +Y is up and +X points away from the shelf), so the jaws print as plain walls.
// Print: PETG (springier than PLA), 0.2 mm layers, 4 perimeters.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Holder] */
width = 105;              // extrusion length (along the shelf edge)
spine = [0, 5];           // x from, x to
jaw_back = -25;           // both jaws reach back to x = -25
jaw_t = 5;
gap = 18.4;               // 18 mm shelf + clearance
arm_front = 65;           // the top jaw continues forward to x = 65
hole_d = 20;
hole_x = 42;
hole_z = [26.25, 78.75];

/* [Hidden] */
eps = 0.01;
H = jaw_t + gap + jaw_t;  // 28.4

difference() {
    linear_extrude(width) union() {
        translate([spine[0], 0]) square([spine[1] - spine[0], H]);
        translate([jaw_back, 0]) square([spine[1] - jaw_back, jaw_t]);
        translate([jaw_back, H - jaw_t]) square([arm_front - jaw_back, jaw_t]);
    }
    for (z = hole_z)
        translate([hole_x, H - jaw_t - 1, z]) rotate([-90, 0, 0]) cylinder(d = hole_d, h = jaw_t + 2, $fn = 96);
}
