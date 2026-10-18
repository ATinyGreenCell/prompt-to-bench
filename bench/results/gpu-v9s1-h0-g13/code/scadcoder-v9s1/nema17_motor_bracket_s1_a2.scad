// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

$fn = 64;

// ---------------- Dimensions (mm) ----------------
base_x0      = -25;   // base plate X start
base_x1      = 25;    // base plate X end
base_y0      = 0;     // base plate Y start
base_y1      = 45;    // base plate Y end
base_z       = 5;     // base plate Z thickness

motor_x0     = -25;   // motor plate X start
motor_x1     = 25;    // motor plate X end
motor_y      = 5;     // motor plate Y thickness (sits on base back edge)
motor_z      = 50;    // motor plate Z height

hole_m4_x    = -17;   // M4 holes X position (+/-)
hole_m4_y    = 30;    // M4 holes Y position
hole_m4_r    = 2.25;  // M4 hole radius

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_n      = 4;     // screw holes count
screw_p      = 31;    // square pattern side length

gusset_t     = 5;     // gusset thickness (X)
gusset_w     = 20;    // gusset leg along Y
gusset_h     = 20;    // gusset leg along Z
gusset_x0    = -25;   // gusset X start (left and right edges)
gusset_x1    = -20;   // gusset X end (left side)

eps          = 0.5;   // cutter overshoot

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -eps])
                cylinder(r = hole_m4_r, h = base_z + 2 * eps);
    }

    // Motor plate standing on the back edge of the base
    difference() {
        translate([motor_x0, base_y1 - motor_y, 0])
            cube([motor_x1 - motor_x0, motor_y, motor_z]);
        // Boss hole (along Y), centred at x = 0, z = 28
        translate([boss_x, base_y1 - motor_y - eps, boss_z])
            rotate([0, 90, 0])
                cylinder(d = boss_d, h = motor_y + 2 * eps);
        // Four M3 screw holes on a 31 mm square pattern
        for (a = [0, 90, 180, 270])
            translate([boss_x + screw_p / 2 * cos(a),
                       base_y1 - motor_y - eps,
                       boss_z + screw_p / 2 * sin(a)])
                cylinder(d = screw_d, h = motor_z + 2 * eps);
    }

    // Triangular gussets, flush with left and right edges
    // Right-angle corner at y = 5, z = 5; extruded along X
    for (gx = [gusset_x0, gusset_x1]) {
        translate([gx, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, 0],
                        [gusset_w, 0],
                        [gusset_w, gusset_h]
                    ]);
    }
}