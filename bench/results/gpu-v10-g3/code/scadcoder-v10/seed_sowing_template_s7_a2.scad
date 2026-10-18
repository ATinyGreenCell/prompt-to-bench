// Petri dish sowing template
// Print orientation: flat on bed, z = 0 up to disc thickness

// ---------- Parameters ----------
petri_d        = 90;    // Petri dish diameter (mm)
disc_d         = 85;    // template disc diameter (mm)
disc_thick     = 2;     // template disc thickness (mm)
hole_d         = 3;     // through-hole diameter (mm)
hole_count_x   = 7;     // holes along X (mm)
hole_count_y   = 7;     // holes along Y (mm)
hole_pitch     = 9;     // centre-to-centre spacing (mm)
notch_w        = 10;    // orientation notch width (X) (mm)
notch_depth    = 4;     // orientation notch depth (Y from rim) (mm)
eps            = 0.5;   // cutter overshoot past faces (mm)
$fn            = 128;   // curve resolution

// ---------- Derived ----------
hole_grid_h = hole_count_y - 1;   // grid height in pitch units
notch_r     = disc_d / 2 - notch_depth;  // notch inner radius (Y)

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_thick);

    // Through-holes
    for (i = [-(hole_count_x - 1) / 2 : hole_count_x - 1 / 2])
        for (j = [-(hole_count_y - 1) / 2 : hole_count_y - 1 / 2])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = disc_thick + 2 * eps);

    // Orientation notch (rectangular, centred on Y axis, +Y side)
    translate([0, notch_r, -eps])
        cube([notch_w, notch_depth + eps, disc_thick + 2 * eps]);
}