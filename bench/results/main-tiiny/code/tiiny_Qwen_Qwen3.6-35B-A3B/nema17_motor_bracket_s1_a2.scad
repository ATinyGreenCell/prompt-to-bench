// NEMA 17 Stepper Motor Mounting Bracket for Syringe Pump
// Units: mm

// --- Base Plate Dimensions ---
base_x_half = 25;      // Half-width of base plate (x: -25 to 25)
base_y_len = 45;       // Length of base plate (y: 0 to 45)
base_z_thick = 5;      // Thickness of base plate (z: 0 to 5)

// --- Motor Mounting Plate Dimensions ---
motor_plate_x_half = 25; // Width of vertical plate (x: -25 to 25)
motor_plate_y_thick = 5; // Thickness of vertical plate (y: 0 to 5)
motor_plate_z_height = 50; // Height of vertical plate (z: 0 to 50)

// --- Hole Dimensions ---
hole_m4_dia = 4.5;     // Diameter for M4 mounting holes
hole_m3_dia = 3.4;     // Diameter for M3 screw holes
hole_boss_dia = 23;    // Diameter for motor centring boss

// --- Hole Positions ---
// M4 Holes on base plate
m4_hole_x = 17;
m4_hole_y = 30;

// M3 Holes on motor plate (31mm square pattern)
m3_pattern_half = 31 / 2; // 15.5 mm from center

// Boss Hole Center
boss_center_x = 0;
boss_center_z = 28;

// --- Extrusion Depth for Boolean Operations ---
cut_depth = 1.0;       // Extra depth to ensure clean cuts

// --- Module: Base Plate ---
module base_plate() {
    // Main block
    difference() {
        cube([base_x_half * 2, base_y_len, base_z_thick], center = false);
        
        // M4 Holes
        // Extend hole depth past the bottom (z=0) and top (z=5)
        for (i = [-1, 1]) {
            $fn = 64;
            translate([i * m4_hole_x, m4_hole_y, -cut_depth]) {
                cylinder(d = hole_m4_dia, h = base_z_thick + 2 * cut_depth, center = false);
            }
        }
    }
}

// --- Module: Motor Plate ---
module motor_plate() {
    // Main block
    difference() {
        cube([motor_plate_x_half * 2, motor_plate_y_thick, motor_plate_z_height], center = false);
        
        // Boss Hole (along Y axis)
        // Center at x=0, z=28. Extends through the plate (y: 0 to 5).
        // Extend past faces y=0 and y=5.
        $fn = 64;
        translate([boss_center_x, -cut_depth, boss_center_z]) {
            // Rotate cylinder from Z-axis to Y-axis
            rotate([90, 0, 0]) {
                cylinder(d = hole_boss_dia, h = motor_plate_y_thick + 2 * cut_depth, center = false);
            }
        }
        
        // M3 Screw Holes (along Y axis)
        // 31mm square pattern centered on boss hole (x=0, z=28)
        // Holes at x = +/- 15.5, z = 28 +/- 15.5
        for (ix = [-1, 1]) {
            for (iz = [-1, 1]) {
                $fn = 64;
                translate([ix * m3_pattern_half, -cut_depth, boss_center_z + iz * m3_pattern_half]) {
                    rotate([90, 0, 0]) {
                        cylinder(d = hole_m3_dia, h = motor_plate_y_thick + 2 * cut_depth, center = false);
                    }
                }
            }
        }
    }
}

// --- Module: Gusset ---
module gusset(side) {
    // Side is -1 for left, 1 for right.
    // Right angle corner at y=5, z=5.
    // Legs: +20 in Y, +20 in Z.
    // Triangle vertices in YZ plane: (5,5), (25,5), (5,25)
    
    // X extent:
    // Left: -25 to -20
    // Right: 20 to 25
    x_start = (side == -1) ? -25 : 20;
    x_end = (side == -1) ? -20 : 25;
    
    // Create the 3D gusset by extruding the 2D triangle along X
    linear_extrude(height = x_end - x_start, center = false, convexity = 10) {
        polygon(points = [
            [5, 5],
            [25, 5],
            [5, 25]
        ]);
    }
}

// --- Main Assembly ---
union() {
    // Base Plate
    base_plate();
    
    // Motor Plate (standing on the back edge of the base)
    // Base is z=0..5. Motor plate sits on y=0..5, z=0..50.
    // The motor plate's bottom face (z=0) aligns with the base's bottom face?
    // "standing on the back edge of the base" usually implies the motor plate's 
    // bottom face is at z=0, and its back face is at y=0, aligned with the base's back face.
    // Let's assume the motor plate's bottom is at z=0, same as the base.
    // The motor plate occupies y: 0..5, z: 0..50.
    // The base occupies y: 0..45, z: 0..5.
    // They overlap in y: 0..5, z: 0..5. This is correct for a union.
    motor_plate();
    
    // Left Gusset
    gusset(-1);
    
    // Right Gusset
    gusset(1);
}