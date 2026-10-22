// Magnetic bead rack for one 8-tube strip of 0.2 mL PCR tubes
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y

// Block dimensions
block_L = 80;   // length in X (mm)
block_W = 24;   // width in Y (mm)
block_H = 20;   // height in Z (mm)

// Tube seat parameters
seat_pitch = 9;        // centre-to-centre spacing in X (mm)
seat_top_d = 6.4;      // hole diameter at top face (mm)
seat_top_z = 20;       // top of seat (block top face)
seat_cyl_bot_z = 12;   // z where cylindrical part ends / cone begins
seat_cone_bot_d = 3;   // cone diameter at bottom of seat (mm)
seat_cone_bot_z = 2;   // z where cone ends (2 mm floor)

// Magnet pocket parameters
pocket_L = 60.4;       // length in X (mm)
pocket_W = 3.3;        // width in Y (mm)
pocket_H = 10.2;       // height in Z (mm)
pocket_y = 6;          // |y| of pocket centres (pockets at y = -6 and y = +6)

$fn = 64;

// ---- Base block ----
block = translate([-block_L/2, -block_W/2, 0]) cube([block_L, block_W, block_H]);

// ---- Tube seats (8, along y = 0, centred on block in X) ----
// Each seat: cylinder from z=12 to z=20 (d=6.4) + cone from z=2 to z=12 (d 3 -> 6.4)
tube_seat() {
    // Cylindrical upper part
    translate([0, 0, seat_cyl_bot_z])
        cylinder(h = seat_top_z - seat_cyl_bot_z,
                 d1 = seat_top_d, d2 = seat_top_d, $fn = 64);
    // Conical lower part (narrowing downward)
    translate([0, 0, seat_cone_bot_z])
        cylinder(h = seat_cyl_bot_z - seat_cone_bot_z,
                 d1 = seat_cone_bot_d, d2 = seat_top_d, $fn = 64);
}

// ---- Magnet pockets (2, at y = -6 and y = +6, open at bottom z=0) ----
magnet_pocket() {
    // Pocket is a rectangular prism from z=0 to z=pocket_H, centred in X and Y
    translate([-pocket_L/2, -pocket_W/2, 0])
        cube([pocket_L, pocket_W, pocket_H]);
}

// ---- Assemble: block minus all cuts ----
difference() {
    block;

    // 8 tube seats, centred on origin in X, at y = 0
    for (i = [0:7]) {
        x_pos = (i - 3.5) * seat_pitch;   // centred: -27, -18, -9, 0, 9, 18, 27, 36
        translate([x_pos, 0, 0])
            tube_seat();
    }

    // 2 magnet pockets, centred in X, at y = -6 and y = +6
    for (yp = [-pocket_y, pocket_y]) {
        translate([0, yp, 0])
            magnet_pocket();
    }
}