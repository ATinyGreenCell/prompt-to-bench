// Two-part enclosure for small electronics board
// Print orientation: box on bed (z = 0), lid on +X side, both build upward

$fn = 64;

// ---- Dimensions (mm) ----
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness
gap        = 10;    // gap between box and lid

lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)
lip_t      = 1.5;   // lid lip thickness
lip_h      = 4;     // lid lip height above plate

eps        = 0.5;   // cutter overshoot past faces

// ---- Derived ----
box_x0 = -box_x / 2;
box_y0 = -box_y / 2;
box_z0 = floor;     // inner cavity starts at z = floor

// ---- Model ----
union() {
    // Box: open-top enclosure
    difference() {
        translate([box_x0, box_y0, 0])
            cube([box_x, box_y, box_z]);
        translate([box_x0, box_y0, box_z0])
            cube([box_x, box_y, box_z - box_z0 + eps]); // open top
    }

    // Lid: plate with sliding lip, printed upside down
    translate([box_x0 + gap, box_y0, 0]) {
        // Base plate
        translate([-lip_x / 2, -lip_y / 2, 0])
            cube([lip_x, lip_y, lip_t]);
        // Lip on top of plate
        translate([-lip_x / 2, -lip_y / 2, lip_t])
            cube([lip_x, lip_y, lip_h]);
    }
}