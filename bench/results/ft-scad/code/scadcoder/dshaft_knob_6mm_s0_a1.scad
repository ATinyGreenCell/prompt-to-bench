// Knob for a hotplate stirrer - a cylinder with an upper grip grooved rim and a D-shaped
// blind bore, for turning a shaft buried in a hot plate. NOVEL general part.
//

shaft_d  = 6;
bore     = 6.2;
flat     = 4.7;
height   = 15;
grooves  = 18;
pointer  = 1;

$fn = 96;

bore_t   = 12;

difference() {
    cylinder(h = height, d = shaft_d + 2);                 // body
    translate([0, 0, -1]) cylinder(h = bore_t + 2, d = bore);   // blind bore
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves])
            translate([shaft_d / 2 - 0.8, 0, height * 0.25])
                circle(d = 2);
    rotate([-90, 0, 0])
        linear_extrude(height) circle(d = shaft_d + 4);   // grip grooves
    translate([0, 0, height * 0.75 - 0.8]) rectangle(d1 = bore / 2 + 1.5, d2 = pointer);
}