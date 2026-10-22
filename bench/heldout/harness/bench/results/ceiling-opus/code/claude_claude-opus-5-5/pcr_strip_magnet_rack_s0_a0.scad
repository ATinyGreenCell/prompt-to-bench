// Magnetic bead rack for one 8-tube strip of 0.2 mL PCR tubes
// Print orientation: standing on bed, magnet pockets open at bottom face

$fn = 96;

// ---- Block ----
block_l = 80;     // block length (X)
block_w = 24;     // block width (Y)
block_h = 20;     // block height (Z)

// ---- Tube seats ----
n_tubes      = 8;    // number of tube seats
tube_pitch   = 9;    // centre-to-centre spacing (X)
seat_d       = 6.4;  // straight bore diameter
seat_cone_z  = 12;   // z where straight bore ends and cone begins
cone_tip_d   = 3;    // cone diameter at bottom
seat_floor_z = 2;    // z where seat ends (2 mm floor)

// ---- Magnet pockets ----
mag_l   = 60.4;   // pocket length (X)
mag_w   = 3.3;    // pocket width (Y)
mag_h   = 10.2;   // pocket height (Z), from bottom face
mag_y   = 6;      // pocket centre offset from y = 0 (both sides)

// ---- Misc ----
eps = 0.5;        // cutter overshoot past faces
ov  = 0.01;       // small overlap between internal cutter pieces

difference() {
    // Main block
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Tube seats
    for (i = [0 : n_tubes - 1]) {
        x = (i - (n_tubes - 1) / 2) * tube_pitch;
        translate([x, 0, 0]) {
            // Straight bore: z = 12 to top (plus overshoot)
            translate([0, 0, seat_cone_z])
                cylinder(d = seat_d, h = block_h - seat_cone_z + eps);
            // Cone: 3 mm at z = 2 up to 6.4 mm at z = 12
            translate([0, 0, seat_floor_z])
                cylinder(d1 = cone_tip_d, d2 = seat_d,
                         h = seat_cone_z - seat_floor_z + ov);
        }
    }

    // Magnet pockets, open at bottom
    for (s = [-1, 1]) {
        translate([-mag_l/2, s * mag_y - mag_w/2, -eps])
            cube([mag_l, mag_w, mag_h + eps]);
    }
}