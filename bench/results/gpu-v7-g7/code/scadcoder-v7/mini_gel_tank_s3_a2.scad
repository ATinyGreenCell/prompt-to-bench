// Buffer tank for mini horizontal gel-electrophoresis box
// Print orientation: tank rests on XY plane at z = 0, open top at z = 40

// ---------- Parameters ----------
outer_x   = 120;   // outer length (X)
outer_y   = 70;    // outer width (Y)
outer_z   = 40;    // outer height (Z)
wall      = 3;     // wall thickness
floor     = 3;     // floor thickness

inner_h   = outer_z - wall;                    // inner height above floor (37)
platform_t= 10;   // platform thickness above inner floor
platform_top = inner_h - floor + platform_t;   // platform top z = 13 (floor at z=3)

eps       = 0.5;  // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Main tank body (open top)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, outer_z - wall]);

    // Gel-tray platform, centred in X, full inner width in Y
    translate([-outer_x/2, -outer_y/2, floor])
        cube([60, outer_y, platform_t]);

    // Horizontal electrode holes through each end wall, along X, at y = 0, z = 30
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - eps : -outer_x/2 - eps, 0, 30])
            rotate([0, 90, 0])
                cylinder(d = 2, h = outer_x + 2*eps);
}