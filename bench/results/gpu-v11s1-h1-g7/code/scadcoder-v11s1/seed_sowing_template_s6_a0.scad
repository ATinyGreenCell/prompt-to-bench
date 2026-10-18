// Sowing template for a 90 mm Petri dish
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---- Disc ----
disc_d      = 85;    // disc diameter
disc_h      = 2;     // disc thickness

// ---- Hole grid ----
hole_n      = 7;     // holes per row/column
hole_d      = 3;     // hole diameter
hole_pitch  = 9;     // centre-to-centre spacing
eps         = 0.5;   // cutter overshoot past faces

// ---- Notch ----
notch_w     = 10;    // notch width (X)
notch_d     = 4;     // notch depth from rim (Y)

$fn = 128;

difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // 7 x 7 through-hole grid, centred
    for (i = [0 : hole_n - 1])
        for (j = [0 : hole_n - 1])
            translate([(i - (hole_n - 1) / 2) * hole_pitch,
                       (j - (hole_n - 1) / 2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([-notch_w / 2, 0, -eps])
        cube([notch_w, notch_d + eps, disc_h + 2 * eps]);
}