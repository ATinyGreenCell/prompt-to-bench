// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), side by side, with a 10 mm gap.
// Part 1 (box) is printed upright (open top). Part 2 (lid) is printed upside down
// as a flat plate with a lip that slides into the box opening.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height (from plate top)
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_clear  = 0.2;   // clearance between lip and box opening (each side)

plate_t    = 2;     // plate thickness
gap        = 10;    // gap between box and lid on the bed
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// Derived
box_i_x = box_x - 2 * box_wall;   // box opening length
box_i_y = box_y - 2 * box_wall;   // box opening width
lip_x0  = (lip_x - box_i_x - 2 * lip_clear) / 2;  // lip X offset from plate edge
lip_y0  = (lip_y - box_i_y - 2 * lip_clear) / 2;  // lip Y offset from plate edge

// ---------------- Model ----------------
union() {
    // Part 1: box, upright
    translate([-box_x / 2, -box_y / 2, 0])
        cube([box_x, box_y, box_z]);

    // Part 2: lid, printed upside down
    translate([box_x / 2 + gap, -box_y / 2, 0])
        cube([box_x, box_y, plate_t]);

    // Lip on top of the plate (overhangs the plate top; prints upside down)
    translate([box_x / 2 + gap + lip_x0, -box_y / 2 + lip_y0, plate_t])
        cube([lip_x, lip_y, lip_h]);
}

// ---------------- Cutters ----------------
difference() {
    // Box: remove the open-top cavity
    translate([-box_x / 2, -box_y / 2, box_floor])
        cube([box_i_x, box_i_y, box_z - box_floor + eps]);

    // Lip: sink the lip wall into the plate (through the plate and a bit into the bed)
    translate([box_x / 2 + gap + lip_x0, -box_y / 2 + lip_y0, plate_t])
        cube([lip_x - 2 * eps, lip_y - 2 * eps, lip_h + plate_t + eps]);
}