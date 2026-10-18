// Mini horizontal gel-electrophoresis box: open-top buffer tank with a central raised
// gel-tray platform and two horizontal end-wall holes for electrode wires.
// Print orientation: tank base on the XY plane, building up in +Z.

$fn = 64;

// ---------------- Dimensions (mm) ----------------
tank_x      = 120;   // outer length in X
tank_y      = 70;    // outer width in Y
tank_h      = 40;    // outer height in Z
wall        = 3;     // wall thickness (sides and floor)
floor       = 3;     // floor thickness under the inner floor
platform_x  = 60;    // platform length in X (centred)
platform_w  = tank_y; // platform spans the full inner width
platform_top = 13;   // height of the platform top (z = 13)
hole_d      = 2;     // electrode hole diameter
hole_z      = 30;    // electrode hole height
eps         = 0.5;   // cutter overshoot past faces

// ---------------- Derived ----------------
inner_h = tank_h - wall - floor;              // 34 mm inner height
platform_t = platform_top - floor;            // 10 mm above inner floor

// ---------------- Model ----------------
difference() {
    union() {
        // Tank body (outer solid)
        cube([tank_x, tank_y, tank_h]);

        // Central platform for the gel tray
        translate([-platform_x/2, 0, floor])
            cube([platform_x, platform_w, platform_t]);
    }

    // Two horizontal electrode holes through the end walls, along X, at y = 0
    for (sx = [-1, 1])
        translate([sx > 0 ? tank_x - eps : -eps, 0, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2*eps);
}