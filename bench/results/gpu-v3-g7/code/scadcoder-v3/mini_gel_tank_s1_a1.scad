// Buffer tank for mini horizontal gel-electrophoresis box
// Units: mm. Tank rests on XY plane at z = 0, builds upward (+Z).

$fn = 96;

// ---- Tank ----
tank_x      = 120;   // outer length (X)
tank_y      = 70;    // outer width (Y)
tank_h      = 40;    // outer height (Z)
wall        = 3;     // wall thickness
floor_t     = 3;     // floor thickness

// ---- Gel-tray platform ----
plat_x      = 60;    // platform length in X (centred)
plat_top_z  = 13;    // platform top height above inner floor (z = 13)

// ---- Electrode holes ----
hole_d      = 2;     // electrode hole diameter
hole_y      = 0;     // electrode hole Y position
hole_w_z    = tank_h - floor_t; // hole length along Z (through end wall)

// ---- Misc ----
eps         = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    // Outer tank shell
    cube([tank_x, tank_y, tank_h]);

    // Inner cavity, from top of floor to tank top (open top)
    translate([wall, wall, floor_t])
        cube([tank_x - 2 * wall, tank_y - 2 * wall, tank_h - floor_t + eps]);

    // Raised platform in middle of tank
    translate([-plat_x / 2, -tank_y / 2, floor_t])
        cube([plat_x, tank_y, plat_top_z - floor_t + eps]);

    // Horizontal electrode holes through each end wall (along X)
    for (side = [-1, 1])
        translate([side * (tank_x / 2 - hole_d / 2), hole_y, floor_t])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = hole_w_z + 2 * eps);
}