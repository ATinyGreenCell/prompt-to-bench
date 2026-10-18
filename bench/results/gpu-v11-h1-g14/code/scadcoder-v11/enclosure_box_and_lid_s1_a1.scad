// Two-part enclosure for a small electronics board (e.g. Arduino-based logger)
// Print orientation: box standing on the bed, lid plate flat on the bed, lip up.
// The parts are placed side by side on the +X axis with a 10 mm gap.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness (same as wall)

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height above plate
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_over   = 0.2;   // clearance between lip inner edge and box opening (each side)

gap        = 10;    // gap between the two parts on the bed
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Derived ----------------
inner_x = box_x - 2 * box_wall;   // box opening length
inner_y = box_y - 2 * box_wall;   // box opening width
lip_in_x = lip_x - 2 * lip_over;  // lip inner length (should equal inner_x - 2*eps)
lip_in_y = lip_y - 2 * lip_over;  // lip inner width (should equal inner_y - 2*eps)

// ---------------- Model ----------------
union() {
    // Part 1: Box, open top
    translate([-box_x / 2, -box_y / 2, 0])
        cube([box_x, box_y, box_z - box_floor]);

    // Part 2: Lid plate with rectangular lip
    // Plate lies on the bed (z = 0), lip builds upward.
    union() {
        translate([(box_x + gap) / 2 - lip_x / 2, -lip_y / 2, 0])
            cube([lip_x, lip_y, lip_h]);

        // Lip wall on top of the plate
        translate([(box_x + gap) / 2 - lip_in_x / 2, -lip_in_y / 2, lip_h - lip_t])
            cube([lip_in_x, lip_in_y, lip_t]);
    }
}