// NEMA 17 Stepper Motor L-Bracket
// Print orientation: Base plate on XY plane (Z=0), building upward.
// Centred on X, aligned to Y=0 at the back.

// Base Plate Dimensions
$base_width_x = 50;   // x from -25 to 25
$base_length_y = 45;  // y from 0 to 45
$base_height_z = 5;   // z from 0 to 5

// Base Mounting Holes (M4)
$base_hole_dia = 4.5;
$base_hole_x1 = -17;
$base_hole_y1 = 30;
$base_hole_x2 = 17;
$base_hole_y2 = 30;

// Vertical Motor Plate Dimensions
$plate_width_x = 50;  // x from -25 to 25
$plate_thickness_y = 5; // y from 0 to 5
$plate_height_z = 50;  // z from 0 to 50

// Motor Boss Hole
$boss_hole_dia = 23;
$boss_hole_x = 0;
$boss_hole_z = 28;

// Motor Screw Holes (M3)
$screw_hole_dia = 3.4;
$screw_pattern_size = 31; // 31mm square pattern
$screw_hole_count = 4;

// Gusset Dimensions
$gusset_thickness = 5; // Matches base height
$gusset_leg_y = 20;    // Along +Y
$gusset_leg_z = 20;    // Along +Z
$gusset_start_x_left = -25;
$gusset_start_x_right = 20;
$gusset_right_angle_y = 5;
$gusset_right_angle_z = 5;

// Global settings for quality
$fn = 64;

// --- Main Construction ---

// We build the part in a single difference block to ensure all holes cut through correctly
// and to handle the union of the base and plate seamlessly.

difference() {
    
    // 1. Base Plate
    translate([0, 0, 0])
        cube([$base_width_x, $base_length_y, $base_height_z]);

    // 2. Vertical Motor Plate
    // Positioned at y = 0, standing on the back edge of the base.
    // x range: -25 to 25 (width 50)
    // y range: 0 to 5 (thickness 5)
    // z range: 0 to 50 (height 50)
    translate([0, 0, 0])
        cube([$plate_width_x, $plate_thickness_y, $plate_height_z]);

    // 3. Base Mounting Holes (M4)
    // Hole 1
    translate([$base_hole_x1, $base_hole_y1, 0])
        cylinder(h = $base_height_z + 1, d = $base_hole_dia, $fn = 64);

    // Hole 2
    translate([$base_hole_x2, $base_hole_y2, 0])
        cylinder(h = $base_height_z + 1, d = $base_hole_dia, $fn = 64);

    // 4. Motor Boss Hole
    // Centre at x=0, z=28. Through the plate (along Y).
    // Plate is 5mm thick in Y.
    translate([$boss_hole_x, 0, $boss_hole_z])
        cylinder(h = $plate_thickness_y + 1, d = $boss_hole_dia, $fn = 64);

    // 5. Motor Screw Holes
    // 31mm square pattern centred on the boss hole.
    // Boss hole is at x=0, z=28.
    // Pattern size 31mm means distance from center to hole center is 31/2 = 15.5mm.
    // Holes at: x = +/- 15.5, z = +/- 15.5 relative to boss center.
    // Absolute coords: x = +/- 15.5, z = 28 +/- 15.5.
    // z1 = 28 - 15.5 = 12.5
    // z2 = 28 + 15.5 = 43.5
    // All holes are at y = 0 (center of plate thickness) to cut through.

    $screw_x_offset = $screw_pattern_size / 2;
    $screw_z_offset = $screw_pattern_size / 2;

    for (i = [0:3]) {
        if (i == 0) { 
            tx = -$screw_x_offset; 
            tz = -$screw_z_offset; 
        }
        else if (i == 1) { 
            tx = $screw_x_offset; 
            tz = -$screw_z_offset; 
        }
        else if (i == 2) { 
            tx = -$screw_x_offset; 
            tz = $screw_z_offset; 
        }
        else { 
            tx = $screw_x_offset; 
            tz = $screw_z_offset; 
        }
        
        translate([tx, 0, $boss_hole_z + tz])
            cylinder(h = $plate_thickness_y + 1, d = $screw_hole_dia, $fn = 64);
    }

    // 6. Triangular Gussets
    // Right triangle in YZ plane.
    // Legs: 20mm along +Y, 20mm along +Z.
    // Right angle corner at y=5, z=5.
    // This means the triangle occupies:
    // Y: from 5 to 25 (5 + 20)
    // Z: from 5 to 25 (5 + 20)
    // Thickness: 5mm along X.

    // Gusset Left (x = -25 to -20)
    // Right angle at (-25, 5, 5)
    // Extends to x = -20.
    // We define the triangle in local coords: (0,0) is the right angle.
    // Points: (0,0), (20,0), (0,20).
    // Translate to (-25, 5, 5). Extrude +5 in X.
    translate([$gusset_start_x_left, $gusset_right_angle_y, $gusset_right_angle_z])
        linear_extrude(height = $gusset_thickness, center = true)
            polygon(points = [[0, 0], [$gusset_leg_y, 0], [0, $gusset_leg_z]], convexity = 3);

    // Gusset Right (x = 20 to 25)
    // Right angle at (25, 5, 5)
    // Extends to x = 20.
    // Translate to (25, 5, 5). Extrude -5 in X.
    translate([$gusset_start_x_right, $gusset_right_angle_y, $gusset_right_angle_z])
        linear_extrude(height = -$gusset_thickness, center = true)
            polygon(points = [[0, 0], [$gusset_leg_y, 0], [0, $gusset_leg_z]], convexity = 3);
}