// Funnel - a spout (tube) with a conical section above, open at both ends. NOVEL general part.
//

spout_d  = 10;
spout_l  = 20;
cone_top = 10;
cone_rim = 60;
wall     = 1.6;

$fn = 64;

ib = max(1.6, spout_d - 2 * wall);   // keep a bore even if the wall is thicker than the diameter

translate([0, 0, spout_l + cone_top])          // rest the cone tip on the spout end (z = 0)
difference() {
    union() {
        cylinder(h = spout_l, d = spout_d);                 // spout (tube)
        cylinder(h = cone_rim - cone_top, d1 = cone_top, d2 = cone_rim);    // cone above it
    }
    translate([0, 0, -1])
    cylinder(h = spout_l + cone_rim - cone_top + 2, d = ib);       // through-bore
}