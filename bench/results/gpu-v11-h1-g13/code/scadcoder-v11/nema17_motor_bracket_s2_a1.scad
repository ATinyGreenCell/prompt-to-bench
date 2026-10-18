// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward

// ---------- Parameters ----------
base_x0, base_x1   = -25, 25;    // base plate X range
base_y0, base_y1   = 0, 45;      // base plate Y range
base_z0, base_z1   = 0, 5;       // base plate Z range

motor_x0, motor_x1 = -25, 25;    // motor plate X range
motor_y0, motor_y1 = 0, 5;       // motor plate Y range
motor_z0, motor_z1 = 0, 50;      // motor plate Z range

hole_m4_x1, hole_m4_y1 = -17, 30; // M4 through-hole 1
hole_m4_x2, hole_m4_y2 = 17, 30;  // M4 through-hole 2
hole_m4_d     = 4.5;             // M4 hole diameter

boss_d       = 23;               // motor centring boss hole diameter
boss_x       = 0;                // boss hole centre X
boss_z       = 28;               // boss hole centre Z

screw_d      = 3.4;              // M3 screw hole diameter
screw_pat    = 31;               // square pattern side length
screw_count  = 4;                // number of screw holes

gusset_t     = 5;                // gusset thickness (X)
gusset_leg   = 20;               // triangular leg length (Y and Z)
gusset_x0    = -25;              // left gusset start X
gusset_x1    = -20;              // left gusset end X
gusset_x2    = 20;               // right gusset start X
gusset_x3    = 25;               // right gusset end X

eps          = 0.5;              // cutter overshoot past faces

$fn = 96;                        // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Left gusset: right triangle in YZ, extruded along -X to X
        translate([gusset_x0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[gusset_leg, gusset_leg],
                             [gusset_leg, 0],
                             [0, 0]]);

        // Right gusset: right triangle in YZ, extruded along X
        translate([gusset_x2, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[gusset_leg, gusset_leg],
                             [0, gusset_leg],
                             [0, 0]]);
    }

    // Base plate M4 through-holes
    for (i = [1, 2])
        translate([i == 1 ? hole_m4_x1 : hole_m4_x2,
                   hole_m4_y1,
                   -eps])
            cylinder(d = hole_m4_d, h = base_z1 - base_z0 + 2 * eps);

    // Motor centring boss hole
    translate([boss_x, motor_y0 - eps, boss_z])
        cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pat / 2, 0, 0])
                cylinder(d = screw_d, h = motor_z1 - motor_z0 + eps);
}