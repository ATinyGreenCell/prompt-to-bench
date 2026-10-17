// Funnel - a spout (tube) sitting on top of a conical funnel, open at both ends. NOVEL part.
//

spout_d  = 10;
spout_l  = 20;
funnel_d = 60;
wall     = 1.6;

$fn = 64;

inner = spout_d - 2 * wall;

union() {
    cylinder(h = spout_l, d = spout_d);                 // spout (tube)
    cylinder(h = spout_l, d = spout_d, d2 = funnel_d);  // cone sitting on the spout
    translate([0, 0, -1]) cylinder(h = spout_l + 2, d = inner);      // through-bore
    translate([0, 0, spout_l + 0.99]) cylinder(h = 1, d = funnel_d); // open the cone end
}