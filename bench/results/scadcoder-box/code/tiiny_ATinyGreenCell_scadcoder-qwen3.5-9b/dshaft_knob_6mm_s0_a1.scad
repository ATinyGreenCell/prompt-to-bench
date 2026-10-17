// Replacement knob for a hotplate stirrer - a cylinder with a D-shaped shaft bore and an
// external grip grooved surface. NOVEL general part.
//

shaft_d   = 6;
knob_d    = 30;
knob_h    = 15;
bore_d    = 6.2;
grooves   = 18;
pointer_w = 1.5;

$fn = 64;

difference() {
    cylinder(h = knob_h, d = knob_d);

    for (i = [0 : grooves - 1])
        translate([0, 0, -1])
            rotate([0, 90, 0])
                cylinder(h = knob_h + 2, d = 2);

    translate([0, 0, -1])
        cylinder(h = bore_d + 2, d = shaft_d);

    translate([0, 0, -1])
        rotate([0, 90, 0])
            translate([-(bore_d / 2 - 1.5), 0, 0])
                cylinder(h = bore_d + 2, d = pointer_w);
}