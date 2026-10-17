// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
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
$platform_top_z = $floor_thickness + $platform_height; // Absolute Z of top surface

// Hole Dimensions
$hole_diameter = 2;
$hole_y = ($outer_y / 2) - ($wall_thickness); // Centered in Y relative to inner wall
$hole_z = 30; // Absolute Z position
$hole_extension = 0.5; // Extension past the face for clean cutting

// Resolution for curved shapes
$fn = 64;

// Helper function to calculate inner dimensions
$inner_x = $outer_x - (2 * $wall_thickness);
$inner_y = $outer_y - (2 * $wall_thickness);
$inner_z = $outer_z - $floor_thickness;

// Main Tank Body
// Constructed as a hollow box with a floor
difference() {
    // Outer Box
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
translate([
    ($outer_x / 2) - ($platform_length / 2), 
    $wall_thickness, // Aligned with inner wall start
    $floor_thickness
]) {
    // Platform Base (to ensure it's solid and connects to tank walls if needed, 
    // though the prompt implies a solid raised platform. We make it a solid block 
    // sitting on the floor level).
    cube([
        $platform_length, 
        $platform_width, 
        $platform_height
    ]);
}

// Electrode Holes
// Two holes, one at each end (X = 0 and X = $outer_x), 
// along the Y axis at the specified Y and Z.
// We use difference to cut these out of the existing solid.

// Left End Hole
translate([
    0, 
    $hole_y, 
    $hole_z
]) {
    cylinder(
        h = $outer_x + $hole_extension, // Extend past both ends
        r = $hole_diameter / 2,
        $fn = $fn
    );
}

// Right End Hole
translate([
    $outer_x, 
    $hole_y, 
    $hole_z
]) {
    cylinder(
        h = $outer_x + $hole_extension, // Extend past both ends
        r = $hole_diameter / 2,
        $fn = $fn
    );
}