// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, motor plate builds upward (+Z)

$fn = 64;

// ---- Base plate ----
base_x0 = -25;   // base plate: x start
base_x1 = 25;    // base plate: x end
base_y0 = 0;     // base plate: y start
base_y1 = 45;    // base plate: y end
base_z0 = 0;     // base plate: z start
base_z1 = 5;     // base plate: z end

// ---- Motor plate ----
motor_x0 = -25;  // motor plate: x start
motor_x1 = 25;   // motor plate: x end
motor_y0 = 0;    // motor plate: y start
motor_y1 = 5;    // motor plate: y end
motor_z0 = 0;    // motor plate: z start
motor_z1 = 50;   // motor plate: z end

// ---- Through-holes (base plate) ----
hole_x = -17;    // hole x position (left)
hole_y = 30;     // hole y position
hole_d = 4.5;    // hole diameter (M4)

// ---- Motor boss hole ----
boss_d  = 23;    // boss hole diameter (along Y)
boss_x  = 0;     // boss hole centre x
boss_z  = 28;    // boss hole centre z

// ---- Screw holes ----
screw_d  = 3.4;  // screw hole diameter (M3)
screw_n  = 4;    // number of screw holes
screw_p  = 31;   // square pattern pitch
screw_x0 = -15.5; // first screw x (counter-clockwise from +X axis)
screw_z0 = -15.5; // first screw z

// ---- Gussets ----
gusset_t = 5;    // gusset thickness (X)
gusset_l = 20;   // gusset leg length (Y and Z)
gusset_x0 = -25; // gusset left edge x
gusset_x1 = -20; // gusset right edge x

// ---- Misc ----
eps = 0.5;       // cutter overshoot past faces

difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Gussets: right triangles in YZ plane, flush with left edge
        translate([gusset_x0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_x0 - (gusset_x1 - gusset_x0) / 2, gusset_l],
                        [gusset_x0 - (gusset_x1 - gusset_x0) / 2, 0],
                        [gusset_x1 - (gusset_x1 - gusset_x0) / 2, 0]
                    ]);
    }

    // Base plate through-holes
    for (sx = [-1, 1])
        translate([sx * hole_x, hole_y, -eps])
            cylinder(d = hole_d, h = base_z1 - base_z0 + 2 * eps);

    // Motor boss hole
    translate([boss_x, 0, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // Screw holes on square pattern
    for (i = [0 : screw_n - 1]) {
        angle = i * 90;
        translate([screw_x0 + (i % 2) * screw_p,
                   screw_z0 + (i / 2) * screw_p,
                   -eps])
            rotate([0, 0, angle])
                cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2 * eps);
    }
}