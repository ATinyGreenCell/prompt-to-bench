// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, vertical plate builds up in +Z

// ---------------- Parameters ----------------
base_x      = 25;     // base plate extends x = -base_x .. +base_x
base_y      = 45;     // base plate extends y = 0 .. base_y
base_t      = 5;      // base plate thickness (z)

hole_m4_x   = 17;     // M4 hole x offset from origin (holes at +/- x)
hole_m4_y   = 30;     // M4 hole y position
hole_m4_d   = 4.5;    // M4 hole diameter

motor_x     = 25;     // motor plate extends x = -motor_x .. +motor_x
motor_y     = 5;      // motor plate extends y = 0 .. motor_y
motor_h     = 50;     // motor plate height (z)

boss_d      = 23;     // motor centring boss hole diameter
boss_x      = 0;      // boss hole x centre
boss_z      = 28;     // boss hole z centre

screw_d     = 3.4;    // M3 screw hole diameter
screw_pitch = 31;     // square pattern side length
screw_n     = 4;      // number of screw holes

gusset_t    = 5;      // gusset thickness (x)
gusset_leg  = 20;     // right triangle legs along +Y and +Z
gusset_x0   = -25;    // left gusset x start
gusset_x1   = 25;     // right gusset x start

eps         = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([-base_x, 0, 0]) cube([2*base_x, base_y, base_t]);
        for (sx = [-1, 1])
            translate([sx*hole_m4_x, hole_m4_y, -eps])
                cylinder(d = hole_m4_d, h = base_t + 2*eps);
    }

    // Vertical motor plate with boss hole and M3 screw holes
    difference() {
        translate([-motor_x, 0, 0]) cube([2*motor_x, motor_y, motor_h]);
        translate([boss_x, -eps, boss_z])
            cylinder(d = boss_d, h = motor_y + 2*eps);
        for (i = [0:3]) {
            a = (i < 2) ? 0 : 90;
            translate([0, -eps, boss_z + (i < 2 ? 0 : motor_y - boss_z)])
                rotate([0, 0, a])
                    translate([-screw_pitch/2, 0, 0])
                        cylinder(d = screw_d, h = motor_y + 2*eps);
        }
    }

    // Triangular gussets flush with left and right edges
    for (sx = [-1, 1]) {
        x1 = sx == -1 ? gusset_x0 : gusset_x1;
        translate([x1, 5, 5])
            linear_extrude(gusset_t)
                translate([-gusset_leg, 0, 0])
                    cube([gusset_leg, gusset_leg, 1]);
    }
}