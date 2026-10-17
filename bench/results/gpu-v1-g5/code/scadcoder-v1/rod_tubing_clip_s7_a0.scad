// Stand-off clip - a ring that snaps onto a round stand rod, with a separate ring for a
// piece of tubing, joined by a solid bridge. Printed flat (the ring planes are parallel to the
// XY plane) so it drops onto a rod and snaps into place. NOVEL general part.
//

stand_d  = 12.7;
tube_d   = 6;
bridge_w = 6;
height   = 10;

$fn = 72;

ring_d = stand_d + 2 * 3;          // outer diameter of the stand ring
open   = 10;                       // opening in the stand ring (-X side)
g      = min(1.5, stand_d / 2 - 3 - open / 2);   // keep the rod hole open even with the opening

t  = tube_d + 2 * 2;               // outer diameter of the tubing ring
open_t = 4.5;
g_t   = min(1.5, tube_d / 2 - 2 - open_t / 2);

difference() {
    union() {
        cylinder(h = height, d = ring_d);                 // stand ring (solid)
        cylinder(h = height, d = t);                      // tubing ring (solid)
        translate([-(bridge_w / 2), 0, 0]) cube([bridge_w, 6, height]);   // bridge
    }
    // cut the opening in the stand ring
    translate([-ring_d / 2 - 1, -open / 2, 0]) cube([open + 2, 6, height]);
    // keep a guide wall near the rod: a wall 1.5 mm thick for x in [-g, g]
    translate([-g - 1, -stand_d / 2 - 1, 0]) cube([g + 1 + 1, stand_d + 4, height]);
    // cut the opening in the tubing ring
    translate([t / 2 - 1, -open_t / 2, 0]) cube([open_t + 2, 6, height]);
    // keep a guide wall near the tube centre: a wall 1.5 mm thick for x in [t / 2 - g_t - 1, t / 2 - g_t + 1]
    translate([t / 2 - g_t - 2, -tube_d / 2 - 1, 0]) cube([g_t * 2 + 4, tube_d + 4, height]);
}