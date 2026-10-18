// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: base on XY plane, open top facing +Z

// ---- Tank dimensions ----
outer_x = 120;   // outer length in X
outer_y = 70;    // outer width in Y
height  = 40;    // overall height in Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness (bottom solid)

// ---- Platform dimensions ----
plat_len   = 60;  // platform length in X (centred)
plat_wid   = outer_y - 2*wall; // platform spans full inner width
plat_top_z = 13;  // top of platform (inner floor at z=10, 10 mm below)

// ---- Electrode holes ----
hole_d     = 2;   // hole diameter
hole_y     = 0;   // hole Y position
hole_z     = 30;  // hole Z position
eps        = 0.5; // cutter overshoot past end walls

// ---- Modelling helpers ----
inner_h = height - wall;              // height above floor
overwall = wall + floor;              // floor height above which walls continue

difference() {
    union() {
        // Main tank body: floor + walls up to the platform top
        cube([outer_x, outer_y, plat_top_z + 1]);

        // Side walls above the platform (both chambers, full height)
        for (sx = [-1, 1])
            translate([sx > 0 ? outer_x - wall : wall, 0, plat_top_z + 1])
                cube([wall, outer_y, height - (plat_top_z + 1)]);
    }

    // Platform: solid block dividing the bottom into two chambers
    translate([outer_x/2 - plat_len/2, 0, floor])
        cube([plat_len, plat_wid, plat_top_z - floor + 1]);

    // Electrode holes through each end wall along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x - wall : wall, hole_y, hole_z - eps])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = wall + 2*eps, $fn = 64);
}