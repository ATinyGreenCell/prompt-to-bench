// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane at z = 0, open top

// ---------- Parameters ----------
tank_x      = 120;   // outer length in X
tank_y      = 70;    // outer width in Y
tank_h      = 40;    // outer height in Z
wall        = 3;     // wall thickness (sides and floor)
floor       = 3;     // floor thickness (under raised platform)
platform_t  = 10;    // platform top height above inner floor (z = 13)
platform_x  = 60;    // platform length in X (centred)
hole_d      = 2;     // electrode hole diameter
hole_y      = 0;     // electrode hole Y position
hole_z      = 30;    // electrode hole Z position
eps         = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
inner_f = tank_h - floor - platform_t;   // chamber height above platform
chamber_v = [tank_x - platform_x, tank_y, inner_f];  // each chamber (X/Y/Z)

// ---------- Model ----------
difference() {
    union() {
        // Floor
        translate([-tank_x/2, -tank_y/2, 0])
            cube([tank_x, tank_y, floor]);

        // Raised platform (centred in X, spans full Y)
        translate([-platform_x/2, -tank_y/2, floor])
            cube([platform_x, tank_y, platform_t]);

        // Two buffer chambers above platform
        for (sx = [-1, 1])
            translate([sx > 0 ? tank_x - platform_x - 0.01 : -0.01,
                       -tank_y/2,
                       floor + platform_t])
                cube(chamber_v);
    }

    // End walls with horizontal electrode holes along X
    for (sx = [-1, 1]) {
        x0 = sx > 0 ? tank_x - wall : -wall;
        difference() {
            translate([x0, -tank_y/2 - 0.01, floor])
                cube([wall, tank_y + 0.02, tank_h - floor]);
            translate([x0 - eps, hole_y, hole_z])
                rotate([0, 90, 0])
                    cylinder(d = hole_d, h = wall + 2*eps);
        }
    }
}