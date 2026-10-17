// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: tank rests on XY plane at z = 0, builds upward (+Z)

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length in X (mm)
tank_y      = 70;    // outer width in Y (mm)
tank_z      = 40;    // outer height in Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length in X (mm), centred
platform_y  = tank_y - 2 * wall;  // platform spans full inner width (mm)
platform_z  = floor + 10;          // platform top height (mm) = 13

hole_d      = 2;     // electrode hole diameter (mm)
hole_y      = 0;     // hole Y position (mm)
hole_z      = 30;    // hole Z position (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)
$fn         = 96;    // curve resolution

// ---------------- Derived ----------------
inner_x = tank_x - 2 * wall;   // 114 mm
inner_y = tank_y - 2 * wall;   // 64 mm
inner_z = tank_z - wall;       // 37 mm (open top)

// ---------------- Model ----------------
difference() {
    // Tank body: hollow rectangular box, open top
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_z]);

    // Gel-tray platform: solid block, centred in X, full inner width
    translate([-platform_x / 2, wall + 1, floor])
        cube([platform_x, platform_y, platform_z - floor]);

    // Electrode holes: horizontal through each end wall along X
    for (sx = [-1, 1])
        translate([sx * (inner_x / 2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2 * eps);
}