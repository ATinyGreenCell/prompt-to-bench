// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box upright, lid upside down (on the +X side of the box)
// Units: mm

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_h      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
lip_t      = 1.5;   // lid lip thickness
lip_h      = 4;     // lid lip height (extends above the 2 mm plate)
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)
clearance  = 0.2;   // side clearance between lip and box opening
gap        = 10;    // gap between box and lid on the bed
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// Derived: box inner size
box_i_x = box_x - 2 * wall;
box_i_y = box_y - 2 * wall;

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    difference() {
        cube([box_x, box_y, box_h]);
        // open-top cavity, walls + floor
        translate([wall, wall, floor])
            cube([box_i_x, box_i_y, box_h - floor]);
    }

    // Part 2: Lid (plate with a centred lip that slides into the box opening)
    union() {
        // base plate, 2 mm thick, same footprint as the box
        cube([box_x, box_y, 2]);

        // lip: a rectangular block, 1.5 mm thick (X), 4 mm tall (Z),
        // outer size 65.6 x 45.6 mm, centred on the plate
        translate([-lip_x / 2, -lip_y / 2, 0])
            cube([lip_x, lip_y, 2 + lip_h]);
    }
}

// ---------------- Layout ----------------
translate([-box_x / 2 - gap / 2, -box_y / 2, 0])      // box
cube([box_x, box_y, box_h]);

translate([box_x / 2 - gap / 2, -box_y / 2, 0])       // lid
cube([box_x, box_y, 2 + lip_h]);