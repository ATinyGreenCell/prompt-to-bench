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
platform_y = outer_y - 2 * wall_thickness; // Spans full inner width
platform_top_z = 13; // Top of platform is at z = 13
platform_bottom_z = floor_thickness; // Bottom of platform is at floor level

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

// Calculate inner chamber lengths
chamber_length = (inner_x - platform_x) / 2;

// Build the tank
module buffer_tank() {
    union() {
        // Main tank body (outer shell)
        difference() {
            // Outer box
            cube([outer_x, outer_y, outer_z], center = false);
            
            // Inner cavity (subtract inner volume)
            translate([wall_thickness, wall_thickness, floor_thickness]) {
                cube([inner_x, inner_y, outer_z - floor_thickness], center = false);
            }
        }
        
        // Raised platform for gel tray
        translate([platform_start_x, 0, platform_bottom_z]) {
            cube([platform_x, platform_y, platform_top_z - platform_bottom_z], center = false);
        }
    }
    
    // Electrode holes through end walls
    // Left end wall hole
    translate([-outer_x/2 + wall_thickness/2, hole_y, hole_z]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_diameter, h = outer_x - 2 * wall_thickness + 0.01, center = false);
        }
    }
    
    // Right end wall hole
    translate([outer_x/2 - wall_thickness/2, hole_y, hole_z]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_diameter, h = outer_x - 2 * wall_thickness + 0.01, center = false);
        }
    }
}

// Set global resolution
$fn = 64;

// Render the part
buffer_tank();