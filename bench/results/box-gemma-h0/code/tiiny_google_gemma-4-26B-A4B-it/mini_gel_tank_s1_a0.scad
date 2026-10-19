// --- Parameters ---
// Outer dimensions of the tank
outer_x = 120; // Length of the tank (X)
outer_y = 70;  // Width of the tank (Y)
outer_z = 40;  // Height of the tank (Z)

// Wall and floor thickness
wall_thickness = 3; 
floor_thickness = 3;

// Platform dimensions
platform_length = 60; // Length of the platform along X
platform_height_from_inner_floor = 10; // Height of platform top relative to inner floor

// Electrode holes
hole_diameter = 2;
hole_y_pos = 0; // Y position of the hole center
hole_z_pos = 30; // Z position of the hole center

// Resolution
$fn = 64;

// --- Calculations ---
inner_x = outer_x - (2 * wall_thickness);
inner_y = outer_y - (2 * wall_thickness);
inner_z = outer_z - floor_thickness;

// The platform top is 10mm above the inner floor.
// Inner floor is at z = floor_thickness.
platform_top_z = floor_thickness + platform_height_from_inner_floor;

// --- Modeling ---

module buffer_tank() {
    difference() {
        // Main Body
        cube([outer_x, outer_y, outer_z]);

        // Hollow out the tank
        translate([wall_thickness, wall_thickness, floor_thickness])
            cube([inner_x, inner_y, outer_z]);

        // Electrode holes (drilled through the X-end walls)
        // We use a cylinder oriented along X. 
        // To ensure clean cuts, we make the cylinder longer than the tank.
        translate([-1, hole_y_pos, hole_z_pos])
            rotate([0, 90, 0])
                cylinder(d = hole_diameter, h = outer_x + 2);
    }

    // The Platform
    // It spans the full inner width (Y) and is 60mm long (X), centered.
    // It sits on the floor.
    translate([
        (outer_x - platform_length) / 2, 
        wall_thickness, 
        floor_thickness
    ])
    cube([platform_length, inner_y, platform_top_z]);
}

// Render the part
buffer_tank();