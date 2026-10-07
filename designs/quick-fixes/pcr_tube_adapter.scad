// Adapter sleeve: holds a 0.2 mL PCR tube in a 1.5 mL tube RACK hole
// Category: quick fixes. FOR RACKS ONLY - NEVER put it in a centrifuge rotor: printed
// parts are not rated for centrifugal loads and can shatter. Not for heat blocks or
// thermal cyclers in any printed material: plastic softens and insulates the tube.
// Printed upside down (collar on the bed), so the only overhang is the 6.4 mm bore
// ceiling, a short bridge. The blind bore from the top stops the tube from sliding to the bottom of the rack hole.
// Print: PLA or PETG, 0.15 mm layers.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Adapter] */
// rests on the rack surface
collar_d = 13;
collar_h = 1.5; // 0.1
// fits a 1.5 mL rack hole
body_d = 10.8; // 0.1
// from the collar up
body_h = 20;
// 0.2 mL PCR tube OD ~6.0 mm + clearance
bore_d = 6.4; // 0.1
// from the top (the end that faces up in the rack)
bore_depth = 15;

/* [Hidden] */
$fn = 64;
eps = 0.01;
H = collar_h + body_h;

// parameter checks: stop with a message instead of building a broken part
assert(body_d - bore_d >= 2 * 0.8, "the sleeve wall is under 0.8 mm: reduce bore_d");
assert(bore_depth <= H - 0.8, "the bore goes through: the tube would fall into the rack hole");
assert(collar_d > body_d, "the collar must be wider than the body or the adapter falls into the hole");

difference() {
    union() {
        cylinder(d = collar_d, h = collar_h + eps);
        translate([0, 0, collar_h]) cylinder(d = body_d, h = body_h);
    }
    // printed collar-down, so the rack's top face is z = 0: the bore opens there
    translate([0, 0, -eps]) cylinder(d = bore_d, h = bore_depth + eps);
}
