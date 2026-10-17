// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
base_x      = 25;    // base plate half-length in X (extends -base_x .. +base_x)
base_y      = 45;    // base plate length in Y
base_z      = 5;     // base plate thickness

motor_plate_x = 25;  // motor plate half-length in X (extends -motor_plate_x .. +motor_plate_x)
motor_plate_y = 5;   // motor plate thickness in Y
motor_plate_z = 50;  // motor plate height in Z

boss_hole   = 23;    // motor centring boss hole diameter
boss_x      = 0;     // boss hole centre X
boss_z      = 28;    // boss hole centre Z

screw_hole  = 3.4;   // M3 screw hole diameter
screw_n     = 4;     // number of screw holes
screw_pitch = 31;    // square pattern side length

gusset_t    = 5;     // gusset thickness in X
gusset_y    = 20;    // gusset leg along +Y
gusset_z    = 20;    // gusset leg along +Z

eps         = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2*base_x, base_y, base_z]);

        // Vertical motor plate
        translate([-motor_plate_x, 0, 0])
            cube([2*motor_plate_x, motor_plate_y, motor_plate_z]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? motor_plate_x - gusset_t : -base_x, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon([[0, 0], [0, gusset_y], [gusset_z, gusset_y]]);
    }

    // Base plate through-holes (M4)
    for (x = [-17, 17])
        translate([x, base_y/2, -eps])
            cylinder(d = 4.5, h = base_z + 2*eps);

    // Motor plate boss hole (along Y) and M3 screw pattern
    translate([boss_x, -eps, boss_z])
        cylinder(d = boss_hole, h = motor_plate_y + 2*eps);

    for (i = [0 : screw_n - 1]) {
        x = -screw_pitch/2 + (i + 0.5) * screw_pitch;
        translate([x, -eps, boss_z])
            cylinder(d = screw_hole, h = motor_plate_y + 2*eps);
    }
}