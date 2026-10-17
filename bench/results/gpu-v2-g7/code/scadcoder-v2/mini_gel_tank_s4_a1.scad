// Buffer tank for a mini horizontal gel-electrophoresis box. Open-top rectangular tank with a
// solid raised platform in the middle that divides the bottom into two buffer chambers. Each end
// wall has a horizontal 2 mm hole for an electrode wire. NOVEL general part.
//

L     = 120;
W     = 70;
H     = 40;
wall  = 3;
floor = 3;
plat  = 60;
plat_h = 10;

$fn = 64;

inner_w = W - 2 * wall;
inner_h = H - floor;

difference() {
    cube([L, W, H]);
    translate([wall, wall, floor]) cube([L - 2 * wall, W - 2 * wall, H - floor]);     // hollow, open top
    translate([L / 2 - plat / 2, 0, floor]) cube([plat, W, plat_h]);                 // central platform (full width)
    for (x = [L * 0.25, L * 0.75])
        translate([x, 0, -1]) cylinder(h = H + 2, d = 2);                            // electrode holes
}