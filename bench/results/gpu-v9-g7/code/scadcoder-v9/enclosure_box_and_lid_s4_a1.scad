// Two-part enclosure for a small electronics board (e.g., Arduino-based logger)
// Print orientation: both parts lie on the bed, side by side, open faces up.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_h      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lid lip thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_over   = 0.2;   // lip overlap into box opening (clearance on each side)

eps        = 0.5;   // cutter overshoot past faces
gap        = 10;    // horizontal gap between the two parts

$fn = 64;

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    translate([-box_x/2, -box_y/2, 0])
        difference() {
            cube([box_x, box_y, floor + wall + box_h - wall]);
            // open the top face, cut through the lid plate
            translate([-box_x/2 - eps, -box_y/2 - eps, floor + wall])
                cube([box_x + 2*eps, box_y + 2*eps, eps]);
        }

    // Part 2: Lid (printed upside down: plate on bed, lip pointing up)
    translate([box_x/2 + gap, -lip_y/2, 0])
        union() {
            // base plate
            translate([-lip_x/2, -lip_y/2, 0])
                cube([lip_x, lip_y, lip_t]);
            // rectangular lip wall, centred on the plate
            translate([-lip_x/2, -lip_y/2, lip_t])
                cube([lip_x, lip_y, lip_h]);
        }
}