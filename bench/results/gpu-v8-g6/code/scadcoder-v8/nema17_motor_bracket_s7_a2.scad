// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building upward (+Z)

// ---------------- Parameters ----------------
plate_x      = 25;    // base plate half-length in X (mm)
plate_y      = 45;    // base plate length in Y (mm)
plate_t      = 5;     // base plate thickness in Z (mm)

hole_m4_x    = 17;    // M4 through-hole offset from centre in X (mm)
hole_m4_y    = 30;    // M4 through-hole Y position (mm)
hole_m4_d    = 4.5;   // M4 through-hole diameter (mm)

motor_hole_d = 23;    // motor centring boss hole diameter (mm)
motor_hole_x = 0;     // motor hole centre X (mm)
motor_hole_z = 28;    // motor hole centre Z (mm)

screw_d      = 3.4;   // M3 screw hole diameter (mm)
screw_pitch  = 31;    // square pattern pitch for screw holes (mm)

gusset_t     = 5;     // gusset thickness in X (mm)
gusset_leg   = 20;    // gusset leg length along +Y and +Z (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, plate_y, plate_t]);

        // Vertical motor plate
        translate([-plate_x, 0, 0])
            cube([plate_x * 2, 5, 50]);

        // Gussets: right triangles in YZ, flush with left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x - gusset_t : -plate_x, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [5 - sx * 10, 5],              // right-angle corner
                            [5 - sx * 10, 5 + gusset_leg], // along +Y
                            [20 - sx * 10, 20]             // along +Z
                        ]);
    }

    // Base plate through-holes
    for (x = [-hole_m4_x, hole_m4_x])
        translate([x, hole_m4_y, -eps])
            cylinder(d = hole_m4_d, h = plate_t + 2 * eps);

    // Motor boss hole
    translate([motor_hole_x, plate_y / 2, motor_hole_z])
        cylinder(d = motor_hole_d, h = plate_t + 2 * eps);

    // Screw holes on square pattern centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([0, -screw_pitch / 2, 0])
                cylinder(d = screw_d, h = plate_t + 2 * eps);
}