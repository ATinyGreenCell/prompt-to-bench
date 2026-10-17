// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---------- Parameters ----------
petri_d        = 90;    // dish diameter (mm)
disc_d         = 85;    // template disc diameter (mm)
disc_t         = 2;     // template disc thickness (mm)

hole_d         = 3;     // through-hole diameter (mm)
hole_n         = 7;     // holes per row/column (7 x 7 grid)
hole_pitch     = 9;     // centre-to-centre spacing (mm)

notch_w        = 10;    // orientation notch width in X (mm)
notch_d        = 4;     // orientation notch depth in Y from rim (mm)

eps            = 0.5;   // cutter overshoot past faces (mm)
$fn            = 128;   // curve resolution

// ---------- Derived ----------
notch_rim_y = disc_d/2 - notch_d;   // Y position of notch start from centre

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_t);

    // 7 x 7 hole grid, centred on disc
    for (i = [0 : hole_n - 1])
        for (j = [0 : hole_n - 1])
            translate([hole_pitch * (i - (hole_n - 1)/2),
                       hole_pitch * (j - (hole_n - 1)/2),
                       -eps])
                cylinder(d = hole_d, h = disc_t + 2*eps);

    // Rectangular orientation notch on +Y side, centred on Y axis
    translate([0, notch_rim_y, -eps])
        cube([notch_w, notch_d + 2*eps, disc_t + 2*eps]);
}