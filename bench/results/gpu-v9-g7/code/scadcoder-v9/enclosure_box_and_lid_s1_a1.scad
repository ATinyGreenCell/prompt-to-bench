// Two-part enclosure for a small electronics board (e.g., Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), side by side on the XY plane.
// The lid is printed upside down: a flat plate on the bed with a wall (lip) rising in +Z,
// so it slides into the open-top box. A 10 mm gap between the parts prevents fusion.
//
// Author: [your name]
// Date   : [today's date]
// Notes  : Measure each part again after printing to check for warping or shrinkage.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
eps        = 0.5;   // cutter overshoot past faces

lid_t      = 2;     // lid plate thickness
lip_h      = 4;     // lid lip (wall) height
lip_w      = 65.6;  // lip outer length (X)
lip_d      = 45.6;  // lip outer width (Y)
lip_over   = 0.2;   // lip overlap into box opening (clearance on each side)

gap        = 10;    // horizontal gap between box and lid
$fn        = 64;    // curve resolution (no curved features here; kept per convention)

// Derived
lip_t = wall;       // lip thickness equals wall thickness (30-degree rule)

// ---------------- Model ----------------
union() {
    // Part 1: open-top box
    translate([-box_x/2, -box_y/2, 0])
        difference() {
            cube([box_x, box_y, box_z]);
            translate([0, 0, floor])
                cube([box_x - 2*wall, box_y - 2*wall, box_z - floor + eps]);
        }

    // Part 2: lid (printed upside down)
    translate([box_x/2 + gap, -lip_d/2, 0])
        cube([lip_w, lip_d, lid_t]);

    // Lip on top of the lid plate
    translate([box_x/2 + gap, -lip_d/2, lid_t])
        cube([lip_w, lip_d, lip_h]);
}