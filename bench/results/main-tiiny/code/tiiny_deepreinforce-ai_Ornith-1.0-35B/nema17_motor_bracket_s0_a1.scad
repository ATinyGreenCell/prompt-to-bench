// === NEMA 17 Stepper Motor Mounting Bracket ===
// Print orientation: base plate on bed (XY plane, z=0)

// --- Base plate dimensions ---
base_x_half = 25;       // Half-width in X (total 50 mm)
base_y = 45;            // Depth in Y (0 to 45 mm)
base_z = 5;             // Thickness in Z

// --- Base plate mounting holes (M4) ---
m4_dia = 4.5;           // M4 hole diameter
m4_x = 17;              // X offset of M4 holes
m4_y = 30;              // Y position of M4 holes

// --- Vertical motor plate dimensions ---
motor_plate_x_half = 25;  // Same width as base
motor_plate_y = 5;        // Thickness (along Y, extends from y=0 to y=5)
motor_plate_z = 50;       // Height

// --- Motor centring boss hole ---
boss_dia = 23;            // Boss hole diameter
boss_x = 0;               // Centre X
boss_z = 28;              // Centre Z

// --- M3 screw holes for motor (31 mm square pattern) ---
m3_dia = 3.4;             // M3 hole diameter
m3_pattern = 31;          // Square pattern size
m3_offset = m3_pattern / 2;  // Half-pattern offset

// --- Triangular gussets ---
gusset_thickness = 5;     // Thickness in X (along base width)
gusset_leg_y = 20;        // Leg along +Y
gusset_leg_z = 20;        // Leg along +Z
gusset_x_start = 20;      // Inner X edge of gusset (right side)

// --- Global fineness ---
$fn = 64;

// === Build the part ===
union() {
    // --- Base plate ---
    translate([0, 0, 0])
        cube([base_x_half * 2, base_y, base_z], center = false);

    // --- Vertical motor plate ---
    // Extends from y=0 to y=5, z=0 to z=50, x=-25 to 25
    translate([0, 0, 0])
        cube([motor_plate_x_half * 2, motor_plate_y, motor_plate_z], center = false);

    // --- Triangular gussets ---
    // Right gusset: right triangle in YZ plane, right angle at (y=5, z=5)
    // Legs: +Y from 5 to 25, +Z from 5 to 25
    // Positioned at x = 20 to 25
    translate([gusset_x_start, 5, 5])
        linear_extrude(height = gusset_thickness, center = false)
            polygon([[0, 0], [gusset_leg_y, 0], [0, gusset_leg_z]]);

    // Left gusset: mirrored across X=0
    // The right triangle should be mirrored, so we flip the polygon
    translate([-gusset_x_start - gusset_thickness, 5, 5])
        linear_extrude(height = gusset_thickness, center = false)
            polygon([[0, 0], [-gusset_leg_y, 0], [0, gusset_leg_z]]);

    // --- Cut: M4 through-holes in base plate ---
    // These go through the base plate (z=0 to z=5) and into the motor plate
    // Extend past both faces by 0.5 mm
    for (sign = [-1, 1]) {
        translate([sign * m4_x, m4_y, -0.5])
            cylinder(d = m4_dia, h = base_z + 1, center = false);
    }

    // --- Cut: Boss hole through motor plate (along Y) ---
    // Centre at (x=0, z=28), along Y from y=0 to y=5
    // Extend past Y faces by 0.5 mm
    translate([boss_x, -0.5, boss_z])
        cylinder(d = boss_dia, h = motor_plate_y + 1, center = false, rotate = [90, 0, 0]);

    // --- Cut: M3 screw holes for motor (4 holes on 31 mm square pattern) ---
    // Centred on boss hole at (x=0, z=28)
    for (sx = [-1, 1]) {
        for (sz = [-1, 1]) {
            translate([sx * m3_offset, -0.5, boss_z + sz * m3_offset])
                cylinder(d = m3_dia, h = motor_plate_y + 1, center = false, rotate = [90, 0, 0]);
        }
    }
}