// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed (z = 0), vertical plate builds up in +Z

$fn = 64;

// ---------------- Base plate ----------------
base_x_min   = -25;   // base plate X start
base_x_max   = 25;    // base plate X end
base_y_min   = 0;     // base plate Y start
base_y_max   = 45;    // base plate Y end
base_thick   = 5;     // base plate thickness (Z)

// ---------------- Vertical motor plate ----------------
vert_x_min   = -25;   // motor plate X start
vert_x_max   = 25;    // motor plate X end
vert_y_min   = 0;     // motor plate Y start
vert_y_max   = 5;     // motor plate Y end (thickness)
vert_height  = 50;    // motor plate height (Z)

// ---------------- Boss hole ----------------
boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

// ---------------- Screw holes ----------------
screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // screw hole pattern pitch (square)
screw_x0     = 0;     // screw pattern X centre
screw_z0     = boss_z; // screw pattern Z centre (on boss centre line)

// ---------------- Gussets ----------------
gusset_x0    = -25;   // left gusset X start
gusset_x1    = -20;   // left gusset X end
gusset_y_len = 20;    // gusset leg along +Y
gusset_z_len = 20;    // gusset leg along +Z
gusset_thick = 5;     // gusset thickness (X)

// ---------------- Cuts ----------------
cut_extra    = 1;     // overshoot for clean cuts

base_w = base_x_max - base_x_min;
base_l = base_y_max - base_y_min;
vert_w = vert_x_max - vert_x_min;

difference() {
    union() {
        // Base plate
        translate([base_x_min, base_y_min, 0])
            cube([base_w, base_l, base_thick]);

        // Vertical motor plate
        translate([vert_x_min, vert_y_min, 0])
            cube([vert_w, vert_y_max - vert_y_min, vert_height]);

        // Left gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x0, 5, 5])
            cube([gusset_x1 - gusset_x0, gusset_y_len, gusset_z_len]);

        // Right gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x1, 5, 5])
            cube([gusset_x_max - gusset_x1, gusset_y_len, gusset_z_len]);
    }

    // Vertical through-holes for base plate (M4)
    for (sx = [-17, 17])
        translate([sx, base_y_min + 30, -cut_extra])
            cylinder(d = 4.5, h = base_thick + 2 * cut_extra);

    // Boss hole through motor plate (along Y)
    translate([boss_x, vert_y_min - cut_extra, boss_z])
        cylinder(d = boss_d, h = (vert_y_max - vert_y_min) + 2 * cut_extra);

    // M3 screw holes on square pattern around boss hole
    for (sx = [-screw_pitch / 2, screw_pitch / 2])
        for (sz = [-screw_pitch / 2, screw_pitch / 2])
            translate([screw_x0 + sx, vert_y_min - cut_extra, screw_z0 + sz])
                cylinder(d = screw_d, h = (vert_y_max - vert_y_min) + 2 * cut_extra);
}