// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, builds up +Z

$fn = 64;

// --- Tank dimensions ---
outer_x = 120;   // outer length in X
outer_y = 70;    // outer width in Y
height  = 40;    // overall height in Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// --- Platform ---
plat_len   = 60;   // platform length in X
plat_top_z = 13;   // platform top height (10 mm above inner floor)

// --- Holes ---
hole_d = 2;     // electrode hole diameter
hole_y = 0;     // hole Y position
hole_z = 30;    // hole Z position

// --- Derived ---
inner_h = height - floor;              // inner floor to top opening
over    = 0.5;                         // cutter overshoot

difference() {
    // Tank body
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, height]);

    // Raised platform (full inner width, centred in X)
    translate([-plat_len/2, -outer_y/2, floor])
        cube([plat_len, outer_y, plat_top_z - floor + over]);

    // Electrode holes through end walls along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - over : -outer_x/2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_x + 2*over);
}