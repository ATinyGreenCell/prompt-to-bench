// Two-part enclosure for small electronics board
// Print orientation: box on bed (z = 0), lid on +X side, both build upward

// ---------- Parameters ----------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness

gap        = 10;    // gap between box and lid

lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_wall   = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height above plate

plate_x    = 70;    // plate length (X)
plate_y    = 50;    // plate width (Y)
plate_t    = 2;     // plate thickness

eps        = 0.5;   // cutter overshoot

$fn = 64;

// ---------- Derived ----------
box_xi = box_x - 2 * box_wall;   // box inner length
box_yi = box_y - 2 * box_wall;   // box inner width

// ---------- Model ----------
union() {
    // Box
    difference() {
        cube([box_x, box_y, box_z]);
        translate([-box_xi / 2, -box_yi / 2, box_floor])
            cube([box_xi, box_yi, box_z - box_floor + eps]);
    }

    // Lid
    translate([box_x + gap, 0, 0]) {
        union() {
            // Plate
            cube([plate_x, plate_y, plate_t]);
            // Lip
            translate([0, 0, plate_t])
                cube([lip_x, lip_y, lip_wall]);
        }
    }
}