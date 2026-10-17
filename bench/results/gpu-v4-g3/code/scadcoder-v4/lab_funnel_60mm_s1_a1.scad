// Funnel - a straight spout topped with a conical bowl, printed upright. NOVEL general part.
//

spout_d   = 10;
spout_h   = 20;
cone_d0   = 10;
cone_d1   = 60;
cone_h    = 30;
wall      = 1.6;

$fn = 64;

bore = spout_d - 2 * wall;

union() {
    difference() {
        cylinder(h = spout_h, d = spout_d);
        translate([0, 0, -1]) cylinder(h = spout_h + 2, d = bore);
    }
    difference() {
        translate([0, 0, spout_h]) cylinder(h = cone_h, d1 = cone_d0, d2 = cone_d1);
        translate([0, 0, spout_h - 1]) cylinder(h = cone_h + 2,
            d1 = cone_d0 - 2 * wall, d2 = cone_d1 - 2 * wall);
    }
}