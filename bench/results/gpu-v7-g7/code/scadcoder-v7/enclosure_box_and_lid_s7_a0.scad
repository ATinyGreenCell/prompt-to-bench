// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie on the bed (z = 0), side by side, with a 10 mm gap.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X
box_y      = 50;    // box outer size in Y
box_z      = 30;    // box outer size in Z
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height (from plate top)
lip_x      = 65.6;  // lip outer size in X
lip_y      = 45.6;  // lip outer size in Y
clearance  = 0.2;   // clearance between lip and box opening on each side

eps        = 0.5;   // overcut for clean boolean differences
$fn        = 64;

// Derived
box_i_x = box_x - 2 * wall;   // box opening in X
box_i_y = box_y - 2 * wall;   // box opening in Y
plate_t = 2;                  // plate thickness under the lip

// ---------------- Modules ----------------
module box() {
    difference() {
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_z]);
        // open top: cut a channel through the top wall and floor
        translate([-box_i_x / 2, -box_i_y / 2, box_z - wall - eps])
            cube([box_i_x, box_i_y, wall + eps + floor]);
    }
}

module lid() {
    union() {
        // base plate
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, plate_t]);
        // centred lip (overlaps the plate by eps so the union is one solid)
        translate([-lip_x / 2, -lip_y / 2, plate_t])
            cube([lip_x, lip_y, lip_h + eps]);
    }
}

// ---------------- Assembly ----------------
// Print together: box on the -X side, lid on the +X side, 10 mm gap
union() {
    box();
    translate([box_x / 2 + 10, 0, 0])
        lid();
}