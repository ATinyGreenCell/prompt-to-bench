// NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base plate on the bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_x      = 25;    // base plate length along X (mm)
plate_y      = 45;    // base plate width along Y (mm)
plate_t      = 5;     // base plate thickness along Z (mm)

hole_m4_x    = 17;    // M4 through-hole X offset from centre (mm)
hole_m4_y    = 30;    // M4 through-hole Y position (mm)

plate_z      = 50;    // vertical motor plate height (mm)
boss_d       = 23;    // motor centring boss hole diameter (mm)
boss_z       = 28;    // motor centring boss hole Z position (mm)

screw_d      = 3.4;   // M3 screw hole diameter (mm)
screw_pitch  = 31;    // M3 screw hole square pattern size (mm)

gusset_t     = 5;     // gusset thickness along X (mm)
gusset_leg   = 20;    // gusset leg length along Y and Z (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, 0, 0])
            cube([plate_x, plate_y, plate_t]);

        // Vertical motor plate
        translate([-plate_x/2, 0, 0])
            cube([plate_x, plate_y, plate_z]);
    }

    // Base plate through-holes (M4)
    translate([-hole_m4_x, hole_m4_y, -eps])
        cylinder(d = hole_m4_x * 2, h = plate_t + 2 * eps);

    // Motor centring boss hole (through vertical plate, along Y)
    translate([0, -eps, boss_z])
        cylinder(d = boss_d, h = plate_y + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : 3])
        rotate([0, 90 * i, 0])
            translate([0, screw_pitch/2, 0])
                cylinder(d = screw_d, h = plate_z + eps);

    // Gussets, flush with left and right edges
    for (sx = [-1, 1])
        translate([sx > 0 ? plate_x/2 - gusset_t : -plate_x/2, 0, 0])
            translate([0, gusset_leg, 0])
                cube([gusset_t, gusset_leg, gusset_leg]);
}