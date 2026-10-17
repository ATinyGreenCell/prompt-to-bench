// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box standing on its floor, lid printed upside down on the +X side.
// Both parts are in the same file, side by side on the bed, with a 10 mm gap between them.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness (separate from walls for clarity)

lip_t      = 1.5;   // lid wall thickness
lip_h      = 4;     // lid wall height (extends above the 2 mm plate)
lip_x      = 65.6;  // lid outer length (X), 4.4 mm clearance inside box
lip_y      = 45.6;  // lid outer width (Y), 4.4 mm clearance inside box
plate      = 70;    // lid plate length (X)
plate_w    = 50;    // lid plate width (Y)

eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    difference() {
        cube([box_x, box_y, box_z - floor]);   // outer shell above floor
        translate([wall, wall, floor])
            cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor + 0.01]); // hollow, open top
    }

    // Part 2: Lid (printed upside down: plate on bed, lip pointing up)
    translate([box_x + 10, -plate_w / 2, 0])
        union() {
            cube([plate, plate_w, 2]);                      // base plate
            translate([-plate + lip_x / 2, -lip_y / 2, 0])
                cube([lip_x, lip_y, lip_h]);                    // lip/overhang (65.6 x 45.6, 4 mm tall)
        }
}