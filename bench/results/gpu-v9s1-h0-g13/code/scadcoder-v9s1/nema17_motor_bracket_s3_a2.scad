// L-shaped mounting bracket for a NEMA 17 stepper motor
// Print orientation: base plate on the bed (z = 0), vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
$fn = 64;               // curve resolution

// Base plate
base_x0 = -25;          // base plate, left edge (X)
base_x1 = 25;           // base plate, right edge (X)
base_y0 = 0;            // base plate, front edge (Y)
base_y1 = 45;           // base plate, back edge (Y)
base_z0 = 0;            // base plate, bottom face (Z)
base_z1 = 5;            // base plate, top face (Z)

// Base plate through-holes (M4)
hole_m4_x = -17;        // hole centre X position
hole_m4_y = 30;         // hole centre Y position
hole_m4_d = 4.5;        // hole diameter

// Vertical motor plate
motor_x0 = -25;         // motor plate, left edge (X)
motor_x1 = 25;          // motor plate, right edge (X)
motor_y0 = 0;           // motor plate, front edge (Y)
motor_y1 = 5;           // motor plate, back edge (Y)
motor_z0 = 0;           // motor plate, bottom face (Z)
motor_z1 = 50;          // motor plate, top face (Z)

// Motor boss hole (through motor plate along Y)
boss_d = 23;            // hole diameter
boss_x = 0;             // hole centre X
boss_z = 28;            // hole centre Z

// M3 screw holes on square pattern, centred on boss hole
screw_d = 3.4;          // screw hole diameter
screw_n = 4;            // number of screw holes
screw_p = 31;           // square pattern pitch (side length)

// Gussets (5 mm thick, flush with left/right edges)
gusset_t = 5;           // gusset thickness along X
gusset_h = 20;          // gusset leg along +Z
gusset_y = 5;           // gusset leg along +Y (extends past both plates for a solid joint)

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate with two vertical through-holes
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -1])
                cylinder(d = hole_m4_d, h = base_z1 - base_z0 + 2);

        // Vertical motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Boss hole for motor centring boss
        translate([boss_x, motor_y1 + 1, boss_z])
            rotate([90, 0, 0])
                cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2);

        // M3 screw holes on a 31 mm square pattern
        for (i = [0 : screw_n - 1]) {
            a = i * 90;
            translate([boss_x, motor_y1 + 1, boss_z + (i < 2 ? -1 : 1)])
                rotate([0, 90, a])
                    cylinder(d = screw_d, h = screw_p);
        }

        // Triangular gussets, flush with the left and right edges
        for (gx = [motor_x0, motor_x1 - gusset_t])
            translate([gx, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [gusset_y, gusset_h],
                            [gusset_y + 1, gusset_h],
                            [gusset_y + 1, 0]
                        ]);
    }
}