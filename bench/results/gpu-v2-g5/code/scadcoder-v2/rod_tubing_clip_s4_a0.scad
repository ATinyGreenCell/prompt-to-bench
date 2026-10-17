// Snap-on clip - a flat (10 mm tall) part that snaps onto a round stand rod and holds a piece
// of round tubing next to it, with a bridge joining the two rings. NOVEL general part.
//

rod_d  = 12.7;
tubing_d = 6;
bridge_w = 6;
height = 10;

$fn = 48;

ring_r = rod_d / 2 + 1.5;
open_x = -10;
open_w = 10;

difference() {
    union() {
        ring(ring_r, open_x, open_w);
        ring(tubing_d / 2 + 1, 15, 4.5);
        cube([bridge_w, 6, height]);
    }
    translate([-ring_r - 1, -open_w / 2 - 1, 0]) cube([open_w + 2, open_w + 2, height]);   // opening in the rod ring
    translate([15, -2.25 - 1, 0]) cube([4.5 + 2, 4.5 + 2, height]);                        // opening in the tubing ring
}

// Round ring with a rectangular opening cut out of the -X side.
ring(d, open_x, open_w) {
    difference() {
        cylinder(h = height, d = d);
        translate([open_x, -open_w / 2 - 1, 0]) cube([open_w + 2, open_w + 2, height]);
    }
}