// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: tank rests on XY plane at z = 0, builds upward (+Z)

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length in X (mm)
tank_y      = 70;    // outer width in Y (mm)
tank_z      = 40;    // outer height in Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length in X (mm), centred
platform_z  = 10;    // platform height above inner floor (mm) -> top at z = 13

hole_d      = 2;     // electrode hole diameter (mm)
hole_y      = 0;     // hole centre Y (mm)
hole_z      = 30;    // hole centre Z (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)
$fn         = 96;    // curve resolution

// ---------------- Derived ----------------
inner_x = tank_x - 2 * wall;   // 114 mm
inner_y = tank_y - 2 * wall;   // 64 mm
inner_z = tank_z - floor;      // 37 mm (floor sits at z = 0..3)

// ---------------- Model ----------------
difference() {
    // Tank body (open top)
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_z - wall]);

    // Raised gel-tray platform, full inner width, centred in X
    translate([-inner_x / 2, -inner_y / 2, floor])
        cube([inner_x, inner_y, floor + platform_z]);

    // Horizontal electrode holes through each end wall along X
    for (sx = [-1, 1])
        translate([sx * (inner_x / 2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_y + 2 * eps);
}