// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness (mm)
wall_t       = 2.5;   // wall thickness (mm)
box_h        = 40;    // total height of box (mm)
outer_x      = 90;    // outer size in X (mm)
outer_y      = 90;    // outer size in Y (mm)
hole_d       = 4.5;   // M4 screw hole diameter (mm)
hole_pitch   = 71.5;  // square pattern side for screw holes (mm)
notch_w      = 12;    // cable notch width (mm)
notch_depth  = 8;     // cable notch depth from open edge (mm)
eps          = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Four walls rising from the plate to the open top
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([0, -outer_y/2, plate_t])
                    cube([outer_x/2, outer_y, box_h - plate_t]);
    }

    // Screw holes through the top plate, centred on the plate
    for (x = [-hole_pitch/2, hole_pitch/2])
        for (y = [-hole_pitch/2, hole_pitch/2])
            translate([x, y, -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);

    // Cable notch in one wall, centred along the wall,
    // reaching 8 mm down from the open edge (z = 32 to z = 40)
    translate([-outer_x/4, 0, box_h - notch_depth])
        cube([notch_w, outer_y, notch_depth + eps]);
}