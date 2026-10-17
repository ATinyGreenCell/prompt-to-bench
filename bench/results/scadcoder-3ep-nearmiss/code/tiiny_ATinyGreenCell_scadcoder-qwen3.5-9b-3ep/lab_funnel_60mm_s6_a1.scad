// Funnel - a spout (tube) sitting below a conical section, open at both ends for fluid flow.
// NOVEL general part for a lab or craft. DO NOT use in contact with skin or food.
//

spout_d = 10;
spout_l = 20;
cone_d  = 60;
wall    = 1.6;

$fn = 64;

ib = spout_d - 2 * wall;   // spout bore
ic = cone_d - 2 * wall;    // cone inner diameter at the spout join

difference() {
    union() {
        cylinder(h = spout_l, d = spout_d);                 // spout
        translate([0, 0, spout_l]) cylinder(h = 30, d1 = spout_d, d2 = cone_d);  // cone
    }
    translate([0, 0, -1]) cylinder(h = spout_l + 2, d = ib);                     // spout bore
    translate([0, 0, spout_l - 1]) cylinder(h = 32, d = ic);                     // cone inner space
}