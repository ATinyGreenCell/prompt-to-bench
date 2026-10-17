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
screw_pitch  = 31;    // screw hole pattern pitch (square)

// ---------- Gussets ----------
gusset_x1    = -25;   // left guset X start
gusset_x2    = -20;   // left guset X end
gusset_x3    = 20;    // right guset X start
gusset_x4    = 25;    // right guset X end
gusset_leg   = 20;    // guset leg lengths (Y and Z)
gusset_y0    = 5;     // guset Y start (plates meet)
gusset_z0    = 5;     // guset Z start (plates meet)

// ---------- Through-holes ----------
hole_d       = 4.5;   // M4 through-hole diameter
hole_x       = [-17, 17]; // through-hole X positions
hole_y       = 30;    // through-hole Y position

// ---------- Cut overshoot ----------
eps          = 0.5;   // extension of cutters past faces

difference() {
    union() {
        // Base plate
        translate([base_x_min, base_y_min, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_thick]);

        // Vertical motor plate
        translate([base_x_min, vert_y_min, 0])
            cube([base_x_max - base_x_min, vert_y_max - vert_y_min, vert_height]);

        // Left gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x1, gusset_y0, gusset_z0])
            cube([gusset_x2 - gusset_x1, gusset_leg, gusset_leg]);

        // Right gusset (right-angle corner at y = 5, z = 5)
        translate([gusset_x3, gusset_y0, gusset_z0])
            cube([gusset_x4 - gusset_x3, gusset_leg, gusset_leg]);
    }

    // Boss hole along Y
    translate([boss_x, vert_y_min - eps, boss_z])
        cylinder(d = boss_d, h = vert_y_max - vert_y_min + 2 * eps);

    // M3 screw holes on square pattern centred on boss hole
    for (screw_y = [-(screw_pitch / 2), screw_pitch / 2])
        for (screw_x = [-(screw_pitch / 2), screw_pitch / 2])
            translate([boss_x + screw_x, vert_y_min - eps + screw_y, boss_z])
                cylinder(d = screw_d, h = vert_y_max - vert_y_min + 2 * eps);

    // M4 through-holes in base plate
    for (hx = hole_x)
        translate([hx, hole_y, -eps])
            cylinder(d = hole_d, h = base_thick + 2 * eps);
}