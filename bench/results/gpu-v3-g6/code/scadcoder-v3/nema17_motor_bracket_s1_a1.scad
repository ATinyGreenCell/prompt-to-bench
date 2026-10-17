// L-shaped mounting bracket for NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed (z = 0), vertical plate builds up along +Z

$fn = 64;

// ---------- Base plate ----------
base_x_min   = -25;   // base plate X start
base_x_max   = 25;    // base plate X end
base_y_min   = 0;     // base plate Y start (back edge)
base_y_max   = 45;    // base plate Y end (front edge)
base_thick   = 5;     // base plate thickness (Z)

// ---------- Vertical motor plate ----------
vert_y_min   = 0;     // motor plate Y start
vert_y_max   = 5;     // motor plate Y end (thickness)
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
gusset_x1    = -25;   // left guset X start
gusset_x2    = -20;   // left guset X end
gusset_y     = 20;    // gusset leg length along +Y (from y = 5)
gusset_z     = 20;    // guset leg length along +Z (from z = 5)

// ---------- Plate overlap ----------
overlap      = 0.01;  // small overlap where plates meet

// ---------- Through-holes ----------
hole_d       = 4.5;   // M4 vertical through-hole diameter
hole_x       = [-17, 17]; // through-hole X positions
hole_y       = 30;    // through-hole Y position

difference() {
    union() {
        // Base plate
        translate([base_x_min, base_y_min, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_thick]);

        // Vertical motor plate
        translate([base_x_min, vert_y_min, 0])
            cube([base_x_max - base_x_min, vert_y_max - vert_y_min, vert_height]);

        // Left gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x1, vert_y_max, 5])
            cube([gusset_x2 - gusset_x1, gusset_y, gusset_z]);

        // Right gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x2, vert_y_max, 5])
            cube([gusset_x2 + (gusset_x2 - gusset_x1), gusset_y, gusset_z]);
    }

    // Vertical through-holes in base plate
    for (x = hole_x)
        translate([x, hole_y, -1])
            cylinder(d = hole_d, h = base_thick + 2, $fn = 64);

    // Boss hole through motor plate (along Y)
    translate([boss_x, vert_y_min - 1, boss_z])
        cylinder(d = boss_d, h = (vert_y_max - vert_y_min) + 2, $fn = 64);

    // M3 screw holes on square pattern centred on boss hole
    for (i = [0 : screw_n - 1]) {
        angle = i * 90;
        translate([boss_x + screw_pitch / 2 * cos(angle),
                   boss_y - screw_pitch / 2 * sin(angle),
                   vert_y_min - 1])
            cylinder(d = screw_d, h = (vert_y_max - vert_y_min) + 2, $fn = 64);
    }
}