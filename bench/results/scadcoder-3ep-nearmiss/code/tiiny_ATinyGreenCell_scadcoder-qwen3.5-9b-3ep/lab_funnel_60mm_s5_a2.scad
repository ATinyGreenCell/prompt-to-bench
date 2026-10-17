// Funnel - a spout (tube) sitting below a conical section, open at both ends for fluid flow.
// NOVEL general part for a lab or control application.
//

spout_d = 10;
spout_z = 20;
cone_d  = 60;
rim_z   = 50;
wall    = 1.6;

$fn = 64;

ib = spout_d - 2 * wall;   // spout bore
ic = cone_d - 2 * wall;    // cone inner diameter at the join

difference() {
    union() {
        cylinder(h = spout_z, d = spout_d);                 // spout
        translate([0, 0, spout_z]) cylinder(h = rim_z - spout_z, d = spout_d);
        translate([0, 0, spout_z]) cylinder(h = rim_z - spout_z, d = cone_d);
    }
    translate([0, 0, -1]) cylinder(h = spout_z + 2, d = ib);                     // bore through spout
    translate([0, 0, spout_z]) cylinder(h = rim_z - spout_z + 1, d = ic);       // inner cone surface
}