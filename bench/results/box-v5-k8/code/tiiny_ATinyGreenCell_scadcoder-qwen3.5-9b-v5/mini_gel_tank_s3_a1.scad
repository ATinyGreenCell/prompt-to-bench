// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: open top facing up, resting on XY plane at z = 0

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length in X
tank_y      = 70;    // outer width in Y
tank_h      = 40;    // outer height in Z

wall        = 3;     // wall thickness
floor       = 3;     // floor thickness under tank

platform_x  = 60;    // platform length in X (centred)
platform_y  = tank_y; // platform spans full inner width
platform_top = 10;   // platform top height above tank floor (z = 13)

hole_d      = 2;     // electrode hole diameter
hole_y      = 0;     // electrode hole Y position
hole_z      = 30;    // electrode hole Z position

eps         = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Derived ----------------
inner_x = tank_x - 2 * wall;   // 114 mm
inner_y = tank_y - 2 * wall;   // 64 mm
inner_z = tank_h - floor;      // 37 mm (floor under tank, open top)

platform_t = platform_top - floor;  // platform height above floor (10 mm)

// ---------------- Model ----------------
difference() {
    // Main tank body (solid, open top)
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_h]);

    // Raised platform for gel tray, centred in X
    translate([-platform_x / 2, -platform_y / 2, floor])
        cube([platform_x, platform_y, platform_t]);

    // Horizontal electrode holes through each end wall, along X
    for (s = [-1, 1])
        translate([s > 0 ? tank_x / 2 - eps : -tank_x / 2 + eps, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2 * eps);
}