// Buffer tank for mini horizontal gel-electrophoresis box
// Print orientation: open top facing +Z, resting on XY plane at z = 0

// ---------------- Parameters ----------------
outer_x   = 120;   // outer length (X)
outer_y   = 70;    // outer width (Y)
outer_z   = 40;    // outer height (Z)
wall      = 3;     // wall thickness
floor     = 3;     // floor thickness

inner_x   = outer_x - 2*wall;   // 114
inner_y   = outer_y - 2*wall;   // 64
inner_z   = outer_z - floor;    // 37  (inner floor at z = floor)

platform_x = 60;    // platform length in X (centred)
platform_top_z = 13; // top of platform, above inner floor (floor + 10)
platform_h  = platform_top_z - floor; // 10 mm above inner floor

hole_d     = 2;     // electrode hole diameter
hole_y     = 0;     // hole Y position
hole_z     = 30;    // hole Z position (above floor)

eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
difference() {
    // Tank body (open top)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, outer_z]);

    // Cut out the two end chambers below the platform (through the full Y)
    for (sx = [-1, 1])
        translate([sx < 0 ? -outer_x/2 - eps : outer_x/2, -outer_y/2, floor])
            cube([eps, outer_y, outer_z - floor]);

    // Raised platform for gel tray
    translate([-platform_x/2, -inner_y/2, floor])
        cube([platform_x, inner_y, platform_h]);

    // Horizontal electrode holes through each end wall along X
    for (x = [-outer_x/2 - hole_d/2 - eps, outer_x/2 + hole_d/2 + eps])
        translate([x, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2*eps);
}