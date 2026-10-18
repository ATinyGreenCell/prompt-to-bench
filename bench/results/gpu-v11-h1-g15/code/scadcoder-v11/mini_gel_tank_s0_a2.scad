// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: base on XY plane, open top at z = 40

// ---------- Parameters ----------
outer_x      = 120;  // outer length in X
outer_y      = 70;   // outer width in Y
tank_h       = 40;   // overall height in Z
wall         = 3;    // wall thickness
floor        = 3;    // floor thickness (bottom slab)

platform_x   = 60;   // platform length in X (centred)
platform_y   = 70;   // platform width in Y (full inner width)
platform_top = 13;   // top of platform, 10 mm above inner floor

hole_d       = 2;    // electrode wire hole diameter
hole_y       = 0;    // hole centre in Y
hole_z       = 30;   // hole centre in Z

eps          = 0.5;  // cutter overshoot

$fn = 64;

// ---------- Derived ----------
inner_w = outer_y - 2 * wall;  // inner width (Y)
// platform height from tank floor
ph = platform_top - floor;

// ---------- Model ----------
difference() {
    union() {
        // Tank body
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([outer_x, outer_y, tank_h]);

        // Raised platform
        translate([-platform_x / 2, -platform_y / 2, floor])
            cube([platform_x, platform_y, ph]);
    }

    // Electrode holes through end walls, along X
    for (sx = [-1, 1])
        translate([sx * (outer_x / 2 - eps), hole_y, hole_z])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = tank_h + 2 * eps);
}