// Replacement knob for a hotplate stirrer - a cylinder with a D-shaped blind bore and a
// pointer groove, and with a ring of grip grooves around the outside. NOVEL general part.
//

bottom   = 30;
height   = 15;
shaft_d  = 6.2;
flat     = 4.7;
grooves  = 18;
pointer  = 1.5;

$fn = 64;

fd() {
    cylinder(h = height, d = bottom);
    difference() {
        translate([0, 0, 0]) cylinder(h = height, d = bottom);
        translate([0, 0, -1])
            intersection() {
                cylinder(h = height + 2, d = shaft_d);
                translate([0, -100, 0]) rotate([0, 90, 0]) cylinder(h = height + 2, d = flat);
            };
        translate([0, -100, height - 1])
            cylinder(h = 2, d = bottom);   // guard plane for the outer grooves
        for (i = [0 : grooves - 1])
            rotate([0, 0, i * 360 / grooves])
                translate([bottom / 2, -100, 0]) cylinder(h = height + 2, d = 2);
        translate([0, 0, height - 1])
            circle(d = bottom - 2);       // guard plane for the pointer groove
        pointer_w = 1.5;
        pointer_d = bottom / 2 - 1;      // start the groove off-centre so it does not overlap the D bore
        translate([-(bottom / 2 - 1 - pointer_d / 2), 0, height - 1])
            cube([pointer_d + pointer_w, bottom, 2]);
    }
}