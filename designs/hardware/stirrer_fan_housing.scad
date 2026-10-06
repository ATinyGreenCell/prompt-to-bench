// Housing for a DIY magnetic stirrer built from an 80 mm PC fan
// Category: full hardware. Glue two magnets to the fan hub (opposite poles facing up,
// symmetric about the hub). The fan screws to four standoffs under the top plate, so
// the magnets clear the plate; countersunk M4 screws keep the stirring surface flat.
// Power: 12 V fan from a certified 12 V supply with a PWM speed controller. No mains.
// Keep loose neodymium magnets away from children and pacemakers.
// Modelled in print orientation: upside down, top plate on the bed.
// Print: PETG or PLA, 0.2 mm layers, 15 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Housing] */
outer = [90, 90, 40];  // X, Y, height [mm]
wall = 2.5;
top_t = 2;             // stir surface; thin keeps magnets close to the stir bar
fan_hole_d = 4.5;      // M4 clearance
fan_hole_spacing = 71.5; // 80 mm fan mounting pattern
countersink_d = 8.4;   // M4 flat head (ISO 10642), 90 deg
standoff = [9, 5];     // diameter, height: magnet thickness + ~1 mm
notch = [12, 8];       // cable notch width x depth, from the open edge

/* [Hidden] */
$fn = 32;
eps = 0.01;

difference() {
    union() {
        difference() {
            translate([-outer.x / 2, -outer.y / 2, 0]) cube(outer);
            translate([-outer.x / 2 + wall, -outer.y / 2 + wall, top_t])
                cube([outer.x - 2 * wall, outer.y - 2 * wall, outer.z]);
        }
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * fan_hole_spacing / 2, sy * fan_hole_spacing / 2, top_t - eps])
                cylinder(d = standoff[0], h = standoff[1] + eps);
    }
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * fan_hole_spacing / 2, sy * fan_hole_spacing / 2, 0]) {
            translate([0, 0, -eps]) cylinder(d = fan_hole_d, h = top_t + standoff[1] + 2 * eps);
            // countersink opens on the bed face = the stirring surface in use
            translate([0, 0, -eps]) cylinder(d1 = countersink_d, d2 = fan_hole_d, h = (countersink_d - fan_hole_d) / 2 + eps);
        }
    translate([-notch.x / 2, outer.y / 2 - wall - 1, outer.z - notch.y])
        cube([notch.x, wall + 2, notch.y + eps]);
}
