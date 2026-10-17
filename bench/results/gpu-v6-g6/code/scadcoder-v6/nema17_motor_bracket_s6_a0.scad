// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate builds upward (+Z)

$fn = 64;

// ---- Base plate ----
base_x_min = -25;   // base plate X start
base_x_max = 25;    // base plate X end
base_y_min = 0;     // base plate Y start
base_y_max = 45;    // base plate Y end
base_z_max = 5;     // base plate thickness

// ---- Motor plate ----
motor_x_min = -25;  // motor plate X start
motor_x_max = 25;  // motor plate X end
motor_y_max = 5;   // motor plate thickness (Y)
motor_z_max = 50;  // motor plate height (Z)

// ---- Boss hole (motor centring) ----
boss_d = 23;        // boss hole diameter
boss_x = 0;         // boss hole X centre
boss_z = 28;        // boss hole Z centre

// ---- Screw holes (M3) ----
screw_d = 3.4;      // screw hole diameter
screw_pitch = 31;   // square pattern side length

// ---- Gussets ----
gusset_x_min = -25; // gusset X start (left edge)
gusset_x_end = -20; // gusset X end
gusset_leg = 20;    // triangle leg length (Y and Z)

// ---- Cutting overlap ----
eps = 0.5;          // extension past cut faces

difference() {
    union() {
        // Base plate
        translate([base_x_min, base_y_min, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_max]);

        // Motor plate, standing on back edge of base
        translate([motor_x_min, motor_y_max - motor_y_max, 0])
            cube([motor_x_max - motor_x_min, motor_y_max, motor_z_max]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? gusset_x_end : gusset_x_min, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = motor_x_max - motor_x_min)
                        polygon([[gusset_leg, gusset_leg], [0, gusset_leg], [gusset_leg, 0]]);
    }

    // Base plate through-holes (M4)
    for (bx = [-17, 17])
        translate([bx, base_y_min - eps, 0])
            cylinder(d = 4.5, h = base_z_max + 2 * eps);

    // Boss hole along Y
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y_max + 2 * eps);

    // M3 screw holes on square pattern centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([boss_x - screw_pitch / 2, 0, boss_z])
                cylinder(d = screw_d, h = motor_z_max + eps);
}