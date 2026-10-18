// Two-part enclosure for small electronics board (e.g., Arduino-based logger)
// Print orientation: both parts on the bed (z = 0), building upward (+Z)
// Placed side by side with a 10 mm gap, so they print together

// ---------------- Parameters ----------------
box_x      = 70;    // Box outer size in X (mm)
box_y      = 50;    // Box outer size in Y (mm)
box_z      = 30;    // Box outer size in Z (mm)
box_wall   = 2;     // Box wall thickness (mm)
box_floor  = 2;     // Box floor thickness (mm)

lip_w      = 65.6;  // Lid lip outer size in X (mm)
lip_d      = 45.6;  // Lid lip outer size in Y (mm)
lip_h      = 4;     // Lid lip height above plate (mm)
lip_t      = 1.5;   // Lid lip wall thickness (mm)

plate_t    = 2;     // Lid plate thickness (mm)

gap        = 10;    // Gap between box and lid (mm)

eps        = 0.5;   // Overcut for clean boolean differences (mm)

$fn = 64;           // Curve resolution (no curved features here, set per rules)

// ---------------- Derived ----------------
lip_y2d    = lip_d + 2 * lip_t;   // Lip outer size in Y including walls
box_int_w  = box_x - 2 * box_wall; // Box inner width (opening in X)
box_int_d  = box_y - 2 * box_wall;   // Box opening in Y (same as wall thickness)

// ---------------- Modules ----------------
module box() {
    // Open-top box: full outer block with a hollowed-out top section
    difference() {
        cube([box_x, box_y, box_z]);
        // Cut from the top face down to below the floor
        translate([
            -box_x / 2 - eps,
            -box_y / 2 - eps,
            box_floor
        ])
        cube([
            box_int_w + 2 * eps,
            box_int_d + 2 * eps,
            box_z - box_floor
        ]);
    }
}

module lid() {
    // Lid printed upside down: a plate on the bed with a rectangular lip
    // The lip slides into the box opening with 0.2 mm clearance on each side
    union() {
        // Base plate
        translate([-lip_w / 2, -lip_d / 2, 0])
        cube([lip_w, lip_d, plate_t]);

        // Lip on top of the plate
        translate([-lip_w / 2, -lip_y2d / 2, plate_t])
        cube([lip_w, lip_y2d, lip_h]);
    }
}

// ---------------- Assembly ----------------
union() {
    box();          // Part 1: the open-top box
    translate([box_x / 2 + gap, 0, 0])
    lid();          // Part 2: the lid, on the +X side of the box
}