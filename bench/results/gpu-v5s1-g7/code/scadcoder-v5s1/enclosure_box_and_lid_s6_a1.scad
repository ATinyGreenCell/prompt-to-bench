// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Prints together: box on the left, lid (upside down) on the right, with a 10 mm gap.
// Units: mm. Wall thicknesses are 2 mm unless noted otherwise.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)

clearance  = 0.2;   // side clearance between lip and box opening
gap        = 10;    // gap between box and lid on the bed
eps        = 0.5;   // overshoot for clean boolean cuts

$fn = 64;

// Derived: lid plate thickness = lip height - wall thickness
plate_t = lip_h - wall;   // 2 mm plate

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    difference() {
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z + floor]);
        translate([-box_x/2 + wall, -box_y/2 + wall, floor])
            cube([box_x - 2*wall, box_y - 2*wall, box_z + 0.01]); // open-top cavity
    }

    // Part 2: Lid (printed upside down: plate on bed, lip pointing up)
    translate([box_x/2 + gap, -lip_y/2, 0])
        union() {
            // Base plate
            translate([0, 0, 0])
                cube([lip_x, lip_y, plate_t]);

            // Rectangular lip, centred on the plate
            translate([-lip_x/2, -lip_y/2, plate_t])
                cube([lip_x, lip_y, wall]);

            // Lip overhangs (4 mm tall, extends past the cavity with clearance)
            translate([-lip_x/2 - clearance, -lip_y/2 - clearance, plate_t + wall])
                cube([lip_x + 2*clearance, lip_y + 2*clearance, lip_h - wall]);
        }
}