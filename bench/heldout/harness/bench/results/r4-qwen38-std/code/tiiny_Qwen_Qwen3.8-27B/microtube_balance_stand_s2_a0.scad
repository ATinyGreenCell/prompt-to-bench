// 1.5 mL microcentrifuge tube stand for an analytical balance
// Printed standing up: rests on the XY plane at z = 0, builds in +Z, centred on the origin in X and Y.

$fn = 64;

// ---- Base disc (z = 0 to 4) ----
base_d   = 50;   // base disc diameter
base_h   = 4;    // base disc height

// ---- Cone (z = 4 to 14) ----
cone_z0  = 4;    // cone starts at z = 4
cone_z1  = 14;   // cone ends at z = 14
cone_h   = cone_z1 - cone_z0;   // 10
cone_d0  = 50;   // cone diameter at z = 4
cone_d1  = 22;   // cone diameter at z = 14

// ---- Column (z = 14 to 33) ----
col_d    = 22;   // column diameter
col_z0   = 14;   // column starts at z = 14
col_z1   = 33;   // column ends at z = 33
col_h    = col_z1 - col_z0;      // 19

// ---- Tube seat (down the axis from the top) ----
seat_d   = 11;   // seat diameter (z = 33 down to z = 23)
seat_z0  = 23;   // seat cylinder bottom
seat_z1  = 33;   // seat cylinder top (open at the top)
seat_h   = seat_z1 - seat_z0;    // 10

tip_d    = 3;    // seat cone tip diameter at z = 6
tip_z0   = 6;    // seat cone bottom (tip)
tip_z1   = 23;   // seat cone top (meets the seat cylinder)
tip_h    = tip_z1 - tip_z0;      // 17

// ---- Viewing window (cut straight through the +X column wall) ----
win_w    = 4;    // window width in Y
win_z0   = 18;   // window bottom
win_z1   = 30;   // window top
win_h    = win_z1 - win_z0;      // 12
win_x    = 10;   // window box centre in X (extends past the 11 mm wall radius)
win_len  = 20;   // window box length in X (from x = 0 to x = 20, past the outer wall)

// ---- Solid body (base + cone + column) ----
body = union() {
    // base disc
    translate([0, 0, 0])
        cylinder(h = base_h, d = base_d);

    // cone narrowing 50 -> 22
    translate([0, 0, cone_z0])
        cylinder(h = cone_h, d1 = cone_d0, d2 = cone_d1);

    // column
    translate([0, 0, col_z0])
        cylinder(h = col_h, d = col_d);
};

// ---- Tube seat (cylinder + conical tip) ----
seat = union() {
    // seat cylinder, z = 23 to 33
    translate([0, 0, seat_z0])
        cylinder(h = seat_h, d = seat_d);

    // conical tip, z = 6 to 23, 3 -> 11
    translate([0, 0, tip_z0])
        cylinder(h = tip_h, d1 = tip_d, d2 = seat_d);
};

// ---- Viewing window cutter (straight through the +X wall) ----
window = translate([win_x, 0, win_z0])
    cube([win_len, win_w, win_h], center = [false, true, false]);

// ---- Final part: solid body minus seat, minus viewing window ----
difference() {
    body;
    seat;
    window;
}