// NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base plate on the bed, motor plate standing up

// ---------------- Parameters ----------------
plate_t       = 5;     // base plate thickness (Z)
motor_plate_h = 50;    // vertical motor plate height (Z)
base_x        = 25;    // base plate extends from -x to +x
base_y        = 45;    // base plate extends from y = 0 to y = base_y

hole_m4_x     = 17;    // M4 hole offset from centre in X (both + and -)
hole_m4_y     = 30;    // M4 hole Y position
hole_m4_d     = 4.5;   // M4 hole diameter

hole_motor_d  = 23;    // motor centring boss hole diameter
hole_motor_x  = 0;     // motor hole centre X
hole_motor_z  = 28;    // motor hole centre Z

hole_m3_d     = 3.4;   // M3 screw hole diameter
hole_m3_pitch = 31;    // M3 screw hole square pattern size
hole_m3_n     = 4;     // number of M3 holes

gusset_t      = 5;     // gusset thickness (X)
gusset_leg    = 20;    // gusset right triangle leg length (Y and Z)

eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([base_x * 2, base_y, plate_t]);

        // Vertical motor plate
        translate([-base_x, 0, 0])
            cube([base_x * 2, base_y, motor_plate_h]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? base_x - gusset_t : -base_x, 0, 0])
                translate([0, base_y - gusset_leg, 0])
                    cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // Through-holes in base plate (M4)
    for (x = [-hole_m4_x, hole_m4_x])
        translate([x, hole_m4_y, -eps])
            cylinder(d = hole_m4_d, h = plate_t + 2 * eps);

    // Motor centring boss hole (along Y)
    translate([hole_motor_x, -eps, hole_motor_z])
        cylinder(d = hole_motor_d, h = base_y + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : hole_m3_n - 1]) {
        a = hole_m3_pitch / sqrt(2);
        x = (i % 2 == 0) ? -a : a;
        z = (i / 2) * hole_m3_pitch;
        translate([x, -eps, z])
            cylinder(d = hole_m3_d, h = motor_plate_h + 2 * eps);
    }
}