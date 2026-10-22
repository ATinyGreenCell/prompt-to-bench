// KNOWN-WRONG PART (must fail): the seats are on a 56 mm circle instead of 50
// Holder that keeps eight 2 mL round-bottom tubes upright (e.g. while loading beads)
// Category: benchware. A round puck with a flat on one side for a label and eight seats on a
// circle, each a cylinder with a half-sphere bottom shaped like the tube.
// Print: PLA or PETG, standing on the bed, 0.2 mm layers.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Puck] */
puck_d = 80;
height = 26;
flat_x = 34;              // everything beyond x = 34 is cut off (label flat)
n_seats = 8;
seat_circle_d = 56;       // first seat on +X
seat_d = 11.2;            // 2 mL tube ~10.8 mm + clearance
seat_low = 6;             // lowest point of each seat (20 mm below the top)

/* [Hidden] */
eps = 0.01;
r = seat_d / 2;

difference() {
    intersection() {
        cylinder(d = puck_d, h = height, $fn = 192);
        translate([-puck_d / 2 - 1, -puck_d / 2 - 1, -1]) cube([puck_d / 2 + 1 + flat_x, puck_d + 2, height + 2]);
    }
    for (k = [0 : n_seats - 1])
        rotate([0, 0, k * 360 / n_seats]) translate([seat_circle_d / 2, 0, seat_low + r]) {
            sphere(r = r, $fn = 64);
            cylinder(r = r, h = height - seat_low - r + 1, $fn = 64);
        }
}
