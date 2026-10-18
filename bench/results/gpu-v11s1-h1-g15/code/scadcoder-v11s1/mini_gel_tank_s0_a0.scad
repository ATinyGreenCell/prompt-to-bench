// Mini horizontal gel-electrophoresis box: open-top rectangular tank with a central
// raised gel-tray platform that divides the bottom into two buffer chambers.
// Print orientation: tank rests on the XY plane (z = 0) and builds upward (+Z).

// ---------------- Parameters ----------------
outer_x      = 120;   // outer tank length along X (mm)
outer_y      = 70;    // outer tank width along Y (mm)
outer_h      = 40;    // outer tank height along Z (mm)

wall         = 3;     // tank wall thickness (mm)
floor        = 3;     // tank floor thickness (mm)

platform_x   = 60;    // platform length along X (mm), centred
platform_top = 10;    // platform top height above inner floor (mm) -> z = 13

hole_d       = 2;     // electrode hole diameter (mm)
hole_y       = 0;     // electrode hole Y position (mm)
hole_z       = 30;    // electrode hole Z position (mm)

eps          = 0.5;   // overshoot for clean boolean cuts (mm)

$fn = 64;

// ---------------- Derived ----------------
inner_x = outer_x - 2 * wall;    // 114 mm
inner_y = outer_y - 2 * wall;    // 64 mm
inner_h = outer_h - floor;       // 37 mm (height above floor)

plat_h = floor + platform_top;   // 13 mm absolute height of platform top

// ---------------- Model ----------------
difference() {
    union() {
        // Tank body (outer block)
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([outer_x, outer_y, outer_h]);

        // Central raised platform for the gel tray
        // Spans the full inner width (Y), centred in X
        translate([-platform_x / 2, -inner_y / 2, floor])
            cube([platform_x, inner_y, plat_h - floor]);
    }

    // Electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx * (outer_x / 2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = wall + eps);
}