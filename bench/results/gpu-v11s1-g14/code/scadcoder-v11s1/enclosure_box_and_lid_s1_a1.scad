// Two-part enclosure for small electronics board
// Print orientation: box standing on bed (z = 0), lid on top, printed upside down

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness

gap        = 10;    // gap between box and lid

lip_wall   = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)

eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Derived ----------------
box_inner_x = box_x - 2 * box_wall;
box_inner_y = box_y - 2 * box_wall;
box_inner_z = box_z - box_floor;   // open-top cavity height

// ---------------- Model ----------------
union() {
    // Part 1: box, open top
    difference() {
        cube([box_x, box_y, box_z]);
        translate([box_wall, box_wall, box_floor])
            cube([box_inner_x, box_inner_y, box_inner_z + 0.01]); // tiny floor
    }

    // Part 2: lid, printed upside down
    translate([box_x + gap, 0, 0]) {
        // base plate
        translate([-lip_x / 2, -lip_y / 2, 0])
            cube([lip_x, lip_y, 2]);
        // lip on top (overhangs the plate, slides into box opening)
        translate([-lip_x / 2, -lip_y / 2, 2])
            cube([lip_x, lip_y, lip_h]);
    }
}