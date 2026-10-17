// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: tank rests on XY plane at z = 0, open top

// ---------- Parameters ----------
tank_x      = 120;   // outer length in X
tank_y      = 70;    // outer width in Y
tank_h      = 40;    // outer height in Z
wall        = 3;     // wall thickness (sides and floor)
floor       = 3;     // floor thickness (under raised platform)
platform_x  = 60;    // platform length in X (centred)
platform_t  = 10;    // platform height above inner floor
hole_d      = 2;     // electrode hole diameter
hole_y      = 0;     // electrode hole Y position
hole_z      = 30;    // electrode hole Z position
eps         = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
inner_f = tank_y - 2 * wall;              // inner width (Y) of tank
plat_t  = floor + platform_t;             // platform top height (z = 13)

// ---------- Model ----------
difference() {
    // Tank body: outer block with open top
    translate([-tank_x/2, -tank_y/2, 0])
        cube([tank_x, tank_y, tank_h]);

    // Raised platform in middle, spanning full inner width
    translate([-platform_x/2, -inner_f/2, floor])
        cube([platform_x, inner_f, plat_t]);

    // Horizontal electrode holes through each end wall along X
    for (sx = [-1, 1])
        translate([sx > 0 ? tank_x/2 - eps : -tank_x/2 - eps, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_y + 2*eps);
}