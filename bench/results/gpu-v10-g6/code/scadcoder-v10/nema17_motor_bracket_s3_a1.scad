// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building upward.

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate, x start (mm)
base_x1      = 25;    // base plate, x end (mm)
base_y0      = 0;     // base plate, y start (mm)
base_y1      = 45;    // base plate, y end (mm)
base_z0      = 0;     // base plate, z start (mm)
base_z1      = 5;     // base plate, z end (mm)
base_hole_r  = 2.25;  // M4 through-hole radius (mm)
base_hole_x  = -17;   // base through-hole x offset (mm)
base_hole_y  = 30;    // base through-hole y offset (mm)

motor_x0     = -25;   // motor plate, x start (mm)
motor_x1     = 25;    // motor plate, x end (mm)
motor_y0     = 0;     // motor plate, y start (mm)
motor_y1     = 5;     // motor plate, y end (mm)
motor_z0     = 0;     // motor plate, z start (mm)
motor_z1     = 50;    // motor plate, z end (mm)
motor_boss_r = 11.5;  // motor boss hole radius (mm)
motor_boss_z = 28;    // motor boss hole centre height (mm)
motor_screw_r = 1.7;  // M3 screw hole radius (mm)
motor_screw_p = 31;   // motor screw pattern size (mm)

gusset_t     = 5;     // gusset thickness (mm)
gusset_leg   = 20;    // gusset leg length (mm)

eps          = 0.5;   // cutter overshoot (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
union() {
    // Base plate with two M4 through-holes
    difference() {
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1]);
        for (sx = [-1, 1])
            translate([sx * base_hole_x, base_hole_y, -eps])
                cylinder(r = base_hole_r, h = base_z1 + 2 * eps);
    }

    // Vertical motor plate with boss hole and four M3 screw holes
    difference() {
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1]);
        translate([0, -eps, motor_boss_z])
            cylinder(r = motor_boss_r, h = motor_y1 - motor_y0 + 2 * eps);
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([motor_screw_p / 2, -eps, motor_boss_z])
                    cylinder(r = motor_screw_r, h = motor_y1 - motor_y0 + 2 * eps);
    }

    // Right-hand gusset, flush with the motor plate
    translate([motor_x0 + gusset_t, gusset_leg, gusset_leg])
        cube([gusset_t, gusset_leg, gusset_leg]);

    // Left-hand gusset, flush with the base plate
    translate([base_x1 - gusset_t, gusset_leg, gusset_leg])
        cube([gusset_t, gusset_leg, gusset_leg]);
}