// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie on the bed (z = 0), side by side, with a 10 mm gap.
// They print together as one solid.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
lip_t      = 1.5;   // lid lip (wall) thickness
lip_h      = 4;     // lid lip height (from plate top)
lip_outer_x = 65.6; // outer size of lip in X
lip_outer_y = 45.6; // outer size of lip in Y
clearance  = 0.2;   // clearance between lip outer size and box opening (each side)
eps        = 0.5;   // overcut for clean boolean differences
gap        = 10;    // gap between the two printed parts

$fn = 64;

// Derived: box opening (inside dimensions)
opening_x = box_x - 2 * wall;   // 66
opening_y = box_y - 2 * wall;   // 46

// Check: lip outer size = opening - 2*clearance = 65.6 x 45.6 (matches spec)

// ---------------- Modules ----------------
module box() {
    difference() {
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z]);
        // open top: cut away the top wall and floor above z = box_z - floor
        translate([-opening_x/2, -opening_y/2, box_z - floor])
            cube([opening_x, opening_y, floor + eps]);
    }
}

module lid() {
    // Plate lying on the bed, centred on origin in X/Y
    plate_t = 2;
    translate([-box_x/2, -box_y/2, 0])
        cube([box_x, box_y, plate_t]);
    // Lip printed upside down: a wall whose outer size is lip_outer_x/outer_y,
    // centred on the plate, so it slides into the box opening.
    translate([-lip_outer_x/2, -lip_outer_y/2, plate_t])
        cube([lip_outer_x, lip_outer_y, lip_h + eps]);
}

// ---------------- Assembly ----------------
union() {
    box();
    translate([gap, 0, 0])
        lid();
}