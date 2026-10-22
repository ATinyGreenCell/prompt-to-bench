// Analytical balance stand for one 1.5 mL microcentrifuge tube
// Print orientation: standing upright, base on the bed (z = 0)

$fn = 96;

// ---------- Outer body ----------
base_d      = 50;   // base disc diameter
base_h      = 4;    // base disc top (z = 0 .. 4)
cone_top_z  = 14;   // outer cone ends here (50 -> 22 mm)
col_d       = 22;   // column diameter
col_top_z   = 33;   // overall height (top of column)

// ---------- Tube seat ----------
seat_d       = 11;  // cylindrical seat diameter
seat_cyl_z   = 23;  // bottom of cylindrical seat portion
seat_tip_d   = 3;   // diameter at the bottom of the conical tip
seat_tip_z   = 6;   // bottom of the conical tip (solid below)

// ---------- Viewing window ----------
win_w       = 4;    // window width in Y
win_z0      = 18;   // window bottom
win_z1      = 30;   // window top

eps = 0.5;          // cutter overlap past faces

difference() {
    // Outer body
    union() {
        cylinder(d = base_d, h = base_h);
        translate([0, 0, base_h])
            cylinder(d1 = base_d, d2 = col_d, h = cone_top_z - base_h);
        translate([0, 0, cone_top_z])
            cylinder(d = col_d, h = col_top_z - cone_top_z);
    }

    // Cylindrical part of seat (extends above top)
    translate([0, 0, seat_cyl_z])
        cylinder(d = seat_d, h = col_top_z - seat_cyl_z + eps);

    // Conical tip of seat (slight overlap into cylinder to avoid coplanar faces)
    translate([0, 0, seat_tip_z])
        cylinder(d1 = seat_tip_d, d2 = seat_d, h = seat_cyl_z - seat_tip_z + 0.01);

    // Viewing window through +X wall, from axis to outside
    translate([0, -win_w / 2, win_z0])
        cube([col_d / 2 + eps, win_w, win_z1 - win_z0]);
}