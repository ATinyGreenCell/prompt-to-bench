// Housing for a DIY magnetic stirrer built from an 80 mm PC fan
// Category: full hardware. Glue two magnets to the fan hub, screw the fan under the
// top plate, power it with a 12 V supply + PWM speed controller.
// Modelled in print orientation: upside down, top plate on the bed.
// Print: PETG or PLA, 0.2 mm layers, 15 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Housing] */
outer = [90, 90, 40];  // X, Y, height [mm]
wall = 2.5;
top_t = 2;             // stir surface; thin keeps magnets close to the stir bar
fan_hole_d = 4.5;      // M4 clearance
fan_hole_spacing = 71.5; // 80 mm fan mounting pattern
notch = [12, 8];       // cable notch width x depth, from the open edge

/* [Hidden] */
$fn = 32;
eps = 0.01;

difference() {
    translate([-outer.x / 2, -outer.y / 2, 0]) cube(outer);
    translate([-outer.x / 2 + wall, -outer.y / 2 + wall, top_t])
        cube([outer.x - 2 * wall, outer.y - 2 * wall, outer.z]);
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * fan_hole_spacing / 2, sy * fan_hole_spacing / 2, -eps])
            cylinder(d = fan_hole_d, h = top_t + 2 * eps);
    translate([-notch.x / 2, outer.y / 2 - wall - 1, outer.z - notch.y])
        cube([notch.x, wall + 2, notch.y + eps]);
}
