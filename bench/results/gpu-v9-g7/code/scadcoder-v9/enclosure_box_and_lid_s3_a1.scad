// Two-part enclosure for a small electronics board (e.g., Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), side by side, with a 10 mm gap.
// The lid is printed upside down: a flat plate with a rectangular lip on top that slides into
// the open-top box. The user specified the lid's outer size (65.6 x 45.6 mm), so that is
// used for the lip; the resulting clearance is about 0.2 mm on each side.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lid lip thickness (the wall on top of the plate)
lip_h      = 4;     // lid lip height (wall height above the plate)
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)

eps        = 0.5;   // cutter overshoot past faces
gap        = 10;    // horizontal gap between the two parts

$fn = 64;

// ---------------- Model ----------------
union() {
    // Part 1: open-top box
    translate([-box_x/2, -box_y/2, 0])
        difference() {
            cube([box_x, box_y, floor + wall]);   // floor + side walls
            translate([0, 0, floor])
                cube([box_x - 2*wall, box_y - 2*wall, wall + eps]);   // open top
        }

    // Part 2: lid (printed upside down: plate, then lip on top)
    translate([gap - gap/2, -lip_y/2, 0])
        union() {
            // base plate
            translate([-lip_x/2, -lip_y/2, 0])
                cube([lip_x, lip_y, lip_t]);
            // rectangular lip (wall), centred on the plate
            translate([-lip_x/2, -lip_y/2, lip_t])
                cube([lip_x, lip_y, lip_h]);
        }
}