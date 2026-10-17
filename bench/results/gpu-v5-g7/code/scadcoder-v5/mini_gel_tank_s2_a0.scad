// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: open top facing up (+Z), resting on XY plane at z = 0

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length in X (mm)
tank_y      = 70;    // outer width in Y (mm)
tank_h      = 40;    // outer height in Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length in X (mm), centred
platform_y  = tank_y - 2 * wall;  // platform spans full inner width
platform_top = floor + 10;  // platform top height = z = 13 (10 mm above inner floor)

hole_d      = 2;     // electrode hole diameter (mm)
hole_y      = 0;     // electrode hole Y position (mm)
hole_z      = 30;    // electrode hole Z position (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Derived ----------------
inner_x = tank_x - 2 * wall;   // 114 mm
inner_y = tank_y - 2 * wall;   // 64 mm
inner_floor_z = floor;         // z = 3 (bottom of inner space)

// ---------------- Model ----------------
difference() {
    // Outer tank body
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_h]);

    // Open top (no lid)

    // End walls (through which electrode holes are drilled)
    for (sx = [-1, 1])
        translate([sx > 0 ? tank_x / 2 - wall : -tank_x / 2, -wall, floor])
            cube([wall, inner_y, tank_h - floor]);   // x end wall, floor-thick at bottom

    // Raised platform in the middle, centred in X
    translate([-platform_x / 2, -platform_y / 2, platform_top - platform_h])
        cube([platform_x, platform_y, platform_h]);

    // Horizontal electrode holes along X, through each end wall
    for (sx = [-1, 1])
        translate([sx * (tank_x / 2 - wall / 2), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = wall + 2 * eps, center = true);
}