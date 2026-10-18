// Two-part enclosure for a small electronics board (e.g., Arduino-based temperature logger)
// Print orientation: box standing on the bed, lid printed upside down on the +X side

// ---------- Parameters ----------
box_x      = 70;    // box outer size in X (mm)
box_y      = 50;    // box outer size in Y (mm)
box_z      = 30;    // box outer size in Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

lip_x      = 65.6;  // lip outer size in X (mm)
lip_y      = 45.6;  // lip outer size in Y (mm)
lip_t      = 1.5;   // lip wall thickness (mm)
lip_h      = 4;     // lip height above plate (mm)

eps        = 0.5;   // cutter overshoot past faces (mm)
gap        = 10;    // gap between the two parts (mm)

$fn = 64;

// ---------- Derived ----------
box_inner_x = box_x - 2 * box_wall;
box_inner_y = box_y - 2 * box_wall;
box_inner_z = box_z - box_floor;   // open top

plate_t = 2;        // lid plate thickness (mm)

// ---------- Model ----------
difference() {
    union() {
        // Box body (includes floor, open top)
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_z]);

        // Lid: plate + centred rectangular lip
        translate([(box_x - lip_x) / 2 + gap, -box_y / 2, 0])
            cube([lip_x, lip_y, plate_t]);

        translate([(box_x - lip_x) / 2 + gap, -lip_y / 2, plate_t])
            cube([lip_x, lip_y, lip_h]);
    }

    // Lip cutter: sink the lip into the plate so the union is not coplanar
    translate([(box_x - lip_x) / 2 + gap, -lip_y / 2, -eps])
        cube([lip_x, lip_y, plate_t + eps]);
}