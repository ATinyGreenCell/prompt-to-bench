// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
$outer_width_x = 120; // X
$outer_width_y = 70;  // Y
$outer_height_z = 40; // Z

// Wall and Floor Thickness
$wall_thickness = 3;
$floor_thickness = 3;

// Platform Dimensions
$platform_length_x = 60; // Length in X (centred)
$platform_width_y = $outer_width_y; // Spans full outer width (Y)
$platform_height_rel_inner = 10; // Height above inner floor

// Electrode Hole Dimensions
$hole_diameter = 2;
$hole_y_pos = 0;
$hole_z_pos = 30;

// Quality Settings
$fn = 64;

// Calculate Inner Dimensions
$inner_width_x = $outer_width_x - 2 * $wall_thickness;
$inner_width_y = $outer_width_y - 2 * $wall_thickness;
$inner_height_z = $outer_height_z - $floor_thickness - $wall_thickness;

// Calculate Platform Top Z
// Inner floor is at Z = $floor_thickness
// Platform top is at Z = $floor_thickness + $platform_height_rel_inner
$platform_top_z = $floor_thickness + $platform_height_rel_inner;

// Start modeling
difference() {
    // 1. Main Tank Body (Open Top)
    // Outer box minus top face
    cube([
        $outer_width_x, 
        $outer_width_y, 
        $outer_height_z
    ], center = false);
    
    // Cut open top (extend slightly past top face)
    translate([0, 0, $outer_height_z - 0.01]) {
        cube([
            $outer_width_x, 
            $outer_width_y, 
            0.02
        ]);
    }

    // 2. Internal Platform
    // Position: Centred in X, Full Width in Y, Sitting on inner floor
    // The platform spans the FULL width (Y) of the tank.
    // Since the tank is 70mm wide and the platform is 70mm wide, it spans the entire outer width.
    // Center X: 120 / 2 = 60. Length 60 -> X range [30, 90].
    // Center Y: 70 / 2 = 35. Width 70 -> Y range [0, 70].
    // Base Z: $floor_thickness (3). Height 10 -> Top Z = 13.
    translate([
        ($outer_width_x / 2) - ($platform_length_x / 2), 
        ($outer_width_y / 2) - ($platform_width_y / 2), 
        $floor_thickness
    ]) {
        // Platform is a solid block
        cube([
            $platform_length_x, 
            $platform_width_y, 
            $platform_height_rel_inner
        ]);
    }

    // 3. Electrode Holes
    // Two holes: Left and Right ends of the tank.
    // Hole center X: 
    // Left Wall X center: $wall_thickness (3)
    // Right Wall X center: $outer_width_x - $wall_thickness (117)
    // Hole center Y: $hole_y_pos (0)
    // Hole center Z: $hole_z_pos (30)
    // Hole Radius
    $hole_radius = $hole_diameter / 2;
    
    // Left Hole
    translate([
        $wall_thickness, 
        $hole_y_pos, 
        $hole_z_pos
    ]) {
        cylinder(
            h = $outer_height_z, 
            r = $hole_radius, 
            center = false
        );
    }
    
    // Right Hole
    translate([
        $outer_width_x - $wall_thickness, 
        $hole_y_pos, 
        $hole_z_pos
    ]) {
        cylinder(
            h = $outer_height_z, 
            r = $hole_radius, 
            center = false
        );
    }
}