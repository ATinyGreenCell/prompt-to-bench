// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), vertical plate builds up along +Z

$fn = 64;

// ---------- Base plate ----------
base_x_min   = -25;   // base plate X start
base_x_max   = 25;    // base plate X end
base_y_min   = 0;     // base plate Y start
base_y_max   = 45;    // base plate Y end
base_thick   = 5;     // base plate thickness (Z)

// ---------- Vertical motor plate ----------
vert_x_min   = -25;   // motor plate X start
vert_x_max   = 25;    // motor plate X end
vert_y_min   = 0;     // motor plate Y start
vert_y_max   = 5;     // motor plate Y end
vert_height  = 50;    // motor plate height (Z)

// ---------- Boss hole ----------
boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

// ---------- Screw holes ----------
screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern pitch (X and Y)
screw_n      = 4;     // number of screw holes

// ---------- Gussets ----------
gusset_x1    = -25;   // left gusset X start
gusset_x2    = -20;   // left gusset X end
gusset_y     = 20;    // gusset leg length along +Y
gusset_z     = 20;    // gusset leg length along +Z

// ---------- Through-holes (M4) ----------
hole_d       = 4.5;   // vertical through-hole diameter
hole_x       = [-17, 17]; // through-hole X positions
hole_y       = 30;    // through-hole Y position

// ---------- Cutting overlap ----------
eps          = 0.5;   // extension of cutters past faces

difference() {
    union() {
        // Base plate
        translate([base_x_min, base_y_min, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_thick]);

        // Vertical motor plate
        translate([vert_x_min, vert_y_min, 0])
            cube([vert_x_max - vert_x_min, vert_y_max - vert_y_min, vert_height]);

        // Left gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x1, 5, 5])
            cube([gusset_x2 - gusset_x1, gusset_y, gusset_z]);

        // Right gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x2, 5, 5])
            cube([gusset_x_max - gusset_x2, gusset_y, gusset_z]);
    }

    // Boss hole along Y
    translate([boss_x, vert_y_min - eps, boss_z])
        cylinder(d = boss_d, h = vert_y_max - vert_y_min + 2 * eps);

    // M3 screw holes on square pattern, centred on boss hole
    for (i = [0 : screw_n - 1])
        translate([screw_pitch * cos(i * 90), screw_pitch * sin(i * 90), 0])
            translate([boss_x, vert_y_min - eps, boss_z])
                cylinder(d = screw_d, h = vert_y_max - vert_y_min + 2 * eps);

    // Vertical through-holes for base plate
    for (x = hole_x)
        translate([x, hole_y, -eps])
            cylinder(d = hole_d, h = base_thick + 2 * eps);
}