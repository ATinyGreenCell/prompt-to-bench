// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank base on XY plane, opening upward (+Z)

// ---------------- Parameters ----------------
outer_x      = 120;   // outer length along X (mm)
outer_y      = 70;    // outer width along Y (mm)
outer_h      = 40;    // outer height along Z (mm)

wall         = 3;     // wall thickness (mm)
floor        = 3;     // floor thickness (mm)

platform_x   = 60;    // platform length along X (mm)
platform_z   = 10;    // platform height above inner floor (mm)

hole_d       = 2;     // electrode wire hole diameter (mm)
hole_y       = 0;     // hole centre Y position (mm)
hole_z       = 30;    // hole centre Z position (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Derived ----------------
inner_x = outer_x - 2 * wall;      // 114 mm
inner_y = outer_y - 2 * wall;      // 64 mm
inner_h = outer_h - floor;         // 37 mm (floor is solid below z = floor)

// ---------------- Model ----------------
difference() {
    // Main tank body (solid block, open top)
    translate([-outer_x / 2, -outer_y / 2, 0])
        cube([outer_x, outer_y, outer_h]);

    // Gel-tray platform, centred in X, spanning full inner width
    translate([-platform_x / 2, -outer_y / 2, floor + platform_z - wall])
        cube([platform_x, outer_y, wall]);   // top at z = floor + platform_z = 13

    // Horizontal electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx * (inner_x / 2 - eps), hole_y, hole_z])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = outer_y + 2 * eps);
}