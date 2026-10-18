// Mini horizontal gel-electrophoresis box - buffer tank
// Units: mm. Print orientation: base on XY plane, building +Z.

// ---------- Parameters ----------
outer_x      = 120;   // tank outer length (X)
outer_y      = 70;    // tank outer width (Y)
outer_z      = 40;    // tank outer height (Z)
wall         = 3;     // wall thickness
floor        = 3;     // floor thickness
platform_x   = 60;    // platform length in X
platform_y   = outer_y; // platform spans full inner width (Y)
platform_top = 13;    // platform top height (z = floor + 10)
hole_d       = 2;     // electrode hole diameter
hole_y       = 0;     // hole Y position
hole_z       = 30;    // hole Z position
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
inner_x = outer_x - 2 * wall;   // 114
inner_z = outer_z - floor;      // 37 (floor at z = 0..3)

// ---------- Model ----------
difference() {
    // Tank body (open top)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, outer_z - floor]);

    // Raised platform (solid, no hole through it)
    translate([-inner_x/2, -inner_y/2, floor])
        cube([platform_x, platform_y, platform_top - floor + 1]);

    // Electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx > 0 ? inner_x/2 - eps : -inner_x/2 - eps,
                   hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_x + 2*eps);
}