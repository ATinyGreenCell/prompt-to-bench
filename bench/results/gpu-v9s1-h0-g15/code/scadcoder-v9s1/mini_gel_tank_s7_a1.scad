// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top, builds up +Z

// ---- Tank dimensions ----
outer_x = 120;   // outer length along X
outer_y = 70;    // outer width along Y
height  = 40;    // outer height along Z
wall    = 3;     // wall thickness
floor   = 3;     // floor thickness

// ---- Platform dimensions ----
plat_len   = 60;  // platform length along X (centred)
plat_top_z = 13;  // platform top height above inner floor

// ---- Electrode holes ----
hole_d = 2;       // hole diameter
hole_y = 0;       // hole Y position
hole_z = 30;      // hole Z position

// ---- Modelling helpers ----
eps = 0.5;        // cutter overshoot past faces
$fn = 96;         // curve resolution

// ---- Derived ----
inner_h = height - floor;  // inner floor to open top
overlap = min(wall, floor) - 0.01;  // wall/floor overlap for clean union

difference() {
    union() {
        // Main tank body
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, height]);

        // Raised platform in the middle
        translate([-plat_len/2, -outer_y/2, floor - overlap])
            cube([plat_len, outer_y, plat_top_z + wall]);
    }

    // Electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx > 0 ? outer_x/2 - eps : -outer_x/2 - eps,
                   hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = outer_y + 2*eps);
}