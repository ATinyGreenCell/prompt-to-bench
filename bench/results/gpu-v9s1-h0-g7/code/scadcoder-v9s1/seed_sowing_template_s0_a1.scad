// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---------- Parameters ----------
disc_d        = 85;    // disc outer diameter
disc_h        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_count_x  = 7;     // holes along X
hole_count_y  = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing
notch_w       = 10;    // orientation notch width (X)
notch_d       = 4;     // orientation notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces

$fn = 128;

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // Grid of through-holes, centred on disc
    for (i = [-(hole_count_x - 1) / 2 : (hole_count_x - 1) / 2])
        for (j = [-(hole_count_y - 1) / 2 : (hole_count_y - 1) / 2])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([-(notch_w / 2), disc_d / 2 - notch_d, 0])
        cube([notch_w, notch_d, disc_h]);
}