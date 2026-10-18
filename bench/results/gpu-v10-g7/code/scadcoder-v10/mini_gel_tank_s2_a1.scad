// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane (z = 0), builds upward (+Z)

// ---------------- Parameters ----------------
outer_x      = 120;   // outer length in X (mm)
outer_y      = 70;    // outer width in Y (mm)
outer_z      = 40;    // outer height in Z (mm)
wall         = 3;     // wall thickness (mm)
floor        = 3;     // floor thickness (mm)
platform_x   = 60;    // platform length in X (mm)
platform_y   = 70;    // platform width in Y (mm) (full inner width)
platform_top = 13;    // platform top height above outer bottom (mm)
hole_d       = 2;     // electrode hole diameter (mm)
hole_z       = 30;    // electrode hole height above outer bottom (mm)
eps          = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------------- Derived ----------------
inner_x = outer_x - 2 * wall;   // 114 mm
inner_y = outer_y - 2 * wall;   // 64 mm
inner_z = outer_z - floor;      // 37 mm (floor at z = 0..3)
// Platform sits on the inner floor; its top is at z = 13, so it is 10 mm tall.

// ---------------- Model ----------------
union() {
    // Outer tank shell
    hull() {
        // Two solid blocks: left end wall + floor, right end wall + floor
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([wall, outer_y, outer_z]);
        translate([outer_x / 2 - wall, -outer_y / 2, 0])
            cube([wall, outer_y, outer_z]);
    }

    // Raised platform for the gel tray
    translate([-platform_x / 2, -platform_y / 2, floor])
        cube([platform_x, platform_y, platform_top - floor]);
}

// ---------------- Electrode holes ----------------
// Horizontal 2 mm holes along X, one through each end wall,
// at y = 0, z = 30. The cylinder axis lies along X, so the
// cut passes cleanly through both walls.
translate([0, 0, hole_z])
    rotate([0, 90, 0])
        cylinder(d = hole_d, h = outer_x + 2 * eps, center = true);