// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank resting on its floor, open top facing up (+Z)

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length along X (mm)
tank_y      = 70;    // outer width along Y (mm)
tank_z      = 40;    // outer height along Z (mm)

wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length along X (mm), centred
platform_z  = 10;    // platform height above inner floor (mm) -> top at z = 13

hole_d      = 2;     // electrode hole diameter (mm)
hole_y      = 0;     // electrode hole Y position (mm)
hole_z      = 30;    // electrode hole Z position (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)
$fn         = 64;    // curve resolution

// ---------------- Derived ----------------
inner_x = tank_x - 2 * wall;   // 114
inner_y = tank_y - 2 * wall;   // 64
inner_z = tank_z - floor;      // 37   // floor at z = 0, inner floor at z = 3

platform_top_z = inner_z + platform_z;  // 47 (absolute Z of platform top)

// ---------------- Model ----------------
difference() {
    // Main tank body (open top)
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_z]);

    // Central raised platform for gel tray
    // Spans full inner width (Y), centred in X, top at z = 13 (relative to inner floor)
    translate([-platform_x / 2, -inner_y / 2, inner_z])
        cube([platform_x, inner_y, platform_z]);

    // Horizontal electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx > 0 ? inner_x / 2 - eps : -inner_x / 2 - eps, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2 * eps);
}