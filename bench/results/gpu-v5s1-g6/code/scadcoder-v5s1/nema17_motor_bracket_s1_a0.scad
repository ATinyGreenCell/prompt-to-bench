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
screw_d      = 3.4;   // M3 screw holes diameter
screw_n      = 4;     // number of screw holes
screw_pitch  = 31;    // square pattern side length

gusset_t     = 5;     // gusset thickness (X)
gusset_y     = 20;    // gusset leg along +Y
gusset_z     = 20;    // gusset leg along +Z

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
union() {
    // Base plate with two vertical through-holes (M4) at y = 30
    difference() {
        translate([base_x0, base_y0, 0])
            cube([base_x1 - base_x0, base_y1 - base_y0, plate_t]);

        for (sx = [-17, 17])
            translate([sx, base_y1 - 15, -eps])
                cylinder(d = 4.5, h = plate_t + 2 * eps);
    }

    // Vertical motor plate standing on the back edge of the base
    difference() {
        translate([motor_x0, motor_y0, 0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_h]);

        // Boss hole along Y, centred at x = 0, z = 28
        translate([boss_x, -eps, boss_z])
            rotate([-90, 0, 0])
                cylinder(d = boss_d, h = motor_y1 - motor_y0 + 2 * eps);

        // M3 screw holes on a 31 mm square pattern, centred on the boss hole
        for (i = [0 : screw_n - 1]) {
            a = mod(i, 2);
            b = floor(i / 2);
            translate([b * screw_pitch - screw_pitch / 2, -eps,
                       a * screw_pitch - screw_pitch / 2])
                cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2 * eps, $fn = 64);
        }
    }

    // Two triangular gussets flush with the left and right edges
    // Right-angle corner at y = 5, z = 5 (where the plates meet)
    for (gx = [-25, 25])
        translate([gx, 5, 5])
            linear_extrude(gusset_t)
                polygon([[0, 0], [gusset_y, 0], [0, gusset_z]]);
}