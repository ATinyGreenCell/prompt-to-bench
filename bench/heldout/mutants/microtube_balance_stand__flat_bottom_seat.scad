// KNOWN-WRONG PART (must fail): the seat is an 11 mm cylinder down to z = 6 (no cone)
// Weighing stand that holds one 1.5 mL microcentrifuge tube upright on a balance pan
// Category: quick fixes. A revolved stand (base disc, cone, column) with a seat that follows the
// tube's conical tip, and a viewing window through the column wall on the +X side.
// Print: PLA or PETG, standing up, 0.2 mm layers. Tare the balance with the stand on it.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Stand] */
base_d = 50;  base_h = 4;       // disc z = 0 .. 4
col_d = 22;   cone_top = 14;    // cone 50 -> 22 mm from z = 4 to 14
height = 33;                    // column from z = 14 to 33
seat_d = 11;  seat_cyl_z = 23;  // 11 mm from the top down to z = 23 ...
tip_d = 11;   tip_z = 6;        // ... then a cone narrowing to 3 mm at z = 6
win_w = 4;    win_z = [18, 30]; // viewing window through the +X wall

/* [Hidden] */
$fn = 128;
eps = 0.01;

difference() {
    rotate_extrude() polygon([[0, 0], [base_d / 2, 0], [base_d / 2, base_h], [col_d / 2, cone_top],
                              [col_d / 2, height], [0, height]]);
    translate([0, 0, tip_z]) cylinder(d1 = tip_d, d2 = seat_d, h = seat_cyl_z - tip_z + eps, $fn = 96);
    translate([0, 0, seat_cyl_z]) cylinder(d = seat_d, h = height - seat_cyl_z + 1, $fn = 96);
    translate([0, -win_w / 2, win_z[0]]) cube([col_d / 2 + 1, win_w, win_z[1] - win_z[0]]);
}
