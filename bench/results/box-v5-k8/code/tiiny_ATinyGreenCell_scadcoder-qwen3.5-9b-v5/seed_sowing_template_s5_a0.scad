// Sowing template for a 90 mm Petri dish
// Print orientation: flat on bed, holes facing up

// ---- Parameters ----
disc_d        = 85;    // disc outer diameter
disc_t       = 2;      // disc thickness
hole_d       = 3;      // through-hole diameter
hole_nx      = 7;      // holes along X
hole_ny      = 7;      // holes along Y
hole_pitch   = 9;      // centre-to-centre spacing
notch_w      = 10;     // notch width (X)
notch_d      = 4;      // notch depth from rim (Y)
eps          = 0.5;    // cutter overshoot past faces
$fn          = 128;    // smoothness of curved shapes

// ---- Model ----
difference() {
    // Main disc, centred in XY, resting on z = 0
    cylinder(d = disc_d, h = disc_t);

    // 7 x 7 grid of through-holes, centred on the disc
    for (i = [-hole_nx/2 : hole_nx/2])
        for (j = [-hole_ny/2 : hole_ny/2])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch on the +Y side, centred on Y
    translate([0, disc_d/2 - notch_d, -eps])
        cube([notch_w, notch_d + eps, disc_t + 2 * eps]);
}