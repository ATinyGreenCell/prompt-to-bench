// Two-part enclosure for a small electronics board (e.g. Arduino-based logger)
// Print orientation: box standing on the bed, lid plate flat on the bed.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X
box_y      = 50;    // box outer size in Y
box_z      = 30;    // box outer size in Z
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness

lip_t      = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lip outer size in X
lip_y      = 45.6;  // lip outer size in Y
lip_over   = 0.2;   // clearance between lip inner edge and box opening (each side)

gap        = 10;    // gap between the two parts on the bed

eps        = 0.5;   // cutter overshoot

$fn = 64;

// ---------------- Derived ----------------
box_inner_x = box_x - 2*box_wall;
box_inner_y = box_y - 2*box_wall;
lip_inner_x = lip_x - 2*lip_over;
lip_inner_y = lip_y - 2*lip_over;

// ---------------- Model ----------------
difference() {
    union() {
        // Part 1: box
        cube([box_x, box_y, box_z]);

        // Part 2: lid plate with lip
        translate([box_x + gap, 0, 0])
            cube([lip_x, lip_y, lip_h]);
    }

    // Lid lip sunk into the top of the box (open-top box)
    translate([box_x + gap - lip_inner_x/2,
               lip_y/2 - lip_inner_y/2,
               box_z - lip_t])
        cube([lip_inner_x, lip_inner_y, lip_h]);
}