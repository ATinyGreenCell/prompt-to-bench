// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: base on XY plane, open top facing +Z

$fn = 64;

// --- Tank dimensions ---
tank_x = 120;   // outer length (X)
tank_y = 70;    // outer width (Y)
tank_z = 40;    // outer height (Z)

// --- Walls ---
wall = 3;       // wall thickness
floor = 3;      // floor thickness

// --- Platform ---
plat_len   = 60;   // platform length in X
plat_top_z = 13;   // platform top height (floor + 10)
plat_w     = tank_y - 2*wall;  // platform width = inner width

// --- Holes ---
hole_d = 2;     // electrode hole diameter
hole_y = 0;     // hole Y position
hole_z = 30;    // hole Z position

// --- Cutting overlap ---
eps = 0.5;      // extension past cut faces

difference() {
    // Tank body
    union() {
        // Side walls and floor
        hull() {
            for (sx = [-1, 1])
                translate([sx * (tank_x/2 - wall), -tank_y/2, 0])
                    cube([wall, tank_y, tank_z]);
        }
        // End walls (at X ends), open top
        for (ez = [0, 1])
            translate([ez == 1 ? wall : tank_x - wall, -tank_y/2, 0])
                cube([tank_x - 2*wall + (ez == 0 ? -eps : eps),
                      tank_y,
                      tank_z - floor]);
    }

    // Central raised platform
    translate([-plat_len/2, -plat_w/2, floor])
        cube([plat_len, plat_w, plat_top_z - floor]);

    // Electrode holes through end walls
    for (x = [wall, tank_x - wall])
        translate([x, hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_y + 2*eps, center = true);
}