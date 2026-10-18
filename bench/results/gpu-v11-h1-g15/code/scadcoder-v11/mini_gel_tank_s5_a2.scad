// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: base on XY plane, open top facing +Z

// ---- Tank dimensions ----
outer_x = 120;   // outer length along X
outer_y = 70;    // outer width along Y (inner width)
tank_h  = 40;    // overall height along Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform ----
plat_len   = 60; // platform length along X
plat_top_z = 13; // top of platform (10 mm above inner floor)

// ---- Holes ----
hole_d     = 2;  // electrode wire hole diameter
hole_y     = 0;  // hole Y position
hole_z     = 30; // hole Z position

// ---- Modelling ----
eps = 0.5;       // cutter overshoot
$fn = 96;

inner_x = outer_x - 2*wall;

difference() {
    // Tank body
    translate([-outer_x/2, -outer_y/2, 0])
        cube([inner_x, outer_y, tank_h]);

    // Raised platform
    translate([-plat_len/2, -outer_y/2, floor])
        cube([plat_len, outer_y, plat_top_z - floor]);

    // Electrode holes
    for (sx = [-1, 1])
        translate([sx * (inner_x/2 - eps), hole_y, hole_z])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = outer_y + 2*eps);
}