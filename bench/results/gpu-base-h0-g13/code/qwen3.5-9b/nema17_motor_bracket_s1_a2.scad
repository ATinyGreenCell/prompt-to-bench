// NEMA 17 Stepper Motor L-Bracket
// Print orientation: Base plate on XY plane (Z=0), building upward.

// Base Plate Dimensions
$base_width_x = 50;   // x from -25 to 25
$base_length_y = 45;  // y from 0 to 45
$base_height_z = 5;   // z from 0 to 5

// Base Mounting Holes (M4)
$base_hole_diameter = 4.5;
$base_hole_x1 = -17;
$base_hole_y1 = 30;
$base_hole_x2 = 17;
$base_hole_y2 = 30;

// Vertical Motor Plate Dimensions
$plate_width_x = 50;  // x from -25 to 25
$plate_thickness_y = 5; // y from 0 to 5
$plate_height_z = 50;  // z from 0 to 50

// Motor Boss Hole
$boss_hole_diameter = 23;
$boss_hole_x = 0;
$boss_hole_z = 28;

// Motor Screw Holes (M3)
$screw_hole_diameter = 3.4;
$screw_pattern_size = 31; // 31mm square pattern
$screw_hole_count = 4;

// Gusset Dimensions
$gusset_thickness = 5;
$gusset_leg_y = 20;
$gusset_leg_z = 20;
$gusset_left_x_start = -25;
$gusset_left_x_end = -20;
$gusset_right_x_start = 20;
$gusset_right_x_end = 25;

// General Settings
$fn = 64;

module base_plate() {
    // Main block
    translate([0, 0, 0])
        cube([$base_width_x, $base_length_y, $base_height_z]);

    // Through-holes (cutting shapes must extend past faces)
    // Hole 1
    translate([$base_hole_x1, $base_hole_y1, 0])
        cylinder(h = $base_height_z + 1, d = $base_hole_diameter, $fn = 64);
    
    // Hole 2
    translate([$base_hole_x2, $base_hole_y2, 0])
        cylinder(h = $base_height_z + 1, d = $base_hole_diameter, $fn = 64);
}

module motor_plate() {
    // Main block standing on the back edge of the base (y=0 to y=5)
    translate([0, 0, 0])
        cube([$plate_width_x, $plate_thickness_y, $plate_height_z]);

    // Boss hole (along Y axis)
    translate([0, 0, $boss_hole_z])
        cylinder(h = $plate_thickness_y + 1, d = $boss_hole_diameter, $fn = 64);

    // Screw holes (31mm square pattern centered on boss hole)
    // Pattern center is at x=0, z=28.
    // Square size 31mm -> half size 15.5mm.
    $offset = $screw_pattern_size / 2;
    
    for (i = [0:3]) {
        // Calculate corner positions based on index using modulo arithmetic
        // 0: bottom-left, 1: bottom-right, 2: top-right, 3: top-left
        // x_offset = -offset if i is even, +offset if i is odd
        // z_offset = -offset if i < 2, +offset if i >= 2
        tx = (i % 2 == 0) ? -$offset : $offset;
        tz = (i < 2) ? -$offset : $offset;
        
        translate([tx, 0, $boss_hole_z + tz])
            cylinder(h = $plate_thickness_y + 1, d = $screw_hole_diameter, $fn = 64);
    }
}

module gusset() {
    // Right triangle in YZ plane, extruded along X.
    // Right angle corner at y=5, z=5 relative to the main block's local origin (0,0,0).
    // Legs: 20mm along +Y, 20mm along +Z.
    // Thickness: 5mm along X.
    // The polygon is defined relative to the corner (0,0) in the local extrusion space.
    // Point 1: (0,0) -> corresponds to y=5, z=5 in global
    // Point 2: (20,0) -> corresponds to y=25, z=5 in global
    // Point 3: (0,20) -> corresponds to y=5, z=25 in global
    
    translate([0, 0, 0])
        linear_extrude(height = $gusset_thickness, center = true)
            polygon(points = [
                [0, 0],          // Relative to corner
                [$gusset_leg_y, 0], // Relative (20,0)
                [0, $gusset_leg_z]  // Relative (0,20)
            ], $fn = 64);
}

module main() {
    difference() {
        union() {
            base_plate();
            motor_plate();
            
            // Left Gusset (x from -25 to -20)
            // The gusset module creates a shape from x=0 to x=5 (thickness).
            // We translate it to start at -25.
            translate([$gusset_left_x_start, 0, 0])
                gusset();
            
            // Right Gusset (x from 20 to 25)
            // We translate it to start at 20.
            translate([$gusset_right_x_start, 0, 0])
                gusset();
        }
        
        // No additional cuts needed for the gussets as they are part of the union.
        // The difference block only cuts holes from the base and motor plate.
    }
}

main();