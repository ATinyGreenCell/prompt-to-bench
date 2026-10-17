// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed, motor plate building up in +Z

// ---------- Parameters ----------
base_x      = 25;    // base plate half-width in X
base_y      = 45;    // base plate length in Y
base_z      = 5;     // base plate thickness in Z

hole_m4_x   = 17;    // M4 hole offset from centre in X (both holes)
hole_m4_y   = 30;    // M4 hole position in Y
hole_m4_d   = 4.5;   // M4 hole diameter

plate_x     = 25;    // motor plate half-width in X
plate_z     = 50;    // motor plate height in Z

boss_d      = 23;    // motor boss hole diameter
boss_x      = 0;     // boss hole X position
boss_z      = 28;    // boss hole Z position

screw_d     = 3.4;   // M3 screw hole diameter
screw_pitch = 31;    // square pattern side length for screw holes

gusset_t    = 5;     // gusset thickness (in X)
gusset_leg  = 20;    // right-triangle leg length (in Y and Z)

eps         = 0.5;   // cutter overshoot past faces

$fn = 96;            // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-base_x, 0, 0])
            cube([2 * base_x, base_y, base_z]);

        // Vertical motor plate, standing on the back edge of the base
        translate([-plate_x, 0, 0])
            cube([2 * plate_x, base_z, plate_z]);

        // Triangular gussets, flush with the left and right edges
        for (sx = [-1, 1])
            translate([sx > 0 ? 20 : -25, 0, 0])
                cube([gusset_t, gusset_leg, gusset_leg]);
    }

    // Two M4 vertical through-holes in the base plate
    for (sx = [-1, 1])
        translate([sx * hole_m4_x, hole_m4_y, -eps])
            cylinder(d = hole_m4_d, h = base_z + plate_z + 2 * eps, $fn = 64);

    // Motor boss hole cut along Y through the motor plate
    translate([boss_x, -eps, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = 2 * plate_x + 2 * eps, $fn = 96);

    // Four M3 screw holes on a square pattern centred on the boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pitch / 2, screw_pitch / 2, -eps])
                cylinder(d = screw_d, h = plate_z + 2 * eps, $fn = 64);
}