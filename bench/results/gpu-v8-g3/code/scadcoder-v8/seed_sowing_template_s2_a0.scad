// Petri dish sowing template - flat disc with 7x7 hole grid and orientation notch
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---------- Parameters ----------
disc_d        = 85;    // disc outer diameter (mm)
disc_h        = 2;     // disc thickness (mm)

hole_d        = 3;     // through-hole diameter (mm)
hole_pitch    = 9;     // centre-to-centre spacing (mm)
hole_nx       = 7;     // holes along X
hole_ny       = 7;     // holes along Y

notch_w       = 10;    // orientation notch width (X) (mm)
notch_depth   = 4;     // orientation notch depth from rim (Y) (mm)

eps           = 0.5;   // cutter overshoot past faces (mm)
$fn           = 128;   // circle resolution

// ---------- Derived ----------
hole_x0 = -(hole_nx - 1) * hole_pitch / 2;  // first hole X (grid centred)
hole_y0 = -(hole_ny - 1) * hole_pitch / 2;  // first hole Y (grid centred)
notch_r = disc_d / 2 - notch_depth;         // notch inner radius (Y position)

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // Through-hole grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i * hole_pitch, hole_y0 + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([0, notch_r, -eps])
        cube([notch_w, notch_depth + eps, disc_h + 2 * eps]);
}