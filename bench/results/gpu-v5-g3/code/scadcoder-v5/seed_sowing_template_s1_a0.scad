// Petri dish sowing template - flat disc with a 7 x 7 hole grid and a rim notch for orientation
// Units: mm. Print orientation: flat on bed, z = 0 upward.

// ---------------- Parameters ----------------
disc_d        = 85;    // disc outer diameter
disc_t        = 2;     // disc thickness
hole_d        = 3;     // through-hole diameter
hole_nx       = 7;     // holes along X
hole_ny       = 7;     // holes along Y
hole_pitch    = 9;     // centre-to-centre spacing
notch_w       = 10;    // notch width (X)
notch_depth   = 4;     // notch depth from rim (Y)
eps           = 0.5;   // cutter overshoot past faces
$fn           = 128;   // curve resolution

// Derived: grid extent and rim thickness at the notch
grid_x0 = -(hole_nx - 1) * hole_pitch / 2;  // first hole X (-18)
grid_y0 = -(hole_ny - 1) * hole_pitch / 2;  // first hole Y (-18)
rim_t   = disc_d / 2 - disc_t / 2;          // 41 mm rim on a 2 mm disc

// ---------------- Model ----------------
difference() {
    // Main disc, centred in XY, resting on z = 0
    cylinder(d = disc_d, h = disc_t);

    // 7 x 7 through-hole grid, centred on the disc
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([grid_x0 + i * hole_pitch,
                       grid_y0 + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch into the rim on the +Y side, centred on Y
    translate([0, rim_t - notch_depth, -eps])
        cube([notch_w, notch_depth + eps, disc_t + 2 * eps]);
}