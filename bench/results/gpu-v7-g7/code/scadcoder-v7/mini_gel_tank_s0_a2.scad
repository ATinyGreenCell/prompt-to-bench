// Buffer tank for mini horizontal gel-electrophoresis box
// Print orientation: open top facing +Z, resting on XY plane at z = 0

// ---------- Parameters ----------
outer_x   = 120;   // outer length (X)
outer_y   = 70;    // outer width (Y)
outer_z   = 40;    // outer height (Z)
wall      = 3;     // wall thickness
floor     = 3;     // floor thickness

inner_h   = outer_z - wall;              // inner height above floor (37)
platform_t= 10;    // platform thickness (top at z = 13)
platform_x= 60;    // platform length in X, centred
hole_d    = 2;     // electrode hole diameter
hole_y    = 0;     // hole Y position
hole_z    = 30;    // hole Z position (above inner floor)

eps       = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
inner_w = outer_y - 2*wall;              // inner width (64)
inner_l = outer_x - 2*wall;              // inner length (114)
chamber_h = inner_h - platform_t;        // chamber height above platform (27)

// ---------- Model ----------
difference() {
    // Tank body: open top, solid floor and walls
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, outer_z]);

    // Cut out the open top (slightly above the top face)
    translate([-outer_x/2 - eps, -outer_y/2 - eps, outer_z - eps])
        cube([outer_x + 2*eps, outer_y + 2*eps, eps]);

    // Gel-tray platform, centred in X, spanning full inner width
    translate([-outer_x/2, -inner_w/2, floor + chamber_h])
        cube([platform_x, inner_w, platform_t]);

    // Horizontal electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - hole_d/2 - eps : -outer_x/2 - eps,
                   hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2*eps, $fn = 64);
}