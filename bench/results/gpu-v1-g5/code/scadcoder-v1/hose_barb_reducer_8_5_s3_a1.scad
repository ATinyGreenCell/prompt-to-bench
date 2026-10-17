// Hose barb reducer - a straight reduction spool with a through bore that carries two stacked
// barbs for one tubing size into two stacked barbs for a smaller size, with a collar near the
// transition. NOVEL general part (a generic reducer, not any one labware item).
//

t1   = 8;
t2   = 5;
bore = 3;
L    = 41;
g    = 1.5;          // clearance between stacked barbs

$fn = 64;

barb_d1 = t1 + 2 * g;
barb_d2 = t2 + 2 * g;

module barb(h, d_top, d_base) {
    d_base = max(d_base, d_top);                 // keep the base the wider end
    linear_extrude(h) circle(d = d_base);
    translate([0, 0, h - 0.01]) cylinder(h = 0.02, d = d_top);   // tip protrudes just past the face
}

difference() {
    union() {
        for (z = [0, 20])
            translate([0, 0, z]) barb(h = 10, d_top = 9.5, d_base = 7.5);      // upper size
        translate([0, 0, 20]) cylinder(h = 5, d = 12);                         // collar
        for (z = [25, 33])
            translate([0, 0, z]) barb(h = 8, d_top = 5, d_base = 6.5);          // lower size
    }
    translate([0, 0, -1]) cylinder(h = L + 2, d = bore);
}