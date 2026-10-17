// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box upright, lid upside down. They print together with a 10 mm gap.
// Units: mm

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_h      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height above plate
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
clearance  = 0.2;   // side clearance between lip and box opening

eps        = 0.5;   // cutter overshoot past faces
$fn        = 64;

// ---------------- Derived ----------------
box_i_x = box_x - 2 * wall;   // inner length
box_i_y = box_y - 2 * wall;   // inner width
box_i_h = box_h - floor;      // inner height (open top)

// ---------------- Model ----------------
union() {
    // Part 1: Box
    difference() {
        cube([box_x, box_y, box_h]);
        translate([wall, wall, floor])
            cube([box_i_x, box_i_y, box_i_h + eps]);   // open-top cavity
    }

    // Part 2: Lid (printed upside down)
    union() {
        // Base plate
        translate([0, 0, 0])
            cube([box_x, box_y, 2]);

        // Rectangular lip, centred on plate, extends past the box opening
        translate([0, 0, 2])
            cube([lip_x, lip_y, lip_h + eps]);
    }
}

// ---------------- Positioning ----------------
translate([-box_x / 2 - 5, -box_y / 2, 0])   // box, centred in XY
cube([box_x, box_y, box_h]);

translate([box_x / 2 + 10, -box_y / 2, 0])   // lid, centred in XY, on +X side
cube([box_x, box_y, box_h]);