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
    difference() {
        // Outer solid block
        // Bottom at z=0, Top at z=40
        cube([outer_x, outer_y, outer_z], center = false);
        
        // Subtract inner cavity
        // Cavity starts at z=3 (floor thickness)
        // Cavity size: inner_x, inner_y, inner_z
        translate([0, 0, floor_thickness])
            cube([inner_x, inner_y, inner_z], center = false);
    }
}

module platform() {
    // Platform is a solid block
    // Centered in X, spans full inner Y
    // Bottom at z=3 (floor), Top at z=13
    translate([0, 0, floor_thickness])
        cube([platform_length_x, platform_width_y, platform_height_offset], center = false);
}

module electrode_holes() {
    // Two holes, one at each X end (left and right)
    // Hole center at y=0, z=30
    // Hole diameter 2mm
    // The holes must extend past the walls to ensure clean cuts
    
    // Left hole (at x = -outer_x/2)
    // We use a cylinder that is tall enough to cut through the wall
    // Wall is at x = -60. Hole center at -60.
    // Cylinder extends from x = -60 - 1 to x = -60 + 1 (diameter 2)
    // But we need to cut through the wall. The wall is at x = -60.
    // The cylinder should be centered at x = -60.
    // To ensure it cuts the wall, we make it slightly longer than the wall thickness?
    // Actually, the cylinder is the cutting tool.
    // The wall is at x = -60. The cylinder center is at x = -60.
    // The cylinder radius is 1. So it covers x from -61 to -59.
    // The wall is at x = -60. The cylinder cuts through it.
    // We need to ensure the cylinder extends in Y and Z to cut the wall.
    // Z: 30. Wall height is 40. Cylinder height needs to be > 40.
    // Y: 0. Wall width is 70. Cylinder height (along Y) needs to be > 70.
    
    // Left hole
    translate([-outer_x/2, 0, hole_z])
        cylinder(d = hole_diameter, h = outer_z + 10, center = true);
        
    // Right hole
    translate([outer_x/2, 0, hole_z])
        cylinder(d = hole_diameter, h = outer_z + 10, center = true);
}

// Main assembly
// We need to subtract the holes from the tank body, then union the platform.
// The platform is inside the tank.

union() {
    // Tank body with holes
    difference() {
        tank_body();
        electrode_holes();
    }
    
    // Platform
    platform();
}