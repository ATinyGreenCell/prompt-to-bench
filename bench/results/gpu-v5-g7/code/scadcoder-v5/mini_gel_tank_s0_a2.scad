// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: open top facing up, resting on XY plane at z = 0

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length in X (mm)
tank_y      = 70;    // outer width in Y (mm)
tank_h      = 40;    // outer height in Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length in X (mm), centred
platform_y  = tank_y - 2 * wall;  // platform spans full inner width
platform_top = floor + 10;  // platform top height (z = 13)

hole_d      = 2;     // electrode hole diameter (mm)
hole_y      = 0;     // electrode hole Y position (mm)
hole_z      = 30;    // electrode hole Z position (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main tank body
    translate([-tank_x/2, -tank_y/2, floor])
        cube([tank_x, tank_y, tank_h - floor]);

    // Raised platform in the middle (divides bottom into two chambers)
    translate([-platform_x/2, -platform_y/2, floor])
        cube([platform_x, platform_y, platform_top - floor]);

    // Horizontal electrode holes through each end wall, along X
    for (s = [-1, 1])
        translate([s > 0 ? tank_x/2 - eps : -tank_x/2 - eps, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2*eps);
}