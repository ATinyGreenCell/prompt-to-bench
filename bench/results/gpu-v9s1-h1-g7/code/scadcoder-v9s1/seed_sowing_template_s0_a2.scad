// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc thickness

$fn = 128;

// --- Disc ---
disc_d      = 85;   // disc diameter
disc_t      = 2;    // disc thickness

// --- Holes ---
hole_n_x    = 7;    // holes in X
hole_n_y    = 7;    // holes in Y
hole_d      = 3;    // hole diameter
hole_pitch  = 9;    // centre-to-centre spacing

// --- Notch ---
notch_w     = 10;   // notch width (X)
notch_d     = 4;    // notch depth from rim (Y)

eps         = 0.5;  // cutter overshoot

difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // Hole grid
    for (i = [-hole_n_x / 2 : hole_n_x / 2 - 1])
        for (j = [-hole_n_y / 2 : hole_n_y / 2 - 1])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Orientation notch on +Y side, centred on Y axis
    translate([0, disc_t - notch_d, 0])
        linear_extrude(height = notch_w)
            polygon([[-notch_w / 2, disc_t], [notch_w / 2, disc_t],
                     [notch_w / 2, disc_t - notch_d],
                     [-notch_w / 2, disc_t - notch_d]]);
}