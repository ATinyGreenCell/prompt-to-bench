// Petri dish sowing template - flat disc with a 7x7 hole grid and a Y-side notch
// Print orientation: flat on the bed, z = 0 up to disc thickness

// ---------- Parameters ----------
disc_d        = 85;    // disc outer diameter
disc_t        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_count_x  = 7;     // holes along X
hole_count_y  = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing
notch_w       = 10;    // notch width (X)
notch_d       = 4;     // notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces

$fn = 128;

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // 7 x 7 hole grid, centred
    for (i = [-hole_count_x / 2 : hole_count_x / 2])
        for (j = [-hole_count_y / 2 : hole_count_y / 2])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch on the +Y rim side
    // (centred on the Y axis, 10 mm wide in X, 4 mm deep in Y)
    translate([0, disc_d / 2 - notch_d, -eps])
        cube([notch_w, notch_d + eps, disc_t + 2 * eps]);
}