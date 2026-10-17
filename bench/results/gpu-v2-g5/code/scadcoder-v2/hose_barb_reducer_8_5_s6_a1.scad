// Hose-barb reducer - joins two silicone-tubing sizes with a through-bore. NOVEL general part.
//

tube1   = 8;
tube2   = 5;
bore    = 3;
barbs1  = 2;
barbs2  = 2;
height1 = 20;
barbl1  = 10;
d1      = 7.5;
d2      = 9.5;
collar  = 12;
height2 = 16;
barbl2  = 8;
d3      = 6.5;
d4      = 5;

$fn = 64;

barb_d() {
    base = d1;
    top  = d2;
    h    = barbl1;
    $fn  = 64;
    for (i = [0 : barbs1 - 1])
        rotate([0, 0, i * 360 / barbs1])
            translate([0, 0, h])
                cylinder(h = h, d1 = base, d2 = top);
    for (i = [0 : barbs1 - 1])
        rotate([0, 0, i * 360 / barbs1])
            translate([0, 0, -h])
                cylinder(h = h, d1 = top, d2 = base);
}

barb_d2() {
    base = d3;
    top  = d4;
    h    = barbl2;
    $fn  = 64;
    for (i = [0 : barbs2 - 1])
        rotate([0, 0, i * 360 / barbs2])
            translate([0, 0, h])
                cylinder(h = h, d1 = base, d2 = top);
    for (i = [0 : barbs2 - 1])
        rotate([0, 0, i * 360 / barbs2])
            translate([0, 0, -h])
                cylinder(h = h, d1 = top, d2 = base);
}

difference() {
    union() {
        for (z = [0 : height1 - 1])
            translate([0, 0, z]) barb_d();
        translate([0, 0, height1]) cylinder(h = collar, d = collar);
        for (z = [height1 + height2 - 1 : height1 + height2])
            translate([0, 0, z]) barb_d2();
    }
    translate([0, 0, -1]) cylinder(h = height1 + height2 + 2, d = bore);
}