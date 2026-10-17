// Snap-on clip - a flat (Z-extruded) part that holds a piece of round tubing next to a round
// lab stand rod, with a snapping fit for the rod. NOVEL general part.
//

rod_d  = 12.7;
ring_w = 3;
t      = 10;
xtub   = 15;
tub_d  = 6;
tub_w  = 2;

$fn = 96;

ring_o = rod_d + 2 * ring_w;

difference() {
    union() {
        ring(x = -ring_w - 1);                 // rod ring, open to the -X so it snaps onto the rod
        ring(x = xtub + tub_w + 1);            // tubing ring, open to the +X
        for (y = [-tub_d / 2 - 1, tub_d / 2 + 1])
            cube([12, 6, t]);                  // solid bridge (Y x X) between the two rings
    }
    translate([-ring_w - 0.01, -5.01, 0]) cube([ring_o + 0.01, 10, t]);   // cut out the rod side
    translate([xtub + tub_w - 0.01, -2.26, 0]) cube([4.5 + 0.01, 4.5, t]);  // cut out the tubing side
}

ring(x) {
    translate([x, 0, 0]) difference() {
        cylinder(h = t, d = ring_o);
        translate([0, -5, -1]) cube([ring_o + 2, 10, t]);
    }
}