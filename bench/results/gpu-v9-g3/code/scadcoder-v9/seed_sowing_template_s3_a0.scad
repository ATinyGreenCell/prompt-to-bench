// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to z = 2

// ---- Parameters ----
disc_d        = 85;    // disc diameter
disc_h        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_count_x  = 7;     // holes along X
hole_count_y  = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing
notch_w       = 10;    // orientation notch width (X)
notch_depth   = 4;     // orientation notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces

$fn = 128;

// ---- Model ----
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // 7 x 7 through-hole grid, centred
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([(i - (hole_count_x - 1) / 2) * hole_pitch,
                       (j - (hole_count_y - 1) / 2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([0, disc_d / 2 - notch_depth, -eps])
        cube([notch_w, notch_depth, disc_h + 2 * eps]);
}