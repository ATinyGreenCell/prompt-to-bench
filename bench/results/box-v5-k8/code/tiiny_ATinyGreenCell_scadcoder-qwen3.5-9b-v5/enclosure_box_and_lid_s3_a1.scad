// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie flat on the bed, side by side, with a 10 mm gap.
// The box prints as an open-top box; the lid prints upside down so its lip faces up.

// ---------------- Parameters ----------------
box_x      = 70;    // outer length of box (X)
box_y      = 50;    // outer width of box (Y)
box_h      = 30;    // outer height of box (Z)
wall       = 2;     // wall thickness throughout box and lid
floor      = 2;     // floor thickness under the box floor
gap        = 10;    // horizontal gap between box and lid on the bed
eps        = 0.5;   // cutter overshoot past faces

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height above the plate
lip_x      = 65.6;  // outer length of lip
lip_y      = 45.6;  // outer width of lip
clearance  = 0.2;   // clearance between lip outer size and box opening

$fn = 64;

// Derived
box_i_x = box_x - 2 * wall;   // box opening in X
box_i_y = box_y - 2 * wall;   // box opening in Y
lip_x1  = lip_x - 2 * clearance;
lip_y1  = lip_y - 2 * clearance;

// ---------------- Model ----------------
difference() {
    union() {
        // Box: open top, solid floor
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_h - floor]);

        // Lid: plate with centred lip, printed upside down
        translate([box_x / 2 + gap, -box_y / 2, 0])
            cube([box_x / 2 + gap, box_y, 2]);                          // plate
        translate([box_x / 2 + gap - wall, -box_y / 2, 0])
            cube([wall, box_y, lip_h + 2]);                             // lip walls (X / Z)
        translate([box_x / 2 + gap - wall, -box_y / 2 + wall, 0])
            cube([wall, box_y - 2 * wall, lip_h + 2]);                 // lip wall (Y / Z)
    }

    // Cut the lip pocket into the box so the lid slides in with the specified clearance
    translate([-box_x / 2 + wall, -box_y / 2 + wall, box_h - floor - eps])
        cube([box_i_x - 2 * wall, box_i_y - 2 * wall, eps]);
}