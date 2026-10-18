// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: base on XY plane, open top facing +Z

// ---- Tank dimensions ----
outer_x = 120;   // outer length in X
outer_y = 70;    // outer width in Y (inner width)
height  = 40;    // overall height in Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform ----
plat_len   = 60; // platform length in X
plat_top_z = 13; // top of platform (10 mm above inner floor)

// ---- Holes ----
hole_d     = 2;  // electrode wire hole diameter
hole_y     = 0;  // hole Y position
hole_z     = 30; // hole Z position

// ---- Misc ----
eps        = 0.5; // cutter overshoot
$fn        = 64;

difference() {
    // Tank body
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, height]);

    // Open top
    translate([-outer_x/2 - eps, -outer_y/2 - eps, height - eps])
        cube([outer_x + 2*eps, outer_y + 2*eps, eps]);

    // Platform
    translate([-plat_len/2, -outer_y/2, floor])
        cube([plat_len, outer_y, plat_top_z - floor + 0.01]);

    // Holes
    for (sx = [-1, 1])
        translate([sx * (outer_x/2 - 1), hole_y, hole_z])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = outer_x + 2, center = true);
}