// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

// ---------------- Parameters ----------------
$fn = 64;

// Base plate
base_x0 = -25;   // base plate X start
base_x1 = 25;    // base plate X end
base_y0 = 0;     // base plate Y start
base_y1 = 45;    // base plate Y end
base_z0 = 0;     // base plate Z start
base_z1 = 5;     // base plate Z end
hole_m4_x = -17; // M4 hole X position (both holes)
hole_m4_y = 30;  // M4 hole Y position (both holes)
hole_m4_d = 4.5; // M4 hole diameter

// Vertical motor plate
motor_x0 = -25;  // motor plate X start
motor_x1 = 25;   // motor plate X end
motor_y0 = 0;    // motor plate Y start
motor_y1 = 5;    // motor plate Y end
motor_z0 = 0;    // motor plate Z start
motor_z1 = 50;   // motor plate Z end

// Motor plate boss hole (through along Y)
boss_hole_d = 23; // boss hole diameter
boss_hole_x = 0;  // boss hole X centre
boss_hole_z = 28; // boss hole Z centre

// Motor plate screw holes (M3, through along Y)
screw_d = 3.4;    // screw hole diameter
screw_pattern = 31; // square pitch for screw holes
screw_count = 4;   // number of screw holes

// Gussets (5 mm thick, flush with left/right edges)
gusset_t = 5;     // gusset thickness along X
gusset_y0 = 5;    // gusset Y start (right-angle corner)
gusset_z0 = 5;    // gusset Z start (right-angle corner)
gusset_y1 = 25;   // gusset Y end (leg length 20 mm)
gusset_z1 = 25;   // gusset Z end (leg length 20 mm)

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -1])
                cylinder(d = hole_m4_d, h = base_z1 + 2);
    }

    // Vertical motor plate standing on the back edge of the base
    difference() {
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);
        // Boss hole, centred on x = 0, z = 28, running along Y
        translate([boss_hole_x, -1, boss_hole_z])
            rotate([90, 0, 0])
                cylinder(d = boss_hole_d, h = motor_y1 - motor_y0 + 2);
        // Screw holes on a 31 mm square pattern, centred on the boss hole
        for (i = [0 : screw_count - 1]) {
            a = (i < 2) ? -screw_pattern / 2 : screw_pattern / 2;
            b = (i < 2) ? -screw_pattern / 2 : screw_pattern / 2;
            translate([a, 0, b])
                cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2);
        }
    }

    // Triangular gussets, flush with the left and right edges
    for (gx = [gusset_x0 = -25, gusset_x1 = 20]) {
        translate([gx, gusset_y0, gusset_z0])
            cube([gusset_t, gusset_y1 - gusset_y0, gusset_z1 - gusset_z0]);
    }
}