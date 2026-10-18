// Two-part enclosure for small electronics board (e.g., Arduino-based temp logger)
// Print orientation: both parts flat on the bed, lid on the +X side of the box,
// with a 10 mm gap between them, so they print together in one go.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X (mm)
box_y      = 50;    // box outer size in Y (mm)
box_z      = 30;    // box outer size in Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

lip_w      = 65.6;  // lid lip outer size in X (mm)
lip_d      = 45.6;  // lid lip outer size in Y (mm)
lip_h      = 4;     // lid lip height above plate (mm)
lip_t      = 1.5;   // lid lip wall thickness (mm)
lip_plate  = 2;     // lid plate thickness (mm)

gap        = 10;    // gap between box and lid on the bed (mm)

eps        = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;           // curve resolution (no curved features here, set per rules)

// ---------------- Derived ----------------
inner_x = box_x - 2 * box_wall;   // 66 mm
inner_y = box_y - 2 * box_wall;   // 46 mm
// Lip outer size is 65.6 x 45.6, box inner is 66 x 46 -> 0.2 mm clearance each side
// Lip top face is at z = plate + lip_h = 6 mm above bed

// ---------------- Modules ----------------
module box() {
    difference() {
        translate([0, 0, 0])
            cube([box_x, box_y, box_z]);
        // Open-top cavity, walls and floor exactly as specified
        translate([box_wall, box_wall, box_floor])
            cube([inner_x, inner_y, box_z - box_floor]);
    }
}

module lid() {
    // Lid is printed upside down: plate on bed, lip on top of it
    union() {
        // Plate
        translate([0, 0, 0])
            cube([lip_w, lip_d, lip_plate]);
        // Lip: wall thick in X and Y, height lip_h
        translate([(lip_w - box_x) / 2, (lip_d - box_y) / 2, lip_plate])
            cube([box_x + (lip_w - box_x), box_y + (lip_d - box_y), lip_h]);
    }
}

// ---------------- Assembly ----------------
union() {
    translate([-gap / 2, 0, 0])
        box();
    translate([gap / 2, 0, 0])
        lid();
}