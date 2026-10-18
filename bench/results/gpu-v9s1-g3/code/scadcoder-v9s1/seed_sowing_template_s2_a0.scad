// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---- Parameters ----
disc_d        = 85;    // disc outer diameter
disc_h        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_nx       = 7;     // holes along X
hole_ny       = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing
notch_w       = 10;    // orientation notch width (X)
notch_d       = 4;     // orientation notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces

$fn = 128;

// ---- Model ----
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // Through-hole grid, centred on disc
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1) / 2) * hole_pitch,
                       (j - (hole_ny - 1) / 2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular notch on +Y side, centred on Y axis
    translate([0, disc_d / 2 - notch_d / 2, 0])
        cube([notch_w, notch_d, disc_h + eps]);
}