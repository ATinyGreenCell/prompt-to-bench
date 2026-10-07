// Two-part enclosure (box + slip-fit lid) for a small electronics board
// Category: full hardware. Both parts in one file, side by side, ready to print.
// Inside: 66 x 46 x 28 mm - fits e.g. an Arduino Nano build (an Uno is too big).
// The lid's lip is `clearance` smaller per side than the opening: 0.2 mm slips on,
// 0.1 mm grips by friction on most printers. A 6 mm cable hole is in one end wall.
// Print: PLA or PETG, 0.2 mm layers. Print a lid first to check the fit.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Enclosure] */
// outer X, Y, Z
box = [70, 50, 30];
wall = 2;
floor_t = 2;
lid_t = 2;
lip_h = 4;
lip_wall = 1.5; // 0.1
// per side: 0.2 slip fit, 0.1 friction fit
clearance = 0.2; // 0.1
// between the parts on the bed
gap = 10;
// cable hole in the -X end wall, 8 mm above the floor
cable_d = 6;

/* [Hidden] */
eps = 0.01;
lip = [box.x - 2 * wall - 2 * clearance, box.y - 2 * wall - 2 * clearance];

// parameter checks: stop with a message instead of building a broken part
assert(wall >= 0.8 && floor_t >= 0.8 && lid_t >= 0.8 && lip_wall >= 0.8, "walls must be at least 0.8 mm (two perimeters)");
assert(clearance >= 0 && clearance < wall, "clearance must be between 0 and the wall thickness");
assert(cable_d < box.z - floor_t, "the cable hole is taller than the box wall");

// box (left)
translate([-box.x - gap / 2, -box.y / 2, 0])
    difference() {
        cube(box);
        translate([wall, wall, floor_t]) cube([box.x - 2 * wall, box.y - 2 * wall, box.z]);
        translate([-1, box.y / 2, floor_t + 8 + cable_d / 2]) rotate([0, 90, 0]) cylinder(d = cable_d, h = wall + 2, $fn = 32);
    }
// lid (right), lip pointing up
translate([gap / 2, -box.y / 2, 0]) {
    cube([box.x, box.y, lid_t]);
    translate([(box.x - lip.x) / 2, (box.y - lip.y) / 2, lid_t - eps])
        difference() {
            cube([lip.x, lip.y, lip_h + eps]);
            translate([lip_wall, lip_wall, -1]) cube([lip.x - 2 * lip_wall, lip.y - 2 * lip_wall, lip_h + 2]);
        }
}
