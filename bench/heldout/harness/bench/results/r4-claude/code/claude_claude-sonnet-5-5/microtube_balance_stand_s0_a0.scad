// Tube stand for 1.5 mL microcentrifuge tube (print standing up)
$fn = 96;

base_d      = 50;   // base disc diameter
base_h      = 4;    // base disc height (z 0..4)
cone_top_z  = 14;   // top of outer cone
col_d       = 22;   // column diameter
col_top_z   = 33;   // top of column

seat_d      = 11;   // cylindrical seat diameter
seat_cyl_z  = 23;   // bottom of cylindrical seat portion
seat_tip_z  = 6;    // bottom of conical seat
seat_tip_d  = 3;    // diameter at seat bottom

win_w       = 4;    // window width (Y)
win_z0      = 18;   // window bottom
win_z1      = 30;   // window top

eps = 0.01;
ext = 1;            // cutter overshoot

difference() {
    union() {
        // base disc
        cylinder(d = base_d, h = base_h);
        // outer cone
        translate([0, 0, base_h - eps])
            cylinder(d1 = base_d, d2 = col_d, h = cone_top_z - base_h + eps);
        // column
        translate([0, 0, cone_top_z - eps])
            cylinder(d = col_d, h = col_top_z - cone_top_z + eps);
    }

    // seat: cylinder + cone tip (revolved profile)
    rotate_extrude()
        polygon([
            [0, seat_tip_z],
            [seat_tip_d / 2, seat_tip_z],
            [seat_d / 2, seat_cyl_z],
            [seat_d / 2, col_top_z + ext],
            [0, col_top_z + ext]
        ]);

    // viewing window on +X side, from the seat axis out through the wall
    translate([0, -win_w / 2, win_z0])
        cube([col_d / 2 + ext, win_w, win_z1 - win_z0]);
}