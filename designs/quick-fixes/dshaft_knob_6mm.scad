// Replacement knob for a 6 mm D-shaft (hotplates, stirrers, power supplies)
// Category: quick fixes. Blind bore from the bottom: round for the first round_len mm
// (many shafts are round near the panel and only flatted towards the tip), D-shaped
// above, with a small chamfer at the mouth to beat elephant's foot. Grip grooves and a
// pointer groove on top that lines up with the flat of the shaft.
// MEASURE FIRST: metric shafts are 6.0 mm with a 4.5 mm flat; US instruments often use
// 1/4" (6.35 mm). Set shaft_d = measured + 0.2 and shaft_flat = measured flat + 0.2,
// and set round_len to the shaft length that has no flat.
// Print: PETG (heat near hotplates), 0.15 mm layers, 4 perimeters, bore face down.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Knob] */
knob_d = 30;
knob_h = 15;
shaft_d = 6.2;         // 6 mm shaft + 0.2 mm clearance
shaft_flat = 4.7;      // flat-to-round distance (4.5 mm nominal + clearance)
bore_depth = 12;
round_len = 4;         // round (un-flatted) part of the bore at the mouth
mouth_chamfer = 0.5;
n_grooves = 18;
groove_d = 2;
pointer_w = 1.5;
pointer_depth = 1;

/* [Hidden] */
eps = 0.01;

difference() {
    cylinder(d = knob_d, h = knob_h, $fn = 128);
    // round section at the mouth, then the D-shaped bore; the flat faces +X
    translate([0, 0, -eps]) cylinder(d = shaft_d, h = round_len + eps, $fn = 64);
    translate([0, 0, -eps])
        linear_extrude(bore_depth + eps)
            intersection() {
                circle(d = shaft_d, $fn = 64);
                translate([-shaft_d / 2, -shaft_d / 2]) square([shaft_flat, shaft_d]);
            }
    translate([0, 0, -eps]) cylinder(d1 = shaft_d + 2 * mouth_chamfer, d2 = shaft_d, h = mouth_chamfer + eps, $fn = 64);
    // grip grooves
    for (i = [0 : n_grooves - 1])
        rotate(i * 360 / n_grooves)
            translate([knob_d / 2, 0, -eps]) cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 24);
    // pointer groove on top, pointing at the flat (+X)
    translate([0, -pointer_w / 2, knob_h - pointer_depth])
        cube([knob_d / 2 + 1, pointer_w, pointer_depth + eps]);
}
