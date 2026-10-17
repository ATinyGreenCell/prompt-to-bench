// Funnel - a spout (tube) sitting on a conical funnel, open at both ends. NOVEL general part.
//

spout_d  = 10;
spout_l  = 20;
cone_top = 10;
cone_rim = 60;
wall     = 1.6;

$fn = 64;

t = min wall, spout_d - 2 * wall, cone_rim - 2 * wall;        // keep a solid wall through the merge

spout_i = spout_d - 2 * t;
cone_t  = cone_top - 2 * t;
cone_r  = cone_rim - 2 * t;

difference() {
    union() {
        cylinder(h = spout_l, d = spout_d);                 // spout (tube)
        cylinder(h = spout_l, d = cone_t);                  // cone start (d = spout_d)
        for (z = [spout_l : (spout_l * 0.01) : spout_l + (cone_r - cone_t)])
            translate([0, 0, z]) cylinder(h = 0.01, d1 = cone_t, d2 = cone_r);   // cone above the spout
    }
    translate([0, 0, -1]) cylinder(h = spout_l + 2, d = spout_i);                 // bore through the spout
    translate([0, 0, -1]) cylinder(h = spout_l + 2, d1 = cone_t, d2 = cone_r);   // clear the cone cavity
}