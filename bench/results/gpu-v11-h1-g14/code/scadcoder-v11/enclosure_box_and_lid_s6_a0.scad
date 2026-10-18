// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts flat on the bed, side by side along X

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X (mm)
box_y      = 50;    // box outer size in Y (mm)
box_z      = 30;    // box outer size in Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

lip_t      = 1.5;   // lid lip wall thickness (mm)
lip_h      = 4;     // lid lip height above plate (mm)
lip_x      = 65.6;  // lip outer size in X (mm)
lip_y      = 45.6;  // lip outer size in Y (mm)

eps        = 0.01;  // small overlap to avoid coplanar faces (mm)
gap        = 10;    // gap between box and lid on the bed (mm)

// Derived
box_inner_x = box_x - 2 * box_wall;
box_inner_y = box_y - 2 * box_wall;
plate_t     = 2;    // lid plate thickness (mm)

// ---------------- Model ----------------
union() {
    // Part 1: Box, open top
    translate([-box_x / 2, -box_y / 2, 0])
        cube([box_x, box_y, box_z - box_floor]);

    // Part 2: Lid, printed upside down
    translate([box_x / 2 + gap, -box_y / 2, 0])
        cube([lip_x, lip_y, plate_t]);

    // Lip on top of the lid plate, sliding into the box opening
    translate([box_x / 2 + gap - lip_x / 2, -box_y / 2, plate_t])
        cube([lip_x, lip_y, lip_h]);
}