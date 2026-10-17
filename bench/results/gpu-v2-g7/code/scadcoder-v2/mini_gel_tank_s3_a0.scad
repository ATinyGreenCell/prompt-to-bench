// Reservoir - a rectangular open-top tank with a raised floor that creates two
// buffer chambers and a solid gel-tray platform in between. The two chambers
// connect above the platform. This is the part the user measured with calipers.
//

L     = 120;
W     = 70;
H     = 40;
wall  = 3;
floor = 3;
plat  = 60;
plat_h = 10;
anod  = 2;

$fn = 64;

inner_w = W - 2 * wall;
inner_h = H - floor;

difference() {
    cube([L, W, H]);
    translate([wall, wall, floor]) cube([L - 2 * wall, W - 2 * wall, H - floor]);     // hollow, open top
    translate([0, 0, H - wall]) cube([L, W, wall]);                                    // top rim
    translate([wall, wall, 0]) cube([L - 2 * wall, W - 2 * wall, floor]);              // floor
    translate([plat, wall, floor]) cube([plat, W - 2 * wall, plat_h]);                 // gel platform
    for (x = [-L / 2, L / 2])
        translate([x, 0, -1]) rotate([-90, 0, 0]) cylinder(h = H + 2, d = anod);      // electrode holes
}