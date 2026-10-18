// Sowing template for a 90 mm Petri dish
// Print orientation: flat on bed, z = 0 upward

// ---- Disc ----
disc_d      = 85;    // disc diameter
disc_t      = 2;     // disc thickness

// ---- Hole grid ----
hole_n      = 7;     // holes per side (7 x 7)
hole_d      = 3;     // hole diameter
hole_pitch  = 9;     // centre-to-centre spacing

// ---- Notch ----
notch_w     = 10;    // notch width (X)
notch_d     = 4;     // notch depth from rim (Y)

// ---- Misc ----
eps         = 0.5;   // cutter overshoot past faces
$fn         = 128;   // curve resolution

difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // Grid of through-holes, centred on disc
    for (i = [-(hole_n - 1) / 2 : (hole_n - 1) / 2])
        for (j = [-(hole_n - 1) / 2 : (hole_n - 1) / 2])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch on +Y rim, centred on Y axis
    translate([-notch_w / 2, disc_t / 2 + notch_d, -eps])
        cube([notch_w, notch_d + eps, disc_t + 2 * eps]);
}