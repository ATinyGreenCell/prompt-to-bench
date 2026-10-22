// Rack for ten 90 mm Petri dishes standing on edge
// Category: benchware. A base with a curved cradle (a 46 mm radius channel along the rack) in which
// the dish rims rest, and eleven solid divider plates that keep the dishes upright, 17 mm apart.
// Print: PLA or PETG, as used (base on the bed), 0.2 mm layers; the rack is 203 mm long, so check
// it fits your bed diagonally if needed.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
base = [203, 80, 20];     // X, Y, Z [mm]
cradle_r = 46;            // 90 mm dish + 2 mm clearance
cradle_axis_z = 52;       // cradle bottom at z = 52 - 46 = 6
n_fins = 11;
fin_t = 3;                // divider thickness (X)
fin_pitch = 20;           // centre-to-centre; slots are 20 - 3 = 17 mm wide
fin_h = 60;               // dividers rise from z = 0 to 60

/* [Hidden] */
eps = 0.01;

union() {
    difference() {
        translate([-base.x / 2, -base.y / 2, 0]) cube(base);
        translate([-base.x / 2 - 1, 0, cradle_axis_z]) rotate([0, 90, 0])
            cylinder(r = cradle_r, h = base.x + 2, $fn = 192);
    }
    for (i = [0 : n_fins - 1])
        translate([(i - (n_fins - 1) / 2) * fin_pitch - fin_t / 2, -base.y / 2, 0]) cube([fin_t, base.y, fin_h]);
}
