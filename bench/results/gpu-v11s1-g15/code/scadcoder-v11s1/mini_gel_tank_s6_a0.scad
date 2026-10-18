// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank resting on XY plane, building up +Z

$fn = 64;

// ---- Tank dimensions ----
outer_x = 120;   // outer length in X
outer_y = 70;    // outer width in Y
outer_z = 40;    // outer height in Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform dimensions ----
plat_x = 60;     // platform length in X (centred)
plat_y = outer_y; // platform spans full inner width
plat_top_z = 13; // top of platform above outer zero

// ---- Electrode holes ----
hole_d = 2;      // hole diameter
hole_y = 0;      // hole Y position
hole_z = 30;     // hole Z position

// ---- Derived ----
inner_x = outer_x - 2*wall;
inner_z = outer_z - wall; // inner floor is at z = floor

eps = 0.5;       // cutter overshoot

difference() {
    union() {
        // Tank body
        cube([outer_x, outer_y, outer_z]);
        // Raised platform (overlaps walls to fuse)
        translate([-plat_x/2, -wall, plat_top_z])
            cube([plat_x, plat_y, outer_z - plat_top_z + 0.01]);
    }
    // Electrode holes through end walls along X
    for (sx = [-1, 1])
        translate([sx * (outer_x/2 - 1), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_x + 2*eps, center = true);
}