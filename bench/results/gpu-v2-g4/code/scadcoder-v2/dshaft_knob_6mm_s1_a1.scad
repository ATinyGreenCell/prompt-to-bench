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

flat_normal = [0, 1, 0];
flat_point  = [0, -1.5, 0];   // the flat of the D lies along Y at this radius

difference() {
    cylinder(h = h, d = d);
    translate([0, 0, 0])
        cylinder(h = h + 1, d = shaft_d);                        // round part of the bore
    translate([0, 0, 0])
        cylinder(h = h + 1, d = shaft_d, $fn = 16);            // flat part of the D-bore
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves])
            translate([d / 2, 0, 0])
                cylinder(h = h + 1, d = groove_d, $fn = 16);   // grip grooves
    translate([0, 0, h - 1])
        linear_extrude(h = 1.5)
            polygon([[-d / 2, -d / 2], [-d / 2, d / 2], [d / 2, d / 2], [d / 2, -d / 2],
                     [0, -d / 2], [0, d / 2]]);                 // top face groove (shape * 2)
    translate([0, 0, h - 1])
        rotate([0, 90, 0])
        linear_extrude(h = 1.5)
            circle(d = pointer_d);                             // tip of the pointer
}