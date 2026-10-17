// DIY magnetic stirrer housing - print orientation (upside down)
// Units: mm

$fn = 64;

// --- Dimensions ---
top_t      = 2;     // top plate thickness
wall_t     = 2.5;   // wall thickness
box_h      = 40;    // total height (open top at z = 40)
outer_x    = 90;    // outer size in X
outer_y    = 90;    // outer size in Y
screw_h    = 4.5;   // M4 screw hole diameter
screw_n    = 4;     // number of screw holes
screw_p    = 71.5;  // square pitch of screw holes
notch_w    = 12;    // cable notch width
notch_d    = 8;     // notch depth from open edge
eps        = 0.5;   // cutter overshoot

// --- Model ---
difference() {
    union() {
        // Top plate (on bed)
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, top_t]);

        // Four walls rising to open top
        for (x = [-outer_x/2, outer_x/2])
            for (y = [-outer_y/2, outer_y/2])
                translate([x - wall_t/2, y - wall_t/2, top_t])
                    cube([wall_t, wall_t, box_h - top_t]);
    }

    // Screw holes through top plate, centred on plate
    for (i = [0 : screw_n - 1]) {
        a = (i - screw_n/2) * screw_p;
        translate([a, a, -eps])
            cylinder(d = screw_h, h = top_t + 2*eps);
    }

    // Cable notch in one wall, centred along the wall
    translate([-outer_x/2 + wall_t/2, 0, box_h - top_t - notch_d])
        cube([notch_w, outer_y + 2*eps, notch_d + 2*eps]);
}