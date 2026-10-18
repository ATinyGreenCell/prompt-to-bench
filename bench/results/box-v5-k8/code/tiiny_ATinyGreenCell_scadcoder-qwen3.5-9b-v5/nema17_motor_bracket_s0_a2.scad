// NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base plate on the bed, vertical plate builds up in +Z

// ---------- Parameters ----------
base_x1      = -25;   // base plate left edge (X)
base_x2      = 25;    // base plate right edge (X)
base_y       = 45;    // base plate depth (Y)
base_z       = 5;     // base plate thickness (Z)

motor_x1     = -25;   // motor plate left edge (X)
motor_x2     = 25;    // motor plate right edge (X)
motor_y      = 5;     // motor plate depth (Y)
motor_z      = 50;    // motor plate height (Z)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole centre X
boss_z       = 28;    // boss hole centre Z

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // screw hole square pattern size
screw_n      = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness (X)
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z

hole_d       = 4.5;   // M4 through-hole diameter
hole_x       = -17;   // through-hole centre X
hole_y       = 30;    // through-hole centre Y

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([base_x1, 0, 0])
            cube([base_x2 - base_x1, base_y, base_z]);

        // Vertical motor plate
        translate([motor_x1, 0, 0])
            cube([motor_x2 - motor_x1, motor_y, motor_z]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? 20 : -25, 0, 0])
                translate([0, gusset_y, 0])
                    cube([gusset_t, gusset_y, gusset_z]);
    }

    // Through-holes in base plate
    translate([hole_x, hole_y, -eps])
        cylinder(d = hole_d, h = base_z + 2 * eps);

    // Motor boss hole along Y
    translate([boss_x, -eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_y + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : screw_n - 1])
        rotate([0, 0, i * 90])
            translate([-screw_pitch / 2, 0, boss_z])
                cylinder(d = screw_d, h = motor_z + eps);
}