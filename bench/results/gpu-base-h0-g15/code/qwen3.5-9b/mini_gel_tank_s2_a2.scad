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
$hole_y = $wall_thickness; // Positioned at inner face of side wall to avoid protrusion
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
// Located at Y = $wall_thickness (inner face) and Z = 30.
// We create two holes: one at the left wall (X=0) and one at the right wall (X=120).
// The cylinder length is set to exactly the wall thickness + extension to stay within bounds.

for (side = [0, 1]) {
    // Calculate center X for the cylinder
    // Side 0 (Left): Centered at X = $wall_thickness / 2
    // Side 1 (Right): Centered at X = $outer_x - ($wall_thickness / 2)
    if (side == 0) {
        $center_x = $wall_thickness / 2;
    } else {
        $center_x = $outer_x - ($wall_thickness / 2);
    }
    
    // Cylinder length: Wall thickness + extension
    $cylinder_length = $wall_thickness + $hole_extension;
    
    translate([
        $center_x, 
        $hole_y, 
        $hole_z
    ]) {
        cylinder(
            h = $cylinder_length, 
            r = $hole_radius,
            $fn = $fn
        );
    }
}