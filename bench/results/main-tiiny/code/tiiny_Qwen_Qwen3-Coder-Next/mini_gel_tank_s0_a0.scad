// Buffer tank for mini horizontal gel-electrophoresis box
// Outer dimensions: 120mm (X) x 70mm (Y) x 40mm (Z)
// Wall thickness: 3mm, Floor thickness: 3mm
// Platform: 60mm long in X (centred), full inner width (Y), top at z = 13mm (10mm above inner floor)

// Dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thick = 3;
floor_thick = 3;
platform_height = 13; // z-coordinate of platform top
platform_len = 60;
hole_dia = 2;
hole_z = 30;

// Derived dimensions
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;
inner_z = outer_z - floor_thick;
platform_width = inner_y; // spans full inner width
platform_start_x = (inner_x - platform_len) / 2;
platform_end_x = platform_start_x + platform_len;

// Function to make holes extend through walls
module extend_hole(x, y, z, dia, len) {
    extend = 1; // extra length to ensure clean cut
    translate([x, y, z]) 
    rotate([0, 90, 0]) 
    cylinder(h = len + 2 * extend, r = dia / 2, $fn = 64);
}

// Main tank shell (outer box with hollow interior)
module tank_shell() {
    difference() {
        // Outer shell
        cube([outer_x, outer_y, outer_z]);
        
        // Hollow interior (walls and floor only)
        translate([wall_thick, wall_thick, floor_thick])
            cube([inner_x, inner_y, inner_z]);
        
        // Cut out platform area from the bottom (to create hollow under platform)
        // Platform is at platform_height (z=13), so we need to hollow from z=0 to z=platform_height
        // but only for the platform area (centred in X, full inner Y)
        translate([wall_thick + platform_start_x, wall_thick, 0])
            cube([platform_len, inner_y, platform_height + 0.01]);
    }
}

// Platform (solid raised platform)
module platform() {
    translate([wall_thick + platform_start_x, wall_thick, platform_height])
        cube([platform_len, inner_y, inner_z - platform_height + 0.01]);
}

// Electrode holes in end walls
module electrode_holes() {
    // Left hole (at x=0 wall, y=0, z=30)
    // Hole goes through the left wall (at x=0) along +X direction
    translate([0, 0, hole_z])
        rotate([0, 90, 0])
        cylinder(h = wall_thick + 1, r = hole_dia / 2, $fn = 64);
    
    // Right hole (at x=outer_x wall, y=0, z=30)
    // Hole goes through the right wall (at x=outer_x) along -X direction
    translate([outer_x, 0, hole_z])
        rotate([0, 90, 180]) // Rotate 180° around Y to point left
        cylinder(h = wall_thick + 1, r = hole_dia / 2, $fn = 64);
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

// Render
$fn = 64;
buffer_tank();