// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate building up in +Z

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
motor_y_min = 0;   // motor plate Y start
motor_y_max = 5;   // motor plate Y end (on back edge of base)
motor_z_max = 50;  // motor plate height

// ---- Boss hole ----
boss_d = 23;        // motor boss hole diameter
boss_x = 0;         // boss hole X centre
boss_z = 28;        // boss hole Z centre

// ---- Screw holes ----
screw_d = 3.4;      // M3 screw hole diameter
screw_pattern = 31; // square pattern side length

// ---- Gussets ----
gusset_x_min = -25; // left gusset X start
gusset_x_max = -20; // left gusset X end
gusset_y_max = 5;   // gusset leg along Y
gusset_z_max = 5;   // gusset leg along Z
gusset_t = 5;       // gusset thickness (X direction)

// ---- Cutting overlap ----
eps = 0.5;          // extension past cut faces

difference() {
    union() {
        // Base plate with two vertical through-holes (M4)
        translate([base_x_min, base_y_min, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_max]);
        for (sx = [-17, 17])
            translate([sx, base_y_min, -eps])
                cylinder(d = 4.5, h = base_z_max + 2 * eps);

        // Vertical motor plate standing on back edge of base
        translate([motor_x_min, motor_y_min, 0])
            cube([motor_x_max - motor_x_min, motor_y_max - motor_x_min, motor_z_max]);

        // Triangular gussets flush with left and right edges
        for (sx = [gusset_x_min, gusset_x_max])
            translate([sx, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [[0, 0], [gusset_y_max, 0], [0, gusset_z_max]]);
    }

    // Boss hole through motor plate along Y
    translate([boss_x, motor_y_min - eps, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y_max - motor_y_min + 2 * eps);

    // Four M3 screw holes on 31 mm square pattern centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([0, 0, -eps])
                cylinder(d = screw_d, h = motor_z_max + 2 * eps);
}