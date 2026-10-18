// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

// ---------------- Parameters ----------------
base_x0      = -25;    // base plate: x start
base_x1      = 25;     // base plate: x end
base_y0      = 0;      // base plate: y start
base_y1      = 45;     // base plate: y end
base_z1      = 5;      // base plate: z end

hole_m4_x1   = -17;    // M4 through-hole 1: x
hole_m4_y1   = 30;     // M4 through-hole 1: y
hole_m4_x2   = 17;     // M4 through-hole 2: x
hole_m4_y2   = 30;     // M4 through-hole 2: y
hole_m4_d    = 4.5;    // M4 hole diameter

motor_x0     = -25;    // motor plate: x start
motor_x1     = 25;     // motor plate: x end
motor_y0     = 0;      // motor plate: y start
motor_y1     = 5;      // motor plate: y end
motor_z1     = 50;     // motor plate: z end

boss_hole_d  = 23;     // motor centring boss hole diameter
boss_hole_x  = 0;      // boss hole centre: x
boss_hole_z  = 28;     // boss hole centre: z

screw_d      = 3.4;    // M3 screw hole diameter
screw_pitch  = 31;     // square pattern side length

gusset_t     = 5;      // gusset thickness (X)
gusset_leg   = 20;     // right triangle leg length (Y and Z)

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1]);

        // Left gusset (flush with left edge)
        translate([gusset_x0, motor_y0, motor_y0])
            linear_extrude(height = gusset_leg)
                polygon(points = [
                    [gusset_x0, motor_y0],
                    [gusset_x1, motor_y0],
                    [gusset_x1, motor_y0 + gusset_leg],
                    [gusset_x0, motor_y0 + gusset_leg]
                ]);

        // Right gusset (flush with right edge)
        translate([gusset_x1, motor_y0, motor_y0])
            linear_extrude(height = gusset_leg)
                polygon(points = [
                    [gusset_x1, motor_y0],
                    [motor_x1, motor_y0],
                    [motor_x1, motor_y0 + gusset_leg],
                    [gusset_x1, motor_y0 + gusset_leg]
                ]);
    }

    // M4 through-holes in base plate
    translate([hole_m4_x1, hole_m4_y1, -eps])
        cylinder(d = hole_m4_d, h = base_z1 + 2 * eps);

    translate([hole_m4_x2, hole_m4_y2, -eps])
        cylinder(d = hole_m4_d, h = base_z1 + 2 * eps);

    // Boss hole through motor plate (along Y)
    translate([boss_hole_x, 0, boss_hole_z])
        rotate([90, 0, 0])
            cylinder(d = boss_hole_d, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on 31 mm square pattern, centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pitch / 2, 0, 0])
                cylinder(d = screw_d, h = motor_z1 + 2 * eps);
}