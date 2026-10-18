// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, motor plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_t      = 5;     // base plate thickness (Z)
base_x0      = -25;   // base plate left edge (X)
base_x1      = 25;    // base plate right edge (X)
base_y0      = 0;     // base plate front edge (Y)
base_y1      = 45;    // base plate back edge (Y)

motor_h      = 50;    // motor plate height (Z)
motor_x0     = -25;   // motor plate left edge (X)
motor_x1     = 25;    // motor plate right edge (X)
motor_y0     = 0;     // motor plate front edge (Y)
motor_y1     = 5;     // motor plate back edge (Y)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole centre X
boss_z       = 28;    // boss hole centre Z
boss_pitch   = 31;    // M3 screw pattern side length
screw_d      = 3.4;   // M3 screw hole diameter

gusset_t     = 5;     // gusset thickness (X)
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z
gusset_x0    = -25;   // left gusset start X
gusset_x1    = 25;    // right gusset end X

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, plate_t]);
        for (sx = [-17, 17])
            translate([sx, base_y1 - 15, -eps])
                cylinder(d = 4.5, h = plate_t + 2 * eps);
    }

    // Motor plate standing on back edge of base, with boss hole and M3 screws
    difference() {
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_h]);
        translate([boss_x, motor_y1 + 1, boss_z])
            cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2);
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([boss_x - boss_pitch / 2, motor_y1 + 1, boss_z])
                    cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2);
    }

    // Triangular gussets flush with left and right edges
    for (x = [gusset_x0, gusset_x1]) {
        translate([x - gusset_t, gusset_y0, 5])
            linear_extrude(gusset_t)
                polygon([[-gusset_y, 0], [gusset_y, 0], [0, gusset_z]]);
    }
}