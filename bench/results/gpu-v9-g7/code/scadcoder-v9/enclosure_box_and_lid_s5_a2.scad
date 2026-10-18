// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts lie on the bed, side by side, with a 10 mm gap.
// The lid is printed upside down so its lip forms an overhang (a solid block here).

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness

lip_t      = 1.5;   // lid lip thickness
lip_h      = 4;     // lid lip height (from plate top)
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_over   = 0.2;   // lip overlap into box opening (clearance on each side)

eps        = 0.5;   // cutter overshoot past faces
gap        = 10;    // gap between box and lid on the bed

$fn = 64;

// ---------------- Model ----------------
union() {
    // Part 1: open-top box
    translate([-box_x/2, -box_y/2, 0])
        difference() {
            cube([box_x, box_y, floor + wall]);   // floor + side walls
            translate([0, 0, floor])
                cube([box_x - 2*wall, box_y - 2*wall, wall + eps]);  // open top
        }

    // Part 2: lid (printed upside down: plate on bed, lip on top)
    translate([box_x/2 + gap, -box_y/2, 0])
        union() {
            // base plate
            translate([-lip_x/2, -lip_y/2, 0])
                cube([lip_x, lip_y, lip_t]);
            // rectangular lip, centred on the plate
            translate([-lip_x/2, -lip_y/2, lip_t])
                cube([lip_x, lip_y, lip_h]);
        }
}