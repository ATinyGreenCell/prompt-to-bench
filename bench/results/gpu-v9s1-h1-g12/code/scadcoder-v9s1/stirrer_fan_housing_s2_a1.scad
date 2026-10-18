// Magnetic stirrer housing - upside-down open box
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // overall height
outer_w      = 90;    // outer size in X and Y
screw_holes  = 4;     // M4 screw holes in top plate
screw_pitch  = 71.5;  // square pattern pitch for screw holes
notch_w      = 12;    // cable notch width
notch_d      = 8;     // cable notch depth from open edge
eps          = 0.5;   // overcut for clean differences

$fn = 64;

// ---------- Model ----------
difference() {
    // Top plate (now at bottom)
    translate([-outer_w/2, -outer_w/2, 0])
        cube([outer_w, outer_w, plate_t]);

    // Four walls, open top
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([0, -outer_w/2, plate_t])
                cube([outer_w, wall_t, box_h - plate_t]);

    // Screw holes through top plate
    for (i = [-1, 1])
        for (j = [-1, 1])
            translate([i * screw_pitch/2, j * screw_pitch/2, -eps])
                cylinder(d = 4.5, h = plate_t + 2*eps);

    // Cable notch in one wall (cut from open edge)
    translate([-outer_w/2 + (outer_w - notch_w)/2,
               -outer_w/2 - eps,
               box_h - notch_d])
        cube([notch_w, wall_t + 2*eps, notch_d + eps]);
}