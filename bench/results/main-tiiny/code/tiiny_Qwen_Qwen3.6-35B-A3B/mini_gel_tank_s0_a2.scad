// Buffer tank for mini horizontal gel-electrophoresis box
// Dimensions in mm

// Outer dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;

// Wall and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Platform dimensions
platform_x = 60;
// Platform spans full inner width (Y)
platform_y = outer_y - 2 * wall_thickness; 
// Top of platform is at z = 13
platform_top_z = 13; 
// Bottom of platform is at floor level (z = floor_thickness)
platform_bottom_z = floor_thickness; 

// Electrode hole dimensions
hole_diameter = 2;
hole_z = 30;
hole_y = 0;

// Calculate inner dimensions
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;

// Calculate platform start and end in X (centred)
platform_start_x = (outer_x - platform_x) / 2;
platform_end_x = platform_start_x + platform_x;

// Set global resolution
$fn = 64;

// Build the tank
module buffer_tank() {
    // Main tank body (outer shell with inner cavity)
    difference() {
        // Outer box
        cube([outer_x, outer_y, outer_z], center = false);
        
        // Inner cavity (subtract inner volume)
        // The cavity starts at the inner floor height (z = floor_thickness)
        // and goes up to the top of the tank (z = outer_z)
        translate([wall_thickness, wall_thickness, floor_thickness]) {
            cube([inner_x, inner_y, outer_z - floor_thickness], center = false);
        }
    }
    
    // Raised platform for gel tray
    // The platform sits on the inner floor (z = floor_thickness)
    // and extends up to z = platform_top_z (13 mm)
    // It spans the full inner width in Y
    translate([platform_start_x, wall_thickness, platform_bottom_z]) {
        cube([platform_x, platform_y, platform_top_z - platform_bottom_z], center = false);
    }
    
    // Electrode holes through end walls
    // The holes are horizontal along X, at y = 0 (center of Y), z = 30
    // They go through the walls at the two X ends
    
    // Left end wall hole
    // The hole center is at x = wall_thickness/2 (center of left wall)
    // The hole length must span the entire inner width plus some extra to ensure clean cutting
    hole_length = outer_x - 2 * wall_thickness + 0.1; // Span inner width + small overlap
    translate([-outer_x/2 + wall_thickness/2, hole_y, hole_z]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_diameter, h = hole_length + 0.1, center = false);
        }
    }
    
    // Right end wall hole
    // The hole center is at x = outer_x - wall_thickness/2 (center of right wall)
    translate([outer_x/2 - wall_thickness/2, hole_y, hole_z]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_diameter, h = hole_length + 0.1, center = false);
        }
    }
}

// Render the part
buffer_tank();