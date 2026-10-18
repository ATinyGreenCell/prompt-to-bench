// Petri dish sowing template - flat disc with a 7x7 hole grid and a Y-axis notch on the rim
// Units: mm. Print orientation: flat on bed, z = 0 upward.

$fn = 128;

// ---- Disc ----
disc_d        = 85;     // disc outer diameter
disc_t        = 2;      // disc thickness

// ---- Hole grid ----
hole_n        = 7;      // holes per row and column
hole_d        = 3;      // through-hole diameter
hole_pitch    = 9;      // centre-to-centre spacing
eps           = 0.5;    // cutter overshoot past top/bottom faces

// ---- Notch ----
notch_w       = 10;     // notch width along X
notch_d       = 4;      // notch depth into rim along Y (centred on Y axis)

// ---- Derived ----
grid_r        = (hole_n - 1) * hole_pitch / 2;  // distance from grid centre to outer holes
rim_t         = disc_d / 2 - grid_r - hole_pitch / 2;  // rim thickness between grid and edge

difference() {
    // Main disc, centred in XY, resting on z = 0
    translate([0, 0, 0])
        cylinder(d = disc_d, h = disc_t);

    // 7 x 7 through-hole grid, centred on the disc
    for (i = [0 : hole_n - 1])
        for (j = [0 : hole_n - 1])
            translate([j * hole_pitch - grid_r, i * hole_pitch - grid_r, 0])
                cylinder(d = hole_d, h = disc_t + 2 * eps);

    // Rectangular orientation notch into the rim on the +Y side, centred on Y
    translate([0, disc_d / 2 - notch_d, -eps])
        cube([notch_w, notch_d, disc_t + 2 * eps]);
}