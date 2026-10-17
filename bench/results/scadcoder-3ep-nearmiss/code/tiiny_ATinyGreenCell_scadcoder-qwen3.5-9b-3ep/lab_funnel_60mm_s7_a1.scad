// Funnel - a straight spout (tube) topped by a conical section, open at both ends for fluid
// flow. NOVEL general part for a lab bench or a custom assembly.
//

spout_d = 10;
spout_l = 20;
cone_d  = 60;
wall    = 1.6;

$fn = 64;

ib = spout_d - 2 * wall;          // spout bore
ic = cone_d - 2 * wall;           // cone inner diameter at its narrow end

difference() {
    union() {
        cylinder(h = spout_l, d = spout_d);                 // spout
        translate([0, 0, spout_l]) cylinder(h = 30, d = spout_d);  // tube section of cone
        translate([0, 0, spout_l]) cylinder(h = 30, d = cone_d);  // conical section
    }
    translate([0, 0, -1]) cylinder(h = spout_l + 2, d = ib);                     // bore through spout
    translate([0, 0, spout_l - 1]) cylinder(h = 32, d = ic);                     // cone inner space
}