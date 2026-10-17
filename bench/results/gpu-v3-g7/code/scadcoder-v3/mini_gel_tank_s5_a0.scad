// Buffer tank for mini horizontal gel electrophoresis
// Print orientation: open top up, resting on XY plane at z = 0

$fn = 64;

// ---- Tank ----
outer_x = 120;   // tank outer length (X)
outer_y = 70;    // tank outer width (Y)
tank_h  = 40;    // tank outer height (Z)
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform ----
plat_x = 60;     // platform length in X (centred)
plat_y = outer_y; // platform spans full inner width
plat_top = 13;   // platform top height above inner floor (z = 13)

// ---- Electrode holes ----
hole_d = 2;      // electrode hole diameter
hole_y = 0;      // electrode hole Y position
hole_z = 30;     // electrode hole Z position

// ---- Misc ----
eps = 0.5;       // cutter overshoot past faces

difference() {
    // Main tank body
    cube([outer_x, outer_y, tank_h]);

    // Inner cavity, from top of floor to just below tank top
    translate([wall, wall, floor])
        cube([outer_x - 2*wall, outer_y - 2*wall, tank_h - floor]);

    // Raised platform in the middle
    translate([-plat_x/2, wall, floor])
        cube([plat_x, plat_y, plat_top]);

    // Horizontal electrode holes through each end wall, along X
    for (x = [-outer_x/2, outer_x/2])
        translate([x, hole_y, hole_z])
            rotate([-90, 0, 0])
                cylinder(d = hole_d, h = outer_x + 2*eps);
}