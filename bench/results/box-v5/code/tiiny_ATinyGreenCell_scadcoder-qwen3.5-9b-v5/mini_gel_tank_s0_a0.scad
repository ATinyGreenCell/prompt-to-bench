// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: open top facing up, resting on XY plane at z = 0

// ---------- Parameters ----------
outer_x   = 120;   // outer length in X
outer_y   = 70;    // outer width in Y
height    = 40;    // overall height in Z
wall      = 3;     // wall thickness
floor     = 3;     // floor thickness
plat_top  = 10;    // platform top height above inner floor
plat_x    = 60;    // platform length in X (centred)
hole_d    = 2;     // electrode hole diameter
eps       = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
inner_h = height - floor;              // inner floor height (z = 3)
plat_z  = inner_h + plat_top;          // platform top height (z = 13)
chamber_h = height - plat_z;           // buffer chamber height above platform (z = 27)

// ---------- Model ----------
difference() {
    // Main tank body
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, height]);

    // Open top
    translate([-outer_x/2 - eps, -outer_y/2 - eps, height])
        cube([outer_x + 2*eps, outer_y + 2*eps, wall]);

    // Raised platform for gel tray
    translate([-plat_x/2, -outer_y/2, inner_h])
        cube([plat_x, outer_y, plat_top]);

    // Electrode holes through end walls, along X at y = 0, z = 30
    for (sx = [-1, 1])
        translate([sx * (outer_x/2 - wall - eps), 0, 30])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_x + 2*eps, center = true);
}