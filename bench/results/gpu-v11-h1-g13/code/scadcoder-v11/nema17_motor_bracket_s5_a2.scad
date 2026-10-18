// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

// ---------------- Parameters ----------------
base_x0      = -25;    // base plate: x start
base_x1      = 25;     // base plate: x end
base_y0      = 0;      // base plate: y start
base_y1      = 45;     // base plate: y end
base_z0      = 0;      // base plate: z start
base_z1      = 5;      // base plate: z end

hole_x       = -17;    // M4 through-hole x position
hole_y       = 30;     // M4 through-hole y position
hole_d       = 4.5;    // M4 hole diameter

plate_x0     = -25;    // motor plate: x start
plate_x1     = 25;     // motor plate: x end
plate_y0     = 0;      // motor plate: y start
plate_y1     = 5;      // motor plate: y end (thickness)
plate_z0     = 0;      // motor plate: z start
plate_z1     = 50;     // motor plate: z end

boss_d       = 23;     // motor centring boss hole diameter
boss_x       = 0;      // boss hole centre x
boss_z       = 28;     // boss hole centre z

screw_d      = 3.4;    // M3 screw hole diameter
screw_p      = 31;     // square pattern pitch (centre to centre)

gusset_t     = 5;      // gusset thickness (X)
gusset_leg   = 20;     // right triangle leg length (Y and Z)
gusset_x0    = -25;    // left gusset x start
gusset_x1    = 20;     // right gusset x end

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Vertical motor plate
        translate([plate_x0, plate_y0, plate_z0])
            cube([plate_x1 - plate_x0, plate_y1 - plate_y0, plate_z1 - plate_z0]);

        // Left triangular gusset (flush with left edge)
        translate([gusset_x0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, 0],
                        [gusset_leg, 0],
                        [0, gusset_leg]
                    ]);

        // Right triangular gusset (flush with right edge)
        translate([gusset_x1, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, 0],
                        [-gusset_leg, 0],
                        [0, gusset_leg]
                    ]);
    }

    // M4 through-holes in base plate
    translate([hole_x, hole_y, -eps])
        cylinder(d = hole_d, h = base_z1 - base_z0 + 2 * eps);

    // Motor boss hole through vertical plate (along Y)
    translate([boss_x, plate_y0 - eps, boss_z])
        cylinder(d = boss_d, h = plate_y1 - plate_y0 + 2 * eps);

    // M3 screw holes on 31 mm square pattern, centred on boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_p / 2, 0, 0])
                cylinder(d = screw_d, h = plate_y1 - plate_y0 + eps);
}