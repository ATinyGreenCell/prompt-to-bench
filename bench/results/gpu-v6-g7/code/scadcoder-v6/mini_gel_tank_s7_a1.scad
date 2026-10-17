// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: tank rests on XY plane at z = 0, builds upward (+Z)

// ---------------- Parameters ----------------
tank_x      = 120;   // tank outer length (X)
tank_y      = 70;    // tank outer width (Y)
tank_z      = 40;    // tank outer height (Z)
wall        = 3;     // wall thickness
floor       = 3;     // floor thickness (bottom slab)

platform_x  = 60;    // platform length in X (centred)
platform_y  = tank_y; // platform spans full inner width (Y)
platform_top_z = 13; // platform top height above tank floor (z = floor + 10)

hole_d      = 2;     // electrode wire hole diameter
hole_y      = 0;     // hole centre Y position
hole_z      = 30;    // hole centre Z position

eps         = 0.5;   // cutter overshoot past faces
$fn         = 96;    // curve resolution

// ---------------- Derived ----------------
inner_x = tank_x - 2 * wall;   // 114
inner_y = tank_y - 2 * wall;   // 64
inner_z = tank_z - wall;       // 37 (floor included)

// ---------------- Model ----------------
difference() {
    // Tank body: outer block with open top (cut through at z = tank_z)
    translate([-tank_x / 2, -tank_y / 2, 0])
        cube([tank_x, tank_y, tank_z]);

    // Gel tray platform (solid, divides bottom into two chambers)
    translate([-platform_x / 2, -platform_y / 2, platform_top_z - floor])
        cube([platform_x, platform_y, floor + 10]);

    // Electrode wire holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx * (inner_x / 2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = inner_x + 2 * eps);
}