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
clearance  = 0.2;   // side clearance between lip and box opening

gap        = 10;    // horizontal gap between box and lid
$fn        = 64;    // curve resolution

// Derived
box_in_x   = box_x - 2 * wall;   // box inner length
box_in_y   = box_y - 2 * wall;   // box inner width
lip_x2     = lip_x + 2 * clearance;  // lip outer size with clearance
lip_y2     = lip_y + 2 * clearance;

// ---------------- Model ----------------
union() {
    // Part 1: open-top box, centred in X/Y, resting on z = 0
    difference() {
        cube([box_x, box_y, box_z + floor]);
        translate([wall, wall, floor])
            cube([box_in_x, box_in_y, box_z + 1]);  // open top, extra height for clean cut
    }

    // Part 2: lid plate with a central lip, printed upside down
    translate([box_x + gap, 0, 0])
        union() {
            // Base plate
            cube([box_x + gap, box_y, 2]);
            // Central lip (wall 1.5 mm thick, 4 mm tall)
            translate([0, 0, 2])
                cube([lip_x2, lip_y2, lip_h]);
        }
}