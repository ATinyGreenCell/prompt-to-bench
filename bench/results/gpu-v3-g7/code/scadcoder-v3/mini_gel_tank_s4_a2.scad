// Buffer tank for mini horizontal gel-electrophoresis box
// Units: mm. Tank rests on XY plane at z = 0, builds upward (+Z).

$fn = 64;

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

// ---- Derived ----
inner_x = tank_x - 2 * wall;     // 114
inner_y = tank_y - 2 * wall;     // 64
inner_fz = floor_t;              // floor top (z = 3)
plat_bz  = inner_fz + wall;      // platform bottom (z = 6)

difference() {
    // Main tank body
    translate([-tank_x/2, -tank_y/2, 0])
        cube([tank_x, tank_y, tank_h]);

    // Two side buffer chambers (remove everything above the platform)
    translate([-inner_x/2 - eps, -inner_y/2, plat_bz])
        cube([inner_x/2, inner_y, tank_h - plat_bz]);
    translate([ inner_x/2 + eps, -inner_y/2, plat_bz])
        cube([inner_x/2, inner_y, tank_h - plat_bz]);

    // Horizontal cut through the platform so the chambers connect above it
    translate([-inner_x/2 - eps, -inner_y/2, plat_top_z])
        cube([inner_x, inner_y, tank_h - plat_top_z]);

    // Electrode holes through each end wall (along X)
    for (side = [-1, 1])
        translate([side * (tank_x/2 - hole_d/2), hole_y, inner_fz])
            rotate([-90, 0, 0])
                cylinder(d = hole_d, h = hole_w_z);
}