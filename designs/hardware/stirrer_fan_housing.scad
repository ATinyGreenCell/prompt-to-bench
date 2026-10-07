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
// X, Y, height [mm]
outer = [90, 90, 40];
wall = 2.5; // 0.1
// stir surface; thin keeps magnets close to the stir bar
top_t = 2;
// M4 clearance
fan_hole_d = 4.5; // 0.1
// 80 mm fan mounting pattern
fan_hole_spacing = 71.5; // 0.1
// M4 flat head (ISO 10642), 90 deg
countersink_d = 8.4; // 0.1
// diameter, height: magnet thickness + ~1 mm
standoff = [9, 5];
// cable notch width x depth, from the open edge
notch = [12, 8];

/* [Hidden] */
$fn = 32;
eps = 0.01;

// parameter checks: stop with a message instead of building a broken part
assert(fan_hole_spacing + countersink_d <= outer.x - 2 * wall && fan_hole_spacing + countersink_d <= outer.y - 2 * wall, "the fan screw pattern does not fit inside the housing");
assert(wall >= 0.8 && top_t >= 0.8, "walls must be at least 0.8 mm (two perimeters)");

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
