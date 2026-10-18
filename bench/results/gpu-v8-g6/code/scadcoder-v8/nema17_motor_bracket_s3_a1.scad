// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, vertical motor plate building up in +Z

// ---------------- Parameters ----------------
plate_x      = 25;    // base plate half-width in X (mm)
plate_y      = 45;    // base plate length in Y (mm)
plate_t      = 5;     // base plate thickness (mm)

motor_h      = 50;    // vertical motor plate height (mm)
motor_y      = 5;     // vertical motor plate thickness in Y (mm)

hole_boss    = 23;    // motor centring boss hole diameter (mm)
hole_boss_x  = 0;     // boss hole centre X (mm)
hole_boss_z  = 28;    // boss hole centre Z (mm)

hole_screw   = 3.4;   // M3 screw hole diameter (mm)
hole_screw_n = 4;     // number of screw holes
hole_screw_a = 31;    // square pattern pitch for screw holes (mm)

gusset_t     = 5;     // gusset thickness along X (mm)
gusset_leg   = 20;    // gusset right-triangle leg length (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate: x -25..25, y 0..45, z 0..5
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate: x -25..25, y 0..5, z 0..50
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, motor_y, motor_h]);

        // Gussets: right triangles in YZ, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x - gusset_t : -plate_x, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [gusset_t, gusset_t],   // right-angle corner at y=5, z=5
                            [gusset_leg, gusset_t], // +Y leg
                            [gusset_t, gusset_leg]  // +Z leg
                        ]);
    }

    // Base plate through-holes (M4) at (x = -17, y = 30) and (x = 17, y = 30)
    for (x = [-17, 17])
        translate([x, plate_y / 2, -eps])
            cylinder(d = 4.5, h = plate_t + 2 * eps);

    // Motor plate boss hole along Y, centred at x = 0, z = 28
    translate([hole_boss_x, -eps, hole_boss_z])
        rotate([-90, 0, 0])
            cylinder(d = hole_boss, h = motor_y + 2 * eps);

    // M3 screw holes on a 31 mm square pattern, centred on the boss hole
    for (i = [0 : hole_screw_n - 1]) {
        angle = i < hole_screw_n / 2 ? 45 : -45;
        translate([hole_boss_x + hole_screw_a / 2 * cos(angle),
                   -eps,
                   hole_boss_z + hole_screw_a / 2 * sin(angle)])
            cylinder(d = hole_screw, h = motor_y + 2 * eps);
    }
}