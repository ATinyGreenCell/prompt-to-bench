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
    translate([open_x - 1, -open_w / 2 - 1, 0]) cube([open_w + 2, open_w + 2, height]);   // rod opening
    translate([15, -2.25 - 1, 0]) cube([4.5 + 2, 4.5 + 2, height]);                        // tubing opening
}

// Round ring with a rectangular cut out of one side
ring(d, open_x, open_w) {
    difference() {
        cylinder(h = height, d = d);
        translate([open_x, -open_w / 2 - 1, 0]) cube([open_w + 2, open_w + 2, height]);
    }
}