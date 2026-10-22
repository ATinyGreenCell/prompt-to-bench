// Magnetic bead rack for one 8-tube strip of 0.2 mL PCR tubes
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y

// Block dimensions
block_L = 80;   // length along X (mm)
block_W = 24;   // width along Y (mm)
block_H = 20;   // height along Z (mm)

// Tube seat parameters
seat_pitch   = 9;    // centre-to-centre spacing along X (mm)
seat_n       = 8;    // number of tube seats
seat_top_d   = 6.4;  // hole diameter at top face (z = 20)
seat_cone_d  = 3.0;  // cone diameter at z = 2
seat_top_z   = 20;   // top of seat (block top face)
seat_cone_z  = 2;    // z where cone ends (2 mm floor)

// Bar magnet pocket parameters
pocket_L = 60.4;    // length along X (mm)
pocket_W = 3.3;     // width along Y (mm)
pocket_H = 10.2;    // height along Z (mm)
pocket_y = 6;       // |y| of pocket centres (centred at y = -6 and y = +6)

$fn = 64;

// ---------------------------------------------------------------------------
// Base block
// ---------------------------------------------------------------------------
module block() { translate([-block_L/2, -block_W/2, 0]) cube([block_L, block_W, block_H]); }

// ---------------------------------------------------------------------------
// Tube seats: 6.4 mm hole from top down to z = 12, then cone to 3 mm at z = 2
// ---------------------------------------------------------------------------
module seat_cut() { union() {
    for (i = [0 : seat_n - 1]) {
        cx = (i - (seat_n - 1) / 2) * seat_pitch;   // centred on origin in X
        // Cylindrical portion: z = 12 to z = 20 (extend 0.5 mm past top for clean cut)
        translate([cx, 0, 12])
            cylinder(h = (seat_top_z - 12) + 0.5, d = seat_top_d, $fn = 64);
        // Conical portion: z = 2 to z = 12
        translate([cx, 0, seat_cone_z])
            cylinder(h = 12 - seat_cone_z, d1 = seat_cone_d, d2 = seat_top_d, $fn = 64);
    }
} }

// ---------------------------------------------------------------------------
// Bar magnet pockets: open at bottom (z = 0), 60.4 x 3.3 x 10.2 mm
// Centred at y = -6 and y = +6, centred in X
// ---------------------------------------------------------------------------
module pocket_cut() { union() {
    for (py = [-pocket_y, pocket_y]) {
        translate([-pocket_L/2, py - pocket_W/2, -0.5])
            cube([pocket_L, pocket_W, pocket_H + 0.5]);
    }
} }

// ---------------------------------------------------------------------------
// Final part
// ---------------------------------------------------------------------------
difference() {
    block();
    seat_cut();
    pocket_cut();
}