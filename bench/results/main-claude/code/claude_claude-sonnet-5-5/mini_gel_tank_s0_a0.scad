// Buffer tank for mini horizontal gel-electrophoresis box
$fn = 64;

tank_x = 120;        // outer length (X)
tank_y = 70;         // outer width (Y)
tank_z = 40;         // outer height (Z)
wall = 3;            // wall thickness
floor_t = 3;         // floor thickness
plat_len = 60;       // platform length in X (centred)
plat_h = 10;         // platform height above inner floor
hole_d = 2;          // electrode wire hole diameter
hole_y = 0;          // hole Y position
hole_z = 30;         // hole Z position
eps = 0.5;           // cutter overshoot

difference() {
    union() {
        // open-top tank shell
        difference() {
            translate([-tank_x/2, -tank_y/2, 0])
                cube([tank_x, tank_y, tank_z]);
            translate([-tank_x/2 + wall, -tank_y/2 + wall, floor_t])
                cube([tank_x - 2*wall, tank_y - 2*wall, tank_z]);
        }
        // raised platform, full inner width, overlapping floor and walls slightly
        translate([-plat_len/2, -tank_y/2 + wall - 0.01, floor_t - 0.01])
            cube([plat_len, tank_y - 2*wall + 0.02, plat_h + 0.01]);
    }
    // electrode wire holes through both end walls, along X
    for (s = [-1, 1])
        translate([s * (tank_x/2 - wall/2), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = wall + 2*eps, center = true);
}