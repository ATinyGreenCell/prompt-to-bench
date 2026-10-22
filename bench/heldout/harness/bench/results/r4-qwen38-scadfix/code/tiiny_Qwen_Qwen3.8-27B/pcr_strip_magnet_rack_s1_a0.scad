// Magnetic bead rack for one 8-tube strip of 0.2 mL PCR tubes
// Print orientation: rests on XY plane (z = 0), builds upward (+Z), centred on origin in X and Y.

// ---- Block dimensions (measured with calipers) ----
block_L = 80;   // length, X
block_W = 24;   // width,  Y
block_H = 20;   // height, Z

// ---- Tube seats (8, along y = 0) ----
n_seats   = 8;      // number of tube seats
seat_pitch = 9;     // centre-to-centre spacing, X
seat_d_top = 6.4;   // hole diameter at top face (z = 20)
seat_d_bot = 3.0;   // cone bottom diameter at z = 2
seat_z_top = 20;    // top of seat (block top face)
seat_z_bot = 2;     // bottom of seat (2 mm floor above bed)

// ---- Bar-magnet pockets (2, centred at y = -6 and y = +6) ----
mag_L = 60.4;  // pocket length, X (0.4 mm clearance over 60 mm magnet)
mag_W = 3.3;   // pocket width,  Y (0.3 mm clearance over 10 mm magnet)
mag_H = 10.2;  // pocket height, Z (0.2 mm clearance over 10 mm magnet)
mag_y = 6;     // pocket centre offset in Y (pockets at y = -6 and y = +6)

// ---- Render quality ----
$fn = 64;

// ---- Base block, centred on origin in X and Y, resting on z = 0 ----
module block() { translate([-block_L/2, -block_W/2, 0]) cube([block_L, block_W, block_H]); }

// ---- Tube seats: 6.4 mm hole from top down to z = 12, then cone to 3 mm at z = 2 ----
// (straight section 20 -> 12, conical section 12 -> 2, 2 mm solid floor remains)
module seats() { for (i = [0 : n_seats-1]) {
    x = (i - (n_seats-1)/2) * seat_pitch;   // centred on origin in X
    union() {
        // straight cylindrical section
        translate([x, 0, 12])
            cylinder(h = seat_z_top - 12, d = seat_d_top, $fn = $fn);
        // conical section (6.4 mm at z = 12 -> 3.0 mm at z = 2)
        translate([x, 0, 2])
            cylinder(h = 12 - 2, d1 = seat_d_bot, d2 = seat_d_top, $fn = $fn);
    }
} }

// ---- Bar-magnet pockets: open at bottom face (z = 0), centred in X ----
module pockets() { for (y = [-mag_y, mag_y]) {
    translate([-mag_L/2, y - mag_W/2, 0])
        cube([mag_L, mag_W, mag_H]);
} }

// ---- Final solid: block minus all cutters ----
difference() {
    block();
    seats();
    pockets();
}