// Replacement knob for a hotplate stirrer - a cylinder with a D-shaped blind bore for a
// D-shaft and an outer grip grooved around the circumference. NOVEL general part.
//

shaft_d   = 6;
knob_d    = 30;
knob_h    = 15;
bore_d    = 6.2;
flat_d    = 4.7;          // diameter across the D bore: flat to opposite wall
grooves   = 18;
groove_d  = 2;
pointer_w = 1.5;

$fn = 72;

difference() {
    cylinder(h = knob_h, d = knob_d);
    translate([0, 0, -1]) rotate([-90, 0, 0])
        difference() {
            cylinder(h = knob_h + 2, d = bore_d);                 // D-bore: a circle with one side cut flat
            translate([-bore_d / 2, 0, 0]) cube([bore_d / 2 + 1, bore_d + 2, knob_h + 2]);   // flat the +X side
        }
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves])
            translate([knob_d / 2, 0, 0])
                difference() {
                    cylinder(h = knob_h, d = groove_d);
                    translate([0, -1, 0]) cube([groove_d + 2, knob_h + 2, groove_d]);      // right-hand half-cylinder groove
                }
    translate([0, 0, knob_h - 1]) cylinder(h = 2, d = pointer_w);                 // pointer groove, open upward
}