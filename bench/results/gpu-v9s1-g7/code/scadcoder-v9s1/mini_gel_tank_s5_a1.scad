// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top, builds up +Z

$fn = 64;

// ---- Tank dimensions ----
outer_x = 120;   // outer length in X
outer_y = 70;    // outer width in Y
height  = 40;    // overall height in Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform dimensions ----
plat_len   = 60;  // platform length in X (centred)
plat_top_z = 13;  // platform top height above inner floor

// ---- Electrode holes ----
hole_d = 2;       // hole diameter
hole_y = 0;       // hole Y position
hole_z = 30;      // hole Z position

// ---- Derived ----
inner_h = height - floor;              // inner floor to open top
cut_ext = 0.5;                         // overshoot for clean cuts

difference() {
    // Main tank body (solid through walls and floor)
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, height]);

    // Gel-tray platform, raised above inner floor
    translate([-plat_len/2, -outer_y/2, floor + plat_top_z])
        cube([plat_len, outer_y, inner_h]);

    // Horizontal electrode holes through each end wall
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - cut_ext : -outer_x/2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2*cut_ext);
}