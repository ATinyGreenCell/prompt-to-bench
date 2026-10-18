// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate flat on bed, motor plate vertical

// ---------------- Parameters ----------------
plate_x       = 25;    // base plate half-width (X)
plate_y       = 45;    // base plate length (Y)
plate_t       = 5;     // base plate thickness (Z)

motor_h       = 50;    // motor plate height (Z)
motor_w       = 5;     // motor plate thickness (Y)

boss_d        = 23;    // motor boss hole diameter
boss_x        = 0;     // boss hole centre X
boss_z        = 28;    // boss hole centre Z

screw_d       = 3.4;   // M3 screw hole diameter
screw_pitch   = 31;    // square pitch for screw holes
screw_count   = 4;     // number of screw holes

gusset_t      = 5;     // gusset thickness (X)
gusset_leg    = 20;    // gusset right-triangle leg length (Y and Z)

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
        translate([boss_x, -eps, boss_z])
            rotate([-90, 0, 0])
                cylinder(d = boss_d, h = motor_w + 2 * eps);
        for (i = [0 : screw_count - 1]) {
            a = atan2(sin(i * 90), cos(i * 90));
            translate([boss_x, motor_w / 2 - screw_pitch / 2,
                       boss_z + screw_pitch / 2])
                rotate([0, 90, a])
                    cylinder(d = screw_d, h = screw_pitch + 2 * eps);
        }
    }

    // Triangular gussets flush with left and right edges
    for (gx = [-25, 20])
        translate([gx, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_leg, gusset_leg],
                        [gusset_leg, 0],
                        [0, gusset_leg]
                    ]);
}