// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank base on XY plane, opening upward (+Z)

// ---------------- Parameters ----------------
outer_x      = 120;   // outer tank length (X)
outer_y      = 70;    // outer tank width (Y)
tank_h       = 40;    // overall tank height (Z)
wall         = 3;     // wall thickness
floor        = 3;     // floor thickness (solid bottom)

platform_len = 60;    // gel tray platform length (X)
platform_r   = 35;    // gel tray platform width (Y) - full inner width
plat_top_z   = 13;    // platform top height (3 mm floor + 10 mm rise)

hole_d       = 2;     // electrode wire hole diameter
hole_y       = 0;     // hole centre Y position
hole_z       = 30;    // hole centre Z position

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Derived ----------------
inner_x = outer_x - 2 * wall;     // 114
inner_y = outer_y - 2 * wall;     // 64
floor_t = floor;                  // solid floor thickness

// ---------------- Model ----------------
difference() {
    // Main tank body (outer dimensions)
    translate([-outer_x / 2, -outer_y / 2, 0])
        cube([outer_x, outer_y, tank_h]);

    // Open top (hollow out above floor level)
    translate([-inner_x / 2, -inner_y / 2, floor_t])
        cube([inner_x, inner_y, tank_h - floor_t + eps]);

    // Gel tray platform - spans full inner width, centred in X
    translate([-platform_len / 2, -platform_r / 2, floor_t])
        cube([platform_len, platform_r, plat_top_z - floor_t + 0.01]);

    // Electrode wire holes through each end wall along X
    for (sx = [-1, 1])
        translate([sx * (inner_x / 2 - hole_d / 2), hole_y, hole_z])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = outer_y + 2 * eps, center = true);
}