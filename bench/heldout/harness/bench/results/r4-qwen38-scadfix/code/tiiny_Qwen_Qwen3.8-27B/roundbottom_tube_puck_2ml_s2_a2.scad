// 8-seat 2 mL round-bottom tube holder
// Round puck 80 mm dia, 26 mm tall, flat label side at x = 34,
// 8 tube seats on a 50 mm dia circle, first on +X.

$fn = 64;

// ---- Dimensions (mm) ----
puck_dia      = 80;   // outer diameter of the puck
puck_radius   = puck_dia / 2;   // 40
puck_height   = 26;   // total height, z = 0 to 26
label_x       = 34;   // flat label face: everything x > 34 removed
seat_circle_d = 50;   // diameter of the circle on which seats are centred
seat_circle_r = seat_circle_d / 2;   // 25
hole_dia      = 11.2; // seat hole diameter
hole_radius   = hole_dia / 2;        // 5.6
seat_depth    = 20;   // depth from top face to lowest point of the half-sphere
n_seats       = 8;    // number of tube seats

// ---- Base puck (cylinder, axis on Z, centred on origin) ----
module puck() { cylinder(h = puck_height, r = puck_radius, $fn = $fn); }

// ---- Flat label side: remove everything beyond x = 34 ----
// Cutter extends 1 mm past the +X face of the puck (x = 40) to avoid coplanar faces.
module label_cutter() { translate([label_x, -puck_radius - 1, -1])
    cube([puck_radius - label_x + 1, 2 * puck_radius + 2, puck_height + 2]); }

// ---- One tube seat (hole + half-sphere bottom) ----
// The half-sphere is centred at z = 6 so its lowest point is 6 - 5.6 = 0.4 mm above the bed,
// i.e. 20 mm below the top face (z = 26).
// The cylindrical part of the seat runs from z = 6 up past the top face (z = 26).
// The cutter is extended 1 mm above the top face to avoid coplanar faces.
module seat() { union() {
    // half-sphere bottom
    translate([0, 0, 6])
        sphere(r = hole_radius, $fn = $fn);
    // cylindrical bore (extends 1 mm above the top face)
    translate([0, 0, 6])
        cylinder(h = puck_height - 6 + 1, r = hole_radius, $fn = $fn);
} }

// ---- Assemble: subtract label cutter and all 8 seats from the puck ----
difference() {
    puck();
    label_cutter();
    for (i = [0 : n_seats - 1]) {
        rotate([0, 0, i * 360 / n_seats])
            translate([seat_circle_r, 0, 0])
                seat();
    }
}