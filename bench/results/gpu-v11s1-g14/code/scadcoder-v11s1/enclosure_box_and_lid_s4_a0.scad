// Two-part enclosure for small electronics board
// Print orientation: box standing on bed (z = 0), lid on top, printed upside down

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X (mm)
box_y      = 50;    // box outer size in Y (mm)
box_z      = 30;    // box outer size in Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

gap        = 10;    // gap between box and lid (mm)

lip_x      = 65.6;  // lid lip outer size in X (mm)
lip_y      = 45.6;  // lid lip outer size in Y (mm)
lip_w      = 1.5;   // lid lip thickness (mm)
lip_h      = 4;     // lid lip height (mm)

eps        = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------------- Model ----------------
union() {
    // Box: open-top enclosure
    difference() {
        cube([box_x, box_y, box_z]);
        translate([box_wall, box_wall, box_floor])
            cube([box_x - 2*box_wall, box_y - 2*box_wall, box_z - box_floor + eps]);
    }

    // Lid: plate with a rectangular lip on top, centred
    translate([box_x + gap, 0, 0])
        union() {
            // Base plate
            translate([-lip_x/2, -lip_y/2, 0])
                cube([lip_x, lip_y, lip_w]);
            // Lip, overlapping the plate slightly for a clean union
            translate([-lip_x/2, -lip_y/2, 0])
                cube([lip_x, lip_y, lip_h + 0.01]);
        }
}