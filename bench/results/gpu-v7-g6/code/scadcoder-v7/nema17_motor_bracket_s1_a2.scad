// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, vertical motor plate builds up +Z

// ---------- Parameters ----------
base_x0   = -25;   // base plate x start
base_x1   = 25;    // base plate x end
base_y0   = 0;     // base plate y start
base_y1   = 45;    // base plate y end
base_z    = 5;     // base plate thickness

motor_x0  = -25;   // motor plate x start
motor_x1  = 25;    // motor plate x end
motor_y0  = 0;     // motor plate y start
motor_y1  = 5;     // motor plate y end (thickness)
motor_z   = 50;    // motor plate height

boss_d    = 23;    // motor centring boss hole diameter
boss_x    = 0;     // boss hole centre x
boss_z    = 28;    // boss hole centre z

screw_d   = 3.4;   // M3 screw hole diameter
screw_n   = 4;     // number of screw holes
screw_p   = 31;    // square pattern pitch
screw_x0  = -screw_p/2; // first hole x (pattern centred on boss)
screw_y0  = -screw_p/2; // first hole y (pattern centred on boss)

gusset_t  = 5;     // gusset thickness (along X)
gusset_leg = 20;   // right triangle legs along +Y and +Z
gusset_x0  = -25;  // left gusset x start
gusset_x1  = -20;  // left gusset x end
gusset_x2  = 20;   // right gusset x start
gusset_x3  = 25;   // right gusset x end

eps       = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
union() {
    // Base plate with two vertical through-holes (M4)
    difference() {
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z]);
        for (sx = [-17, 17], sy = [30])
            translate([sx, sy, -eps])
                cube([4.5, 4.5, base_z + 2*eps]);
    }

    // Vertical motor plate standing on the back edge of the base
    difference() {
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z]);
        // Boss hole along Y, centred at x = 0, z = 28
        translate([boss_x, -eps, boss_z])
            rotate([90, 0, 0])
                cylinder(d = boss_d, h = motor_y1 + 2*eps);
        // Four M3 screw holes on a 31 mm square pattern
        for (i = [0 : screw_n - 1]) {
            a = screw_p / 2;
            x = screw_x0 + a * (i % 2 == 0 ? 1 : -1);
            y = screw_y0 + a * (i / 2 == 0 ? 1 : -1);
            translate([x, y, -eps])
                cube([screw_d, screw_d, motor_z + 2*eps]);
        }
    }

    // Gussets, flush with left and right edges
    for (gx = [gusset_x0, gusset_x2]) {
        translate([gx, 0, 0])
            linear_extrude(gusset_x1 - gx + gusset_t)
                // right triangle: legs along +Y and +Z, right angle at y=5, z=5
                translate([0, gusset_leg, gusset_leg])
                    cube([gusset_leg, gusset_t, gusset_leg]);
    }
}