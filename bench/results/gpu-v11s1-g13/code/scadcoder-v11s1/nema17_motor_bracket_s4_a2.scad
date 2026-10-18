// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate lies flat on the bed, motor plate builds upward (+Z)

$fn = 64;

// ---------------- Dimensions (mm) ----------------
base_x0      = -25;   // base plate: x start
base_x1      = 25;    // base plate: x end
base_y1      = 45;    // base plate: y end (y0 = 0)
base_z1      = 5;     // base plate: z end
hole_d4      = 4.5;   // M4 through-hole diameter
hole_x4      = 17;    // M4 hole centre, x (+/-)
hole_y4      = 30;    // M4 hole centre, y
hole_d3      = 3.4;   // M3 screw hole diameter
hole_pitch   = 31;    // square pattern pitch for M3 holes
hole_z3      = 28;    // motor boss hole centre height (z)
boss_d       = 23;    // motor centring boss hole diameter
gusset_w     = 5;     // gusset thickness (X)
gusset_leg   = 20;    // right triangle leg length (Y and Z)
gusset_x0    = -25;   // gusset left edge (x)
gusset_x1    = 20;    // gusset right edge (x)
overlap      = 0.5;   // plate overlap / cutter overshoot

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, 0, 0])
            cube([base_x1 - base_x0, base_y1, base_z1]);

        // Vertical motor plate (on back edge)
        translate([base_x0, 0, 0])
            cube([base_x1 - base_x0, base_z1, hole_z3 + overlap]);

        // Gussets: right triangle in YZ, flush with left/right edges
        for (sx = [-1, 1])
            translate([sx * gusset_x0, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_w)
                        polygon([[0, base_z1 - gusset_leg],
                                 [gusset_leg, base_z1 - gusset_leg],
                                 [0, base_z1 - gusset_leg + overlap]]);
    }

    // M4 through-holes
    for (sx = [-1, 1])
        translate([sx * hole_x4, hole_y4, -overlap])
            cylinder(d = hole_d4, h = base_z1 + 2 * overlap);

    // Motor boss hole (along Y), centred on x = 0, z = 28
    translate([0, -overlap, hole_z3])
        rotate([-90, 0, 0])
            cylinder(d = boss_d, h = base_y1 + 2 * overlap);

    // M3 screw holes on 31 mm square pattern
    for (i = [0 : 3]) {
        x = (i % 2 - 0.5) * hole_pitch;
        y = (i / 2 - 0.25) * hole_pitch;
        translate([x, y, -overlap])
            cylinder(d = hole_d3, h = hole_z3 + 2 * overlap);
    }
}