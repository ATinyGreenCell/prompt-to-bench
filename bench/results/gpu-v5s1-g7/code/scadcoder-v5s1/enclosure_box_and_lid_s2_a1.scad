// Two-part enclosure for small electronics board (e.g. Arduino-based temperature logger)
// Prints together in one job: box on left, upside-down lid on right, with a gap.
// Units: mm. No external libraries.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
eps        = 0.5;   // cutter overshoot past faces

lip_t      = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)
clearance  = 0.2;   // clearance between lip and box opening
gap        = 10;    // gap between box and lid on bed

$fn = 64;

// Derived
box_in_x = box_x - 2 * wall;
box_in_y = box_y - 2 * wall;
lip_x2   = lip_x + 2 * clearance;   // lip outer size with clearance
lip_y2   = lip_y + 2 * clearance;

// ---------------- Model ----------------
union() {
    // Part 1: open box, resting on z = 0, centred in X/Y
    difference() {
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_z + floor]);
        translate([-box_in_x / 2, -box_in_y / 2, floor])
            cube([box_in_x, box_in_y, box_z + 1]);   // open top
    }

    // Part 2: lid plate with a central lip, printed upside down
    translate([box_x / 2 + gap, -lip_y2 / 2, 0])
        difference() {
            // Base plate, 70 x 50 x 2 mm
            translate([-lip_x2 / 2, -lip_y2 / 2, 0])
                cube([lip_x2, lip_y2, 2]);
            // Lip: a wall 1.5 mm thick and 4 mm tall, centred on the plate
            translate([-lip_x2 / 2, -lip_y2 / 2, 0])
                cube([lip_x2, lip_y2, lip_h + eps]);
        }
    }
}