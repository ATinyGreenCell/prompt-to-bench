// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie on the bed (z = 0), side by side, with a 10 mm gap.
// The box is open-topped; the lid is printed upside down and slides into the box opening.
// Units: mm. No external libraries.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_h      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
eps        = 0.5;   // cutter overshoot past faces

lip_t      = 1.5;   // lid wall thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lid outer length (X)
lip_y      = 45.6;  // lid outer width (Y)
clearance  = 0.2;   // clearance between lid and box opening
gap        = 10;    // gap between the two parts on the bed

$fn = 64;

// ---------------- Derived ----------------
box_i_x = box_x - 2 * wall;   // inner length
box_i_y = box_y - 2 * wall;   // inner width
box_i_h = box_h - floor;      // inner height (floor under, open top)

// ---------------- Models ----------------
module box() {
    difference() {
        cube([box_x, box_y, box_h]);
        // open the top: cut a block above the floor, through the walls and ceiling
        translate([wall, wall, floor])
            cube([box_i_x + eps, box_i_y + eps, box_i_h + eps]);
    }
}

module lid() {
    // Plate base
    t = 2;  // plate thickness
    // Rectangular lip on top of the plate, centred on it
    // (printed upside down, the lip becomes an undercut that snaps into the box)
    difference() {
        union() {
            cube([box_x, box_y, t]);
            cube([lip_x, lip_y, t + lip_h]);
        }
        // cut the lip's top face so the wall is exactly lip_t thick
        translate([-lip_x / 2, -lip_y / 2, t])
            cube([lip_x, lip_y, lip_h + eps]);
    }
}

// ---------------- Assembly ----------------
translate([-box_x / 2 - gap / 2, 0, 0]) box();      // box on -X side
translate([box_x / 2 - gap / 2, 0, 0]) rotate([0, 90, 0]) lid();  // lid on +X side, upside down

// Result: a single print with two parts, 10 mm apart, the lid sliding into the box opening.