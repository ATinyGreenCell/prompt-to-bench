// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, vertical plate builds up in +Z

// ---------- Parameters ----------
base_x0      = -25;   // base plate x start
base_x1      = 25;    // base plate x end
base_y0      = 0;     // base plate y start
base_y1      = 45;    // base plate y end
base_z       = 5;     // base plate thickness

motor_x0     = -25;   // motor plate x start
motor_x1     = 25;    // motor plate x end
motor_y      = 5;     // motor plate y end (thickness)
motor_z      = 50;    // motor plate height

boss_hole    = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole x centre
boss_z       = 28;    // boss hole z centre

screw_hole   = 3.4;   // M3 screw hole diameter
screw_n      = 4;     // number of screw holes
screw_pitch  = 31;    // square pattern side length

gusset_t     = 5;     // gusset thickness (X)
gusset_x0    = -25;   // left gusset x start
gusset_x1    = -20;   // left gusset x end
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);

        // Vertical motor plate
        translate([motor_x0, 0, 0])
            cube([motor_x1 - motor_x0, motor_y, motor_z]);

        // Gussets (right-angle corner at y = 5, z = 5)
        for (sx = [-1, 1])
            translate([sx > 0 ? 20 : gusset_x0, 5, 5])
                linear_extrude([gusset_t * sx > 0 ? 1 : -1])
                    polygon([[0, 0], [gusset_y, 0], [0, gusset_z]]);
    }

    // Base plate through-holes (M4)
    for (x = [-17, 17])
        translate([x, base_y0 + 30, -eps])
            cylinder(d = 4.5, h = base_z + 2 * eps);

    // Motor plate boss hole (along Y)
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_hole, h = motor_y + 2 * eps);

    // Motor plate screw holes (M3, square pattern)
    for (i = [0 : screw_n - 1]) {
        y = (i - (screw_n - 1) / 2) * screw_pitch;
        for (sx = [-1, 1])
            translate([sx * screw_pitch / 2, y, -eps])
                cylinder(d = screw_hole, h = motor_y + 2 * eps);
    }
}