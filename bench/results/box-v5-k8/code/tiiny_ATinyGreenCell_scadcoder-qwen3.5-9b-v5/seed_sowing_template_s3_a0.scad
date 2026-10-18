// Petri dish sowing template - flat disc with a 7x7 hole grid and a Y-axis orientation notch
// Print orientation: flat on the bed, z = 0 up to disc thickness

// ---------- Parameters ----------
disc_d        = 85;    // disc outer diameter
disc_t        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_count_x  = 7;     // holes along X
hole_count_y  = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing
notch_w       = 10;    // notch width (X)
notch_d       = 4;     // notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces
$fn           = 128;   // curve resolution

// ---------- Derived ----------
grid_centre   = (hole_count_x - 1) * hole_pitch / 2;  // 36 mm from each edge
rim_d         = disc_d - 2 * notch_d;                 // rim diameter at notch

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // Through-hole grid, centred on the disc
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([-grid_centre + i * hole_pitch, -grid_centre + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch on the +Y side, centred on Y
    translate([-notch_w / 2, (disc_d / 2 - notch_d), -eps])
        cube([notch_w, notch_d + eps, disc_t + 2 * eps]);
}