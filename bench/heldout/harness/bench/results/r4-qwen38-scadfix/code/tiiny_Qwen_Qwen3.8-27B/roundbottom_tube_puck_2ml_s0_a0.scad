// 8-tube round-bottom holder (bead-beating puck)
// Units: mm. Print orientation: rests on XY plane (z = 0), axis on Z,
// flat label face on +X (everything beyond x = 34 removed).

$fn = 64;

// --- Puck body ---
puck_d   = 80;   // outer diameter of the round puck
puck_r   = puck_d / 2;   // 40 mm
puck_h   = 26;   // total height of the puck
label_x  = 34;   // flat label face: remove everything beyond x = 34

// --- Tube seats (8, on a 50 mm circle, first on +X) ---
n_seats  = 8;
seat_cd  = 50;   // circle diameter on which the 8 seats are spaced
seat_r   = seat_cd / 2;   // 25 mm
hole_d   = 11.2;         // seat hole diameter
hole_r   = hole_d / 2;   // 5.6 mm
seat_depth = 20;         // lowest point of each seat is 20 mm below the top face
top_z    = puck_h;       // 26 mm
seat_bot_z = top_z - seat_depth;   // 6 mm  (centre of the half-sphere bottom)

// --- Build the puck, then cut the label face and the 8 seats ---
difference() {
    // 1) Round puck standing on the bed
    cylinder(h = puck_h, r = puck_r, $fn = $fn);

    // 2) Flat label face: remove everything beyond x = label_x
    //    (cutting box extends 1 mm past the outer face to avoid coplanar faces)
    translate([-label_x, -puck_r - 1, -1])
        cube([puck_r + 1, 2 * puck_r + 2, puck_h + 2]);

    // 3) Eight tube seats, evenly spaced, first on +X
    for (i = [0 : n_seats - 1]) {
        rotate([0, 0, i * 360 / n_seats]) {
            // cylindrical wall of the seat (from top face down to the sphere centre)
            translate([seat_r, 0, seat_bot_z])
                cylinder(h = seat_depth + 1, r = hole_r, $fn = $fn);

            // half-sphere bottom (lowest point 20 mm below the top face)
            translate([seat_r, 0, seat_bot_z])
                sphere(r = hole_r, $fn = $fn);
        }
    }
}