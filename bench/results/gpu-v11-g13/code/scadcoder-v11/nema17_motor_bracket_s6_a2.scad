// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

// ---------- Parameters ----------
base_x0      = -25;    // base plate x start
base_x1      = 25;     // base plate x end
base_y0      = 0;      // base plate y start
base_y1      = 45;     // base plate y end
base_z1      = 5;      // base plate thickness (z)

motor_x0     = -25;    // motor plate x start
motor_x1     = 25;     // motor plate x end
motor_y0     = 0;      // motor plate y start
motor_y1     = 5;      // motor plate y end (thickness)
motor_z1     = 50;     // motor plate height (z)

hole_m4_x    = -17;    // M4 through-hole x position
hole_m4_y    = 30;     // M4 through-hole y position
hole_m4_d    = 4.5;    // M4 hole diameter

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole centre x
boss_z       = 28;     // boss hole centre z

screw_d      = 3.4;    // M3 screw hole diameter
screw_pat    = 31;     // screw hole square pattern size
screw_count  = 4;      // number of screw holes

gusset_t     = 5;      // triangular gusset thickness (x)
gusset_y     = 20;     // gusset leg along +Y
gusset_z     = 20;     // gusset leg along +Z

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;              // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1]);

        // Left gusset (x = -25 to -20), right gusset (x = 20 to 25)
        for (sx = [-1, 1])
            translate([sx * (motor_x0 + gusset_t / 2), 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [0, 5],
                            [0, gusset_y],
                            [gusset_z, gusset_y]
                        ]);
    }

    // M4 through-hole in base plate
    translate([hole_m4_x, hole_m4_y, -eps])
        cylinder(d = hole_m4_d, h = base_z1 + 2 * eps);

    // Boss hole through motor plate (along Y)
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (a = [0 : 90 : 270])
        rotate([0, 0, a])
            translate([screw_pat / 2, 0, -eps])
                cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2 * eps);
}