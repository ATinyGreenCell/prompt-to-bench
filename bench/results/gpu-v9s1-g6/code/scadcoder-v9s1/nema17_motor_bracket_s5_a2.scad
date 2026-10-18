// L-shaped mounting bracket for a NEMA 17 stepper motor
// Print orientation: base plate on the bed (z = 0), vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
base_x1      = -25;    // base plate left edge (X)
base_x2      = 25;     // base plate right edge (X)
base_y1      = 0;      // base plate front edge (Y)
base_y2      = 45;     // base plate back edge (Y)
base_z       = 5;      // base plate thickness (Z)

motor_x1     = -25;    // motor plate left edge (X)
motor_x2     = 25;     // motor plate right edge (X)
motor_y1     = 0;      // motor plate front edge (Y)
motor_y2     = 5;      // motor plate back edge (Y)
motor_z      = 50;     // motor plate height (Z)

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole centre X
boss_z       = 28;     // boss hole centre Z

screw_d      = 3.4;    // M3 screw hole diameter
screw_pitch  = 31;     // square pattern side length
screw_count  = 4;      // number of screw holes

gusset_t     = 5;      // gusset thickness (X)
gusset_y     = 20;     // gusset leg along +Y
gusset_z     = 20;     // gusset leg along +Z

eps          = 0.5;    // cutter overshoot past faces
$fn          = 96;     // curve resolution

// ---------------- Model ----------------
union() {
    // Base plate with two M4 through-holes at (-17, 30) and (17, 30)
    difference() {
        translate([base_x1, base_y1, 0])
            cube([base_x2 - base_x1, base_y2 - base_y1, base_z]);

        for (sx = [-17, 17])
            translate([sx, base_y2 - 15, -eps])
                cylinder(d = 4.5, h = base_z + 2 * eps);
    }

    // Vertical motor plate standing on the back edge of the base
    difference() {
        translate([motor_x1, motor_y1, 0])
            cube([motor_x2 - motor_x1, motor_y2 - motor_y1, motor_z]);

        // Boss hole cut along Y, centred at x = 0, z = 28
        translate([boss_x, -eps, boss_z])
            rotate([-90, 0, 0])
                cylinder(d = boss_d, h = motor_y2 - motor_y1 + 2 * eps);
    }

    // Four M3 screw holes on a 31 mm square pattern centred on the boss hole
    for (i = [0 : screw_count - 1]) {
        a = (i < 2) ? 0 : 90;   // 0 deg: X axis, 90 deg: Z axis
        r = screw_pitch / 2;
        translate([boss_x + r * cos(a), motor_y1 - eps, boss_z + r * sin(a)])
            rotate([0, 90, a])
                cylinder(d = screw_d, h = motor_y2 - motor_y1 + 2 * eps);
    }

    // Two triangular gussets flush with the left and right edges
    for (gx = [motor_x1, motor_x2 - gusset_t]) {
        translate([gx, motor_y1, base_z])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_y, gusset_z],   // right-angle corner at y = 5, z = 5
                        [gusset_y, 0],
                        [0, gusset_z]
                    ]);
    }
}