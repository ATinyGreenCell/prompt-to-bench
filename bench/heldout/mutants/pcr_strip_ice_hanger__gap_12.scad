// KNOWN-WRONG PART (must fail): the wall gap is 12 mm (no clearance) instead of 12.5
// Holder that hangs one 8-tube PCR strip inside an ice bucket, hooked over its 12 mm wall
// Category: quick fixes. An upside-down U (two legs and a bridge) that fits over the wall, and a
// ledge at the foot of the inner leg with eight tube holes, so the tubes sit down in the ice.
// Print: PLA or PETG, as used (both legs and the ledge on the bed); the bridge spans 12.5 mm.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Hanger] */
length = 84;              // along X, centred
leg_t = 4;
gap = 12;                 // 12 mm bucket wall + clearance
leg_h = 50;               // both legs from z = 0 to 50
bridge_t = 4;             // bridge from z = 46 to 50
ledge = [30, 6];          // ledge reaches 30 mm toward -Y, 6 mm thick
hole_d = 6.4;
n = 8;
pitch = 9;
hole_y = -15;

/* [Hidden] */
eps = 0.01;
outer_y = leg_t + gap;    // outer leg from y = 16.5 to 20.5

difference() {
    union() {
        translate([-length / 2, -ledge[0], 0]) cube([length, ledge[0] + eps, ledge[1]]);
        translate([-length / 2, 0, 0]) cube([length, leg_t, leg_h]);
        translate([-length / 2, 0, leg_h - bridge_t]) cube([length, outer_y + leg_t, bridge_t]);
        translate([-length / 2, outer_y, 0]) cube([length, leg_t, leg_h]);
    }
    for (i = [0 : n - 1])
        translate([(i - (n - 1) / 2) * pitch, hole_y, -1]) cylinder(d = hole_d, h = ledge[1] + 2, $fn = 48);
}
