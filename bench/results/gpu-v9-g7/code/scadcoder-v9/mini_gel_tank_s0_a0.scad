// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top facing +Z

$fn = 64;

// ---- Tank dimensions ----
tank_x = 120;   // outer length in X
tank_y = 70;    // outer width in Y
tank_z = 40;    // outer height in Z
wall   = 3;     // wall thickness
floor  = 3;     // floor thickness

// ---- Platform dimensions ----
plat_len   = 60;   // platform length in X
plat_top_z = 13;   // platform top height (floor is at z = 3)

// ---- Electrode holes ----
hole_d = 2;    // hole diameter
hole_y = 0;    // hole Y position
hole_z = 30;   // hole Z position

// ---- Derived ----
inner_x = tank_x - 2 * wall;
inner_y = tank_y - 2 * wall;
inner_floor_z = floor;
eps = 0.5;     // cutter overshoot

module tank_body() {
    difference() {
        translate([-wall, -wall, 0])
            cube([tank_x, tank_y, tank_z]);
        // open top: remove everything above inner floor + eps
        translate([-wall, -wall, inner_floor_z + eps])
            cube([tank_x, tank_y, tank_z - inner_floor_z - eps + 0.01]);
    }
}

module platform() {
    // solid block from inner floor up to plat_top_z, centred in X, full Y
    translate([-inner_x / 2, -inner_y / 2, inner_floor_z])
        cube([plat_len, inner_y, plat_top_z - inner_floor_z]);
}

module electrode_holes() {
    for (sx = [-1, 1])
        translate([sx * (inner_x / 2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2 * eps);
}

union() {
    tank_body();
    platform();
    electrode_holes();
}