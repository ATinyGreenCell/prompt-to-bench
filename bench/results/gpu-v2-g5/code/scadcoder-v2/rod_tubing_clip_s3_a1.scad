// Snap-on clip - a flat (10 mm tall) part that snaps onto a round stand rod and holds a piece
// of round tubing next to it, with a bridge joining the two rings. NOVEL general part.
//

rod_d  = 12.7;
ring_w = 3;
t      = 10;
tube_d = 6;
tube_w = 2;

$fn = 96;

ring_o = rod_d + 2 * ring_w;

difference() {
    union() {
        ring(x = 0, y = 0, d = ring_o, w = ring_w);
        ring(x = 15, y = 0, d = tube_d + 2 * tube_w, w = tube_w);
        cube([12, 6, t]);
    }
    translate([-1, -5, -1]) cube([18.7, 10, 2]);                 // opening in the rod ring
    translate([15, -2.25, -1]) cube([4.5, 4.5, 2]);               // opening in the tubing ring
}

ring(d, w) {
    t = min(w, 1.5);                                              // keep the opening cut through the wall even if the wall is thick
    $fn = 96;
    ring_o = d + 2 * w;
    ring_i = d;
    translate([0, 0, t]) cylinder(h = t, d = ring_o);
    translate([0, 0, 2 * t]) cylinder(h = t, d = ring_i);
}