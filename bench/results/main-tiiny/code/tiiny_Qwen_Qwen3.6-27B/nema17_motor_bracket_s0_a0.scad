// L-shaped NEMA 17 Mounting Bracket for Syringe Pump
// Print orientation: Base plate on XY plane (z=0), building upward (+Z).

// --- Dimensions ---
// Base Plate
base_x_min = -25;
base_x_max = 25;
base_y_min = 0;
base_y_max = 45;
base_z_min = 0;
base_z_max = 5;

// Vertical Motor Plate
motor_x_min = -25;
motor_x_max = 25;
motor_y_min = 0;
motor_y_max = 5;
motor_z_min = 0;
motor_z_max = 50;

// Gussets
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_x_start_left = -25;
gusset_x_end_left = -20;
gusset_x_start_right = 20;
gusset_x_end_right = 25;

// Holes - Base Plate (M4)
hole_base_dia = 4.5;
hole_base_pos_1 = [-17, 30];
hole_base_pos_2 = [17, 30];

// Holes - Motor Plate (Centering Boss)
hole_boss_dia = 23;
hole_boss_center = [0, 28]; // x, z

// Holes - Motor Plate (M3 Screws)
hole_screw_dia = 3.4;
screw_pattern_size = 31; // Square pattern side length
screw_pattern_center = [0, 28]; // x, z (same as boss)

// --- Rendering Settings ---
$fn = 64;

// --- Main Assembly ---
difference() {
    union() {
        // 1. Base Plate
        translate([
            (base_x_min + base_x_max) / 2,
            (base_y_min + base_y_max) / 2,
            (base_z_min + base_z_max) / 2
        ])
        cube([
            base_x_max - base_x_min,
            base_y_max - base_y_min,
            base_z_max - base_z_min
        ], center = true);

        // 2. Vertical Motor Plate
        translate([
            (motor_x_min + motor_x_max) / 2,
            (motor_y_min + motor_y_max) / 2,
            (motor_z_min + motor_z_max) / 2
        ])
        cube([
            motor_x_max - motor_x_min,
            motor_y_max - motor_y_min,
            motor_z_max - motor_z_min
        ], center = true);

        // 3. Left Gusset
        // Right triangle in YZ plane, right angle at (y=5, z=5)
        // Legs extend +Y and +Z
        translate([gusset_x_start_left, 5, 5])
        linear_extrude(height = gusset_thickness, convexity = 10)
        polygon(points = [
            [0, 0], // Right angle corner (local)
            [gusset_leg_y, 0], // Along +Y
            [0, gusset_leg_z]  // Along +Z
        ]);

        // 4. Right Gusset
        translate([gusset_x_start_right, 5, 5])
        linear_extrude(height = gusset_thickness, convexity = 10)
        polygon(points = [
            [0, 0], // Right angle corner (local)
            [gusset_leg_y, 0], // Along +Y
            [0, gusset_leg_z]  // Along +Z
        ]);
    }

    // --- Cuts ---

    // 5. Base Plate Holes (M4)
    // Extend slightly past z=0 and z=5 to ensure clean cut
    translate([hole_base_pos_1[0], hole_base_pos_1[1], -1])
    cylinder(h = base_z_max + 2, r = hole_base_dia / 2, center = false);

    translate([hole_base_pos_2[0], hole_base_pos_2[1], -1])
    cylinder(h = base_z_max + 2, r = hole_base_dia / 2, center = false);

    // 6. Motor Plate Centering Boss Hole (23mm)
    // Cuts along Y axis. Center at x=0, z=28.
    // Extend past y=0 and y=5
    translate([hole_boss_center[0], -1, hole_boss_center[1]])
    rotate([90, 0, 0]) // Rotate cylinder to align with Y axis
    cylinder(h = motor_y_max + 2, r = hole_boss_dia / 2, center = false);

    // 7. Motor Plate M3 Screw Holes (31mm square pattern)
    // Pattern centered on boss hole (x=0, z=28)
    // Square side 31mm -> offset from center is 31/2 = 15.5mm
    screw_offset = screw_pattern_size / 2;
    
    // Four corners of the square pattern
    screw_positions = [
        [screw_pattern_center[0] - screw_offset, screw_pattern_center[1] - screw_offset], // Bottom Left
        [screw_pattern_center[0] + screw_offset, screw_pattern_center[1] - screw_offset], // Bottom Right
        [screw_pattern_center[0] - screw_offset, screw_pattern_center[1] + screw_offset], // Top Left
        [screw_pattern_center[0] + screw_offset, screw_pattern_center[1] + screw_offset]  // Top Right
    ];

    for (pos = screw_positions) {
        // pos[0] is x, pos[1] is z
        translate([pos[0], -1, pos[1]])
        rotate([90, 0, 0]) // Rotate cylinder to align with Y axis
        cylinder(h = motor_y_max + 2, r = hole_screw_dia / 2, center = false);
    }
}