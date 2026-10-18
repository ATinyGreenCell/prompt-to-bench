// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top, builds +Z

// ---- Tank ----
tank_x = 120;      // outer length (X)
tank_y = 70;       // outer width (Y)
tank_z = 40;       // outer height (Z)
wall   = 3;        // wall thickness
floor  = 3;        // floor thickness

// ---- Platform ----
plat_len   = 60;   // platform length in X
plat_top_z = 13;   // platform top height (z = floor + 10)

// ---- Holes ----
hole_d = 2;        // electrode hole diameter
hole_y = 0;        // hole Y position
hole_z = 30;       // hole Z position

// ---- Misc ----
eps = 0.5;         // cutter overshoot
$fn = 64;

inner_h = tank_z - floor;  // height above floor (open top)

difference() {
    // Tank body
    translate([-tank_x/2, -tank_y/2, 0])
        cube([tank_x, tank_y, tank_z]);

    // Raised platform (through floor, solid to walls)
    translate([-tank_x/2 + (tank_x - plat_len)/2, -tank_y/2, 0])
        cube([plat_len, tank_y, plat_top_z]);

    // Electrode holes through end walls along X
    for (sx = [-1, 1])
        translate([sx > 0 ? tank_x/2 - 1 : -tank_x/2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_y + 2*eps, center = true);
}