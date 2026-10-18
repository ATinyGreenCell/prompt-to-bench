// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)
// Note: this is the upside-down open-box orientation relative to use

// ---------------- Parameters ----------------
outer_x      = 90;    // outer size in X (mm)
outer_y      = 90;    // outer size in Y (mm)
top_plate_t  = 2;     // top plate thickness (mm), z = 0..2
wall_t       = 2.5;   // wall thickness (mm)
open_top_z   = 40;    // height of open top edge (mm)
hole_d       = 4.5;   // M4 screw hole diameter (mm)
hole_pitch   = 71.5;  // square pattern side for screw holes (mm)
notch_w      = 12;    // power cable notch width (mm)
notch_depth  = 8;     // notch depth from open edge (mm), z = 32..40
eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 64;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, top_plate_t]);

        // Four walls from top plate up to open top
        for (x = [-1, 1], y = [-1, 1])
            translate([x * (outer_x/2 - wall_t), y * (outer_y/2 - wall_t), top_plate_t - 0.01])
                cube([2 * wall_t, 2 * wall_t, open_top_z - top_plate_t + 0.01]);
    }

    // Screw holes through top plate on square pattern
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([hole_pitch/2, 0, -eps])
                cylinder(d = hole_d, h = top_plate_t + 2 * eps);

    // Power cable notch in one wall, 8 mm down from open edge
    translate([-notch_w/2, outer_y/2 - wall_t, open_top_z - notch_depth])
        cube([notch_w, wall_t + eps, notch_depth + eps]);
}