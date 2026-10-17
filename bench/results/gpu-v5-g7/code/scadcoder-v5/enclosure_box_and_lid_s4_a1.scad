// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box upright, lid upside-down. They print together with a 10 mm gap.
// Units: mm

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_h      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height (from plate top)
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
clearance  = 0.2;   // side clearance between lip and box opening

gap        = 10;    // horizontal gap between box and lid during print
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// Derived: inner size of box opening
inner_x = box_x - 2 * wall;   // 66
inner_y = box_y - 2 * wall;   // 46

// ---------------- Model ----------------
difference() {
    union() {
        // Part 1: Box (open top)
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_h - floor]);   // floor included in height

        // Part 2: Lid (plate + centred lip), printed upside-down
        translate([box_x / 2 + gap, -box_y / 2, 0])
            cube([box_x / 2 + gap, box_y, 2]);                          // plate (2 mm thick)
        translate([box_x / 2 + gap, -box_y / 2, 2])
            cube([lip_x, lip_y, lip_h]);                                 // lip on plate
    }

    // Notch the lip so it slides into the box opening with the specified clearance
    translate([box_x / 2 + gap - lip_x / 2 - clearance,
                -box_y / 2 - lip_y / 2 - clearance,
                2 + eps])
        cube([lip_x + 2 * clearance,
              lip_y + 2 * clearance,
              lip_h + eps]);
}