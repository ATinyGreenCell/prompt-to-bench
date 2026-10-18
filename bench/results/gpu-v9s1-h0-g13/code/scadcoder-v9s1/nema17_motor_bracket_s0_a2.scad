// L-shaped mounting bracket for a NEMA 17 stepper motor
// Print orientation: base plate on the bed (z = 0), motor plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_x      = 25;    // base plate half-width (X: -25 .. 25)
plate_y      = 45;    // base plate length (Y: 0 .. 45)
plate_t      = 5;     // base plate thickness (Z: 0 .. 5)

motor_h      = 50;    // motor plate height (Z: 0 .. 50)
motor_w      = 5;     // motor plate thickness (Y: 0 .. 5)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole centre X
boss_z       = 28;    // boss hole centre Z

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length
screw_n      = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness (X)
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;             // curve resolution

// ---------------- Model ----------------
union() {
    // Base plate with two M4 through-holes at (-17, 30) and (17, 30)
    difference() {
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);
        for (sx = [-17, 17])
            translate([sx, 30, -eps])
                cylinder(d = 4.5, h = plate_t + 2 * eps);
    }

    // Vertical motor plate standing on the back edge of the base
    difference() {
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, motor_w, motor_h]);
        // Boss hole (along Y), centred at x = 0, z = 28
        translate([boss_x, -eps, boss_z])
            rotate([-90, 0, 0])
                cylinder(d = boss_d, h = motor_w + 2 * eps);
        // Four M3 screw holes on a 31 mm square pattern, centred on the boss hole
        for (i = [0 : screw_n - 1]) {
            a = atan2(sin(i * 90), cos(i * 90));
            translate([boss_x, motor_w / 2 - screw_pitch / 2, boss_z + a * eps])
                rotate([0, 90, i * 90])
                    cylinder(d = screw_d, h = motor_w + 2 * eps);
        }
    }

    // Two triangular gussets, flush with the left and right edges
    // Right-triangle in YZ: legs 20 mm along +Y and +Z, right angle at (y = 5, z = 5)
    for (gx = [-25, 20])
        translate([gx, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [[0, gusset_y], [gusset_z, gusset_y], [0, 0]]);
}