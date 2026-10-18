// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)
// Positioned per user coordinates (x -25 to 25, y 0 to 45), not centred

// ---------- Parameters ----------
base_x_len    = 50;    // base plate length along X
base_y_len    = 45;    // base plate depth along Y
base_t        = 5;     // base plate thickness (Z)

hole_m4_x     = 17;    // M4 hole offset from centre in X (+/-)
hole_m4_y     = 30;    // M4 hole position along Y
hole_m4_d     = 4.5;   // M4 hole diameter

motor_x_len   = 50;    // motor plate length along X
motor_y_len   = 5;     // motor plate thickness (along Y)
motor_h       = 50;    // motor plate height (Z)

boss_d        = 23;    // motor centring boss hole diameter
boss_x        = 0;     // boss hole X position
boss_z        = 28;    // boss hole Z position

screw_d       = 3.4;   // M3 screw hole diameter
screw_pitch   = 31;    // square pattern side length for screws
screw_h       = 10;    // depth of screw holes from motor plate top

gusset_t      = 5;     // gusset thickness (along X)
gusset_leg    = 20;    // right triangle leg length (along Y and Z)

eps           = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-base_x_len/2, 0, 0])
            cube([base_x_len, base_y_len, base_t]);

        // Motor plate, standing on back edge of base
        translate([-motor_x_len/2, 0, 0])
            cube([motor_x_len, motor_y_len, motor_h]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? 20 : -25, motor_y_len, base_t])
                cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // M4 through-holes in base plate
    for (x = [-hole_m4_x, hole_m4_x])
        translate([x, hole_m4_y, -eps])
            cylinder(d = hole_m4_d, h = base_t + 2*eps);

    // Motor boss hole through motor plate (along Y)
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = motor_y_len + 2*eps, center = true);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : 3]) {
        for (j = [0 : 3]) {
            x = (i - 1.5) * screw_pitch;
            z = (j - 1.5) * screw_pitch;
            translate([x, 0, boss_z + z])
                rotate([90, 0, 0])
                    cylinder(d = screw_d, h = screw_h + eps);
        }
    }
}