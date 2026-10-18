// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), vertical plate builds upward.

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate x start
base_x1      = 25;    // base plate x end
base_y0      = 0;     // base plate y start
base_y1      = 45;    // base plate y end
base_z       = 5;     // base plate thickness

motor_x0     = -25;   // motor plate x start
motor_x1     = 25;    // motor plate x end
motor_y0     = 0;     // motor plate y start
motor_y1     = 5;     // motor plate y end (on back edge of base)
motor_z      = 50;    // motor plate height

hole_m4_x1   = -17;   // M4 through-hole x position 1
hole_m4_y1   = 30;    // M4 through-hole y position 1
hole_m4_x2   = 17;    // M4 through-hole x position 2
hole_m4_y2   = 30;    // M4 through-hole y position 2
hole_m4      = 4.5;   // M4 hole diameter

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole centre x
boss_z       = 28;    // boss hole centre z
screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length

gusset_t     = 5;     // gusset thickness (along X)
gusset_leg   = 20;    // right triangle leg length (Y and Z)
gusset_x0    = -25;   // left gusset x start
gusset_x1    = -20;   // left gusset x end
gusset_y0    = 5;     // gusset bottom y
gusset_z0    = 5;     // gusset side z

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z]);

        // Left triangular gusset
        translate([gusset_x0, gusset_y0, gusset_z0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[0, 0], [gusset_leg, 0], [0, gusset_leg]]);

        // Right triangular gusset
        translate([gusset_x1, gusset_y0, gusset_z0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[0, 0], [gusset_leg, 0], [0, gusset_leg]]);
    }

    // M4 through-holes in base plate
    for (i = [1, 2])
        translate([i == 1 ? hole_m4_x1 : hole_m4_x2,
                   i == 1 ? hole_m4_y1 : hole_m4_y2,
                   -eps])
            cylinder(d = hole_m4, h = base_z + 2 * eps);

    // Motor boss hole (along Y)
    translate([boss_x, motor_y0 - eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on square pattern centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pitch / 2, 0, 0])
                cylinder(d = screw_d, h = motor_z + eps);
}