// NEMA 17 Stepper Motor L-Bracket
// Print orientation: Base plate on XY plane (Z=0), building upward.
// Centred on origin in X and Y.

// Base Plate Dimensions
$base_x = 50; // x from -25 to 25
$base_y = 45; // y from 0 to 45
$base_z = 5;  // z from 0 to 5

// Base Mounting Holes (M4)
$base_hole_d = 4.5;
$base_hole_x1 = -17;
$base_hole_y1 = 30;
$base_hole_x2 = 17;
$base_hole_y2 = 30;

// Vertical Motor Plate Dimensions
$motor_plate_x = 50; // x from -25 to 25
$motor_plate_y = 5;  // y from 0 to 5
$motor_plate_z = 50; // z from 0 to 50

// Motor Boss Hole
$boss_hole_d = 23;
$boss_hole_x = 0;
$boss_hole_z = 28;

// Motor Screw Holes (M3)
$screw_hole_d = 3.4;
$screw_pattern_size = 31; // 31 mm square pattern
$screw_hole_count = 4;

// Gusset Dimensions
$gusset_thickness = 5; // x thickness
$gusset_leg_y = 20;    // leg along +Y
$gusset_leg_z = 20;    // leg along +Z
$gusset_x_start_left = -25;
$gusset_x_end_left = -20;
$gusset_x_start_right = 20;
$gusset_x_end_right = 25;
$gusset_corner_y = 5;
$gusset_corner_z = 5;

// Global settings
$fn = 64;

module base_plate() {
    // Main block
    translate([0, 0, 0])
        cube([$base_x, $base_y, $base_z]);

    // Cut M4 holes
    $fn = 64;
    for (i = [0, 1]) {
        translate([
            i == 0 ? $base_hole_x1 : $base_hole_x2,
            i == 0 ? $base_hole_y1 : $base_hole_y2,
            0
        ])
            cylinder(
                h = $base_z + 0.1, // Extend slightly past top face
                d = $base_hole_d,
                $fn = 64
            );
    }
}

module motor_plate() {
    // Main block
    translate([0, 0, 0])
        cube([$motor_plate_x, $motor_plate_y, $motor_plate_z]);

    // Cut Boss Hole
    // Centre in Y is at $motor_plate_y / 2 = 2.5
    translate([
        $boss_hole_x,
        $motor_plate_y / 2, 
        $boss_hole_z
    ])
        cylinder(
            h = $motor_plate_z + 0.1, // Extend slightly past top/bottom
            d = $boss_hole_d,
            $fn = 64
        );

    // Cut Screw Holes (31mm square pattern centred on boss)
    // Pattern size 31mm means distance between opposite holes is 31mm.
    // Offset from center = 31 / 2 = 15.5mm.
    $offset = $screw_pattern_size / 2;
    $y_pos = $motor_plate_y / 2; // Centre Y of plate

    for (i = [0, 1]) {
        for (j = [0, 1]) {
            translate([
                $boss_hole_x + (i == 0 ? -$offset : $offset),
                $y_pos + (j == 0 ? -$offset : $offset),
                $boss_hole_z
            ])
                cylinder(
                    h = $motor_plate_z + 0.1, // Extend slightly past top/bottom
                    d = $screw_hole_d,
                    $fn = 64
                );
        }
    }
}

module gusset() {
    // Right triangle in YZ plane, extruded along X
    // Legs: 20mm along +Y, 20mm along +Z
    // Right angle corner at (y=5, z=5) relative to global origin
    // The triangle vertices in YZ plane (relative to corner):
    // Corner (0,0) -> (20,0) -> (20,20) -> (0,20) -> (0,0) creates a square.
    // We need a triangle. Vertices: (0,0), (20,0), (0,20).
    // This forms a right triangle with the right angle at (0,0).
    // The user specified the right-angle corner is at y=5, z=5.
    // So the triangle occupies Y: 5 to 25, Z: 5 to 25.
    
    translate([0, $gusset_corner_y, $gusset_corner_z]) {
        // Define the triangle path relative to the corner (0,0)
        // Points: (0,0) -> (20,0) -> (0,20) -> (0,0)
        polygon(
            points = [
                [0, 0],
                [$gusset_leg_y, 0],
                [0, $gusset_leg_z]
            ]
        );
    }
}

module main() {
    union() {
        // Center the entire assembly on the origin.
        // Base plate X: -25 to 25 (width 50). Center X = 0.
        // Base plate Y: 0 to 45 (width 45). Center Y = 22.5.
        translate([-25, 22.5, 0]) {
            base_plate();
            motor_plate();
            
            // Left Gusset (x from -25 to -20)
            // Center of this 5mm thick gusset is at x = -22.5
            translate([-22.5, 0, 0])
                gusset();
                
            // Right Gusset (x from 20 to 25)
            // Center of this 5mm thick gusset is at x = 22.5
            translate([22.5, 0, 0])
                gusset();
        }
    }
}

main();