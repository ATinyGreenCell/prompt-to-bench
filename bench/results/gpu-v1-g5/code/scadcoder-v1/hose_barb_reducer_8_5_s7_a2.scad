// Hose barb reducer - a straight (axial) reducer that joins two silicone tube sizes via
// stacked barbs, with a through-bore. The two barb sections are held in a cylindrical
// collar. NOVEL general part (a generic reducer, not any one labware item).
//

t1   = 8;
t2   = 5;
bore = 3;
L    = 41;
coll = 12;

$fn = 64;

barb_d1 = 7.5 + (t1 * 0.1);     // top of the larger barbs
barb_d2 = 7.5;
g1      = min(bore, t2 * 0.7);   // clearance bore through the larger section
barb_h1 = 10;

barb_d3 = 6.5 - (t2 * 0.1);     // top of the smaller barbs
barb_d4 = 5.0;
g2      = min(bore, t1 * 0.7);   // clearance bore through the smaller section
barb_h2 = 8;

difference() {
    union() {
        for (z = [0, barb_h1])
            translate([0, 0, z])
                cylinder(h = barb_h1, d = barb_d1);              // upper barb
        for (z = [barb_h1, barb_h1 + barb_h2])
            translate([0, 0, z])
                cylinder(h = barb_h2, d = barb_d3);              // lower barb
        translate([0, 0, L - coll]) cylinder(h = coll + 1, d = coll);                 // collar
    }
    translate([0, 0, -1]) cylinder(h = L + 2, d = bore);                 // through-bore
}