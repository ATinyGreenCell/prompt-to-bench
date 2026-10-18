// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building upward (+Z)

$fn = 64;

// ---------------- Dimensions (mm) ----------------
// Base plate
base_x0      = -25;   // plate x start
base_x1      = 25;    // plate x end
base_y0      = 0;     // plate y start
base_y1      = 45;    // plate y end
base_z       = 5;     // plate thickness (z)

// Motor plate
motor_x0     = -25;   // plate x start
motor_x1     = 25;    // plate x end
motor_y0     = 0;     // plate y start
motor_y1     = 5;     // plate y end
motor_z      = 50;    // plate height (z)

// Through-holes
hole_m4_x1   = -17;   // M4 hole x position (left)
hole_m4_y    = 30;    // M4 hole y position
hole_m4_d    = 4.5;   // M4 hole diameter
hole_m4_x2   = 17;    // M4 hole x position (right)

// Boss hole (motor centring boss)
boss_d       = 23;    // boss hole diameter
boss_x       = 0;     // boss hole centre x
boss_z       = 28;    // boss hole centre z

// Screw holes (M3, on square pattern)
screw_d      = 3.4;   // screw hole diameter
screw_pitch  = 31;    // square pattern side length
screw_count  = 4;     // number of screw holes

// Gussets
gusset_t     = 5;     // gusset thickness (x)
gusset_leg   = 20;    // right triangle leg length (along +Y and +Z)

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);

        // Motor plate, standing on the back edge of the base
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z]);

        // Gussets, flush with the left and right edges
        for (sx = [-1, 1])
            translate([sx * (base_x1 - gusset_t), motor_y0, 0])
                cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // Through-holes in the base plate
    for (x = [hole_m4_x1, hole_m4_x2])
        translate([x, hole_m4_y, -1])
            cylinder(d = hole_m4_d, h = base_z + 2);

    // Boss hole through the motor plate (along Y)
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2);

    // Screw holes on a square pattern, centred on the boss hole
    for (i = [0 : screw_count - 1]) {
        x = (i % 2 == 0) ? -screw_pitch / 2 : screw_pitch / 2;
        z = (i < 2) ? -screw_pitch / 2 : screw_pitch / 2;
        translate([x, 0, z])
            cylinder(d = screw_d, h = motor_z + 2);
    }
}