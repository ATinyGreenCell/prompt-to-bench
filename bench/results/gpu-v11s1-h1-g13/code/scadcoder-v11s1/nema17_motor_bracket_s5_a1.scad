// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), motor plate builds upward (+Z)

// ---------------- Parameters ----------------
base_x0      = -25;   // base plate: x start
base_x1      = 25;    // base plate: x end (2 * 25 mm)
base_y0      = 0;     // base plate: y start
base_y1      = 45;    // base plate: y end
base_z0      = 0;     // base plate: z start
base_z1      = 5;     // base plate: z end

hole_x       = -17;   // M4 through-hole x position (left)
hole_y       = 30;    // M4 through-hole y position
hole_d       = 4.5;   // M4 hole diameter

motor_x0     = -25;   // motor plate: x start
motor_x1     = 25;    // motor plate: x end (2 * 25 mm)
motor_y0     = 0;     // motor plate: y start
motor_y1     = 5;     // motor plate: y end
motor_z0     = 0;     // motor plate: z start
motor_z1     = 50;    // motor plate: z end (50 mm tall)

boss_h       = 23;    // motor centring boss hole depth (along Y)
boss_x       = 0;     // boss hole centre x
boss_z       = 28;    // boss hole centre z

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length
screw_count  = 4;     // number of screw holes

gusset_t     = 5;     // gusset thickness (X)
gusset_leg   = 20;    // right triangle leg length (Y and Z)
gusset_x0    = -25;   // gusset left edge x
gusset_x1    = -20;   // gusset left end x
gusset_y1    = 5;     // gusset right-angle corner y
gusset_z1    = 5;     // gusset right-angle corner z

eps          = 0.5;   // cutter overshoot past faces

$fn = 64;             // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);

        // Motor plate (overlaps base slightly for a solid union)
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);

        // Gussets: right triangles in YZ plane, extruded along X
        for (sx = [-1, 1]) {
            x_pos = sx > 0 ? gusset_x1 : gusset_x0;
            translate([x_pos, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = gusset_t)
                        polygon(points = [
                            [x_pos == gusset_x0 ? gusset_x0 - 1 : x_pos, gusset_y1],
                            [x_pos == gusset_x0 ? gusset_x0 - 1 : x_pos, gusset_z1],
                            [gusset_y1, gusset_z1]
                        ]);
        }
    }

    // Base plate M4 through-holes
    for (hx = [-1, 1])
        translate([hx * hole_x, hole_y, -eps])
            cylinder(d = hole_d, h = base_z1 - base_z0 + 2 * eps);

    // Motor boss hole (along Y)
    translate([boss_x, -eps, boss_z])
        rotate([-90, 0, 0])
            cylinder(d = boss_h, h = motor_y1 - motor_y0 + 2 * eps);

    // M3 screw holes on square pattern
    for (i = [0 : screw_count - 1]) {
        x = (i % 2 - 0.5) * screw_pitch;
        z = (i / 2 - 0.25) * screw_pitch;
        translate([x, 0, z])
            cylinder(d = screw_d, h = motor_y1 - motor_y0 + 2 * eps);
    }
}