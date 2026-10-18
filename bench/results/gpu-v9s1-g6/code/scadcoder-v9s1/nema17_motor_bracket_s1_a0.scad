// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed, motor plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_x       = 25;    // base plate half-width (X)
plate_y       = 45;    // base plate length (Y)
plate_t       = 5;     // base plate thickness (Z)

motor_h       = 50;    // motor plate height (Z)
motor_w       = 5;     // motor plate thickness (Y)

boss_d        = 23;    // motor boss hole diameter
boss_x        = 0;     // boss hole centre X
boss_z        = 28;    // boss hole centre Z

screw_d       = 3.4;   // M3 screw hole diameter
screw_pitch   = 31;    // square pattern side length

gusset_t      = 5;     // gusset thickness (X)
gusset_leg    = 20;    // right-triangle leg length (Y and Z)

eps           = 0.5;   // cutter overshoot past faces
$fn           = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Motor plate (standing on back edge of base)
        translate([-plate_x, plate_y - motor_w, 0])
            cube([plate_x * 2, motor_w, motor_h]);

        // Left gusset: right triangle in YZ, flush with left edge
        translate([-plate_x - gusset_t, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [plate_y - motor_w, plate_t + eps],   // right-angle corner
                        [plate_y - motor_w + gusset_leg, plate_t + eps],
                        [plate_y - motor_w, plate_t + gusset_leg]
                    ]);

        // Right gusset: right triangle in YZ, flush with right edge
        translate([plate_x + gusset_t, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [plate_y - motor_w, plate_t + eps],
                        [plate_y - motor_w, plate_t + gusset_leg],
                        [plate_y - motor_w + gusset_leg, plate_t + eps]
                    ]);
    }

    // Base plate through-holes (M4)
    for (h = [-1, 1])
        translate([-17 * h, 30, -eps])
            cylinder(d = 4.5, h = plate_t + 2 * eps);

    // Motor boss hole (along Y)
    translate([boss_x, plate_y - motor_w - eps, boss_z])
        rotate([0, 90, 0])
            cylinder(d = boss_d, h = motor_w + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (a = [-1, 1])
        for (b = [-1, 1])
            translate([a * screw_pitch / 2, b * screw_pitch / 2, -eps])
                cylinder(d = screw_d, h = motor_h + 2 * eps);
}