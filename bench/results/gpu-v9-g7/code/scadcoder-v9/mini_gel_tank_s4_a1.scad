// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top facing +Z

// ---------- Parameters ----------
outer_x   = 120;   // outer length in X (mm)
outer_y   = 70;    // outer width in Y (mm)
height    = 40;    // overall height in Z (mm)
wall      = 3;     // wall thickness (mm)
floor     = 3;     // floor thickness (mm)

platform_x = 60;   // platform length in X (mm), centred
platform_top_z = 13; // top of platform above inner floor (mm)

hole_d     = 2;    // electrode hole diameter (mm)
hole_y     = 0;    // hole Y position (mm)
hole_z     = 30;   // hole Z position (mm)

eps        = 0.5;  // cutter overshoot past faces (mm)

$fn = 96;

// ---------- Derived ----------
inner_x = outer_x - 2*wall;   // 114
inner_y = outer_y - 2*wall;   // 64
floor_t = floor;              // 3
plat_h  = platform_top_z - floor_t; // 10

// ---------- Model ----------
difference() {
    union() {
        // Tank body
        translate([-outer_x/2, -outer_y/2, floor])
            cube([outer_x, outer_y, height - floor]);

        // Central raised platform (throughs the floor, ends at z = 13)
        translate([-platform_x/2, -inner_y/2, 0])
            cube([platform_x, inner_y, platform_top_z]);
    }

    // Electrode holes through end walls along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - eps : -outer_x/2 - eps,
                   hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2*eps);
}