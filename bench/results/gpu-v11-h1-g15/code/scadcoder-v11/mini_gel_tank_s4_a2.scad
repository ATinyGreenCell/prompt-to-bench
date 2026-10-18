// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: base on XY plane, open top facing +Z

// ---------- Parameters ----------
outer_x      = 120;   // outer length in X
outer_y      = 70;    // outer width in Y
outer_z      = 40;    // overall height in Z
wall         = 3;     // wall thickness
floor        = 3;     // floor thickness (bottom slab)

platform_x   = 60;    // platform length in X (centred)
platform_y   = 70;    // platform width in Y (full inner width)
platform_top = 13;    // top of platform above outer base

hole_d       = 2;     // electrode wire hole diameter
hole_y       = 0;     // hole centre Y
hole_z       = 30;    // hole centre Z

eps          = 0.5;   // cutter overshoot

$fn = 64;

// ---------- Derived ----------
inner_h = outer_z - floor;               // 37 mm deep
// platform_top = inner_h - wall; would be 37-3=34, but given as 13 (lowered floor)

// ---------- Model ----------
difference() {
    // Tank body
    cube([outer_x, outer_y, outer_z]);

    // Open top
    translate([0, 0, outer_z - eps])
        cube([outer_x, outer_y, eps]);

    // Raised platform
    translate([-platform_x/2, 0, floor])
        cube([platform_x, platform_y, platform_top - floor]);

    // Electrode holes through end walls, along X
    for (sx = [-1, 1])
        translate([sx * (outer_x/2 - eps), hole_y, hole_z])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = outer_x + 2*eps);
}