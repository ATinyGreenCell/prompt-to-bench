// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: tank rests on XY plane, builds upward in +Z

$fn = 64;

// ---- Tank dimensions ----
tank_x_out = 120;   // outer length in X
tank_y_out = 70;    // outer width in Y
tank_z_out = 40;    // outer height in Z
wall       = 3;     // wall thickness
floor      = 3;     // floor thickness

// ---- Platform dimensions ----
plat_x     = 60;    // platform length in X (centred)
plat_y     = tank_y_out - 2 * wall; // platform spans full inner width
plat_top_z = 13;    // platform top height above tank floor

// ---- Cutout dimensions ----
hole_d     = 2;     // electrode wire hole diameter
hole_y     = 0;     // hole centre Y
hole_z     = 30;    // hole centre Z

// ---- Derived ----
inner_h = tank_z_out - floor; // height of buffer chambers
eps     = 0.5;              // cutter overshoot

difference() {
    // Tank body (solid outer block, open top)
    translate([-tank_x_out/2, -tank_y_out/2, 0])
        cube([tank_x_out, tank_y_out, tank_z_out]);

    // Gel tray platform, raised from floor
    translate([-plat_x/2, -plat_y/2, floor])
        cube([plat_x, plat_y, plat_top_z]);

    // Electrode wire holes through end walls
    for (sx = [-1, 1])
        translate([sx * (tank_x_out/2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = plat_y + 2*eps);
}