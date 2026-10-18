// Petri dish sowing template - flat disc with a 7x7 grid of through-holes and a
// rectangular orientation notch into the rim on the +Y side. Units: mm.
//
// NOTE: This is a solid model. To get the through-holes, print it with "holes
// upward" (e.g. upside down on the bed) or use $fn = 64 so the cutters pass
// cleanly through.

// ---------------- Parameters ----------------
disc_d        = 85;     // disc outer diameter
disc_t        = 2;      // disc thickness (Z)
hole_d        = 3;      // through-hole diameter
hole_nx       = 7;      // holes along X
hole_ny       = 7;      // holes along Y
hole_pitch    = 9;      // centre-to-centre spacing (X and Y)
notch_w       = 10;     // notch width (X)
notch_depth   = 4;      // notch depth into rim (Y, from outer edge)
eps           = 0.5;    // cutter overshoot past faces
$fn           = 128;    // curve resolution

// ---------------- Model ----------------
difference() {
    // Main disc, centred in XY, resting on z = 0
    cylinder(d = disc_d, h = disc_t);

    // Hole grid, centred on the disc
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1) / 2) * hole_pitch,
                       (j - (hole_ny - 1) / 2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Orientation notch into the +Y rim, centred on the Y axis
    translate([-(notch_w / 2),
               disc_d / 2 - notch_depth,
               -eps])
        cube([notch_w, notch_depth + eps, disc_t + 2 * eps]);
}