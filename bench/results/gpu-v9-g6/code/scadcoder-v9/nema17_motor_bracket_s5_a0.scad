// L-shaped mounting bracket for NEMA 17 stepper motor (syringe pump)
// Print orientation: base plate on bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_w      = 50;    // base plate length (X), also motor plate width (Y)
plate_h      = 5;     // base plate thickness (Z)
motor_h      = 50;    // vertical motor plate height (Z)
hole_m4      = 4.5;   // M4 through-holes in base plate
hole_m4_x    = 17;    // M4 hole X offset from centre (+/-)
hole_m4_y    = 30;    // M4 hole Y position
boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre
screw_d      = 3.4;   // M3 screw holes in motor plate
screw_nx     = 4;     // number of screw holes along X
screw_ny     = 4;     // number of screw holes along Y
screw_pitch  = 31;    // square pattern side length
gusset_t     = 5;     // triangular gusset thickness (X)
gusset_leg   = 20;    // gusset leg length along +Y and +Z
eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([-plate_w/2, 0, 0])
            cube([plate_w, plate_h, 10]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -eps])
                cylinder(d = hole_m4, h = plate_h + 2*eps);
    }

    // Vertical motor plate with boss hole and M3 screw holes
    translate([-plate_w/2, 0, 0])
        difference() {
            cube([plate_w, plate_h, motor_h]);
            // Boss hole along Y
            translate([boss_x, -eps, boss_z])
                cylinder(d = boss_d, h = plate_w + 2*eps);
            // M3 screw holes on square pattern
            for (i = [0 : screw_nx - 1])
                for (j = [0 : screw_ny - 1])
                    translate([(i - (screw_nx - 1)/2) * screw_pitch,
                               (j - (screw_ny - 1)/2) * screw_pitch,
                               -eps])
                        cylinder(d = screw_d, h = motor_h + 2*eps);
        }

    // Triangular gussets, flush with left and right edges
    for (x0 = [-plate_w/2 + gusset_t, plate_w/2 - gusset_t])
        translate([x0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [gusset_leg, gusset_leg],
                        [gusset_leg, 0],
                        [0, gusset_leg]
                    ]);
}