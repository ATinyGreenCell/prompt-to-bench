// Stand-off clip - a ring that snaps onto a round stand rod, with a separate ring for a
// piece of tubing, joined by a bridge. Printed flat (the 2-D profile extruded 10 mm in Z). NOVEL
// general part (not one of the 16 benchmark tasks).
//

stand_d  = 12.7;
tube_d   = 6;
bridge_w = 6;
height   = 10;

$fn = 48;

ring_d = stand_d + 2 * 3;          // outer diameter of the stand ring
open   = 10;                       // opening in the stand ring (-X side)
g      = min(1.5, stand_d / 2 - 3 - open / 2);   // keep the rod hole open even with the opening: wall above the centre line

t  = tube_d + 2 * 2;               // outer diameter of the tubing ring
open_t = 4.5;
g_t   = min(1.5, tube_d / 2 - 2 - open_t / 2);    // same idea for the tubing ring

difference() {
    union() {
        for (y = [-ring_d / 2, ring_d / 2])
            translate([0, y, 0]) circle(d = ring_d);
        translate([-(ring_d / 2 - bridge_w / 2), 0, 0]) rectangle([bridge_w, ring_d, 1]);
    }
    translate([0, 0, -1]) difference() {
        union() {
            for (y = [-ring_d / 2, ring_d / 2])
                translate([0, y, 0]) circle(d = ring_d - 2 * 3);
            translate([-(ring_d / 2 - bridge_w / 2 - 1), 0, 0]) rectangle([bridge_w + 2, ring_d, 1]);
        }
        translate([-ring_d / 2 - 1, -open / 2, 0]) rectangle([open + 2, open, 1]);   // opening (-X side)
    }
    for (y = [-t / 2, t / 2])
        translate([15, y, 0]) circle(d = t);
    translate([15, 0, -1]) difference() {
        circle(d = t - 2 * 2);
        translate([-(t / 2 - open_t / 2 - 1), 0, 0]) rectangle([open_t + 2, t, 1]);   // opening (+X side)
    }
    translate([0, 0, -1]) circle(d = min(stand_d, ring_d - 2 * 3 - open));   // keep the stand rod hole clear below the opening
    translate([15, 0, -1]) circle(d = min(tube_d, t - 2 * 2 - open_t));         // keep the tubing hole clear below its opening
}

linear_extrude(height) render();