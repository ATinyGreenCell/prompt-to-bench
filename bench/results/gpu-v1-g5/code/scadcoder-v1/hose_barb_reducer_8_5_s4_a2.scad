// Hose barb reducer - a straight (axial) reducer that joins two silicone tubing sizes via
// stacked barbs, with a through-bore. The two barb sections are held in a cylindrical collar.
// NOVEL general part (a generic reducer, not any one labware item).
//

t1   = 8;
t2   = 5;
bore = 3;
L    = 41;
coll = 12;

$fn = 64;

barb_d1 = 7.5 + (t1 - 2 * bore) * 0.5;      // outer diameter of the 8 mm barbs at the narrow end
barb_d2 = 9.5;                               // outer diameter of the 8 mm barbs at the wide end
barb_h1 = 10;
barb_h2 = 8;
s      = 1.5;                                // step (flange) below each wide end

difference() {
    union() {
        for (z = [0, 20]) {                     // two barbs in the lower section
            translate([0, 0, z])
                cylinder(h = barb_h1, d = barb_d1);
            translate([0, 0, z + 20 - barb_h1])
                cylinder(h = barb_h1, d = barb_d2);
            translate([0, 0, z + 20 - barb_h1])
                cylinder(h = s, d = barb_d2 + 2 * s);          // flange below the wide end
        }
        for (z = [25, 33]) {                    // two barbs in the upper section
            translate([0, 0, z])
                cylinder(h = barb_h2, d = barb_d2);
            translate([0, 0, z + 20 - barb_h2])
                cylinder(h = barb_h2, d = barb_d1);
            translate([0, 0, z + 20 - barb_h2])
                cylinder(h = s, d = barb_d1 + 2 * s);          // flange below the wide end
        }
        cylinder(h = L, d = coll);              // collar that spans the full length
    }
    translate([0, 0, -1]) cylinder(h = L + 2, d = bore);   // through-bore
}