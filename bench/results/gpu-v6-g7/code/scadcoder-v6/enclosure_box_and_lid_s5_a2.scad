// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box stands on the bed, lid lies flat on the bed upside down.
// The two parts are placed side by side with a 10 mm gap so they print together.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness (separate from walls for clarity)

lip_t      = 1.5;   // lid wall thickness
lip_h      = 4;     // lid wall height (sticks up because the lid is upside down)
lip_x      = 65.6;  // lid wall outer length (X)
lip_y      = 45.6;  // lid wall outer width (Y)
clearance  = 0.2;   // clearance between lid wall inner size and box opening

eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Derived ----------------
box_inner_x = box_x - 2 * wall;   // 66.0
box_inner_y = box_y - 2 * wall;   // 46.0
// Lid wall inner size = box opening - 2*clearance
assert(abs((box_inner_x - lip_x) + clearance - (-clearance)) < 0.001, "X dimensions inconsistent");
assert(abs((box_inner_y - lip_y) + clearance - (-clearance)) < 0.001, "Y dimensions inconsistent");

// ---------------- Model ----------------
union() {
    // Part 1: Box
    difference() {
        cube([box_x, box_y, box_z]);
        // Open top: cut from above the top face
        translate([wall, wall, box_z - floor])
            cube([box_inner_x, box_inner_y, floor + eps]);
    }

    // Part 2: Lid (printed upside down)
    union() {
        // Base plate
        translate([0, 0, 0])
            cube([box_x, box_y, 2]);
        // Rectangular lip on top of the plate, centred on it
        translate([-lip_x / 2, -lip_y / 2, 0])
            cube([lip_x, lip_y, lip_h]);
    }
}