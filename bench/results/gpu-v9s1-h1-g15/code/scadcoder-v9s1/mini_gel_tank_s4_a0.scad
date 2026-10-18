// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top at z = 40

// ---------- Parameters ----------
outer_x   = 120;   // tank outer length (X)
outer_y   = 70;    // tank outer width (Y)
height    = 40;    // tank overall height (Z)
wall      = 3;     // wall thickness
floor     = 3;     // floor thickness under chambers

platform_len = 60;   // platform length in X
platform_top_z = 13; // top of platform (above inner floor)

hole_d     = 2;    // electrode hole diameter
hole_y     = 0;    // hole Y position
hole_z     = 30;   // hole Z position

eps        = 0.5;  // cutter overshoot
$fn        = 64;

// ---------- Derived ----------
inner_h = height - wall;              // 37 mm chamber height
overl   = min(wall, floor);           // walls merge into floor

// ---------- Model ----------
difference() {
    union() {
        // Base slab (floor + end walls, includes overlap)
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, overl]);

        // Raised platform
        translate([-platform_len/2, -outer_y/2, floor])
            cube([platform_len, outer_y, platform_top_z - floor]);
    }

    // Buffer chambers (open at top, above platform)
    translate([-outer_x/2, -outer_y/2, platform_top_z])
        cube([outer_x, outer_y, height - platform_top_z]);

    // Electrode holes through end walls
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - eps : -outer_x/2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2*eps);
}