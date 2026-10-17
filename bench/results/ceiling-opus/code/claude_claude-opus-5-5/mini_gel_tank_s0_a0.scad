// Mini horizontal gel-electrophoresis buffer tank
// Print orientation: open top facing +Z, floor on XY plane at z = 0

$fn = 64;

// ---------- Tank dimensions ----------
tank_x      = 120;   // outer length (X)
tank_y      = 70;    // outer width (Y)
tank_z      = 40;    // outer height (Z)
wall_t      = 3;     // side/end wall thickness
floor_t     = 3;     // floor thickness

// ---------- Gel tray platform ----------
plat_len_x  = 60;    // platform length along X (centred)
plat_h      = 10;    // platform height above inner floor
plat_top_z  = floor_t + plat_h;  // = 13, platform top height

// ---------- Electrode wire holes ----------
hole_d      = 2;     // wire hole diameter
hole_z      = 30;    // hole centre height
hole_y      = 0;     // hole centre Y position

// ---------- Helpers ----------
eps         = 0.5;   // overcut for clean boolean differences
inner_x     = tank_x - 2*wall_t;
inner_y     = tank_y - 2*wall_t;

union() {
    // Tank shell with wire holes
    difference() {
        // Outer block
        translate([-tank_x/2, -tank_y/2, 0])
            cube([tank_x, tank_y, tank_z]);

        // Inner cavity (open top)
        translate([-inner_x/2, -inner_y/2, floor_t])
            cube([inner_x, inner_y, tank_z - floor_t + eps]);

        // Electrode wire holes through both end walls
        for (s = [-1, 1])
            translate([s*(tank_x/2 - wall_t/2), hole_y, hole_z])
                rotate([0, 90, 0])
                    cylinder(d = hole_d, h = wall_t + 2*eps, center = true);
    }

    // Solid raised gel platform spanning full inner width
    // (slightly overlaps floor and side walls so it fuses into one solid)
    translate([-plat_len_x/2, -inner_y/2 - 0.01, floor_t - 0.01])
        cube([plat_len_x, inner_y + 0.02, plat_h + 0.01]);
}