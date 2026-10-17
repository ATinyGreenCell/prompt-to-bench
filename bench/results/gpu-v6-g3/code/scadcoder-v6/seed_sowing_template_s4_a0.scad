// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc_t

$fn = 128;

// --- Disc ---
disc_d     = 85;    // disc diameter
disc_t     = 2;     // disc thickness

// --- Hole grid ---
hole_n     = 7;     // holes per side (7 x 7)
hole_d     = 3;     // hole diameter
hole_pitch = 9;     // centre-to-centre spacing

// --- Notch ---
notch_w    = 10;    // notch width (X)
notch_d    = 4;     // notch depth from rim (Y, +Y side)

// --- Misc ---
eps        = 0.5;   // cutter overshoot

difference() {
    // Disc
    cylinder(d = disc_d, h = disc_t);

    // Hole grid, centred
    for (i = [0 : hole_n - 1])
        for (j = [0 : hole_n - 1])
            translate([j * hole_pitch - (hole_n - 1) * hole_pitch / 2,
                       i * hole_pitch - (hole_n - 1) * hole_pitch / 2,
                       -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch on +Y rim
    translate([-notch_w / 2, disc_d / 2 - notch_d, -eps])
        cube([notch_w, notch_d + eps, disc_t + 2 * eps]);
}