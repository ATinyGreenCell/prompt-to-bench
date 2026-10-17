// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane at z = 0, builds upward (+Z)

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length in X (mm)
tank_y      = 70;    // outer width in Y (mm)
tank_h      = 40;    // outer height in Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length in X (mm), centred
platform_z  = 13;    // platform top height above inner floor (mm)
platform_y  = tank_y - 2 * wall;  // platform spans full inner width (mm)

hole_d      = 2;     // electrode hole diameter (mm)
hole_y      = 0;     // electrode hole Y position (mm)
hole_z      = 30;    // electrode hole Z position (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)
$fn         = 96;    // curve resolution

// ---------------- Derived ----------------
inner_f = tank_h - floor;              // inner floor height (z = 3)
chamber_h = inner_f - platform_z;      // buffer chamber height above platform (z = 10)

// ---------------- Model ----------------
difference() {
    // Main tank body (open top)
    translate([-tank_x/2, -tank_y/2, 0])
        cube([tank_x, tank_y, tank_h]);

    // Raised central platform for gel tray
    translate([-platform_x/2, -platform_y/2, platform_z - chamber_h])
        cube([platform_x, platform_y, chamber_h + eps]);

    // Horizontal electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx > 0 ? tank_x/2 - hole_d/2 : -tank_x/2 + hole_d/2,
                   hole_y,
                   hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_y + 2*eps, center = true);
}