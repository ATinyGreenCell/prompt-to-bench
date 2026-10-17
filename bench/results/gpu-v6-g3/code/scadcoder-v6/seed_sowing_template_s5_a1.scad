// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---- Parameters ----
disc_d        = 85;    // disc diameter (mm)
disc_h        = 2;     // disc thickness (mm)
hole_d        = 3;     // through-hole diameter (mm)
hole_count_x  = 7;     // holes along X
hole_count_y  = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing (mm)
notch_w       = 10;    // orientation notch width (X) (mm)
notch_d       = 4;     // orientation notch depth from rim (Y) (mm)
eps           = 0.5;   // cutter overshoot past faces (mm)
$fn           = 128;   // circle resolution

// ---- Model ----
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // 7 x 7 hole grid, centred
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([
                (i - (hole_count_x - 1) / 2) * hole_pitch,
                (j - (hole_count_y - 1) / 2) * hole_pitch,
                -eps
            ])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([-notch_w / 2, 0, -eps])
        cube([notch_w, notch_d + eps, disc_h + 2 * eps]);
}