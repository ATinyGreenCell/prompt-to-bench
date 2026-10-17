// Petri dish sowing template - flat disc with a 7 x 7 hole grid and a rim notch for orientation
// Print orientation: flat on the bed, z = 0 up to disc thickness

// ---------------- Parameters ----------------
disc_d        = 85;    // disc outer diameter
disc_t        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_nx       = 7;     // holes along X
hole_ny       = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing
notch_w       = 10;    // notch width (X)
notch_d       = 4;     // notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces
$fn           = 128;   // curve resolution

// Derived: grid centre offset so the outer holes lie near the rim
grid_r = (hole_nx - 1) * hole_pitch / 2;

// ---------------- Model ----------------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // Through-hole grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([grid_r * (i - (hole_nx - 1) / 2),
                       grid_r * (j - (hole_ny - 1) / 2),
                       -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch on the +Y side, centred on Y
    translate([-notch_w / 2, disc_d / 2 - notch_d, -eps])
        cube([notch_w, notch_d + eps, disc_t + 2 * eps]);
}