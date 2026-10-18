// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane, open top facing +Z

$fn = 64;

// ---- Tank ----
tank_x = 120;      // outer length (X)
tank_y = 70;       // outer width (Y)
tank_z = 40;       // outer height (Z)
wall   = 3;        // wall thickness
floor  = 3;        // floor thickness

// ---- Platform ----
plat_x = 60;       // platform length in X
plat_y = tank_y - 2*wall;  // platform spans full inner width
plat_top = 13;     // platform top height above tank bottom (z)

// ---- Electrode holes ----
hole_d = 2;        // horizontal hole diameter
hole_y = 0;        // hole Y position
hole_z = 30;       // hole Z position

// ---- Misc ----
eps = 0.5;         // cutter overshoot past faces

difference() {
    // Tank body
    translate([-tank_x/2, -tank_y/2, 0])
        cube([tank_x, tank_y, tank_z]);

    // Open top
    translate([-tank_x/2, -tank_y/2, tank_z - eps])
        cube([tank_x, tank_y, eps]);

    // Raised platform (solid, divides bottom into two chambers)
    translate([-tank_x/2 + (tank_x - plat_x)/2, -plat_y/2, floor])
        cube([plat_x, plat_y, plat_top - floor]);

    // Horizontal electrode holes through each end wall (along X)
    for (sx = [-1, 1])
        translate([sx > 0 ? tank_x/2 - eps : -tank_x/2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_y + 2*eps);
}