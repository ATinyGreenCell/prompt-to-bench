// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed, motor plate building up in +Z

$fn = 64;

// ---- Base plate ----
base_x0 = -25;   // x start
base_x1 = 25;    // x end
base_y0 = 0;     // y start
base_y1 = 45;    // y end
base_z0 = 0;     // z start
base_z1 = 5;     // z end

// ---- Through holes (M4) ----
hole_x  = -17;   // hole 1 x
hole_y  = 30;    // hole 1 y
hole_d  = 4.5;   // hole diameter
hole_x2 = 17;    // hole 2 x
hole_y2 = 30;    // hole 2 y

// ---- Motor plate ----
motor_x0 = -25;  // x start
motor_x1 = 25;   // x end
motor_y0 = 0;    // y start
motor_y1 = 5;    // y end
motor_z0 = 0;    // z start
motor_z1 = 50;   // z end

// ---- Boss hole (motor centring) ----
boss_d  = 23;    // hole diameter
boss_x  = 0;     // hole centre x
boss_z  = 28;    // hole centre z

// ---- Screw holes (M3) ----
screw_d  = 3.4;  // hole diameter
screw_n  = 4;    // number of holes
screw_a  = 31;   // square pattern size

// ---- Gussets ----
gusset_t = 5;    // thickness
gusset_x0 = -25; // left edge x
gusset_x1 = -20; // right edge x
gusset_y0 = 5;   // right-angle corner y
gusset_z0 = 5;   // right-angle corner z
gusset_h = 20;   // leg length along +Y and +Z

// ---- Misc ----
eps = 0.5;       // cutter overshoot

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Gussets (right triangle in YZ, extruded along X)
        for (x = [gusset_x0, gusset_x1])
            translate([x, gusset_y0, gusset_z0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [[0, 0], [gusset_h, 0], [0, gusset_h]]);
    }

    // Base plate through holes
    for (h = [[hole_x, hole_y], [hole_x2, hole_y2]])
        translate([h[0], h[1], -eps])
            cylinder(d = hole_d, h = base_z1 - base_z0 + 2 * eps);

    // Boss hole
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // Screw holes
    for (i = [0 : screw_n - 1])
        rotate([0, 0, i < screw_n - 1 ? 90 : 0])
            translate([0, screw_a * i, 0])
                cylinder(d = screw_d, h = motor_z1 - motor_z0 + eps);
}