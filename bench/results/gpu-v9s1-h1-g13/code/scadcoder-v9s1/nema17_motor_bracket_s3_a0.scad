// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, motor plate building up in +Z

// ---------------- Parameters ----------------
plate_x      = 25;    // base plate half-width (X)
plate_y      = 45;    // base plate length (Y)
plate_t      = 5;     // base plate thickness (Z)

motor_h      = 50;    // motor plate height (Z)
motor_w      = 5;     // motor plate thickness (Y)

boss_d       = 23;    // motor boss hole diameter
boss_x       = 0;     // boss hole X position
boss_z       = 28;    // boss hole Z position

screw_d      = 3.4;   // M3 screw hole diameter
screw_p      = 31;    // square pattern side length
screw_n      = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness (X)
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Motor plate (standing on back edge of base)
        translate([-plate_x, plate_y - motor_w, 0])
            cube([plate_x * 2, motor_w, motor_h]);

        // Left gusset (flush with left edge, right-angle at y = 5, z = 5)
        translate([-plate_x, plate_y - motor_w, plate_t])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[gusset_y, gusset_z], [plate_t, gusset_z], [plate_t, plate_t]]);

        // Right gusset (flush with right edge)
        translate([plate_x - gusset_t, plate_y - motor_w, plate_t])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[gusset_y, gusset_z], [plate_t, gusset_z], [plate_t, plate_t]]);
    }

    // Base plate through-holes (M4)
    for (h = [plate_t, motor_h])
        translate([-17, 30, -eps])
            cylinder(d = 4.5, h = h + 2 * eps);

    // Motor boss hole (along Y)
    translate([boss_x, plate_y - motor_w - eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_w + 2 * eps);

    // M3 screw holes on square pattern centred on boss hole
    for (i = [0 : screw_n - 1])
        translate([(i - (screw_n - 1) / 2) * screw_p / 2,
                   (i - (screw_n - 1) / 2) * screw_p / 2,
                   -eps])
            cylinder(d = screw_d, h = motor_h + 2 * eps);
}