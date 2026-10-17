// Hose-barb reducer - joins two silicone-tubing sizes with a through-bore. NOVEL general part.
//

t1   = 8;
t2   = 5;
bore = 3;
h1   = 20;
o1b  = 7.5;
o1t  = 9.5;
c    = 12;
h2   = 8;
o2b  = 6.5;
o2t  = 5;

$fn = 64;

saw(d_b, d_t, h) {
    res = cylinder(h = h, d = d_b);
    translate([0, 0, h * 0.25]) cylinder(h = h * 0.5, d = d_t);
    translate([0, 0, h * 0.75]) cylinder(h = h * 0.25, d = d_b);
    return res;
}

union() {
    for (z = [0, h1])
        translate([0, 0, z])
            for (y = [-1, 1])
                rotate([0, 90, 0]) saw(o1b, o1t, h1);
    translate([0, 0, h1]) cylinder(h = 5, d = c);
    for (z = [h1 + 5, h1 + 5 + h2])
        translate([0, 0, z])
            for (y = [-1, 1])
                rotate([0, 90, 0]) saw(o2b, o2t, h2);
    translate([0, 0, -1]) cylinder(h = h1 + 5 + h2 + 2, d = bore);
}