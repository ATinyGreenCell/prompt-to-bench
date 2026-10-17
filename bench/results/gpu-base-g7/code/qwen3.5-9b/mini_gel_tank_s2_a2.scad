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
$platform_top_z = $floor_thickness + $platform_height; // Absolute Z of top surface (should be 13)

// Hole Dimensions
$hole_diameter = 2;
$hole_y = 0; // Specified position
$hole_z = 30; // Absolute Z position
$hole_extension = 0.5; // Extension past the face for clean cutting

// Resolution for curved shapes
$fn = 64;

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
            $outer_x - (2 * $wall_thickness), 
            $outer_y - (2 * $wall_thickness), 
            $outer_z - $floor_thickness
        ]);
    }
}

// Raised Platform
// Positioned in the middle of the tank, spanning full inner width
// Base is at z = $floor_thickness (3), height is 10, so top is at 13.
translate([
    ($outer_x / 2) - ($platform_length / 2), 
    $wall_thickness, // Aligned with inner wall start
    $floor_thickness
]) {
    cube([
        $platform_length, 
        $platform_width, 
        $platform_height
    ]);
}

// Electrode Holes
// Two holes, one at each end (X = 0 and X = $outer_x), 
// along the Y axis at the specified Y and Z.
// Orientation: Horizontal along X axis.
// We use difference to cut these out of the existing solid.

// Helper to create a horizontal hole
module horizontal_hole(x_pos, y_pos, z_pos, length) {
    translate([x_pos, y_pos, z_pos]) {
        // Cylinder aligned with X axis (rotate 90 deg around Y)
        rotate([0, 90, 0]) {
            cylinder(
                h = length,
                r = $hole_diameter / 2,
                $fn = $fn
            );
        }
    }
}

// Left End Hole
// Position: x=0, y=0, z=30
// Length: Must cut through the wall at x=0 (thickness 3) plus extension.
// To keep bounding box at 120, we cut from x=-extension to x=wall_thickness+extension.
// Length = $wall_thickness + 2 * $hole_extension
length_left = $wall_thickness + (2 * $hole_extension);
horizontal_hole(0, $hole_y, $hole_z, length_left);

// Right End Hole
// Position: x=120, y=0, z=30
// Length: Same as left
length_right = $wall_thickness + (2 * $hole_extension);
horizontal_hole($outer_x, $hole_y, $hole_z, length_right);