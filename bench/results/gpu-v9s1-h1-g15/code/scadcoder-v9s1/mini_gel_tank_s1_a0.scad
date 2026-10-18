// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top at z = 40

// ---- Tank dimensions ----
outer_x = 120;   // outer length along X
outer_y = 70;    // outer width along Y
height  = 40;    // overall height along Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform dimensions ----
platform_len   = 60;   // platform length along X
platform_top_z = 13;   // top of platform (10 mm above inner floor)

// ---- Wire holes ----
hole_d = 2;     // hole diameter
hole_y = 0;     // hole Y position
hole_z = 30;    // hole Z position

// ---- Derived ----
inner_x = outer_x - 2 * wall;   // 114
inner_z = height - floor;       // 37

$fn = 64;

difference() {
    // Tank body
    union() {
        // Floor
        translate([-outer_x / 2, -outer_y / 2, 0])
            cube([outer_x, outer_y, floor]);
        // Walls (sides and ends, overlapping at corners)
        translate([-inner_x / 2, -outer_y / 2, floor])
            cube([inner_x, outer_y, height - floor]);   // sides
        translate([-outer_x / 2, -inner_y / 2, floor])
            cube([outer_x, inner_y, height - floor]);   // ends
    }

    // Raised platform (through, so chambers stay connected above)
    translate([-platform_len / 2, -outer_y / 2, floor])
        cube([platform_len, outer_y, platform_top_z]);

    // Wire holes through end walls along X
    for (sx = [-1, 1])
        translate([sx > 0 ? inner_x / 2 - 1 : -inner_x / 2, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2 * wall, $fn = 64);
}