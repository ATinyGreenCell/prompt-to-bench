// Magnetic bead rack for one 8-tube strip of 0.2 mL PCR tubes
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y.

$fn = 64;

// ---- Block dimensions (measured with calipers) ----
block_L = 80;   // length along X
block_W = 24;   // width along Y
block_H = 20;   // height along Z

// ---- Tube seats (8 x 0.2 mL PCR tubes) ----
n_seats   = 8;          // number of tube seats
seat_pitch = 9;         // centre-to-centre spacing along X
seat_d_top = 6.4;       // hole diameter at top face (z = 20)
seat_d_bot = 3.0;       // cone bottom diameter at z = 2
seat_z_top = block_H;   // top of seat (open to top face)
seat_z_bot = 2;         // bottom of seat (2 mm floor)

// ---- Bar-magnet pockets (2 x 60 x 10 x 3 mm magnets) ----
mag_L = 60.4;           // pocket length along X (0.2 mm clearance)
mag_W = 3.3;            // pocket width along Y (0.3 mm clearance)
mag_H = 10.2;           // pocket height along Z (0.2 mm clearance)
mag_y = 6;              // pocket centre offset in Y (centred at y = -6 and y = 6)

// ---- Build the solid block ----
block = translate([-block_L/2, -block_W/2, 0])
    cube([block_L, block_W, block_H]);

// ---- Tube-seat cutter: cylinder (top) + cone (bottom) ----
// Cylinder from z = 12 to z = 20 (6.4 mm dia), cone from z = 2 to z = 12 (6.4 -> 3 mm dia)
seat_cutter = union() {
    // Upper cylindrical portion: 6.4 mm dia, z = 12 to z = 20
    translate([0, 0, 12])
        cylinder(h = 8, r1 = seat_d_top/2, r2 = seat_d_top/2, $fn = $fn);
    // Lower conical portion: 6.4 mm dia at z = 12 -> 3 mm dia at z = 2
    translate([0, 0, 2])
        cylinder(h = 10, r1 = seat_d_bot/2, r2 = seat_d_top/2, $fn = $fn);
};

// ---- Magnet-pocket cutter: box open at bottom (z = 0 to z = 10.2) ----
// Extend 0.5 mm below z = 0 so the cut is not coplanar with the block bottom.
mag_cutter = translate([-mag_L/2, -mag_W/2, -0.5])
    cube([mag_L, mag_W, mag_H + 0.5]);

// ---- Assemble: subtract all cutters from the block ----
difference() {
    block;

    // 8 tube seats along y = 0, 9 mm apart, centred on the block in X
    for (i = [0 : n_seats-1]) {
        x_pos = (i - (n_seats-1)/2) * seat_pitch;
        translate([x_pos, 0, 0])
            seat_cutter;
    }

    // 2 bar-magnet pockets at y = -6 and y = +6, centred in X
    for (y_off = [-mag_y, mag_y]) {
        translate([0, y_off, 0])
            mag_cutter;
    }
}