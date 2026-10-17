// Buffer tank for mini horizontal gel electrophoresis
// Units: mm. Tank rests on XY plane (z = 0), builds upward.

$fn = 96;

// ---- Tank ----
tank_x      = 120;   // outer length (X)
tank_y      = 70;    // outer width (Y)
tank_h      = 40;    // outer height (Z)
wall        = 3;     // wall thickness
floor_t     = 3;     // floor thickness

// ---- Platform ----
plat_x      = 60;    // platform length in X (centred)
plat_top_z  = 13;    // platform top height above inner floor (z = 13)

// ---- Electrode holes ----
hole_d      = 2;     // electrode hole diameter
hole_y      = 0;     // electrode hole Y position
hole_z      = 30;    // electrode hole Z position

// ---- Misc ----
eps         = 0.5;   // cutter overshoot past faces

// Inner dimensions
inner_x = tank_x - 2 * wall;
inner_y = tank_y - 2 * wall;
inner_h = tank_h - floor_t;

// Platform legs extend into the buffer chambers
leg_x = (inner_x - plat_x) / 2 + wall;

difference() {
    union() {
        // Tank body
        cube([tank_x, tank_y, floor_t]);
        cube([inner_x, inner_y, inner_h]);
        // Raised platform
        translate([-plat_x / 2, -wall, floor_t])
            cube([plat_x, tank_y, plat_top_z]);
    }

    // Door-like bridge across each end, above the platform,
    // leaving the two buffer chambers connected
    translate([-inner_x / 2 - 0.01, -eps, plat_top_z])
        cube([inner_x / 2, inner_y + 2 * eps, tank_h - floor_t]);
    translate([plat_x / 2 + 0.01, -eps, plat_top_z])
        cube([inner_x / 2, inner_y + 2 * eps, tank_h - floor_t]);

    // Horizontal electrode holes through each end wall
    translate([-tank_x / 2, hole_y, hole_z])
        rotate([-90, 0, 0]) cylinder(d = hole_d, h = tank_y + 2 * eps);
    translate([tank_x / 2, hole_y, hole_z])
        rotate([-90, 0, 0]) cylinder(d = hole_d, h = tank_y + 2 * eps);
}