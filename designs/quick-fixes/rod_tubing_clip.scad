// Snap-on clip that holds tubing next to a 12 mm or 12.7 mm (1/2") lab stand rod
// Category: quick fixes. Two C-shaped rings joined by a bridge, extruded 10 mm.
// Measure first: stand rods are commonly 12 mm or 12.7 mm (1/2"). Set rod_id to the
// measured rod diameter minus ~0.2 mm for grip, and tube_id to the tubing's OUTER
// diameter (e.g. 8 mm ID silicone tubing is ~11 mm OD). The snap openings and the ring
// spacing follow these two numbers.
// Print: PETG (springier than PLA), flat, 0.2 mm layers, 100 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Clip] */
height = 10;
// measured rod diameter - 0.2 mm; opening on the -X side
rod_id = 12.5; // 0.1
rod_wall = 3;
// tubing OUTER diameter; opening on the +X side
tube_id = 6;
tube_wall = 2;

/* [Hidden] */
$fn = 96;
rod_gap = 0.8 * rod_id;                                     // snap openings
tube_gap = 0.75 * tube_id;
tube_x = rod_id / 2 + rod_wall + tube_wall + tube_id / 2 + 0.65;  // tubing ring centre
bridge = [rod_id / 2 + rod_wall - 1.35, tube_x - tube_id / 2 - tube_wall + 2, 6];  // x from, x to, width in Y

// parameter checks: stop with a message instead of building a broken part
assert(rod_wall >= 0.8 && tube_wall >= 0.8, "ring walls must be at least 0.8 mm");

module ring(id, wall) difference() { circle(d = id + 2 * wall); circle(d = id); }

linear_extrude(height)
    difference() {
        union() {
            ring(rod_id, rod_wall);
            translate([tube_x, 0]) ring(tube_id, tube_wall);
            translate([bridge[0], -bridge[2] / 2]) square([bridge[1] - bridge[0], bridge[2]]);
        }
        translate([-20, -rod_gap / 2]) square([20, rod_gap]);      // rod snap opening
        translate([tube_x, -tube_gap / 2]) square([10, tube_gap]); // tubing snap opening
        circle(d = rod_id);
        translate([tube_x, 0]) circle(d = tube_id);
    }
