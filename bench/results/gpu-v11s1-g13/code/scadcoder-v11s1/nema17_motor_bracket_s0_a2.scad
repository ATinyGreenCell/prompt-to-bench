// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building upward (+Z)

$fn = 64;

// ---------------- Dimensions (mm) ----------------
// Base plate
base_x0 = -25;    // base plate x start
base_x1 = 25;     // base plate x end
base_y0 = 0;      // base plate y start
base_y1 = 45;     // base plate y end
base_z1 = 5;      // base plate thickness (z 0..5)

// Motor plate
motor_x0 = -25;   // motor plate x start
motor_x1 = 25;    // motor plate x end
motor_y0 = 0;     // motor plate y start
motor_y1 = 5;     // motor plate y end (z 0..50)
motor_z1 = 50;    // motor plate height

// Through-holes
hole_m4_x = [-17, 17]; // M4 holes at x = -17 and x = 17
hole_m4_y = 30;      // M4 holes at y = 30
hole_m4_d = 4.5;    // M4 hole diameter

// Motor boss hole
boss_d = 23;       // boss hole diameter (along Y)
boss_x = 0;        // boss hole centre x
boss_z = 28;       // boss hole centre z

// Screw holes
screw_d = 3.4;     // M3 screw hole diameter
screw_pitch = 31;  // square pattern side length
screw_count = 4;   // number of screw holes

// Gussets
gusset_t = 5;      // gusset thickness (X)
gusset_l = 20;     // triangle leg along +Y
gusset_h = 20;     // triangle leg along +Z
gusset_x0 = -25;   // left gusset x start
gusset_x1 = 25;    // right gusset x end

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1]);

        // Motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1]);

        // Gussets: right triangle in YZ, flush with left/right edges
        for (x = [gusset_x0, gusset_x1])
            translate([x, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon([[0, 5], [gusset_l, 5], [0, gusset_h]]);
    }

    // M4 through-holes
    for (x = hole_m4_x)
        translate([x, hole_m4_y, -1])
            cylinder(d = hole_m4_d, h = base_z1 + motor_z1 + 2);

    // Boss hole for motor centring boss
    translate([boss_x, -1, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2);

    // M3 screw holes on square pattern centred on boss hole
    for (i = [0 : screw_count - 1]) {
        angle = i * 90;
        translate([boss_x, boss_x, -1])
            rotate([0, 0, angle])
                translate([0, -screw_pitch / 2, -screw_pitch / 2])
                    cylinder(d = screw_d, h = motor_z1 + 2);
    }
}