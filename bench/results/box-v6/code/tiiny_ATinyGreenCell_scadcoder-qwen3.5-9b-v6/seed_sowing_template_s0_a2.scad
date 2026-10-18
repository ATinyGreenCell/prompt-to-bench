// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to z = 2

// ---- Parameters ----
disc_d      = 85;    // disc diameter
disc_h      = 2;     // disc thickness
hole_d      = 3;     // through-hole diameter
hole_nx     = 7;     // holes per row (X)
hole_py     = 7;     // holes per column (Y)
hole_pitch  = 9;     // centre-to-centre spacing
notch_w     = 10;    // orientation notch width (X)
notch_d     = 4;     // orientation notch depth from rim (Y)
eps         = 0.5;   // cutter overshoot past faces

$fn = 128;

// ---- Model ----
difference() {
    // Disc
    cylinder(d = disc_d, h = disc_h);

    // Hole grid, centred on disc
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_py - 1])
            translate([
                (i - (hole_nx - 1) / 2) * hole_pitch,
                (j - (hole_py - 1) / 2) * hole_pitch,
                -eps
            ])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([-notch_w / 2, notch_d, -eps])
        cube([notch_w, notch_d + eps, disc_h + 2 * eps]);
}