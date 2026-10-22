// 8-seat round-bottom tube holder (2 mL tubes)
// Round puck, 80 mm dia, 26 mm tall, flat label side at x = 34.
// 8 seats on a 50 mm dia circle, first on +X.
// Each seat: 11.2 mm dia hole, hemispherical bottom, lowest point 20 mm below top (z = 6).

$fn = 64;

// --- Dimensions (mm) ---
puck_dia   = 80;    // outer diameter of the puck
puck_r     = puck_dia / 2;   // 40
puck_h     = 26;    // total height of the puck
label_x    = 34;    // flat label side: everything beyond x = 34 removed
seat_pitch_dia = 50; // circle on which the 8 seats are centred
seat_pitch_r   = seat_pitch_dia / 2;  // 25
n_seats    = 8;     // number of tube seats
hole_dia   = 11.2;  // tube seat hole diameter
hole_r     = hole_dia / 2;   // 5.6
seat_depth = 20;    // vertical distance from top face to lowest point of the seat
top_z      = puck_h;        // 26
bottom_z   = top_z - seat_depth;  // 6  (lowest point of each seat)

// --- Base puck (cylinder standing on z=0, axis on Z) ---
module puck() { cylinder(h = puck_h, r = puck_r, $fn = $fn); }

// --- Flat label side: remove everything beyond x = label_x ---
// Cutting box extends 1 mm past the +X face of the puck (40) and 1 mm past top/bottom.
module label_cut() {
    translate([label_x, -puck_r - 1, -1])
        cube([puck_r - label_x + 1, 2 * puck_r + 2, puck_h + 2]);
}

// --- One seat (hole + hemispherical bottom) ---
// Hole: cylinder from z = bottom_z to z = top_z + 1 (1 mm past top face)
// Hemisphere: sphere centred at z = bottom_z, only the lower half remains inside the puck
// (the upper half is outside the puck and is removed by the difference).
module seat() {
    union() {
        cylinder(h = top_z - bottom_z + 1, r = hole_r, $fn = $fn);
        sphere(r = hole_r, $fn = $fn);
    }
}

// --- Eight seats, evenly spaced on the pitch circle, first on +X ---
module seats() {
    for (i = [0 : n_seats - 1]) {
        rotate([0, 0, i * 360 / n_seats])
            translate([seat_pitch_r, 0, bottom_z])
                seat();
    }
}

// --- Final part ---
difference() {
    difference() {
        puck();
        label_cut();
    }
    seats();
}