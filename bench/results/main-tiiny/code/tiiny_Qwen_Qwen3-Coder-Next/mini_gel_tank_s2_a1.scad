// Buffer tank for mini horizontal gel-electrophoresis box
// Outer dimensions: 120 mm (X) x 70 mm (Y) x 40 mm (Z)
// Wall thickness: 3 mm, Floor thickness: 3 mm
// Platform: 60 mm long in X (centred), full inner width (Y), top at z = 13 (10 mm above inner floor)
// Electrode holes: 2 mm diameter, horizontal, at y = 0, z = 30, through each end wall

$fn = 64;

// Dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thick = 3;
floor_thick = 3;
platform_height = 13; // z-coordinate of platform top (from base)
hole_z = 30;
hole_d = 2;

// Inner dimensions
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;
inner_z = outer_z - floor_thick;

// Platform dimensions
platform_x = 60;
platform_y = inner_y;
platform_z = platform_height;

// Calculate positions
half_outer_x = outer_x / 2;
half_outer_y = outer_y / 2;

// Main tank shell
module tank_shell() {
    difference() {
        // Outer shell
        cube([outer_x, outer_y, outer_z]);
        
        // Inner cavity (removes interior)
        translate([wall_thick, wall_thick, floor_thick])
            cube([inner_x, inner_y, inner_z]);
    }
}

// Platform (solid raised platform)
module platform() {
    platform_start_x = (outer_x - platform_x) / 2;
    translate([platform_start_x, wall_thick, floor_thick])
        cube([platform_x, inner_y, platform_z]);
}

// Electrode holes - properly constrained within tank walls
module electrode_holes() {
    // Left hole (through left wall at x = wall_thick)
    translate([wall_thick - 0.01, 0, hole_z])
        cylinder(h = wall_thick + 0.02, r = hole_d / 2);
    
    // Right hole (through right wall at x = outer_x - wall_thick)
    translate([outer_x - wall_thick - 0.01, 0, hole_z])
        cylinder(h = wall_thick + 0.02, r = hole_d / 2);
}

// Build the buffer tank
module buffer_tank() {
    union() {
        // Tank shell
        tank_shell();
        
        // Platform
        platform();
        
        // Electrode holes
        electrode_holes();
    }
}

// Final tank
buffer_tank();