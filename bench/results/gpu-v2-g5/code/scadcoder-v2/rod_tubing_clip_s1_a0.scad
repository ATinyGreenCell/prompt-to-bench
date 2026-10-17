// Snap-on clip - a flat (Z-extruded) part that holds round tubing next to a round
// stand rod, with a snapping fit for the rod. NOVEL general part.
//

rod_d  = 12.7;
ring_w = 3;
t      = 10;
x_open = 10;

$fn = 96;

ring_d = rod_d + 2 * ring_w;

difference() {
    union() {
        ring(x = 0, d = ring_d, w = ring_w);
        ring(x = 15, d = 6 + 2 * ring_w, w = ring_w);
        cube([12, 6, t]);
    }
    translate([-1, -5, -1]) cube([x_open, 10, t + 2]);                 // opening in the rod ring
    translate([15, -2.25, -1]) cube([4.5, 4.5, t + 2]);                 // opening in the tubing ring
}

ring(x, d, w) {
    od = d + 2 * w;
    $fn = 96;
    difference() {
        cylinder(h = t, d = od);
        translate([x, 0, -1]) cylinder(h = t + 2, d = d + 0.5);        // inner hole - 0.25 mm clearance
    }
}