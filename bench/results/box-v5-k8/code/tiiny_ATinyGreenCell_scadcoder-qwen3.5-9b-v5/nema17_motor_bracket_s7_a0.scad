// NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base plate on the bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_x      = 25;     // base plate half-length in X (total 50 mm)
plate_y      = 45;     // base plate length in Y
plate_t      = 5;      // base plate thickness in Z

hole_m4_x    = 17;     // M4 hole X offset from origin (+/-)
hole_m4_y    = 30;     // M4 hole Y position
hole_m4_d    = 4.5;    // M4 hole diameter

plate_z      = 50;     // vertical motor plate height in Z
plate_y2     = 5;      // vertical plate depth in Y

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole X centre
boss_z       = 28;     // boss hole Z centre

screw_d      = 3.4;    // M3 screw hole diameter
screw_pitch  = 31;     // M3 screw hole square pattern size

gusset_t     = 5;      // gusset thickness in X
gusset_y     = 20;     // gusset leg along +Y
gusset_z     = 20;     // gusset leg along +Z

eps          = 0.5;    // cutter overshoot past faces
$fn          = 96;     // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y2, plate_z]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x - gusset_t : -plate_x, 0, 0])
                cube([gusset_t, gusset_y, gusset_z]);
    }

    // Through-holes
    // Two M4 vertical holes in base plate
    for (x = [-hole_m4_x, hole_m4_x])
        translate([x, hole_m4_y, -eps])
            cylinder(d = hole_m4_d, h = plate_t + 2 * eps);

    // Motor centring boss hole through vertical plate (along Y)
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_d, h = plate_y2 + 2 * eps);

    // Four M3 screw holes on a square pattern centred on the boss hole
    for (i = [0 : 3])
        rotate([0, 0, i * 90])
            translate([boss_x, plate_y2 / 2 - eps, boss_z])
                cylinder(d = screw_d, h = plate_y2 + 2 * eps);
}