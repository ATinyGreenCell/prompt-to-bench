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
$platform_z_offset = $floor_thick + $platform_height; // Z position of top surface

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
// Outer box: 120x70x40
// Cut out inner void: (120-6)x(70-6)x(40-3) = 114x64x37
// The void starts at Z=0 (bottom) and goes up to Z=37 (top of inner floor)
tank_body = union(
    cube([
        $outer_x, 
        $outer_y, 
        $outer_z
    ]),
    difference() {
        // Create the void for the liquid
        translate([
            $wall_thick, 
            $wall_thick, 
            0
        ])
        cube([
            $inner_x, 
            $inner_y, 
            $inner_z
        ]);
    }
);

// Raised Platform
// Located in the middle of the tank (X), spanning full width (Y)
// Base sits on the inner floor (Z = $floor_thick)
// Top is at Z = $floor_thick + $platform_height
platform = difference() {
    // Solid block for the platform
    translate([
        ($outer_x / 2) - ($platform_x / 2),
        0, // Centered in Y
        $floor_thick
    ])
    cube([
        $platform_x,
        $platform_y,
        $platform_height
    ]);
    
    // Cut out the void for the buffer chambers below the platform
    // The void needs to go from Z=0 up to the bottom of the platform ($floor_thick)
    translate([
        ($outer_x / 2) - ($platform_x / 2),
        0,
        0
    ])
    cube([
        $platform_x,
        $platform_y,
        $floor_thick
    ]);
};

// Electrode Holes
// Two holes: one at each end (X = +/- 30mm from center)
// Hole center: Y=0, Z=30
// Diameter: 2mm
// Orientation: Horizontal along X axis
hole = difference() {
    cylinder(
        h = $outer_z + 1, // Extend slightly past top and bottom
        r = $hole_diameter / 2,
        $fn = $fn
    );
};

// Assemble Final Part
final_part = union(
    tank_body,
    platform
);

// Apply holes
difference() {
    final_part;
    
    for (x_pos = [-($outer_x/2) + ($platform_x/2), ($outer_x/2) - ($platform_x/2)]) {
        translate([
            x_pos,
            $hole_y,
            $hole_z
        ])
        rotate([90, 0, 0]) // Rotate cylinder to lie along X axis
        hole;
    }
}