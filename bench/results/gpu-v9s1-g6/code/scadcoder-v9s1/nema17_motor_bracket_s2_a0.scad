// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed, motor plate builds upward (+Z)

// ---------------- Parameters ----------------
$fn = 64;

// Base plate
base_x0 = -25;   // base plate X start
base_x1 = 25;    // base plate X end
base_y0 = 0;     // base plate Y start
base_y1 = 45;    // base plate Y end
base_z0 = 0;     // base plate Z start
base_z1 = 5;     // base plate Z end
mount_hole_d = 4.5;  // M4 through-holes diameter
mount_hole_x = [-17, 17]; // through-hole X positions
mount_hole_y = 30;      // through-hole Y position

// Motor plate
motor_x0 = -25;  // motor plate X start
motor_x1 = 25;   // motor plate X end
motor_y0 = 0;    // motor plate Y start
motor_y1 = 5;    // motor plate Y end
motor_z0 = 0;    // motor plate Z start
motor_z1 = 50;   // motor plate Z end

// Boss hole (motor centring)
boss_d = 23;     // boss hole diameter
boss_x = 0;      // boss hole X centre
boss_z = 28;     // boss hole Z centre

// Screw holes for boss
screw_d = 3.4;   // M3 screw diameter
screw_n = 4;     // number of screw holes
screw_s = 31;    // square pattern side length

// Gussets
gusset_t = 5;    // gusset thickness (along X)
gusset_w = 20;   // gusset leg along +Y
gusset_h = 20;   // gusset leg along +Z

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Left gusset (x = -25 to -20)
        translate([-25, 5, 5])
            cube([gusset_t, gusset_w, gusset_h]);

        // Right gusset (x = 20 to 25)
        translate([20, 5, 5])
            cube([gusset_t, gusset_w, gusset_h]);
    }

    // Base plate through-holes
    for (x = mount_hole_x)
        translate([x, mount_hole_y, -1])
            cylinder(d = mount_hole_d, h = base_z1 + 2);

    // Boss hole
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2);

    // Screw holes on square pattern
    for (i = [0 : screw_n - 1]) {
        a = (i < 2) ? 0 : 90;
        translate([boss_x + (i < 2 ? -screw_s / 2 : screw_s / 2),
                   boss_z + (i >= 2 ? -screw_s / 2 : screw_s / 2)])
            rotate([0, 0, a])
                cylinder(d = screw_d, h = motor_z1 + 2);
    }
}