// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building up in +Z

// ---------------- Parameters ----------------
base_x1      = -25;   // base plate left edge (X)
base_x2      = 25;    // base plate right edge (X)
base_y       = 45;    // base plate length (Y)
base_t       = 5;     // base plate thickness (Z)

hole_m4_x    = -17;   // M4 through-hole centre X (base plate)
hole_m4_y    = 30;    // M4 through-hole centre Y (base plate)
hole_m4_x2   = 17;    // M4 through-hole centre X (second, base plate)

motor_x1     = -25;   // motor plate left edge (X)
motor_x2     = 25;    // motor plate right edge (X)
motor_y      = 5;     // motor plate thickness (Y)
motor_z      = 50;    // motor plate height (Z)

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
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x1, 0, 0])
            cube([base_x2 - base_x1, base_y, base_t]);

        // Motor plate (stands on back edge of base)
        translate([motor_x1, 0, 0])
            cube([motor_x2 - motor_x1, motor_y, motor_z]);

        // Left gusset, flush with left edge (x = -25 to -20)
        translate([-25, 5, 5])
            linear_extrude([gusset_t])
                polygon([[0, 0], [gusset_y, 0], [0, gusset_z]]);

        // Right gusset, flush with right edge (x = 20 to 25)
        translate([20, 5, 5])
            linear_extrude([gusset_t])
                polygon([[0, 0], [gusset_y, 0], [0, gusset_z]]);
    }

    // Base plate through-holes (M4)
    translate([hole_m4_x, hole_m4_y, -eps])
        cylinder(d = 4.5, h = base_t + 2 * eps);

    translate([hole_m4_x2, hole_m4_y, -eps])
        cylinder(d = 4.5, h = base_t + 2 * eps);

    // Motor plate boss hole (along Y)
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_d, h = motor_y + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : screw_n - 1]) {
        a = screw_pitch / sqrt(2);   // offset from centre along X and Y
        x = (i % 2 == 0) ? -a : a;
        y = (i % 2 == 1) ? -a : a;
        translate([x, y, -eps])
            cylinder(d = screw_d, h = motor_z + 2 * eps);
    }
}