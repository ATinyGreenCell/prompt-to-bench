// Snap-on clip that holds a piece of tubing next to a 12.7 mm (1/2 inch) lab stand rod.
// It is printed flat: a 10 mm tall extrusion (Z) of a 2-D profile in the XY plane.
// The profile consists of: (1) a rod ring with 12.7 mm inner diameter and 3 mm wall (18.7 mm
// outer diameter), centred at the origin, with a 10 mm wide opening cut out of its -X side
// (everything with x < 0 and -5 < y < 5 is removed from this ring) so it snaps onto the rod;
// (2) a tubing ring with 6 mm inner diameter and 2 mm wall, centred at x = 15, y = 0, with a
// 4.5 mm wide opening cut out of its +X side (x > 15 and -2.25 < y < 2.25); (3) a solid bridge
// 6 mm wide (Y) between x = 8 and x = 12 that joins the two rings without blocking either
// ring's hole.
//

rod_d     = 12.7;
wall_rod  = 3;
open_rod  = 10;
tube_d    = 6;
wall_tube = 2;
open_tube = 4.5;
bridge_w  = 6;
height    = 10;

$fn = 72;

open_rod_h = 2 * sqrt(18.7 ^ 2 - 5 ^ 2);   // keep the +X part of the rod ring intact

difference() {
    union() {
        cylinder(h = height, d = 18.7);                 // rod ring (full)
        cylinder(h = height, d = tube_d + 2 * wall_tube, center = true, translate([15, 0, 0]));   // tubing ring (full)
        cube([bridge_w, 6, height]);                     // solid bridge between the two rings
    }
    translate([-100, -5, -1]) cube([200, open_rod_h, height]);   // cut out the -X side of the rod ring
    translate([15, -2.25, -1]) cube([open_tube, 4.5, height]);   // cut out the +X side of the tubing ring
}