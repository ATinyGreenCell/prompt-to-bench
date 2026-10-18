// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top, builds +Z

// ---- Tank dimensions ----
tank_x = 120;      // outer length along X (mm)
tank_y = 70;       // outer width along Y (mm)
tank_z = 40;       // outer height along Z (mm)
wall    = 3;       // wall thickness (mm)
floor   = 3;       // floor thickness (mm)

// ---- Platform dimensions ----
plat_len   = 60;   // platform length along X (mm)
plat_top_z = 13;   // platform top height (mm), floor + 10
$fn        = 64;   // curve resolution

// ---- Hole dimensions ----
hole_d = 2;        // electrode hole diameter (mm)
hole_y = 0;        // hole Y position (mm)
hole_z = 30;       // hole Z position (mm)

// ---- Cutting overlap ----
eps = 0.5;         // extension past cut faces (mm)

difference() {
    // Tank body
    translate([-tank_x/2, -tank_y/2, 0])
        cube([tank_x, tank_y, tank_z]);

    // Gel-tray platform (full inner width, centred in X)
    translate([-tank_x/2 + (tank_x - plat_len)/2, -tank_y/2, 0])
        cube([plat_len, tank_y, plat_top_z]);

    // Horizontal electrode holes through end walls along X
    for (sx = [-1, 1])
        translate([sx * (tank_x/2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_y + 2*eps);
}