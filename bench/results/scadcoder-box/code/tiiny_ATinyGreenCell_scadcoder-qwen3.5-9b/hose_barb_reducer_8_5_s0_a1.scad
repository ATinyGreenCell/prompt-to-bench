// Hose-barb reducer - a straight (axial) reducer that joins two silicone tubing sizes via
// barbed ends, with a through-bore. The two barb ends are stacked on the same axis. NOVEL part.
//

t1   = 8;
t2   = 5;
L    = 41;
bore = 3;
g    = 1.5;                 // wall thickness for the barbs and the collar

$fn = 64;

outer8 = t1 + 2 * g;
outer5 = t2 + 2 * g;

difference() {
    union() {
        for (z = [0, 10])
            barb(t1, outer8, L / 2, z);      // upper 8 mm barbs
        for (z = [0, 10])
            barb(t2, outer5, L / 2, z + 20); // lower 5 mm barbs
        cylinder(h = L - 40, d = 12);        // end collar
    }
    translate([0, 0, -1]) cylinder(h = L + 2, d = bore);   // through-bore
}

// A right-hand barb: a root diameter d up to height h with a linear taper to tip diameter t,
// then a shoulder back to d. NOVEL shape.
module barb(t, d, h, z) {
    sl = min(h, (d - t) / 2);                 // taper length so the tip stays >= t
    difference() {
        cylinder(h = h + 1, d = d);
        translate([0, 0, z]) cylinder(h = sl + 1, d = t);                 // taper cone
        translate([0, 0, z + h - sl]) cylinder(h = sl + 1, d = d);       // shoulder
    }
}