// Buffer tank for mini horizontal gel-electrophoresis box
// Outer dimensions: 120 mm (X) x 70 mm (Y) x 40 mm (Z)
// Wall thickness: 3 mm, floor thickness: 3 mm
// Platform: 60 mm long (X), full inner width (Y), top at z = 13 mm (10 mm above inner floor)

$fn = 64;

// Dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thick = 3;
floor_thick = 3;
platform_length = 60;
platform_height = 13; // z = 13 mm from bottom
hole_dia = 2;
hole_z = 30;

// Calculate inner dimensions
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;
inner_z = outer_z - floor_thick;

// Buffer tank shell
module tank_shell() {
    difference() {
        // Outer shell
        cube([outer_x, outer_y, outer_z]);
        
        // Inner cavity (removes interior)
        translate([wall_thick, wall_thick, floor_thick])
            cube([inner_x, inner_y, inner_z]);
        
        // Remove platform area from the bottom (to create hollow under platform)
        // Platform is centered in X, so it starts at (outer_x - platform_length)/2
        platform_start_x = (outer_x - platform_length) / 2;
        translate([wall_thick + platform_start_x, wall_thick, floor_thick])
            cube([platform_length, inner_y, platform_height]);
    }
}

// Platform (solid raised platform)
module platform() {
    platform_start_x = (outer_x - platform_length) / 2;
    translate([wall_thick + platform_start_x, wall_thick, floor_thick])
        cube([platform_length, inner_y, platform_height]);
}

// Electrode holes (through end walls at X = 0 and X = outer_x)
module electrode_holes() {
    // Left hole (at x = 0 wall, centered in Y and at z = 30)
    // Position: x = -0.01 (to cut through left wall), y = outer_y/2, z = hole_z
    translate([-0.01, outer_y/2, hole_z])
        cylinder(h = 0.02 + outer_x, d = hole_dia, center = true);
    
    // Right hole (at x = outer_x wall)
    translate([outer_x - 0.01, outer_y/2, hole_z])
        cylinder(h = 0.02 + outer_x, d = hole_dia, center = true);
}

// Build the buffer tank
module buffer_tank() {
    union() {
        // Tank shell
        tank_shell();
        
        // Platform
        platform();
        
        // Electrode holes (cut through end walls)
        electrode_holes();
    }
}

// Render the buffer tank
buffer_tank();