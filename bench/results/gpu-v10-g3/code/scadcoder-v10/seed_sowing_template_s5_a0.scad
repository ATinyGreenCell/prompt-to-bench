// Petri dish sowing template - flat disc with a 7x7 hole grid and a rim notch
// Print orientation: flat on the bed, z = 0 up to disc_thickness

// ---------- Parameters ----------
disc_d        = 85;    // disc outer diameter (mm)
disc_thick    = 2;     // disc thickness (mm)
hole_d        = 3;     // through-hole diameter (mm)
hole_count_x  = 7;     // holes along X (mm)
hole_count_y  = 7;     // holes along Y (mm)
hole_pitch    = 9;     // centre-to-centre spacing (mm)
notch_w       = 10;    // orientation notch width along X (mm)
notch_d       = 4;     // orientation notch depth along Y, from rim (mm)
eps           = 0.5;   // cutter overshoot past faces (mm)
$fn           = 128;   // curve resolution

// ---------- Derived ----------
grid_h = (hole_count_y - 1) * hole_pitch;   // hole span along Y (mm)
// Notch is centred on the Y axis, so its X position is symmetric about 0

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_thick);

    // Through-hole grid
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([-(hole_count_x - 1) * hole_pitch / 2 + i * hole_pitch,
                       -grid_h / 2 + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_thick + 2 * eps);

    // Rectangular orientation notch on the +Y side, centred on Y
    translate([0, disc_d / 2 - notch_d, -eps])
        cube([notch_w, notch_d, disc_thick + 2 * eps]);
}