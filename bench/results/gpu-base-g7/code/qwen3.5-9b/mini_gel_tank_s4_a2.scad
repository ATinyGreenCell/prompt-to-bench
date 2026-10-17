// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
$outer_x = 120;
$outer_y = 70;
$outer_z = 40;

// Wall and Floor Thickness
$wall_thick = 3;
$floor_thick = 3;

// Platform Dimensions
$platform_x = 60;
$platform_y = $outer_y; // Spans full inner width
$platform_height = 10; // Height above inner floor

// Hole Dimensions
$hole_diameter = 2;
$hole_y = 0;
$hole_z = 30;

// Configuration
$fn = 128; // High resolution for smooth curves

// Derived Dimensions
$inner_x = $outer_x - (2 * $wall_thick);
$inner_y = $outer_y - (2 * $wall_thick);
$inner_z = $outer_z - $floor_thick; // Top of inner floor is at Z = $floor_thick

// Main Tank Body
// Constructed as a solid block with the internal void subtracted
tank_body = difference() {
    // Outer solid block
    cube([
        $outer_x, 
        $outer_y, 
        $outer_z
    ]);
    
    // Internal void (air space)
    translate([0, 0, 0]) 
    cube([
        $inner_x, 
        $inner_y, 
        $inner_z
    ]);
};

// Raised Platform
// Position: Centered in X, Full width in Y, Sitting on inner floor
// Inner floor top is at Z = $floor_thick (3mm)
// Platform top is at Z = 13mm
// Platform bottom is at Z = 3mm
translate([
    ($outer_x - $platform_x) / 2, 
    0, 
    $floor_thick
])
platform = cube([
    $platform_x, 
    $platform_y, 
    $platform_height
]);

// Electrode Holes
// Two holes: Left end and Right end
// Hole axis: X-axis (horizontal)
// Hole position: Y = 0, Z = 30
// Length must extend slightly past the tank ends to ensure clean cutting
hole_length = $outer_x + 2;

hole_left = translate([
    ($outer_x - $hole_diameter) / 2, 
    $hole_y, 
    $hole_z
]) cylinder(h = hole_length, r = $hole_diameter / 2, $fn = $fn);

hole_right = translate([
    ($outer_x + $hole_diameter) / 2, 
    $hole_y, 
    $hole_z
]) cylinder(h = hole_length, r = $hole_diameter / 2, $fn = $fn);

// Final Assembly
// Union the tank and platform, then subtract the holes
final_tank = union(
    tank_body,
    platform
) difference([
    hole_left,
    hole_right
]);

// Render
final_tank;