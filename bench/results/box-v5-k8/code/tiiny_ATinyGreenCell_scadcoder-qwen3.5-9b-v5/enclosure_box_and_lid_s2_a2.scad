// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie on the bed (z = 0), side by side, with a 10 mm gap.
// The box is open-topped; the lid is printed upside down and slides into the box opening.
// Units: mm. No external libraries.

// ---------------- Parameters ----------------
box_x      = 70;    // outer length of box (X)
box_y      = 50;    // outer width of box (Y)
box_h      = 30;    // overall height of box (Z)
wall       = 2;     // wall thickness (X and Y)
floor      = 2;     // floor thickness under the board (Z)

lip_t      = 1.5;   // lip wall thickness (Z)
lip_h      = 4;     // lip height above the plate (Z)
lip_x      = 65.6;  // outer length of lip (X)
lip_y      = 45.6;  // outer width of lip (Y)
lip_over   = 0.2;   // clearance between lip outer size and box opening (each side)

gap        = 10;    // horizontal gap between box and lid (X)
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Derived ----------------
box_i_x = box_x - 2 * wall;   // 66 mm inside length
box_i_y = box_y - 2 * wall;   // 46 mm inside width
lip_x1  = box_i_x - lip_over; // 65.8 mm (inner edge of lip aligns with box inner wall)
lip_x2  = box_i_x + lip_over; // 66.2 mm (outer edge of lip)

// ---------------- Model ----------------
union() {
    // Box: 2 mm walls, 2 mm floor, open top
    difference() {
        cube([box_x, box_y, box_h]);
        // open the top (cut down from z = box_h - floor)
        translate([wall, wall, box_h - floor])
            cube([box_i_x + 1, box_i_y + 1, floor + 1]);
    }

    // Lid: plate 70 x 50 x 2 mm with a centred rectangular lip on top, printed upside down
    translate([box_x + gap, 0, 0])
        difference() {
            union() {
                // base plate
                cube([box_x, box_y, 2]);
                // lip: wall 1.5 mm thick, 4 mm tall above the plate
                translate([0, 0, 2])
                    cube([lip_x, lip_y, lip_h]);
            }
            // cut the pocket the lip slides into (extends past the box top face)
            translate([wall, wall, box_h - floor])
                cube([box_i_x + 1, box_i_y + 1, floor + 1 + eps]);
        }
}