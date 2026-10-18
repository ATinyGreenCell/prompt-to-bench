// Magnetic stirrer housing - open box covering an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40

// ---------- Parameters ----------
top_t      = 2;     // top plate thickness
wall_t     = 2.5;   // wall thickness
box_h      = 40;    // wall height (open top at z = 40)
outer_w    = 90;    // outer size in X and Y
hole_d     = 4.5;   // M4 screw hole diameter
hole_pitch = 71.5;  // square pattern side for screw holes
notch_w    = 12;    // cable notch width
notch_bottom = 32;  // notch floor height (notch runs z = 32 to 40)
eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_w/2, -outer_w/2, 0])
            cube([outer_w, outer_w, top_t]);

        // Four walls, open top
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_w/2 - wall_t : -outer_w/2,
                       sy > 0 ? outer_w/2 - wall_t : -outer_w/2,
                       top_t])
                cube([wall_t, wall_t, box_h - top_t]);
    }

    // Screw holes through top plate
    for (x = [-hole_pitch/2, hole_pitch/2],
         y = [-hole_pitch/2, hole_pitch/2])
        translate([x, y, -eps])
            cylinder(d = hole_d, h = top_t + 2*eps);

    // Cable notch in one wall (centred along +Y wall)
    translate([outer_w/2 - wall_t, -notch_w/2, notch_bottom])
        cube([wall_t + eps, notch_w, box_h - notch_bottom + eps]);
}