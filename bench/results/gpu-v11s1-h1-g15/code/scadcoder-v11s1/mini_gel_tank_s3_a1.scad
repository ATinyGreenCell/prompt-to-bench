// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane, builds up in +Z

$fn = 64;

// ---- Tank dimensions ----
outer_x = 120;   // outer length along X
outer_y = 70;    // outer width along Y
outer_z = 40;    // outer height along Z
wall    = 3;     // wall thickness (X and Y)
floor   = 3;     // floor thickness under the inner floor

// ---- Platform dimensions ----
plat_x     = 60;   // platform length along X (centred)
plat_w     = outer_y; // platform spans full inner width
plat_top_z = 13;   // height of platform top above tank bottom

// ---- Electrode holes ----
hole_d = 2;     // hole diameter
hole_y = 0;     // hole Y position
hole_z = 30;    // hole Z position

// ---- Derived ----
inner_x = outer_x - 2*wall;
inner_z = outer_z - floor;
eps     = 0.5;  // cutter overshoot

difference() {
    // Tank body
    union() {
        cube([outer_x, outer_y, outer_z]);
        // floor slab under the inner floor
        translate([-outer_x/2, -outer_y/2, -floor])
            cube([outer_x, outer_y, floor + 0.01]);
    }

    // Raised platform
    translate([-plat_x/2, -plat_w/2, 0])
        cube([plat_x, plat_w, plat_top_z]);

    // Electrode holes through end walls
    for (sx = [-1, 1])
        translate([sx * (outer_x/2 - eps), hole_y, hole_z])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = wall + eps);
}