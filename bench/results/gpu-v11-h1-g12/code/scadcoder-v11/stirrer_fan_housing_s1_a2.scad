// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

// ---------- Dimensions ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // outer wall height (open top at z = 40)
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
hole_d       = 4.5;   // M4 screw hole diameter
hole_n       = 4;     // number of screw holes
hole_pitch   = 71.5;  // square pattern side length for holes
notch_w      = 12;    // cable notch width
notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Solid outer block
    translate([-outer_x / 2, -outer_y / 2, 0])
        cube([outer_x, outer_y, box_h]);

    // Screw holes through top plate
    for (i = [0 : hole_n - 1]) {
        x = (i % 2 - 0.5) * hole_pitch;
        y = (i / 2 - 0.5) * hole_pitch;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = plate_t + 2 * eps);
    }

    // Cable notch in one wall (z = 32 to 40, open edge at 40)
    translate([-hole_pitch / 2 - wall_t, -notch_w / 2, box_h - notch_depth])
        cube([hole_pitch / 2 + wall_t, notch_w, notch_depth + eps]);
}