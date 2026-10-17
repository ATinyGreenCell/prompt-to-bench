// Stand-off clip - a profile extruded through a panel, with a rod ring (for a 12.7 mm / 1/2 inch
// stand rod) and a tubing ring (for 6 mm wall tubing), joined by a solid bridge. The rod ring has
// an opening on the -X side so it snaps onto the rod. NOVEL general part.
//

rod_d     = 12.7;
ring_wall = 3;
tub_d     = 6;
tub_wall  = 2;
bridge_w  = 6;
height    = 10;

$fn = 72;

ring_o = rod_d + 2 * ring_wall;
tub_o  = tub_d + 2 * tub_wall;

difference() {
    union() {
        cylinder(h = height, d = ring_o);                 // rod ring
        translate([15, 0, 0]) cylinder(h = height, d = tub_o);   // tubing ring
        translate([8, -3, 0]) cube([4, 6, height]);                     // bridge (y +/- 3)
    }
    // Open the rod ring: remove x < 0 and |y| < 5 (a wall ~1.3 mm thick remains)
    translate([-ring_o - 1, -5, 0]) cube([ring_o + 2, 10, height + 1]);
    // Open the tubing ring: remove x > 15 and |y| < 2.25 (a wall ~1.2 mm remains)
    translate([15, -2.25, 0]) cube([4.5, 5, height + 1]);
}