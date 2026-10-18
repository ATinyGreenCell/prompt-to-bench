// Sowing template for a 90 mm Petri dish
// Print orientation: flat on bed, z = 0 upward

$fn = 128;

// --- Disc ---
disc_d      = 85;   // disc diameter
disc_t      = 2;    // disc thickness

// --- Holes ---
hole_d      = 3;    // hole diameter
hole_pitch  = 9;    // centre-to-centre spacing
hole_nx     = 7;    // holes along X
hole_ny     = 7;    // holes along Y

// --- Notch ---
notch_w     = 10;   // notch width (X)
notch_d     = 4;    // notch depth from rim (Y)

// --- Cutting overlap ---
eps         = 0.5;

difference() {
    // Disc centred on origin
    cylinder(d = disc_d, h = disc_t);

    // Hole grid centred on disc
    for (i = [-hole_nx/2 + 0.5 : 0.5 : hole_nx/2 - 0.5])
        for (j = [-hole_ny/2 + 0.5 : 0.5 : hole_ny/2 - 0.5])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Notch on +Y side, centred on Y axis
    translate([0, disc_d/2 - notch_d/2, 0])
        cube([notch_w, notch_d, disc_t + eps]);
}