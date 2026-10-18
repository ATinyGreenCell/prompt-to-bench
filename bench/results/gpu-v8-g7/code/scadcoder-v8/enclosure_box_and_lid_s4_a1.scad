// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), build upward, side by side.
// The lid is printed upside down: a flat plate on the bed with a lip that drops into the box.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness (sides and floor)
floor      = 2;     // box floor thickness (separate from side walls for clarity)

lip_t      = 1.5;   // lid lip thickness (the wall of the lip)
lip_h      = 4;     // lid lip height (extends above the box opening)
lip_x      = 65.6;  // outer length of the lip (X)
lip_y      = 45.6;  // outer width of the lip (Y)
clearance  = 0.2;   // gap between lip outer size and box opening on each side

gap        = 10;    // bed gap between the two parts (X direction)
overlap    = 0.01;  // small overlap so the lip fuses into the plate

$fn = 64;

// ---------------- Derived ----------------
inner_x = box_x - 2 * wall;   // box opening length
inner_y = box_y - 2 * wall;   // box opening width
plate_t = 2;                  // base plate thickness under the lip

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    translate([-box_x / 2, -box_y / 2, 0])
        hull() {
            // Floor
            translate([-box_x / 2, -box_y / 2, -floor])
                cube([box_x, box_y, floor]);
            // Side walls (extend above the open top)
            translate([-box_x / 2, -box_y / 2, box_z - wall])
                cube([box_x, box_y, wall]);
        }

    // Part 2: Lid, printed upside down
    translate([box_x / 2 + gap, -box_y / 2, 0])
        union() {
            // Base plate lying on the bed
            translate([-lip_x / 2, -lip_y / 2, 0])
                cube([lip_x, lip_y, plate_t]);
            // Lip: a wall of thickness lip_t, height lip_h, centred on the plate.
            // Its outer size is 65.6 x 45.6, so it slides into the 68 x 46 opening
            // with 0.2 mm clearance on each side.
            translate([-lip_x / 2, -lip_y / 2, plate_t - overlap])
                cube([lip_x, lip_y, plate_t + lip_h]);
        }
}