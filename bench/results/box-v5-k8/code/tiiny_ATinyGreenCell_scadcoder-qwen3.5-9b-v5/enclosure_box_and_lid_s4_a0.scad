// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts on the bed, side by side, with a 10 mm gap between them.
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
lip_h      = 4;     // lid wall height (above the 2 mm plate)
lip_x      = 65.6;  // lid outer length (X)
lip_y      = 45.6;  // lid outer width (Y)
lip_clear  = 0.2;   // clearance between lid and box opening (each side)
gap        = 10;    // gap between the two printed parts

$fn = 64;

// ---------------- Derived ----------------
box_i_x = box_x - 2 * wall;   // inner length (X)
box_i_y = box_y - 2 * wall;   // inner width (Y)
// lid lip height above the bed = plate (2 mm) + wall (1.5 mm) + extra (4 mm)
lip_total_h = 2 + lip_t + lip_h;   // 7.5 mm

// ---------------- Model ----------------
union() {
    // Part 1: Box, open top, centred in X/Y, resting on z = 0
    difference() {
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_h]);
        // Open the top: cut a rectangle that extends past the top face
        translate([-box_i_x / 2, -box_i_y / 2, box_h - eps])
            cube([box_i_x, box_i_y, eps + 1]);
    }

    // Part 2: Lid, printed upside down, on the +X side of the box
    translate([box_x / 2 + gap, -lip_y / 2, 0])
        difference() {
            // Plate + lip block
            translate([0, 0, 0])
                cube([lip_x, lip_y, lip_total_h]);
            // Cut a recess so the lip walls stand 4 mm above the bed
            translate([0, 0, lip_total_h - lip_h])
                cube([lip_x, lip_y, lip_h + eps]);
            // Recesses for the box opening, with 0.2 mm clearance on each side
            translate([-lip_x / 2 + eps, -lip_y / 2 + eps, 0])
                cube([box_i_x + 2 * eps, box_i_y + 2 * eps, lip_total_h]);
        }
}