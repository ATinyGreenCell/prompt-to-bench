// Funnel - a straight spout (tube) with a conical bowl, open at both ends, for pouring
// liquids in the lab. NOVEL general part.
//

spout_d = 10;
spout_l = 20;
cone_d  = 60;
rim     = 50;
wall    = 1.6;

$fn = 64;

ib = spout_d - 2 * wall;   // bore of the spout

difference() {
    union() {
        cylinder(h = spout_l, d = spout_d);          // spout
        translate([0, 0, spout_l]) cylinder(h = 30, d1 = spout_d, d2 = cone_d);  // cone (flared mouth)
        translate([0, 0, spout_l]) cylinder(h = 30, d1 = ib, d2 = cone_d - 2 * wall);  // inner cone, open mouth
    }
    translate([0, 0, -1]) cylinder(h = spout_l + 2, d = ib);  // bore through the spout
}