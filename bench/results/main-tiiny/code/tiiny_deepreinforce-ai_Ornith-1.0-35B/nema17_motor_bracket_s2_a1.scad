// === NEMA 17 Stepper Motor Mounting Bracket ===
// Print orientation: base plate on bed (XY plane, z=0)

// --- Base plate dimensions ---
base_x_half = 25;          // Half-width in X (total 50 mm)
base_y = 45;               // Depth in Y (0 to 45 mm)
base_z = 5;                // Thickness in Z

// --- Base plate mounting holes ---
base_hole_dia = 4.5;       // M4 hole diameter
base_hole_y = 30;          // Y position for both holes
base_hole_x_positions = [-17, 17];  // X positions

// --- Vertical motor plate dimensions ---
motor_plate_x_half = 25;   // Half-width in X (same as base)
motor_plate_y = 5;       // Thickness in Y (stands on back edge of base)
motor_plate_z = 50;      // Height in Z

// --- Motor plate features ---
boss_hole_dia = 23;        // Centring boss hole diameter
boss_hole_x = 0;           // Centre X
boss_hole_z = 28;          // Centre Z
m3_hole_dia = 3.4;         // M3 screw hole diameter
m3_pattern_half = 31 / 2;  // Half of 31 mm square pattern

// --- Triangular gussets ---
gusset_thickness = 5;      // Thickness in X (flush with plate edges)
gusset_leg_y = 20;         // Leg along +Y
gusset_leg_z = 20;         // Leg along +Z
gusset_corner_y = 5;       // Y of right-angle corner (where plates meet)
gusset_corner_z = 5;       // Z of right-angle corner

// --- Global ---
$fn = 64;

// === Base plate ===
base_plate = translate([0, 0, 0])
    cube([base_x_half * 2, base_y, base_z], center = false);

// === Vertical motor plate ===
// Sits on the back edge of the base (y=0 face of base, which is at y=0)
motor_plate = translate([0, 0, 0])
    cube([motor_plate_x_half * 2, motor_plate_y, motor_plate_z], center = false);

// === Boss hole (through Y axis) ===
// Centre at x=0, z=28, extending past both faces of motor plate in Y
boss_hole = translate([boss_hole_x, 0, boss_hole_z])
    cylinder(d = boss_hole_dia, h = motor_plate_y + 2, center = false);

// === M3 screw holes (through Y axis) ===
// 31 mm square pattern centred on boss hole (x=0, z=28)
m3_holes = [];
for (dx = [-m3_pattern_half, m3_pattern_half]) {
    for (dz = [-m3_pattern_half, m3_pattern_half]) {
        m3_holes = concat(m3_holes, [
            translate([dx, 0, boss_hole_z + dz])
                cylinder(d = m3_hole_dia, h = motor_plate_y + 2, center = false)
        ]);
    }
}

// === Base plate mounting holes (M4, through Z) ===
base_mount_holes = [];
for (hx = base_hole_x_positions) {
    base_mount_holes = concat(base_mount_holes, [
        translate([hx, base_hole_y, 0])
            cylinder(d = base_hole_dia, h = base_z + 2, center = false)
    ]);
}

// === Triangular gussets ===
// Right triangle in YZ plane: right angle at (y=5, z=5), legs along +Y and +Z
// Triangle vertices in YZ: (5,5), (5+20,5)=(25,5), (5,5+20)=(5,25)
gusset_triangle_yz = [
    [gusset_corner_y, gusset_corner_z],
    [gusset_corner_y + gusset_leg_y, gusset_corner_z],
    [gusset_corner_y, gusset_corner_z + gusset_leg_z]
];

// Left gusset: at x = -25 to -20 (thickness 5, flush with left edge)
left_gusset = translate([-25, 0, 0])
    linear_extrude(height = gusset_thickness, center = false, offset = 0)
        polygon(gusset_triangle_yz);

// Right gusset: at x = 20 to 25 (thickness 5, flush with right edge)
right_gusset = translate([20, 0, 0])
    linear_extrude(height = gusset_thickness, center = false, offset = 0)
        polygon(gusset_triangle_yz);

// === Assemble: union of solid parts ===
bracket_solid = union() {
    base_plate;
    motor_plate;
    left_gusset;
    right_gusset;
};

// === Cut holes ===
final_part = difference() {
    bracket_solid;
    boss_hole;
    for (h = m3_holes) h;
    for (h = base_mount_holes) h;
};

// === Output ===
render()
    color("lightblue")
    final_part;