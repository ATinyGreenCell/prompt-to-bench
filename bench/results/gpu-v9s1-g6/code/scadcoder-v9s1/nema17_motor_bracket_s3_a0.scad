// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, vertical plate building upward.

// ---------------- Parameters ----------------
$fn = 64;

// Base plate
base_x0 = -25;      // base plate, left edge (X)
base_x1 = 25;       // base plate, right edge (X)
base_y0 = 0;        // base plate, front edge (Y)
base_y1 = 45;       // base plate, back edge (Y)
base_z0 = 0;        // base plate, bottom face (Z)
base_z1 = 5;        // base plate, top face (Z)
hole_m4_x = -17;    // M4 through-holes, X position
hole_m4_y = 30;    // M4 through-holes, Y position
hole_m4_d = 4.5;   // M4 through-hole diameter

// Vertical motor plate
motor_x0 = -25;     // motor plate, left edge (X)
motor_x1 = 25;      // motor plate, right edge (X)
motor_y0 = 0;       // motor plate, front edge (Y)
motor_y1 = 5;       // motor plate, back edge (Y)
motor_z0 = 0;       // motor plate, bottom face (Z)
motor_z1 = 50;      // motor plate, top face (Z)

// Boss hole (motor centring boss)
boss_d = 23;        // boss hole diameter
boss_x = 0;         // boss hole centre, X
boss_z = 28;        // boss hole centre, Z

// Screw holes for boss
screw_d = 3.4;      // M3 screw hole diameter
screw_n = 4;        // number of screw holes
screw_p = 31;       // square pattern pitch (side length)

// Gussets
gusset_t = 5;       // gusset thickness (along X)
gusset_l = 20;      // gusset leg along +Y
gusset_h = 20;      // gusset leg along +Z

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate with M4 through-holes
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -1])
                cylinder(d = hole_m4_d, h = base_z1 + 2);

        // Vertical motor plate with boss hole and M3 screw holes
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);
        translate([boss_x, motor_y1, boss_z])
            rotate([90, 0, 0])
                cylinder(d = boss_d, h = motor_y1 - motor_y0 + 1);
        for (i = [0 : screw_n - 1]) {
            a = i * 90;
            translate([boss_x, motor_y1 + (i < 2 ? -1 : 1), boss_z + (i < 2 ? -1 : 1)])
                rotate([0, 90, a])
                    cylinder(d = screw_d, h = screw_p);
        }

        // Triangular gussets, flush with left and right edges
        for (gx = [-25, 20])
            translate([gx, motor_y0, motor_z0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, 0],
                        [gusset_l, 0],
                        [0, gusset_h]
                    ]);
    }
}