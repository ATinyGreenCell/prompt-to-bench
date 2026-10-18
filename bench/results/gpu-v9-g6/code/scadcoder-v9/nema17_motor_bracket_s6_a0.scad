// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, motor plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_w      = 50;    // base plate length (X)
plate_h      = 45;    // base plate width (Y)
plate_t      = 5;     // base plate thickness (Z)

hole_x       = 17;    // M4 hole offset from origin (±X)
hole_y       = 30;    // M4 hole position (Y)
hole_d       = 4.5;   // M4 hole diameter

motor_w      = 50;    // motor plate length (X)
motor_h      = 5;     // motor plate width (Y)
motor_z      = 50;    // motor plate height (Z)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole centre X
boss_z       = 28;    // boss hole centre Z

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length

gusset_t     = 5;     // gusset thickness (X)
gusset_leg   = 20;    // right-triangle leg length (Y and Z)

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_w/2, 0, 0])
            cube([plate_w, plate_h, plate_t]);

        // Vertical motor plate (on back edge of base)
        translate([-motor_w/2, 0, 0])
            cube([motor_w, motor_h, motor_z]);

        // Gussets: right-triangle in YZ, flush with left/right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? motor_w/2 - gusset_t : -motor_w/2,
                       gusset_leg, gusset_leg])
                cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // Base plate through-holes (M4)
    for (x = [-hole_x, hole_x])
        translate([x, hole_y, -eps])
            cylinder(d = hole_d, h = plate_t + 2*eps);

    // Motor plate boss hole (along Y)
    translate([boss_x, -eps, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = motor_h + 2*eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pitch/2, screw_pitch/2, 0])
                translate([0, 0, -eps])
                    cylinder(d = screw_d, h = motor_h + 2*eps);
}