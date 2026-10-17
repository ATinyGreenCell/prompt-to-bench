// DIY magnetic stirrer housing (print orientation: upside down)
// Units: mm

// ---------- Parameters ----------
fan_d        = 80;    // fan diameter
outer_x      = 90;    // outer size in X
outer_y      = 90;    // outer size in Y
top_t        = 2;     // top plate thickness (z = 0 to 2)
wall_t       = 2.5;   // wall thickness
wall_h       = 40;    // total wall height (z = 0 to 40)
hole_d       = 4.5;   // M4 screw hole diameter
hole_count   = 4;     // number of screw holes
hole_pitch   = 71.5;  // square pattern side length for holes
notch_w      = 12;    // cable notch width
notch_bottom = 8;     // notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    // Box body: top plate + four walls, open top at z = wall_h
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, wall_h]);

    // Screw holes through the top plate, centred on the plate
    for (i = [0 : hole_count - 1]) {
        a = (i % 2) * (hole_pitch - 2 * eps);  // x position
        b = (i / 2) * (hole_pitch - 2 * eps);  // y position (0, 35.75, 71.5, 35.75)
        translate([a, b, -eps])
            cylinder(d = hole_d, h = top_t + 2 * eps);
    }

    // Cable notch in one wall (along Y), centred, from z = wall_h - notch_bottom to open edge
    translate([-eps, -outer_y/2 - eps, wall_h - notch_bottom])
        cube([2 * eps + notch_w, outer_y + 2 * eps, notch_bottom + eps]);
}