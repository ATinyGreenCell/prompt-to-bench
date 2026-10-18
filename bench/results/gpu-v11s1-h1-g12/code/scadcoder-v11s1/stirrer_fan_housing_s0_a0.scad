// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate down on bed (z = 0), walls build upward (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height of box (top of walls)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // screw hole diameter (M4)
hole_pitch   = 71.5;  // square pattern pitch for screw holes
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // cable notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    union() {
        // Top plate (lies on z = 0)
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([outer_x, outer_y, plate_t]);

        // Four walls rising from plate to z = box_h
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (outer_x / 2 - wall_t), sy * (outer_y / 2 - wall_t), plate_t])
                cube([2 * wall_t, 2 * wall_t, box_h - plate_t]);
    }

    // Screw holes through top plate on centred square pattern
    for (i = [0 : 3]) {
        x = -hole_pitch / 2 + (i - 1.5) * hole_pitch;
        y = -hole_pitch / 2 + (i - 1.5) * hole_pitch;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = plate_t + 2 * eps);
    }

    // Cable notch in one wall, centred along the wall
    translate([-outer_x / 2 + wall_t, 0, box_h - notch_depth])
        cube([notch_w, wall_t, notch_depth + eps]);
}