// Petri dish sowing template - 7x7 hole grid with orientation notch
// Print orientation: flat on bed, z = 0 upward

// ---------- Parameters ----------
grid_size    = 7;    // holes per side (7 x 7)
hole_d       = 3;    // hole diameter (mm)
hole_pitch   = 9;    // centre-to-centre spacing (mm)
disc_d       = 85;   // disc outer diameter (mm)
disc_h       = 2;    // disc thickness (mm)
notch_w      = 10;   // notch width along X (mm)
notch_d      = 4;    // notch depth into rim along Y (mm)
eps          = 0.5;  // cutter overshoot past faces (mm)
$fn          = 128;  // curve resolution

// ---------- Derived ----------
grid_x0 = -(grid_size - 1) * hole_pitch / 2;  // first hole X
grid_y0 = -(grid_size - 1) * hole_pitch / 2;  // first hole Y
notch_y = disc_d / 2 - notch_d;               // notch top edge Y

// ---------- Model ----------
difference() {
    // Main disc
    cylinder(d = disc_d, h = disc_h);

    // Hole grid
    for (i = [0 : grid_size - 1])
        for (j = [0 : grid_size - 1])
            translate([grid_x0 + i * hole_pitch,
                       grid_y0 + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = disc_h + 2 * eps);

    // Orientation notch (rectangular, extends past top face)
    translate([-notch_w / 2, notch_y, disc_h / 2])
        cube([notch_w, notch_d + eps, disc_h + eps]);
}