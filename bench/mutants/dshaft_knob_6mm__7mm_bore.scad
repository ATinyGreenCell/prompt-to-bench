// D-shaft knob with a 7 mm bore instead of 12 mm

/* [Knob] */
knob_d = 30;
knob_h = 15;
shaft_d = 6.2;         // 6 mm shaft + 0.2 mm clearance
shaft_flat = 4.7;      // flat-to-round distance (4.5 mm nominal + clearance)
bore_depth = 7;
n_grooves = 18;
groove_d = 2;
pointer_w = 1.5;
pointer_depth = 1;

/* [Hidden] */
eps = 0.01;

difference() {
    cylinder(d = knob_d, h = knob_h, $fn = 128);
    // D-shaped bore; the flat faces +X
    translate([0, 0, -eps])
        linear_extrude(bore_depth + eps)
            intersection() {
                circle(d = shaft_d, $fn = 64);
                translate([-shaft_d / 2, -shaft_d / 2]) square([shaft_flat, shaft_d]);
            }
    // grip grooves
    for (i = [0 : n_grooves - 1])
        rotate(i * 360 / n_grooves)
            translate([knob_d / 2, 0, -eps]) cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 24);
    // pointer groove on top, pointing at the flat (+X)
    translate([0, -pointer_w / 2, knob_h - pointer_depth])
        cube([knob_d / 2 + 1, pointer_w, pointer_depth + eps]);
}
