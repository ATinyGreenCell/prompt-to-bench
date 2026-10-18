// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed (z = 0), motor plate builds upward

// ---------- Parameters ----------
base_x0      = -25;    // base plate, x start
base_x1      = 25;     // base plate, x end
base_y0      = 0;      // base plate, y start
base_y1      = 45;     // base plate, y end
base_z1      = 5;      // base plate, z end

motor_x0     = -25;    // motor plate, x start
motor_x1     = 25;     // motor plate, x end
motor_y0     = 0;      // motor plate, y start
motor_y1     = 5;      // motor plate, y end (sits on back edge of base)
motor_z1     = 50;     // motor plate, z end

hole_m4_x1   = -17;    // M4 through-hole in base, x
hole_m4_y1   = 30;     // M4 through-hole in base, y
hole_m4_x2   = 17;     // M4 through-hole in base, x
hole_m4_y2   = 30;     // M4 through-hole in base, y
hole_m4_d    = 4.5;    // M4 hole diameter

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole centre, x
boss_z       = 28;     // boss hole centre, z

screw_d      = 3.4;    // M3 screw hole diameter
screw_pat    = 31;     // square pattern side length for screw holes

gusset_t     = 5;      // gusset thickness (X)
gusset_leg   = 20;     // right-triangle leg length (Y and Z)
gusset_x0    = -25;    // left gusset, x start
gusset_x1    = -20;    // left gusset, x end
gusset_x2    = 20;     // right gusset, x start
gusset_x3    = 25;     // right gusset, x end

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;              // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1]);

        // Vertical motor plate
        translate([motor_x0, motor_y0, base_z1])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - base_z1]);

        // Left triangular gusset (flush with left edge)
        translate([gusset_x0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[gusset_leg, gusset_leg], [gusset_leg, 0], [0, 0]]);

        // Right triangular gusset (flush with right edge)
        translate([gusset_x2, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[gusset_leg, gusset_leg], [0, gusset_leg], [0, 0]]);
    }

    // Base plate through-holes (M4)
    for (i = [1, 2])
        translate([i == 1 ? hole_m4_x1 : hole_m4_x2, hole_m4_y1, -eps])
            cylinder(d = hole_m4_d, h = base_z1 + 2 * eps);

    // Motor boss hole (through along Y)
    translate([boss_x, motor_y0 - eps, boss_z])
        cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on a square pattern, centred on the boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pat / 2, 0, 0])
                cylinder(d = screw_d, h = motor_z1 + eps);
}