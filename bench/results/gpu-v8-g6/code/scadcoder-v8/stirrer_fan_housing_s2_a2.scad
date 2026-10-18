// Magnetic stirrer housing - upside-down open box over a 80 mm PC fan
// Print orientation: top plate on bed (z = 0..2), walls rise to z = 40

$fn = 64;

// ---- Dimensions (mm) ----
top_t      = 2;     // top plate thickness
wall_t     = 2.5;   // wall thickness
box_h      = 40;    // wall height (open top at z = 40)
outer_w    = 90;    // outer size in X and Y
screw_p    = 71.5;  // square pitch of 4 screw holes
screw_d    = 4.5;   // M4 screw hole diameter
notch_w    = 12;    // cable notch width
notch_bot  = 8;     // notch depth from open edge (z = 32..40)
eps        = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    // Solid block
    translate([-outer_w/2, -outer_w/2, 0])
        cube([outer_w, outer_w, box_h + top_t]);

    // Screw holes through top plate
    for (sx = [-screw_p/2, screw_p/2])
        for (sy = [-screw_p/2, screw_p/2])
            translate([sx, sy, -eps])
                cylinder(d = screw_d, h = top_t + 2*eps);

    // Cable notch in one wall (centred along wall, z = 32..40)
    translate([-outer_w/2, -notch_w/2, box_h - notch_bot])
        cube([outer_w, notch_w, notch_bot + eps]);
}