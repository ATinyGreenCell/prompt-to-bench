// Hose barb reducer - a straight reduction part with a through bore that joins two
// silicone tubing sizes, each size with a stacked pair of barbs. NOVEL general part.
//

t1   = 8;
t2   = 5;
bore = 3;
L    = 41;
g    = 1.5;

$fn = 64;

barb_d1 = 7.5;
barb_h1 = 10;

barb_d2 = 6.5;
barb_h2 = 8;

difference() {
    union() {
        for (z = [0, 10])
            translate([0, 0, z * 10])
                module(d = barb_d1, h = barb_h1) barb(d, h);
        translate([0, 0, 20]) cylinder(h = 5, d = 12);
        for (z = [0, 10])
            translate([0, 0, 25 + z * 8])
                module(d = barb_d2, h = barb_h2) barb(d, h);
    }
    translate([0, 0, -1]) cylinder(h = L + 2, d = bore);
}

module barb(d, h) {
    $fn = 16;
    translate([0, 0, -1])
        union() {
            cylinder(h = h + 2, d = d);
            cylinder(h = 1, d1 = d, d2 = d - 2 * g);   // shoulder
            translate([0, 0, h])
                cylinder(h = 1, d1 = d - 2 * g, d2 = d - 2 * g - 2 * g);   // tip
        }
}