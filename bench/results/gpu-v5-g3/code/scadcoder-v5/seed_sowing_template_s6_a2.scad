// Petri dish sowing template - flat disc with a 7 x 7 hole grid and a rim notch for orientation
// Print orientation: flat on the bed, z = 0 up to disc thickness

// ---------------- Parameters ----------------
disc_d        = 85;    // disc outer diameter (mm)
disc_t        = 2;     // disc thickness (mm)

hole_d        = 3;     // through-hole diameter (mm)
hole_nx       = 7;     // number of holes along X
hole_ny       = 7;     // number of holes along Y
hole_pitch    = 9;     // centre-to-centre spacing (mm)

notch_w       = 10;    // orientation notch width along X (mm)
notch_depth   = 4;     // orientation notch depth from rim along Y (mm)

eps           = 0.5;   // cutter overshoot past faces (mm)
$fn           = 128;   // curve resolution

// ---------------- Model ----------------
difference() {
    // Main disc, centred in XY, resting on z = 0
    cylinder(d = disc_d, h = disc_t);

    // 7 x 7 grid of through-holes, centred on the disc
    for (i = [-(hole_nx - 1) / 2 : (hole_nx - 1) / 2])
        for (j = [-(hole_ny - 1) / 2 : (hole_ny - 1) / 2])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch cut into the rim on the +Y side, centred on Y
    translate([(disc_d / 2 - notch_w / 2), disc_d / 2 - notch_depth, -eps])
        cube([notch_w, notch_depth + eps, disc_t + 2 * eps]);
}