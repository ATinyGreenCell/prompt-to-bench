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

barb_d1 = 7.5 + 2 * (t1 / 2);      // outer diameter of the 8 mm tube at the narrow end
barb_d2 = 7.5 + 2 * (t2 / 2);      // outer diameter of the 5 mm tube at the narrow end

module barb(h, d, t)                 // a barb: cone (spike) standing on a shoulder
    difference() {
        union() {
            cylinder(h = h, d = d);                 // spike
            cylinder(h = 1, d = d + 2 * t);         // shoulder below the spike
        }
        translate([0, 0, -1]) cylinder(h = h + 2, d = bore);   // bore through the whole part
    }

section1 = 20;
section2 = L - section1 - 1;         // clear the collar between the two sections

difference() {
    union() {
        for (z = [0, section1])
            translate([0, 0, z]) rotate([0, 0, 90])
                barb(h = 10, d = barb_d1, t = (9.5 - 7.5) / 2);      // upper barb (8 mm tube)
        for (z = [section1 + 1, L - 1])
            translate([0, 0, z]) rotate([0, 0, 90])
                barb(h = 8, d = barb_d2, t = (6.5 - 5.0) / 2);       // lower barb (5 mm tube)
        cylinder(h = L, d = coll);                                     // outer collar
    }
    translate([0, 0, -1]) cylinder(h = L + 2, d = bore);   // through-bore
}