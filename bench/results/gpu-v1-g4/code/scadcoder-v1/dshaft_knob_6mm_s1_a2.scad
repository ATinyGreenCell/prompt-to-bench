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
flat  = shaft_d * 1.06;                 // keep the D-bore slightly clearance-less for the shaft
r     = min(knob_d / 2, (shaft_d + 4) / 2);    // radius so the flat stays within the cylinder

difference() {
    cylinder(h = knob_h, d = outer);
    translate([0, 0, -1]) rotate([-90, 0, 0])
        difference() {
            circle(d = 2 * r);
            translate([-flat / 2, 0, 0]) square([flat, 2 * r]);       // D-bore: circle with one side flat
        }
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves])
            translate([knob_d / 2, 0, 0])
                difference() {
                    cylinder(h = knob_h + 2, d = 2.5);                 // groove axis
                    translate([-.1, -1.25, 0]) rotate([1, 0, 0]) cube([2.5, 2.5, knob_h + 2]);  // remove +y half -> groove on +x side
                }
    translate([0, 0, knob_h - 1]) cylinder(h = 2, d = knob_d);       // cap the top face
    translate([0, 0, knob_h - 0.5]) cylinder(h = 0.5, d = knob_d * 0.3);   // pointer groove (axial channel)
}