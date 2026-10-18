// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions (Strictly enforced)
$outer_x = 120;
$outer_y = 70;
$outer_z = 40;

// Wall and Floor Thickness
$wall_thickness = 3;
$floor_thickness = 3;

// Platform Dimensions
$platform_length = 60; // X dimension
$platform_width = $outer_y - (2 * $wall_thickness); // Spans full inner width
$platform_height = 10; // Height above inner floor
$platform_top_z = $floor_thickness + $platform_height; // Absolute Z of top surface (13)

// Hole Dimensions
$hole_diameter = 2;
$hole_radius = $hole_diameter / 2;
$hole_y = 0; // Specified position
$hole_z = 30; // Absolute Z position
$hole_extension = 0.5; // Extension past face for clean cutting

// Configuration
$fn = 128; // High resolution for smooth curves

// Calculate Inner Dimensions
$inner_x = $outer_x - (2 * $wall_thickness);
$inner_y = $outer_y - (2 * $wall_thickness);
$inner_z = $outer_z - $floor_thickness;

// Main Tank Body
// Constructed as a hollow box with a floor
difference() {
    // Outer Block
    cube([
        $outer_x, 
        $outer_y, 
        $outer_z
    ]);
    
    // Inner Void (Hollow space)
    // The void starts at z = $floor_thickness
    translate([
        $wall_thickness, 
        $wall_thickness, 
        $floor_thickness
    ]) {
        cube([
            $inner_x, 
            $inner_y, 
            $inner_z
        ]);
    }
}

// Raised Platform
// Positioned in the middle of the tank, spanning full inner width
// Starts at inner wall (Y = $wall_thickness)
translate([
    ($outer_x / 2) - ($platform_length / 2), 
    $wall_thickness, // Aligned with inner wall start
    $floor_thickness
]) {
    // Platform Base (extends through the void to the floor)
    cube([
        $platform_length, 
        $platform_width, 
        $platform_height + $floor_thickness
    ]);
}

// Electrode Holes
// Drilled horizontally along X axis.
// To maintain the 120mm outer dimension, we drill starting from the inner face of the wall
// and extend outwards.
// Left Wall: Starts at X = $wall_thickness, extends to X = 0 (and slightly beyond)
// Right Wall: Starts at X = $outer_x - $wall_thickness, extends to X = $outer_x (and slightly beyond)

for (side = [0, 1]) {
    // Calculate start X for the cylinder
    // Side 0 (Left): Start at inner face ($wall_thickness)
    // Side 1 (Right): Start at inner face ($outer_x - $wall_thickness)
    $start_x = (side == 0) ? $wall_thickness : ($outer_x - $wall_thickness);
    
    // Calculate end X for the cylinder (must extend past the outer face)
    // Side 0: End at 0 - $hole_extension
    // Side 1: End at $outer_x + $hole_extension
    $end_x = (side == 0) ? ($hole_extension) : ($outer_x + $hole_extension);
    
    translate([
        ($start_x + $end_x) / 2, // Center the cylinder between start and end
        $hole_y, 
        $hole_z
    ]) {
        // Cylinder for the hole
        // Length is the distance from inner face to outer face plus extension
        $cylinder_length = ($outer_x - $wall_thickness) + $hole_extension;
        
        cylinder(
            h = $cylinder_length, 
            r = $hole_radius,
            $fn = $fn
        );
    }
}