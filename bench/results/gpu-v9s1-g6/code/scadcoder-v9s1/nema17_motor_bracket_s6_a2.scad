// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate flat on the bed, motor plate standing up

// ---------------- Parameters ----------------
plate_x1      = -25;   // base plate X start
plate_x2      = 25;    // base plate X end
plate_y1      = 0;     // base plate Y start
plate_y2      = 45;    // base plate Y end
plate_z       = 5;     // base plate thickness (Z)

motor_x1      = -25;   // motor plate X start
motor_x2      = 25;    // motor plate X end
motor_y1      = 0;     // motor plate Y start (flush with base edge)
motor_y2      = 5;     // motor plate Y end (thickness)
motor_h       = 50;    // motor plate height (Z)

boss_d        = 23;    // motor centring boss hole diameter
boss_x        = 0;     // boss hole X centre
boss_z        = 28;    // boss hole Z centre

screw_d       = 3.4;   // M3 screw hole diameter
screw_pitch   = 31;    // square pattern side length
screw_count   = 4;     // number of screw holes

gusset_t      = 5;     // gusset thickness (X)
gusset_y      = 20;    // gusset leg along +Y
gusset_z      = 20;    // gusset leg along +Z

eps           = 0.5;   // cutter overshoot past faces

$fn = 96;              // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([plate_x1, plate_y1, 0])
            cube([plate_x2 - plate_x1, plate_y2 - plate_y1, plate_z]);

        // Vertical motor plate
        translate([motor_x1, motor_y1, 0])
            cube([motor_x2 - motor_x1, motor_y2 - motor_y1, motor_h]);

        // Triangular gussets (right-angle corner at y = 5, z = 5)
        for (sx = [-1, 1])
            translate([sx * (motor_x2 - gusset_t), gusset_y, gusset_z])
                cube([gusset_t, gusset_y, gusset_z]);
    }

    // Base plate M4 through-holes
    for (h = [plate_z - eps, plate_z + eps])
        translate([-17, 30, h])
            cylinder(d = 4.5, h = plate_z + 2 * eps);

    // Motor boss hole (along Y) and M3 screw pattern
    translate([boss_x, motor_y2 + eps, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y2 + 2 * eps);

    for (i = [0 : screw_count - 1])
        for (j = [0 : screw_count - 1])
            translate([(i - (screw_count - 1) / 2) * screw_pitch,
                       (j - (screw_count - 1) / 2) * screw_pitch,
                       -eps])
                cylinder(d = screw_d, h = motor_y2 + 2 * eps);
}