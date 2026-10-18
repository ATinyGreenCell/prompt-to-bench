// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g., syringe pump)
// Print orientation: base plate lies on the bed (z = 0), motor plate builds upward.

// ---------------- Parameters ----------------
base_x      = 25;    // base plate half-width (X: -25 to 25)
base_y      = 45;    // base plate length (Y: 0 to 45)
base_t      = 5;     // base plate thickness (Z: 0 to 5)

motor_h     = 50;    // motor plate height (Z: 0 to 50)
motor_w     = 5;     // motor plate thickness (Y: 0 to 5)

boss_d      = 23;    // motor centring-boss hole diameter
boss_x      = 0;     // hole centre X
boss_z      = 28;    // hole centre Z

screw_d     = 3.4;   // M3 screw hole diameter
screw_s     = 31;    // square pattern side length
screw_n     = 4;     // number of screw holes

gusset_t    = 5;     // gusset thickness (X direction)
gusset_y    = 20;    // gusset leg along +Y (from y = 5)
gusset_z    = 20;    // gusset leg along +Z (from z = 5)

eps         = 0.5;   // cutter overshoot past faces

$fn = 96;            // curve resolution

// ---------------- Model ----------------
difference() {
    // --- Bodies ---
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2 * base_x, base_y, base_t]);

        // Motor plate (standing on the back edge of the base)
        translate([-base_x, motor_w, 0])
            cube([2 * base_x, motor_w, motor_h]);

        // Triangular gussets, flush with the left and right edges
        // Right triangle in YZ: legs 20 mm along +Y and +Z, right angle at (y = 5, z = 5)
        for (sx = [-1, 1])
            translate([sx * (base_x - gusset_t), 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon([[gusset_y, gusset_z], [5, gusset_z], [5, 5]]);
    }

    // --- Cutouts ---
    // Motor-boss hole, through along Y, centred at x = 0, z = 28
    translate([boss_x, motor_w + eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_w + 2 * eps);

    // Four M3 screw holes on a 31 mm square pattern, centred on the boss hole
    for (i = [0 : screw_n - 1]) {
        a = 45 + i * 90;
        r = screw_s / 2;
        translate([r * cos(a), r * sin(a), -eps])
            cylinder(d = screw_d, h = motor_h + 2 * eps);
    }
}