// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // outer height of box (top of walls)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_pitch   = 71.5;  // square pattern pitch for screw holes
notch_w      = 12;    // cable notch width
notch_bottom = 8;     // notch depth from open edge (z = 32 to z = 40)
eps          = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    union() {
        // Top plate
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Four walls, 90 x 90 outer, rising to z = box_h
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_x / 2 - wall_t : -outer_x / 2,
                       sy > 0 ? outer_y / 2 - wall_t : -outer_y / 2,
                       0])
                cube([wall_t, wall_t, box_h]);
    }

    // Screw holes through top plate on 71.5 mm square pattern
    for (i = [0 : 3]) {
        x = -hole_pitch / 2 + (i - 1.5) * hole_pitch;
        y = -hole_pitch / 2 + (i - 1.5) * hole_pitch;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = plate_t + 2 * eps);
    }

    // Cable notch in one wall: 12 mm wide, centred along wall,
    // from z = 32 to z = 40 (open edge is at z = box_h)
    translate([-outer_x / 2 - eps, -notch_w / 2, box_h - notch_bottom])
        cube([notch_w + 2 * eps, wall_t, notch_bottom + eps]);
}