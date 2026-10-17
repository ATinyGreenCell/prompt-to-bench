// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed, motor plate building up in +Z

// ---------- Parameters ----------
base_x      = 25;    // base plate half-length in X
base_y      = 45;    // base plate length in Y
base_z      = 5;     // base plate thickness in Z

hole_m4_x   = -17;   // M4 through-hole X offset (both holes)
hole_m4_y   = 30;    // M4 through-hole Y position

motor_hole  = 23;    // motor boss through-hole diameter
motor_hole_x = 0;    // motor boss hole X centre
motor_hole_z = 28;   // motor boss hole Z centre

screw_hole  = 3.4;   // M3 screw hole diameter
screw_pitch = 31;    // square pattern side length for screw holes

gusset_t    = 5;     // gusset thickness (in X)
gusset_leg  = 20;    // right-triangle leg length (Y and Z)

eps         = 0.5;   // cutter overshoot past faces

$fn = 96;            // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2 * base_x, base_y, base_z]);

        // Vertical motor plate (on back edge of base)
        translate([-base_x, 0, 0])
            cube([2 * base_x, 5, 50]);

        // Gussets, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? 20 : -25, 5, 5])
                cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // M4 through-holes
    for (mx = [-1, 1])
        translate([mx * hole_m4_x, hole_m4_y, -eps])
            cylinder(d = 4.5, h = base_z + 50 + 2 * eps);

    // Motor boss through-hole (along Y)
    translate([motor_hole_x, -eps, motor_hole_z])
        cylinder(d = motor_hole, h = 5 + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * screw_pitch / 2, sy * screw_pitch / 2, -eps])
                    cylinder(d = screw_hole, h = 50 + 2 * eps);
}