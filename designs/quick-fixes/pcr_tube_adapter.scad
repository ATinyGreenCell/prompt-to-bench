// Adapter sleeve: holds a 0.2 mL PCR tube in a 1.5 mL tube RACK hole
// Category: quick fixes. FOR RACKS ONLY - NEVER put it in a centrifuge rotor: printed
// parts are not rated for centrifugal loads and can shatter. Not for heat blocks or
// thermal cyclers in any printed material: plastic softens and insulates the tube.
// Printed upside down (collar on the bed) so nothing overhangs; the blind bore from the
// top stops the tube from sliding to the bottom of the rack hole.
// Print: PLA or PETG, 0.15 mm layers.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Adapter] */
collar_d = 13;         // rests on the rack surface
collar_h = 1.5;
body_d = 10.8;         // fits a 1.5 mL rack hole
body_h = 20;           // from the collar up
bore_d = 6.4;          // 0.2 mL PCR tube OD ~6.0 mm + clearance
bore_depth = 15;       // from the top (the end that faces up in the rack)

/* [Hidden] */
$fn = 64;
eps = 0.01;
H = collar_h + body_h;

difference() {
    union() {
        cylinder(d = collar_d, h = collar_h + eps);
        translate([0, 0, collar_h]) cylinder(d = body_d, h = body_h);
    }
    // printed collar-down, so the rack's top face is z = 0: the bore opens there
    translate([0, 0, -eps]) cylinder(d = bore_d, h = bore_depth + eps);
}
