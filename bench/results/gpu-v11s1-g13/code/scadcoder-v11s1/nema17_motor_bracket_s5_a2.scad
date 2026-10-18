// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed (z = 0), motor plate builds upward.

$fn = 64;

// ---- Base plate ----
base_x0   = -25;          // plate x start
base_x1   = 25;           // plate x end (2 * 25 = 50 mm long)
base_y0   = 0;            // plate y start
base_y1   = 45;           // plate y end
base_z1   = 5;            // plate top z
hole_d    = 4.5;          // M4 through-hole diameter
hole_x    = [-17, 17];    // through-hole x positions
hole_y    = 30;           // through-hole y position

// ---- Motor plate ----
plate_x0  = -25;          // plate x start
plate_x1  = 25;           // plate x end
plate_y0  = 0;            // plate y start
plate_y1  = 5;            // plate thickness (Y)
plate_z1  = 50;           // plate top z
boss_d    = 23;           // motor centring boss hole diameter
boss_x    = 0;            // boss hole x centre
boss_z    = 28;           // boss hole z centre
screw_d   = 3.4;          // M3 screw hole diameter
screw_n   = 4;            // number of screw holes
screw_a   = 31;           // square pattern side length
screw_h   = 10;           // screw holes depth from top

// ---- Gussets ----
gus_t     = 5;            // gusset thickness (X)
gus_y     = 20;           // triangle leg along +Y
gus_z     = 20;           // triangle leg along +Z
gus_x0    = -25;          // left edge x
gus_x1    = -20;          // left triangle x end
gus_x2    = 20;           // right triangle x start
gus_x3    = 25;           // right edge x

// ---- Misc ----
eps       = 0.5;          // cutter overshoot past faces

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1]);

        // Vertical motor plate, standing on back edge of base
        translate([plate_x0, base_y1, 0])
            cube([plate_x1 - plate_x0, plate_y1 - plate_y0, plate_z1]);

        // Gussets, flush with left and right edges
        for (startx = [gus_x0, gus_x2])
            translate([startx, gus_y0 := 5, gus_z0 := 5])
                linear_extrude(height = gus_t)
                    polygon(points = [
                        [0, gus_y0],
                        [gus_y, gus_y0],
                        [gus_y0, gus_z]
                    ]);
    }

    // Base plate through-holes
    for (hx = hole_x)
        translate([hx, hole_y, -eps])
            cylinder(d = hole_d, h = base_z1 + 2 * eps);

    // Motor plate boss hole
    translate([boss_x, plate_y1 / 2, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = plate_y1 + eps, center = true);

    // Motor plate screw holes on square pattern
    for (i = [0 : screw_n - 1]) {
        x = (i % 2 - 0.5) * screw_a;
        y = (i / 2 - 0.5) * screw_a;
        translate([x, y, plate_z1 - screw_h])
            cylinder(d = screw_d, h = screw_h + eps);
    }
}