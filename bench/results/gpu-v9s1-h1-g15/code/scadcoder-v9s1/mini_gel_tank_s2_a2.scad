// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: tank rests on XY plane, builds up +Z

$fn = 64;

// ---- Tank dimensions ----
outer_x = 120;   // outer length in X
outer_y = 70;    // outer width in Y
outer_z = 40;    // outer height in Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform dimensions ----
plat_len   = 60;  // platform length in X
plat_top_z = 13;  // platform top height (10 mm above inner floor)

// ---- Wire holes ----
hole_d = 2;       // hole diameter
hole_y = 0;       // hole Y position
hole_z = 30;      // hole Z position

// ---- Derived ----
inner_f = outer_x - 2 * wall;  // inner floor length
inner_w = outer_y - 2 * wall;  // inner width (platform spans this)
plat_h = plat_top_z - floor;   // platform height above floor

difference() {
    // Tank body
    translate([-outer_x / 2, -outer_y / 2, 0])
        cube([outer_x, outer_y, outer_z]);

    // Open top (hollow above inner floor)
    translate([-inner_f / 2, -inner_w / 2, floor])
        cube([inner_f, inner_w, outer_z - floor]);

    // Raised platform in the middle
    translate([-inner_f / 2 + wall, -inner_w / 2, floor])
        cube([plat_len, inner_w, plat_h]);

    // Wire holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx > 0 ? inner_f / 2 - 1 : -inner_f / 2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2 * wall, center = true);
}