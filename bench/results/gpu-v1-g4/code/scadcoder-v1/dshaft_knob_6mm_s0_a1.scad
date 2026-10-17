// Replacement knob for a hotplate stirrer - a cylinder with a D-shaped blind bore for a
// D-shaft and an outer grip grooved around the circumference. NOVEL general part.
//

shaft_d   = 6;
knob_d    = 30;
knob_h    = 15;
bore_depth = 12;
grooves   = 18;

$fn = 72;

outer = knob_d;
flat  = shaft_d * 1.06;                 // keep the D bore slightly clearance over the shaft
t     = min(2.5, knob_h - bore_depth);  // wall below the bore so the shaft can drop through

difference() {
    cylinder(h = knob_h, d = outer);
    translate([0, 0, -1]) cylinder(h = knob_h + 2, d = shaft_d);                       // shaft (clearance)
    translate([0, 0, -1]) cylinder(h = bore_depth + 2, d = flat);                       // D bore - circle
    translate([-(flat - shaft_d) / 2, 0, -1]) cylinder(h = bore_depth + 2, d = flat - shaft_d);   // D flat
    for (i = [0 : grooves - 1])                                                           // grip grooves
        rotate([0, 0, i * 360 / grooves]) translate([knob_d / 2, 0, -1])
            cylinder(h = knob_h + 2, d = 2);
    translate([0, 0, knob_h - 1]) cylinder(h = 2, d = knob_d);                          // top cap (the groove starts below it)
    translate([0, 0, knob_h - 1]) rotate([-90, 0, 0]) cylinder(h = 2, d = 1.5);         // pointer groove
}