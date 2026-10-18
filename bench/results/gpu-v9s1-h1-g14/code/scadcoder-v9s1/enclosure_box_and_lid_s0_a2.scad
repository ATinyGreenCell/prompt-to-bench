// Two-part enclosure for small electronics board (e.g., Arduino-based logger)
// Print orientation: both parts flat on the bed, side by side along X.
// The lid is printed upside down so its lip overlaps the box opening.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length along X (mm)
box_y      = 50;    // box outer width along Y (mm)
box_z      = 30;    // box height along Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

lip_w      = 65.6;  // lid lip outer length along X (mm)
lip_d      = 45.6;  // lid lip outer width along Y (mm)
lip_h      = 4;     // lid lip height above plate (mm)
lip_t      = 1.5;   // lid lip wall thickness (mm)

gap        = 10;    // clear gap between box and lid (mm)

// ---------------- Derived ----------------
inner_x = box_x - 2 * box_wall;   // 66 mm
inner_y = box_y - 2 * box_wall;   // 46 mm
// Lip outer size minus clearance = plate size (0.2 mm clearance each side)
plate_x = lip_w - 0.4;            // 65.2 mm
plate_y = lip_d - 0.4;            // 45.2 mm
plate_z = box_z - lip_h;          // 26 mm (top of plate)

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
    union() {
        // Base plate, 2 mm thick, centred on origin in X/Y
        translate([-plate_x / 2, -plate_y / 2, 0])
            cube([plate_x, plate_y, 2]);

        // Rectangular lip on top of the plate
        translate([-lip_w / 2, -lip_d / 2, plate_z])
            cube([lip_w, lip_d, lip_h]);
    }
}

// ---------------- Assembly ----------------
// Box centred on origin in X/Y, resting on z = 0
translate([-box_x / 2, -box_y / 2, 0])
    box();

// Lid placed on the +X side, with the specified gap
translate([box_x / 2 + gap, -plate_y / 2, 0])
    lid();