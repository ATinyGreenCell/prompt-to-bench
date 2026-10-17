// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie on the bed (z = 0), side by side, with a 10 mm gap.
// Units: mm.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
lip_t      = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height (from plate top)
lip_outer_x = 65.6; // outer size of lip in X
lip_outer_y = 45.6; // outer size of lip in Y
clearance  = 0.2;   // clearance between lip and box opening (each side)
eps        = 0.5;   // cutter overshoot past faces
gap        = 10;    // gap between the two printed parts

$fn = 64;

// Derived: box opening (inner size)
opening_x = box_x - 2 * wall;   // 66
opening_y = box_y - 2 * wall;   // 46

// Derived: lip overshoot so it passes the opening + clearance
lip_overshoot = clearance + eps; // 2.7

// ---------------- Modules ----------------
module box() {
    difference() {
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z]);
        // open top: empty space from z = box_z - floor up to the top face
        translate([-opening_x/2, -opening_y/2, box_z - floor - eps])
            cube([opening_x, opening_y, floor + 2*eps]);
    }
}

module lid() {
    // Plate lying on the bed
    translate([-box_x/2, -box_y/2, 0])
        cube([box_x, box_y, 2]);
    // Rectangular lip on top, centred, with overshoot past the opening
    translate([-lip_outer_x/2, -lip_outer_y/2, 2])
        cube([lip_outer_x, lip_outer_y, lip_h + lip_overshoot]);
}

// ---------------- Assembly ----------------
union() {
    box();
    translate([gap, 0, 0])
        lid();
}