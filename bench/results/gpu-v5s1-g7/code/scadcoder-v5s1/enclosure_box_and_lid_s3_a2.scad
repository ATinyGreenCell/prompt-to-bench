// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Prints together: box on the left, lid (upside down) on the right, with a 10 mm gap.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height (from plate top)
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)
clearance  = 0.2;   // side clearance between lip and box opening

plate_t    = 2;     // lid plate thickness
gap        = 10;    // gap between box and lid on the bed

eps        = 0.5;   // cutter overshoot past faces
$fn        = 64;

// Derived
lip_x2 = lip_x + 2 * clearance;   // lip outer size with clearance
lip_y2 = lip_y + 2 * clearance;

// ---------------- Model ----------------
difference() {
    union() {
        // Part 1: Box (open top)
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_z + floor]);

        // Part 2: Lid (printed upside down: plate on bed, lip pointing up)
        translate([box_x / 2 + gap, -box_y / 2, 0])
            cube([lip_x2, box_y, plate_t]);
        translate([box_x / 2 + gap, -box_y / 2, plate_t])
            cube([lip_x2, box_y, lip_h]);
    }

    // Cut the lid lip into the box, leaving the clearance
    translate([-lip_x2 / 2, -lip_y2 / 2, floor + eps])
        cube([lip_x2, lip_y2, box_z - floor + 2 * eps]);
}