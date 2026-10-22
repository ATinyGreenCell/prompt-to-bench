// Buffer tank for mini horizontal gel-electrophoresis box
// Dimensions in millimetres (mm)

// Outer dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;

// Wall and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Platform dimensions
platform_length_x = 60;
platform_height_offset = 10; // Height above inner floor
platform_width_y = outer_y - 2 * wall_thickness; // Spans full inner width

// Electrode hole dimensions
hole_diameter = 2;
hole_z = 30;
hole_y = 0;

// Calculate inner dimensions
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// Calculate platform top Z position
// Floor is at z=3. Platform top is 10mm above floor.
platform_top_z = floor_thickness + platform_height_offset;
// Platform bottom is at floor_thickness (z=3)

// Calculate hole position relative to bottom
// Hole is at z=30.

// Main assembly module
module tank_body() {
    // Create the outer shell
    // We want the bottom at z=0, top at z=40.
    // Centered in X and Y.
    difference() {
        // Outer solid block
        // Center at (0,0,20) to make bottom at 0
        translate([0, 0, 20])
            cube([outer_x, outer_y, outer_z], center = true);
        
        // Subtract inner cavity
        // Cavity starts at z=3 (floor thickness)
        // Cavity size: inner_x, inner_y, inner_z
        translate([0, 0, floor_thickness + 20])
            cube([inner_x, inner_y, inner_z], center = true);
    }
}

module platform() {
    // Platform is a solid block
    // Centered in X, spans full inner Y
    // Bottom at z=3, Top at z=13
    // Center Z = 8
    translate([0, 0, 8])
        cube([platform_length_x, platform_width_y, platform_height_offset], center = true);
}

module electrode_holes() {
    // Two holes, one at each X end (left and right)
    // Hole center at y=0, z=30
    // Hole diameter 2mm
    // The holes must extend past the walls to ensure clean cuts
    
    // Left hole (at