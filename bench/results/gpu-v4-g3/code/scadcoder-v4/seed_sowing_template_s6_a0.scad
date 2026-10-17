// Petri dish sowing template
// Print orientation: flat on bed, z = 0 upward

// ---------- Parameters ----------
disc_d        = 85;    // disc outer diameter
disc_t        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_pitch    = 9;     // centre-to-centre spacing
hole_nx       = 7;     // holes along X
hole_ny       = 7;     // holes along Y
notch_w       = 10;    // orientation notch width (X)
notch_d       = 4;     // orientation notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces
$fn           = 128;   // curve resolution

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // 7 x 7 through-hole grid, centred
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([
                (i - (hole_nx - 1) / 2) * hole_pitch,
                (j - (hole_ny - 1) / 2) * hole_pitch,
                -eps
            ])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([-notch_w / 2, 0, -eps])
        cube([notch_w, notch_d + eps, disc_t + 2 * eps]);
}