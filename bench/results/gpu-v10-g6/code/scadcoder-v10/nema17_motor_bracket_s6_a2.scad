// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate building up in +Z

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate X start
base_x1      = 25;    // base plate X end
base_y0      = 0;     // base plate Y start
base_y1      = 45;    // base plate Y end
base_z0      = 0;     // base plate Z start
base_z1      = 5;     // base plate Z end

hole_m4_x    = -17;   // M4 hole X position (left)
hole_m4_y    = 30;    // M4 hole Y position
hole_m4_d    = 4.5;   // M4 hole diameter

hole_m4_x_r  = 17;    // M4 hole X position (right)
hole_m4_y    = 30;    // M4 hole Y position (same)
hole_m4_d    = 4.5;   // M4 hole diameter (same)

motor_x0     = -25;   // motor plate X start
motor_x1     = 25;    // motor plate X end
motor_y0     = 0;     // motor plate Y start
motor_y1     = 5;     // motor plate Y end
motor_z0     = 0;     // motor plate Z start
motor_z1     = 50;    // motor plate Z end

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_n      = 4;     // number of screw holes
screw_a      = 31;    // screw pattern size (square side)

gusset_t     = 5;     // gusset thickness (X)
gusset_y0    = 5;     // gusset leg along Y (from plate joint)
gusset_z0    = 5;     // gusset leg along Z (from plate joint)

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        for (h = [-1, 1])
            translate([h * hole_m4_x, hole_m4_y, -eps])
                cylinder(d = hole_m4_d, h = base_z1 - base_z0 + 2 * eps);
    }

    // Vertical motor plate with boss hole and M3 screw holes
    difference() {
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Boss hole along Y
        translate([boss_x, -eps, boss_z])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

        // Screw holes on square pattern, centred on boss
        for (i = [0 : screw_n - 1])
            rotate([0, 0, i < screw_n - 1 ? 90 : 0])
                translate([screw_a / 2, 0, 0])
                    cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2 * eps);
    }

    // Left gusset (flush with x = -25)
    translate([base_x0 - gusset_t, gusset_y0, gusset_z0])
        cube([gusset_t, gusset_y1 := 20, gusset_z1 := 20]);

    // Right gusset (flush with x = 25)
    translate([base_x1 - gusset_t, gusset_y0, gusset_z0])
        cube([gusset_t, gusset_y1 := 20, gusset_z1 := 20]);
}