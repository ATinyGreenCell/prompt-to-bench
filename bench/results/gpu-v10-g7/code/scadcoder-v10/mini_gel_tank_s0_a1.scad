// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane (z = 0), builds upward (+Z)

// ---------------- Parameters ----------------
outer_x      = 120;   // outer length in X (mm)
outer_y      = 70;    // outer width in Y (mm)
outer_z      = 40;    // outer height in Z (mm)

wall         = 3;     // wall thickness (mm)
floor        = 3;     // floor thickness (mm)

platform_x   = 60;    // platform length along X (mm)
platform_y   = outer_y; // platform spans full inner width (mm)
platform_top = 13;    // platform top height above outer bottom (mm)

hole_d       = 2;     // electrode hole diameter (mm)
hole_y       = 0;     // electrode hole Y position (mm)
hole_z       = 30;    // electrode hole Z position (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// Derived
inner_x = outer_x - 2 * wall;   // 114 mm
inner_z = outer_z - floor;      // 37 mm (floor at z = 0..3)
plat_h  = platform_top - floor; // 10 mm (platform sits on inner floor)

// ---------------- Model ----------------
union() {
    // Tank body (floor + side walls, open top)
    translate([-outer_x / 2, -outer_y / 2, 0])
        cube([outer_x, outer_y, outer_z - wall]);

    // Raised platform for gel tray (centred in X, spans full width)
    translate([-inner_x / 2, -platform_y / 2, floor])
        cube([platform_x, platform_y, plat_h]);

    // Electrode holes through each end wall along X
    for (sx = [-1, 1])
        translate([sx > 0 ? inner_x / 2 - eps : -inner_x / 2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_x + 2 * eps);
}