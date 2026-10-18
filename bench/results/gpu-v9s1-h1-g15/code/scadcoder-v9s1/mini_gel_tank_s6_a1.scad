// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top at z = 40

// ---- Tank dimensions ----
outer_x = 120;   // outer length along X
outer_y = 70;    // outer width along Y
height  = 40;    // overall height along Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform dimensions ----
plat_len   = 60;  // platform length along X
plat_top_z = 13;  // platform top height (10 mm above inner floor)

// ---- Wire holes ----
hole_d = 2;       // hole diameter
hole_y = 0;       // hole Y position
hole_z = 30;      // hole Z position

// ---- Derived ----
inner_x = outer_x - 2 * wall;   // 114
inner_z = height - floor;       // 37
overlap = 0.5;                  // for clean boolean cuts

$fn = 64;

difference() {
    // Main tank body (solid, no internal model needed)
    translate([-outer_x / 2, -outer_y / 2, 0])
        cube([outer_x, outer_y, height]);

    // Raised platform in the middle
    translate([-plat_len / 2, -outer_y / 2, floor])
        cube([plat_len, outer_y, plat_top_z]);

    // Horizontal wire holes through each end wall along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x / 2 - overlap : -outer_x / 2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2 * overlap);
}