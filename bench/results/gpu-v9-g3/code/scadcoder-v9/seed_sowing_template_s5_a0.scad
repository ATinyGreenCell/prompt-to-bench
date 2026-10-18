// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to z = 2

// ---------- Parameters ----------
pitch   = 9;     // hole centre-to-centre spacing (mm)
n_x     = 7;     // holes along X
n_y     = 7;     // holes along Y
hole_d  = 3;     // through-hole diameter (mm)
disc_d  = 85;    // disc outer diameter (mm)
disc_h  = 2;     // disc thickness (mm)
notch_w = 10;    // orientation notch width (X) (mm)
notch_d = 4;     // orientation notch depth from rim (Y) (mm)
eps     = 0.5;   // cutter overshoot past faces (mm)

$fn = 128;

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // 7 x 7 hole grid, centred
    for (i = [0 : n_x - 1])
        for (j = [0 : n_y - 1])
            translate([(i - (n_x - 1) / 2) * pitch,
                       (j - (n_y - 1) / 2) * pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([0, disc_d / 2 - notch_d, -eps])
        cube([notch_w, notch_d, disc_h + 2 * eps]);
}