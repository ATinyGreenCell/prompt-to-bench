// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---------- Parameters ----------
petri_d        = 90;    // Petri dish diameter (mm)
disc_d         = 85;    // template disc diameter (mm)
disc_thick     = 2;     // template disc thickness (mm)
hole_d         = 3;     // through-hole diameter (mm)
hole_count_x   = 7;     // holes per row (X)
hole_count_y   = 7;     // holes per column (Y)
hole_pitch     = 9;     // centre-to-centre spacing (mm)
notch_w        = 10;    // orientation notch width (X) (mm)
notch_depth    = 4;     // orientation notch depth (Y from rim) (mm)
eps            = 0.5;   // cutter overshoot past faces (mm)
$fn            = 128;   // curve resolution

// ---------- Derived ----------
hole_x0 = -(hole_count_x - 1) * hole_pitch / 2;  // first hole X
hole_y0 = -(hole_count_y - 1) * hole_pitch / 2;  // first hole Y

// ---------- Model ----------
difference() {
    // main disc
    cylinder(d = disc_d, h = disc_thick);

    // through-hole grid
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([hole_x0 + i * hole_pitch,
                       hole_y0 + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_thick + 2 * eps);

    // rectangular orientation notch on +Y side, centred on Y axis
    translate([0, disc_thick - notch_depth, -eps])
        cube([notch_w, notch_depth + eps, eps]);
}