// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, motor plate building up in +Z

// ---------------- Parameters ----------------
plate_w      = 50;    // base plate length (X)
plate_h      = 45;    // base plate width (Y)
plate_t      = 5;     // base plate thickness (Z)

hole_m4_x    = -17;   // M4 through-hole X position (back edge)
hole_m4_y    = 30;    // M4 through-hole Y position
hole_m4_d    = 4.5;   // M4 through-hole diameter

motor_w      = 50;    // motor plate length (X)
motor_h      = 5;     // motor plate width (Y)
motor_z      = 50;    // motor plate height (Z)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length

gusset_t     = 5;     // gusset thickness (X)
gusset_leg   = 20;    // gusset leg length (Y and Z)

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([-plate_w/2, 0, 0])
            cube([plate_w, plate_h, plate_t]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -eps])
                cylinder(d = hole_m4_d, h = plate_t + 2*eps);
    }

    // Vertical motor plate with boss hole and M3 screw holes
    translate([-motor_w/2, 0, 0])
        difference() {
            cube([motor_w, motor_h, motor_z]);
            translate([boss_x, -motor_h/2 - eps, boss_z])
                rotate([-90, 0, 0])
                    cylinder(d = boss_d, h = motor_h + 2*eps);
            for (a = [0, 90, 180, 270])
                rotate([0, 0, a])
                    translate([-screw_pitch/2, -motor_h/2 - eps, 0])
                        cylinder(d = screw_d, h = motor_h + 2*eps);
        }

    // Gussets on the left and right edges
    for (sx = [-1, 1])
        translate([sx * (motor_w/2 - gusset_t), 0, 0])
            // right triangle in YZ, extruded along X
            linear_extrude(height = gusset_t)
                translate([0, 5, 5])
                    cube([gusset_t, gusset_leg, gusset_leg]);
    }
}