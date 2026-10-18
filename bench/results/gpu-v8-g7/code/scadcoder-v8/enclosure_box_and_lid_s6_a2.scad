// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), build upward, side by side.
// The lid is printed upside down: a flat plate with a rectangular lip on top that slides
// into the open-top box.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box side wall thickness
box_floor  = 2;     // box floor thickness

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height above the plate
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_clear  = 0.2;   // clearance between lip inner size and box opening (each side)

plate_t    = 2;     // lid plate thickness
gap        = 10;    // gap between box and lid on the bed
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    translate([-box_x/2, -box_y/2, 0])
        cube([box_x, box_y, box_z + box_floor]);

    // Part 2: Lid (plate + lip, printed upside down)
    translate([box_x/2 + gap, -box_y/2, 0])
        union() {
            // Plate
            cube([box_x, box_y, plate_t]);
            // Lip: 1.5 mm wall, 4 mm tall, centred on the plate
            translate([-lip_x/2, -lip_y/2, plate_t])
                cube([lip_x, lip_y, plate_t + lip_h]);
        }
}