// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

// ---------- Dimensions ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // outer wall height (open top)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_pitch   = 71.5;  // square pattern pitch for screw holes
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Outer box body
    union() {
        // solid block under the open top
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([outer_x, outer_y, box_h]);
    }

    // open top (hollowed out, keeps walls)
    translate([-outer_x / 2, -outer_y / 2, box_h - wall_t])
        cube([outer_x - 2 * wall_t, outer_y - 2 * wall_t, wall_t]);

    // screw holes through the top plate
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * hole_pitch / 2, sy * hole_pitch / 2, -eps])
            cylinder(d = hole_d, h = plate_t + 2 * eps);

    // cable notch in one wall (z = 32 to 40, open edge at z = 40)
    translate([-outer_x / 2 + wall_t + notch_w / 2, -outer_y / 2, box_h - notch_depth])
        cube([notch_w, outer_y + 2 * eps, notch_depth + eps]);
}