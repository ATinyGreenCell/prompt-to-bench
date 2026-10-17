// Replacement knob for a hotplate stirrer - a cylindrical knob with a D-shaped blind bore
// to fit a D-shaft, an outer grip groove pattern, and a top pointer groove. NOVEL general part.
//

d      = 30;
h      = 15;
shaft_d = 6.2;
flat   = 4.7;
grooves = 18;
groove_d = 2;
pointer_w = 1.5;
pointer_d = 1;

$fn = 64;

difference() {
    cylinder(h = h, d = d);
    translate([0, 0, -1])
        cylinder(h = h + 2, d = shaft_d);
    translate([0, 0, -1])
        cylinder(h = h + 2, d = shaft_d + flat);
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves]) translate([d / 2, 0, -1]) cylinder(h = h + 2, d = groove_d, $fn = 16);
    translate([0, 0, h - pointer_d]) rotate([0, 0, 90]) rectangle([d, pointer_w]);
}