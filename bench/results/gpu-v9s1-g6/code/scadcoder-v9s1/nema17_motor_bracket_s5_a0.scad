// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_x       = 25;    // base plate half-width (X)
plate_y       = 45;    // base plate length (Y)
plate_t       = 5;     // base plate thickness (Z)

motor_h       = 50;    // vertical motor plate height (Z)
motor_w       = 5;     // vertical motor plate thickness (Y)

boss_d        = 23;    // motor centring boss hole diameter
boss_x        = 0;     // boss hole centre X
boss_z        = 28;    // boss hole centre Z

screw_d       = 3.4;   // M3 screw hole diameter
screw_pattern = 31;    // square pitch of screw holes
screw_count   = 4;     // number of screw holes

gusset_t      = 5;     // gusset thickness (X)
gusset_leg    = 20;    // right-triangle leg length (Y and Z)
gusset_x      = [-25, 20]; // gusset start X positions

eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        for (h = [0, 1])
            translate([-17, 30, h * plate_t - eps])
                cylinder(d = 4.5, h = plate_t + 2 * eps);
    }

    // Vertical motor plate with boss hole and M3 screw holes
    difference() {
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, motor_w, motor_h]);

        // Boss hole along Y
        translate([boss_x, -eps, boss_z])
            rotate([-90, 0, 0])
                cylinder(d = boss_d, h = motor_w + 2 * eps);

        // Screw holes on square pattern centred on boss hole
        for (i = [0 : screw_count - 1]) {
            a = (i < 2) ? 0 : 90;   // 0 deg: X axis, 90 deg: Z axis
            r = screw_pattern / 2;
            translate([boss_x + r * cos(a), -eps, boss_z + r * sin(a)])
                rotate([0, 90, a])
                    cylinder(d = screw_d, h = motor_w + 2 * eps);
        }
    }

    // Triangular gussets flush with left and right edges
    for (gx = gusset_x)
        translate([gx, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_leg, gusset_leg],   // right-angle corner at y=5, z=5
                        [gusset_leg, 0],
                        [0, gusset_leg]
                    ]);
}