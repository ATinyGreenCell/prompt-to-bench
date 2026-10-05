// Adapter sleeve: holds a 0.2 mL PCR tube in a 1.5 mL tube rack hole
// Category: quick fixes. Printed upside down (collar on the bed) so nothing overhangs.
// Print: PLA or PETG, 0.15 mm layers. Not for heat blocks unless printed in a
// high-temperature material (PLA softens around 55-60 C).
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Adapter] */
collar_d = 13;         // rests on the rack surface
collar_h = 1.5;
body_d = 10.8;         // fits a 1.5 mL rack hole
body_h = 20;           // from the collar up
bore_d = 6.2;          // 0.2 mL PCR tube

/* [Hidden] */
$fn = 64;
eps = 0.01;

difference() {
    union() {
        cylinder(d = collar_d, h = collar_h + eps);
        translate([0, 0, collar_h]) cylinder(d = body_d, h = body_h);
    }
    translate([0, 0, -eps]) cylinder(d = bore_d, h = collar_h + body_h + 2 * eps);
}
