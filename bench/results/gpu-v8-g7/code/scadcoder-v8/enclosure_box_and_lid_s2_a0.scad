// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), build upward, side by side.
// The lid is printed upside down: a flat plate with a rectangular lip on top that slides
// into the open-top box.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness (sides and floor)
box_floor  = 2;     // box floor thickness (separate from side walls per the spec)

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height above the plate
lip_x      = 65.6;  // outer lip size in X
lip_y      = 45.6;  // outer lip size in Y
lip_clear  = 0.2;   // clearance between lip inner edge and box opening on each side

plate_t    = 2;     // lid plate thickness
gap        = 10;    // gap between box and lid on the bed
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Derived ----------------
box_inner_x = box_x - 2 * box_wall;   // 66.0
box_inner_y = box_y - 2 * box_wall;   // 46.0
// lip inner size = box inner size - 2 * clearance
lip_in_x = box_inner_x - 2 * lip_clear; // 65.2
lip_in_y = box_inner_y - 2 * lip_clear; // 45.2

// ---------------- Model ----------------
union() {
    // Part 1: Box (open top)
    difference() {
        cube([box_x, box_y, box_z + box_floor]);
        // open-top cavity
        translate([box_wall, box_wall, box_floor])
            cube([box_inner_x, box_inner_y, box_z + eps]);
    }

    // Part 2: Lid (plate with top lip), placed on the +X side of the box
    translate([box_x + gap, 0, 0])
        union() {
            // plate lying on the bed
            translate([-lip_x / 2, -lip_y / 2, 0])
                cube([lip_x, lip_y, plate_t]);
            // rectangular lip on top of the plate
            translate([-lip_x / 2, -lip_y / 2, plate_t])
                cube([lip_in_x, lip_in_y, plate_t + lip_h]);
        }
}