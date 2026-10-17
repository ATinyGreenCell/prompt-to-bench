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
        translate([8, -3, 0]) cube([bridge_w, 6, height]);
    }
    translate([open_x, -open_w / 2 - 1, -0.5]) cube([open_w, open_w + 2, height + 1]);
    translate([15, -2.25 - 1, -0.5]) cube([4.5, 4.5, height + 1]);
}

ring(r, open_x, open_w) {
    difference() {
        cylinder(h = height, d = 2 * r);
        translate([open_x, -open_w / 2 - 1, -0.5]) cube([open_w, open_w + 2, height + 1]);
    }
}