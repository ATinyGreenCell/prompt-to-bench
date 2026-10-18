// Mini horizontal gel-electrophoresis box: buffer tank with central gel-platform
// Print orientation: tank rests on XY plane, builds up in +Z, open top

$fn = 64;

// ---- Tank ----
tank_x      = 120;   // outer length (X)
tank_y      = 70;    // outer width (Y)
tank_h      = 40;    // outer height (Z)
wall        = 3;     // wall thickness
floor       = 3;     // floor thickness

// ---- Platform ----
plat_x      = 60;    // platform length in X, centred
plat_top_z  = 13;    // platform top height above tank bottom (floor + inner floor)

// ---- Electrode holes ----
hole_d      = 2;     // horizontal hole diameter (through end walls)
hole_y      = 0;     // hole centre Y
hole_z      = 30;    // hole centre Z

// ---- Derived ----
tank_in_x   = tank_x - 2*wall;
tank_in_y   = tank_y - 2*wall;
plat_h      = plat_top_z - floor;   // platform height above floor
eps         = 0.5;                  // cutter overshoot

union() {
    // Tank body (floor + side walls, open top)
    difference() {
        cube([tank_in_x, tank_in_y, floor]);
        translate([wall, wall, floor])
            cube([tank_in_x, tank_in_y, tank_h - floor]);
    }

    // Central gel platform, full inner width, through the walls
    translate([-tank_x/2 + wall, wall, floor])
        cube([plat_x, tank_in_y, plat_h]);

    // Horizontal electrode holes through each end wall
    for (sx = [-1, 1])
        translate([sx * (tank_x/2 - hole_d/2), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = wall + eps, center = true);
}