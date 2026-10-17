// Stand-off clip - a ring that snaps onto a round stand rod, with a separate ring for a
// piece of tubing, joined by a bridge. Printed flat (an extruded 2-D profile): the two rings
// do not touch the bed until they are placed over the rod they are meant to hold. NOVEL part.
//

rod_d   = 12.7;
clearance = 3;
ring_w  = 3;
bridge_w = 6;
height  = 10;

$fn = 72;

inner  = rod_d + 2 * clearance;
outer  = inner + 2 * ring_w;
t      = ring_w;

opening = 10;
bridge_h = 4;

difference() {
    union() {
        ring(outer, inner, t);                 // rod ring
        ring(6, 6 - 2 * t, t, pos = 15);          // tubing ring
        translate([8, -3, 0]) cube([bridge_w, 6, height]);   // bridge between them
    }
    translate([-(inner / 2 + 1), -opening / 2 - 1, 0]) rotate([-90, 0, 0])
        cube([opening + 2, 2 * (opening / 2 + 1), height + 2]);              // -X opening in the rod ring
    translate([15 - 6, -opening / 2 - 1, 0]) rotate([-90, 0, 0]) cube([opening + 2, 2 * (opening / 2 + 1), height + 2]);  // +X opening in the tubing ring
}

// Reusable ring: inner diameter inner, wall t, centred (x, y). An opening of size d is cut on the +x side.
module ring(outer, inner, t, x = 0, y = 0, d = 10) {
    $fn = 72;
    w = min(t, d / 2 - 1);                 // keep the wall thicker than half the opening
    difference() {
        cylinder(h = height, d = outer);
        translate([x - (inner / 2 + 1), y, 0]) rotate([-90, 0, 0]) cube([inner + 2 * w, d + 2, height + 2]);
    }
}