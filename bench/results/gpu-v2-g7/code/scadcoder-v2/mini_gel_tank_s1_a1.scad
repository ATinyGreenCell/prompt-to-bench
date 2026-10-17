// Buffer tank for a mini horizontal gel-electrophoresis box. Open-top rectangular tank with a
// solid raised platform in the middle that divides the bottom into two buffer chambers. Each
// chamber has a horizontal electrode hole through an end wall. NOVEL general part.
//

L     = 120;
W     = 70;
H     = 40;
wall  = 3;
floor = 3;
plat_X = 60;
plat_Z = 10;
hole  = 2;

$fn = 64;

inner_H = H - wall;
inner_W = W - 2 * wall;
inner_L = L - 2 * wall;

difference() {
    cube([L, W, H]);
    translate([wall, wall, wall]) cube([inner_L, inner_W, inner_H - floor]);     // remove inner volume, leaving floor
    translate([plat_X, 0, floor]) cube([plat_X, W, plat_Z]);                      // remove the lower part of the central platform so it rests on the floor
    for (x = [-L / 2, L / 2])
        translate([x, 0, -1]) rotate([-90, 0, 0]) cylinder(h = H + 2, d = hole);  // electrode holes through the end walls
}