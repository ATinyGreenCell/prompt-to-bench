// NEMA 17 stepper motor L-shaped mounting bracket
// Print orientation: base plate on the bed (z = 0), vertical motor plate at y = 0..5.

// --- Base plate ---
base_x_min = -25;
base_x_max =  25;
base_y_min =   0;
base_y_max =  45;
base_z_min =   0;
base_z_max =   5;

// --- M4 through-holes in base plate ---
m4_diameter = 4.5;
m4_hole_1 = [-17, 30];
m4_hole_2 = [ 17, 30];

// --- Vertical motor plate ---
motor_x_min = -25;
motor_x_max =  25;
motor_y_min =   0;
motor_y_max =   5;
motor_z_min =   0;
motor_z_max =  50;

// --- Motor centring boss hole (through Y) ---
boss_diameter = 23;
boss_center = [0, 28]; // x, z

// --- M3 screw holes, 31 mm square pattern centred on boss ---
m3_diameter = 3.4;
m3_square = 31;
m3_offset = m3_square / 2;

// --- Triangular gussets (5 mm thick, flush with left/right edges) ---
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_corner_y = 5;
gusset_corner_z = 5;

// --- Difference clearance (cutting shapes extend past faces) ---
cut_clearance = 0.05;

// --- Curvature quality ---
$fn = 64;

// Base plate
base = cube([base_x_max - base_x_min,
             base_y_max - base_y_min,
             base_z_max - base_z_min],
            center=[(base_x_min+base_x_max)/2,
                    (base_y_min+base_y_max)/2,
                    (base_z_min+base_z_max)/2]);

// Vertical motor plate
motor = cube([motor_x_max - motor_x_min,
              motor_y_max - motor_y_min,
              motor_z_max - motor_z_min],
             center=[(motor_x_min+motor_x_max)/2,
                     (motor_y_min+motor_y_max)/2,
                     (motor_z_min+motor_z_max)/2]);

// Left gusset: right triangle in YZ plane, 5 mm thick in X
left_gusset = linear_extrude(gusset_thickness, center=false)
    polygon(points=[
        [gusset_corner_y, gusset_corner_z],
        [gusset_corner_y + gusset_leg_y, gusset_corner_z],
        [gusset_corner_y, gusset_corner_z + gusset_leg_z]
    ]);

// Right gusset: mirror of left gusset
right_gusset = mirror([1, 0, 0]) left_gusset;

// --- Final assembly ---
difference() {
    union() {
        base;
        motor;
        left_gusset;
        right_gusset;
    }
    // M4 hole 1 (vertical through base)
    cylinder(d=m4_diameter + 2*cut_clearance,
             h=base_z_max - base_z_min + 2*cut_clearance,
             center=[m4_hole_1[0], m4_hole_1[1],
                     (base_z_min+base_z_max)/2],
             $fn=$fn);

    // M4 hole 2 (vertical through base)
    cylinder(d=m4_diameter + 2*cut_clearance,
             h=base_z_max - base_z_min + 2*cut_clearance,
             center=[m4_hole_2[0], m4_hole_2[1],
                     (base_z_min+base_z_max)/2],
             $fn=$fn);

    // Boss hole (through Y, horizontal)
    cylinder(d=boss_diameter + 2*cut_clearance,
             h=motor_y_max - motor_y_min + 2*cut_clearance,
             center=[boss_center[0],
                     (motor_y_min+motor_y_max)/2,
                     boss_center[1]],
             $fn=$fn,
             rotate=[0, 90, 0]);

    // M3 screw holes (vertical through motor plate)
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 2; j++) {
            cx = (i == 0 ? -1 : 1) * m3_offset;
            cz = (j == 0 ? -1 : 1) * m3_offset;
            cylinder(d=m3_diameter + 2*cut_clearance,
                     h=motor_z_max - motor_z_min + 2*cut_clearance,
                     center=[cx,
                             (motor_y_min+motor_y_max)/2,
                             cz],
                     $fn=$fn);
        }
    }
}