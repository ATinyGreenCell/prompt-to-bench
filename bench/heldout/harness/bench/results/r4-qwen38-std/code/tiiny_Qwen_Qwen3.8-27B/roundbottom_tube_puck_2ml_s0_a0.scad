// 2 mL round-bottom tube holder – 8 seats in a flat-sided puck
// Units: mm. Print orientation: puck axis on Z, rests on XY plane (z = 0).

// ---- Puck body ----
puck_d   = 80;   // outer diameter of the round puck
puck_r   = puck_d / 2;   // 40 mm
puck_h   = 26;   // total height of the puck
cut_x    = 34;   // flat label side: remove everything with x > cut_x

// ---- Tube seats (8, on a 50 mm dia circle, first on +X) ----
seat_d   = 11.2;  // hole / half-sphere diameter
seat_r   = seat_d / 2;   // 5.6 mm
seat_circ_d = 50;  // circle on which the 8 seats are evenly spaced
seat_circ_r = seat_circ_d / 2;   // 25 mm
seat_depth = 20;  // lowest point of each seat is 20 mm below the top face
seat_top_z = puck_h;          // top face of the puck (z = 26)
seat_bot_z = seat_top_z - seat_depth;   // 6 mm – lowest point of the half-sphere

// ---- Curvature quality ----
$fn = 64;

// 1) Round puck, flat side removed (x > cut_x)
puck = difference() {
    cylinder(h = puck_h, r = puck_r, center = false);
    // cutter extends 1 mm past the +X face of the puck (x = 40)
    translate([-1, -puck_r - 1, -1])
        cube([puck_r - cut_x + 1, 2 * puck_r + 2, puck_h + 2]);
};

// 2) Eight tube seats: cylindrical bore + half-sphere bottom,
//    lowest point at z = seat_bot_z, evenly spaced on a 50 mm dia circle
seats = for (i = [0:7])
    rotate([0, 0, i * 45])
        translate([seat_circ_r, 0, 0])
            union() {
                // cylindrical bore: from just below the half-sphere centre up past the top face
                cylinder(h = seat_top_z - seat_bot_z + 1, r = seat_r, center = false)
                    // placed so its bottom is 1 mm below the half-sphere centre (z = seat_bot_z + seat_r)
                    // and its top extends 1 mm above the puck top face
                    // => translate z = seat_bot_z + seat_r - 1
                    ;
                // half-sphere bottom: sphere centred at z = seat_bot_z + seat_r,
                // clipped to the lower half (z <= seat_bot_z + seat_r)
                intersection() {
                    sphere(r = seat_r, $fn = 64);
                    // half-space z <= seat_bot_z + seat_r
                    translate([0, 0, seat_bot_z + seat_r - seat_r - 1])
                        cube([2 * seat_r + 2, 2 * seat_r + 2, 2 * seat_r + 2]);
                }
            };

// 3) Final part: puck minus the eight seats
difference() {
    puck;
    seats;
}