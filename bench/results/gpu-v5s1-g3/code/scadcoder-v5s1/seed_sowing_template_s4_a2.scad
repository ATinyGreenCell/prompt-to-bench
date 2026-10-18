// Petri dish sowing template - flat disc with a 7x7 grid of through-holes and a rectangular
// orientation notch into the rim on the +Y side. Units: mm.

// ---------- Parameters ----------
disc_d          = 85;     // disc diameter
disc_t          = 2;      // disc thickness
hole_d          = 3;      // through-hole diameter
hole_pitch      = 9;      // centre-to-centre spacing
hole_count_x    = 7;      // holes along X
hole_count_y    = 7;      // holes along Y
notch_w         = 10;     // notch width (X)
notch_depth     = 4;      // notch depth into rim (Y)
eps             = 0.5;    // cutter overshoot past faces
$fn             = 128;    // curve resolution

// ---------- Model ----------
difference() {
    // Main disc, centred in XY, resting on z = 0
    cylinder(d = disc_d, h = disc_t);

    // Through-hole grid, centred on the disc
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([(i - (hole_count_x - 1) / 2) * hole_pitch,
                       (j - (hole_count_y - 1) / 2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch into the rim on the +Y side, centred on Y
    translate([-(notch_w / 2), 0, -eps])
        cube([notch_w, notch_depth + eps, disc_t + 2 * eps]);
}