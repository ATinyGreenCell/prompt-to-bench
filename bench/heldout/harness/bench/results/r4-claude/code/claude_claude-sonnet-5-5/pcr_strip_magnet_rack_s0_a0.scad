// Magnetic bead rack for an 8-tube strip of 0.2 mL PCR tubes

// Block
block_l = 80;          // block length (X)
block_w = 24;          // block width (Y)
block_h = 20;          // block height (Z)

// Tube seats
n_seats = 8;           // number of seats
pitch = 9;             // centre-to-centre spacing (X)
seat_d = 6.4;          // upper hole diameter
seat_straight_z = 12;  // z where straight bore ends / cone starts
seat_tip_d = 3;        // cone bottom diameter
seat_floor = 2;        // floor thickness (cone ends at this z)

// Magnet pockets
mag_l = 60.4;          // pocket length (X)
mag_w = 3.3;           // pocket width (Y)
mag_h = 10.2;          // pocket height (Z), open at bottom
mag_y = 6;             // pocket centre offset in |Y|

eps = 0.5;             // cutter overshoot

$fn = 64;

difference() {
    // solid block
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // tube seats
    for (i = [0 : n_seats - 1]) {
        x = (i - (n_seats - 1) / 2) * pitch;
        translate([x, 0, 0]) {
            // straight bore to top
            translate([0, 0, seat_straight_z])
                cylinder(d = seat_d, h = block_h - seat_straight_z + eps);
            // conical bottom
            translate([0, 0, seat_floor])
                cylinder(d1 = seat_tip_d, d2 = seat_d,
                         h = seat_straight_z - seat_floor);
        }
    }

    // magnet pockets, open at the bottom
    for (s = [-1, 1]) {
        translate([-mag_l/2, s * mag_y - mag_w/2, -eps])
            cube([mag_l, mag_w, mag_h + eps]);
    }
}