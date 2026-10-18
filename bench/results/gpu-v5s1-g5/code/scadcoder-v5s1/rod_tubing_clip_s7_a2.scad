// Stand rod and tubing clip - prints flat, snaps onto a 12.7 mm stand rod and holds a
// small tube next to it. NOVEL general part.
//

rod_d     = 12.7;
ring_w    = 3;
outer_d   = rod_d + 2 * ring_w;
opening_w = 10;
bridge_x1 = 8;
bridge_x2 = 12;
bridge_w  = bridge_x2 - bridge_x1;
tube_d    = 6;
tube_w    = 2;
tube_x    = 15;
cut_x     = tube_x + tube_w;
cut_y     = tube_d / 2 + 0.5;
height    = 10;

$fn = 96;

difference() {
    union() {
        // Stand-rod ring
        cylinder(h = height, d = outer_d);
        // Tubing ring
        translate([tube_x, 0, 0]) cylinder(h = height, d = tube_d + 2 * tube_w);
        // Solid bridge
        translate([bridge_x1, -bridge_w / 2, 0]) cube([bridge_w, bridge_w, height]);
    }
    // Opening in the rod ring
    translate([-outer_d / 2 - 1, -opening_w / 2, 0])
        cube([opening_w + 2, opening_w + 2, height + 2]);
    // Opening in the tubing ring
    translate([cut_x, -cut_y, 0])
        cube([tube_w + 1, 2 * cut_y + 1, height + 2]);
}