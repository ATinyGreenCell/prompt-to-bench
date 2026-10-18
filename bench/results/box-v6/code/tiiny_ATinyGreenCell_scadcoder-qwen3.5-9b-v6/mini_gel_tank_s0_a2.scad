// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: tank resting on XY plane, open top facing +Z

// ---------- Parameters ----------
tank_x      = 120;   // outer length in X (mm)
tank_y      = 70;    // outer width in Y (mm)
tank_z      = 40;    // outer height in Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)
platform_x  = 60;    // platform length in X (mm), centred
platform_z  = 10;    // platform height above inner floor (mm) -> top at z = 13
hole_d      = 2;     // electrode hole diameter (mm)
eps         = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Derived ----------
inner_w = tank_y - 2 * wall;   // inner width (Y)
inner_f = tank_z - floor;      // inner floor height (top of floor)

// ---------- Model ----------
difference() {
    // Outer tank block
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_z]);

    // Open top (cut above tank height)
    translate([-tank_x / 2 - eps, -tank_y / 2 - eps, tank_z - eps])
        cube([tank_x + 2 * eps, tank_y + 2 * eps, eps]);

    // Raised platform, full inner width, centred in X
    translate([-platform_x / 2, -inner_w / 2, inner_f])
        cube([platform_x, inner_w, platform_z]);

    // Horizontal electrode holes through each end wall, at y = 0, z = 30
    for (sx = [-1, 1])
        translate([sx > 0 ? tank_x / 2 - eps : -tank_x / 2 - eps, 0, 30])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2 * eps, $fn = 64);
}