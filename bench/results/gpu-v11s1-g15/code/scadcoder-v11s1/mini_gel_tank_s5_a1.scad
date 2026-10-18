// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane, builds up in +Z

$fn = 64;

// ---- Tank dimensions ----
outer_x = 120;   // outer length in X
outer_y = 70;    // outer width in Y
outer_z = 40;    // outer height in Z
wall    = 3;     // wall thickness (X and Y)
floor   = 3;     // floor thickness under the inner floor

// ---- Platform dimensions ----
plat_x     = 60;   // platform length in X (centred)
plat_w     = outer_y; // platform spans full inner width
plat_top_z = 13;   // platform top height (10 mm above inner floor: 3+3+10)

// ---- Electrode holes ----
hole_d = 2;     // hole diameter
hole_y = 0;     // hole Y position
hole_z = 30;    // hole Z position

// ---- Cutting overlap ----
eps = 0.5;      // extension past cut faces

difference() {
    // Tank body (solid through the floor)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, outer_z + floor]);

    // Inner cavity (open top)
    translate([-outer_x/2 + wall, -outer_y/2 + wall, floor])
        cube([outer_x - 2*wall, outer_y - 2*wall, outer_z]);

    // Raised platform
    translate([-plat_x/2, -plat_w/2, floor])
        cube([plat_x, plat_w, plat_top_z - floor]);

    // Electrode holes through end walls along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - eps : -outer_x/2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_x + 2*eps);
}