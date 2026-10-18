// NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base plate on the bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_x      = 25;     // base plate half-length in X (total 50 mm)
plate_y      = 45;     // base plate length in Y
plate_t      = 5;      // base plate thickness in Z

hole_m4_x    = 17;     // M4 hole centre offset from origin in X (both + and -)
hole_m4_y    = 30;     // M4 hole centre in Y

plate_z      = 50;     // vertical motor plate height in Z
plate_yt     = 5;      // vertical plate thickness in Y

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole centre in X
boss_z       = 28;     // boss hole centre in Z

screw_d      = 3.4;    // M3 screw hole diameter
screw_pitch  = 31;     // M3 screw hole square pattern size (centred on boss)

gusset_t     = 5;      // gusset thickness along X
gusset_y     = 20;     // gusset leg along +Y
gusset_z     = 20;     // gusset leg along +Z

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate (stands on back edge of base)
        translate([-plate_x, plate_y - plate_yt, 0])
            cube([plate_x * 2, plate_yt, plate_z]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x - gusset_t : -plate_x, 0, 0])
                cube([gusset_t, gusset_y, gusset_z]);
    }

    // Through-holes
    translate([-hole_m4_x, hole_m4_y, -eps])
        cylinder(d = hole_m4_x, h = plate_t + 2 * eps);

    translate([hole_m4_x, hole_m4_y, -eps])
        cylinder(d = hole_m4_x, h = plate_t + 2 * eps);

    // Motor centring boss hole (along Y)
    translate([boss_x, plate_y - plate_yt / 2, boss_z])
        cylinder(d = boss_d, h = plate_yt + eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : 3])
        rotate([0, 90 * i, 0])
            translate([boss_x, plate_y - plate_yt / 2 - eps, boss_z])
                cylinder(d = screw_d, h = plate_z + eps);
}