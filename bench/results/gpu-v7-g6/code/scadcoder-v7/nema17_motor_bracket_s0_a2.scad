// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, vertical motor plate builds up +Z

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate x start
base_x1      = 25;    // base plate x end
base_y0      = 0;     // base plate y start
base_y1      = 45;    // base plate y end
base_z0      = 0;     // base plate z start
base_z1      = 5;     // base plate z end

motor_plate_x0 = -25;  // motor plate x start (same as base)
motor_plate_x1 = 25;   // motor plate x end (same as base)
motor_plate_y0 = 0;    // motor plate y start (same as base)
motor_plate_y1 = 5;    // motor plate y end (back edge of base)
motor_plate_z0 = 0;    // motor plate z start (same as base)
motor_plate_z1 = 50;   // motor plate z end (top)

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole centre x
boss_z       = 28;     // boss hole centre z

screw_d      = 3.4;    // M3 screw hole diameter
screw_n      = 4;      // number of screw holes
screw_pitch  = 31;     // square pattern side length

gusset_t     = 5;      // gusset thickness (along X)
gusset_leg   = 20;     // right triangle legs along +Y and +Z
gusset_x0    = -25;    // gusset x start (left edge)
gusset_x1    = -20;    // gusset x end (left gusset)
gusset_x2    = 20;     // right gusset x start
gusset_x3    = 25;     // right gusset x end

eps          = 0.5;    // cutter overshoot past faces
$fn          = 96;     // curve resolution

// ---------------- Model ----------------
union() {
    // Base plate with two vertical through-holes (M4)
    difference() {
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);
        for (sx = [-17, 17])
            translate([sx, base_y1 - 15, -eps])
                cylinder(d = 4.5, h = base_z1 - base_z0 + 2 * eps);
    }

    // Vertical motor plate with boss hole and four M3 screw holes
    difference() {
        translate([motor_plate_x0, motor_plate_y0, motor_plate_z0])
            cube([motor_plate_x1 - motor_plate_x0,
                  motor_plate_y1 - motor_plate_y0,
                  motor_plate_z1 - motor_plate_z0]);
        // Boss hole along Y
        translate([boss_x, -eps, boss_z])
            cylinder(d = boss_d, h = motor_plate_y1 - motor_plate_y0 + 2 * eps, $fn = 64);
        // Screw holes on 31 mm square pattern, centred on boss hole
        for (i = [0 : screw_n - 1]) {
            a = screw_pitch / 2;
            x = boss_x + a * (i % 2 == 0 ? 1 : -1);
            z = boss_z + a * (i / 2 == 0 ? 1 : -1);
            translate([x, -eps, z])
                cylinder(d = screw_d, h = motor_plate_y1 - motor_plate_y0 + 2 * eps, $fn = 64);
        }
    }

    // Gussets flush with left and right edges
    for (gx = [gusset_x0, gusset_x2]) {
        translate([gx, 0, 0])
            linear_extrude(gusset_x3 - gx + eps)
                // right triangle in YZ plane: legs along +Y and +Z,
                // right-angle corner at y = 5, z = 5 (where the plates meet)
                translate([0, gusset_leg, gusset_leg])
                    cube([gusset_leg, gusset_t, gusset_leg]);
    }
}