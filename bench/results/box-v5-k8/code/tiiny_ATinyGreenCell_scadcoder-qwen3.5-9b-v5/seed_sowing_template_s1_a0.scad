// Sowing template for Petri dish
// Print orientation: flat on bed, holes facing up

// ---- Parameters ----
disc_d        = 85;    // disc diameter
disc_t       = 2;      // disc thickness
hole_d       = 3;      // through-hole diameter
hole_nx      = 7;      // holes along X
hole_ny      = 7;      // holes along Y
hole_pitch   = 9;      // centre-to-centre spacing
notch_w      = 10;     // notch width (X)
notch_d      = 4;      // notch depth from rim (Y)
eps          = 0.5;    // cutter overshoot

$fn = 128;

// ---- Model ----
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // Hole grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([-hole_nx * hole_pitch / 2 + i * hole_pitch,
                       -hole_ny * hole_pitch / 2 + j * hole_pitch,
                       0])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Orientation notch on +Y side
    translate([0, disc_d / 2 - notch_d, -eps])
        cube([notch_w, notch_d + 2 * eps, disc_t + 2 * eps]);
}