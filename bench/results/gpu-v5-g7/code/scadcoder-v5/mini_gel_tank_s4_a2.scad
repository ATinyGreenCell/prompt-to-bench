// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: open top facing up (+Z), resting on XY plane at z = 0

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length in X (mm)
tank_y      = 70;    // outer width in Y (mm)
tank_h      = 40;    // outer height in Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length in X, centred (mm)
platform_y  = tank_y - 2 * wall;  // platform spans full inner width (mm)
platform_top = floor + 10;  // platform top height, 10 mm above inner floor (mm)

hole_d      = 2;     // electrode wire hole diameter (mm)
hole_y      = 0;     // hole centre Y position (mm)
hole_z      = 30;    // hole centre Z position (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)
$fn         = 96;    // curve resolution

// ---------------- Derived ----------------
inner_x = tank_x - 2 * wall;   // inner floor length in X
inner_y = tank_y - 2 * wall;   // inner floor width in Y
floor_t = floor;               // floor thickness (same as floor variable)

// ---------------- Model ----------------
difference() {
    // Main tank body: open-top rectangular box with solid floor
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_h]);

    // Cut open top, through full area but stopping at floor thickness
    translate([-tank_x / 2, -tank_y / 2, tank_h - eps])
        cube([tank_x, tank_y, floor_t + eps]);

    // Raised platform in the middle, sitting on the floor
    translate([-platform_x / 2, -platform_y / 2, floor])
        cube([platform_x, platform_y, platform_top - floor]);

    // Horizontal electrode wire holes through each end wall, along X
    for (s = [-1, 1])
        translate([s > 0 ? tank_x / 2 - wall : -tank_x / 2 + wall, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = wall + eps, $fn = 64);
}