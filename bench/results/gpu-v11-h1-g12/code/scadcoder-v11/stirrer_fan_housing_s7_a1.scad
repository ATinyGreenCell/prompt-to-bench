// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness (mm)
wall_t       = 2.5;   // wall thickness (mm)
box_h        = 40;    // total height of box (mm)
outer_x      = 90;    // outer size in X (mm)
outer_y      = 90;    // outer size in Y (mm)
hole_d       = 4.5;   // M4 screw hole diameter (mm)
hole_pitch   = 71.5;  // screw hole square pattern size (mm)
notch_w      = 12;    // cable notch width (mm)
notch_depth  = 8;     // cable notch depth from open edge (mm)
eps          = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Model ----------
difference() {
    // Outer box body
    union() {
        // Top plate
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Walls (open top)
        for (sides = [0, 90, 180, 270])
            rotate([0, 0, sides])
                translate([outer_x / 2 - wall_t, -outer_y / 2, plate_t])
                    cube([wall_t, outer_y, box_h - plate_t]);
    }

    // Screw holes through top plate, centred on plate
    for (x = [-hole_pitch / 2, hole_pitch / 2])
        for (y = [-hole_pitch / 2, hole_pitch / 2])
            translate([x, y, -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);

    // Cable notch in one wall, centred along the wall, near the open edge
    translate([-outer_x / 2, -outer_y / 2, plate_t])
        rotate([90, 0, 0])
            translate([0, -notch_w / 2, box_h - notch_depth])
                cube([notch_w, outer_y / 2 + eps, notch_depth + eps]);
}