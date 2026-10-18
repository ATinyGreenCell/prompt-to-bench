// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: base on XY plane, open top, builds up +Z

$fn = 64;

// ---- Tank dimensions ----
tank_x = 120;      // outer length (X)
tank_y = 70;       // width (Y)
tank_z = 40;       // height (Z)
wall   = 3;        // wall thickness
floor  = 3;        // floor thickness

// ---- Platform ----
plat_len   = 60;   // platform length in X
plat_top_z = 13;   // top of platform (10 mm above inner floor)

// ---- Electrode holes ----
hole_d     = 2;    // hole diameter
hole_y     = 0;    // hole Y position
hole_z     = 30;   // hole Z position

// ---- Derived ----
inner_x = tank_x - 2*wall;
inner_y = tank_y - 2*wall;
inner_z = tank_z - floor;
eps     = 0.5;     // cutter overshoot

union() {
    // Tank body
    difference() {
        cube([tank_x, tank_y, tank_z]);
        // Open top
        translate([0, 0, tank_z - floor])
            cube([inner_x, inner_y, inner_z]);
    }

    // Raised platform
    translate([(tank_x - plat_len)/2, 0, tank_z - floor])
        cube([plat_len, tank_y, plat_top_z - (tank_z - floor) + 0.01]);

    // Electrode holes
    for (sx = [-1, 1])
        translate([sx * (inner_x/2 - hole_d/2), hole_y, hole_z - eps])
            rotate([90, 0, 0])
                cylinder(d = hole_d, h = inner_y + 2*eps);
}