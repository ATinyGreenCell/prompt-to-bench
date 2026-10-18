// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed (z = 0), motor plate builds upward.

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate x start
base_x1      = 25;    // base plate x end
base_y0      = 0;     // base plate y start
base_y1      = 45;    // base plate y end
base_z       = 5;     // base plate thickness

motor_x0     = -25;   // motor plate x start
motor_x1     = 25;    // motor plate x end
motor_y0     = 0;     // motor plate y start
motor_y1     = 5;     // motor plate y end (top)
motor_z      = 50;    // motor plate height

hole_m4_x    = -17;   // M4 hole x position (left)
hole_m4_y    = 30;    // M4 hole y position
hole_m4_d    = 4.5;   // M4 hole diameter

hole_m4_x2   = 17;    // M4 hole x position (right)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole x centre
boss_z       = 28;    // boss hole z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length
screw_count  = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness (X)
gusset_leg   = 20;    // right triangle leg length (Y and Z)
gusset_x0    = -25;   // left gusset x start
gusset_x1    = -20;   // left gusset x end
gusset_x2    = 20;    // right gusset x start
gusset_x3    = 25;    // right gusset x end

eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);

        // Motor plate, standing on back edge of base
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? gusset_x2 : gusset_x0,
                       gusset_leg,
                       gusset_leg])
                cube([gusset_t,
                      gusset_leg,
                      gusset_leg]);
    }

    // Vertical M4 through-holes in base
    for (hx = [hole_m4_x, hole_m4_x2])
        translate([hx, hole_m4_y, -eps])
            cylinder(d = hole_m4_d, h = base_z + 2 * eps);

    // Motor boss hole through motor plate (along Y)
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 - 2 * eps, center = true);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : screw_count - 1]) {
        x = (i % 2 == 0) ? -screw_pitch / 2 : screw_pitch / 2;
        z = (i < 2) ? -screw_pitch / 2 : screw_pitch / 2;
        translate([x, 0, z])
            cylinder(d = screw_d, h = motor_z + 2 * eps);
    }
}