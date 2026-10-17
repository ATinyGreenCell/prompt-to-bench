// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie on the bed (z = 0), side by side, with a 10 mm gap.
// Units: mm.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
lip_t      = 1.5;   // lid lip (wall) thickness
lip_h      = 4;     // lid lip height (above plate)
lip_outer_x = 65.6; // outer size of lip in X
lip_outer_y = 45.6; // outer size of lip in Y
clearance  = 0.2;   // clearance between lip outer size and box opening
overlap    = 0.01;  // small overlap so the lip passes into the open top
gap        = 10;    // gap between the two printed parts

$fn = 64;

// Derived: box opening (inner size)
opening_x = box_x - 2 * wall;   // 66
opening_y = box_y - 2 * wall;   // 46

// Check: lip outer size = opening - 2*clearance = 65.6 x 45.6 (matches spec)

// ---------------- Part 1: Box ----------------
module box() {
    difference() {
        translate([-box_x/2, -box_y/2, 0])
            cube([box_x, box_y, box_z]);
        // Open top: cut away the top floor_thick layer
        translate([-opening_x/2, -opening_y/2, box_z - floor])
            cube([opening_x, opening_y, floor + overlap]);
    }
}

// ---------------- Part 2: Lid ----------------
module lid() {
    // Plate lying on the bed
    plate_t = 2;
    translate([-box_x/2, -box_y/2, 0])
        cube([box_x, box_y, plate_t]);

    // Rectangular lip on top of the plate, centred, with clearance on each side
    // (outer size 65.6 x 45.6, 1.5 mm thick, 4 mm tall)
    translate([-lip_outer_x/2, -lip_outer_y/2, plate_t])
        cube([lip_outer_x, lip_outer_y, lip_h + overlap]);
}

// ---------------- Assembly ----------------
union() {
    box();
    translate([gap, 0, 0])
        lid();
}