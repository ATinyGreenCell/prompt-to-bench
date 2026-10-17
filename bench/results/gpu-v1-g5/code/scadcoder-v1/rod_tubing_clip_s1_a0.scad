// Stand-off clip - a ring that snaps onto a round stand rod, with a separate ring for a
// piece of tubing, joined by a bridge. Printed flat (an extruded 2-D profile): the two rings
// do not touch the bed until they are assembled onto a stand, so they are not warped by the print.
// NOVEL general part.
//

stand_d  = 12.7;
tube_d   = 6;
bridge_w = 6;
height   = 10;

$fn = 48;

ring_d = stand_d + 2 * 3;          // outer diameter of the stand ring
open   = 10;                       // opening in the stand ring (-X side)
g      = stand_d + 0.5;            // approach the stand with a clearance

tube_d = min(tube_d, 15);          // keep the tubing ring reasonable
open_t = 4.5;                      // opening in the tubing ring (+X side)

difference() {
    union() {
        ring(stand_d + 2 * 3, 3, open);                 // stand ring
        ring(tube_d, 2, open_t, x = 15);                 // tubing ring
        translate([8, -3, 0]) cube([bridge_w, 6, height]);   // bridge
    }
    translate([0, -6, -1]) rotate([-90, 0, 0]) cylinder(h = height + 2, d = g);      // stand rod
    translate([15 + 15 / 2, 0, -1]) rotate([-90, 0, 0]) cylinder(h = height + 2, d = open_t + 4);   // tubing opening
}

// Ring: a circle with a rectangular opening cut out of the +X side, for a panel or a stand rod.
module ring(od, wall, opening, x = 0) {
    inner = od - 2 * wall;
    translate([x, 0, 0]) difference() {
        cylinder(h = 1, d = od);
        translate([-opening / 2, -od / 2 - 1, 0]) cube([opening, od + 4, 1]);
    }
}