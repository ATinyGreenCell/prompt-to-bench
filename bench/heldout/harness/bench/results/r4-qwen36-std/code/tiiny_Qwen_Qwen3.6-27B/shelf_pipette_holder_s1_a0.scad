// Dimensions (mm)
shelf_thickness = 18;
extrusion_length = 105;

// Profile dimensions
spine_x_min = 0;
spine_x_max = 5;
spine_y_min = 0;
spine_y_max = 28.4;

bottom_jaw_x_min = -25;
bottom_jaw_x_max = 5;
bottom_jaw_y_min = 0;
bottom_jaw_y_max = 5;

top_jaw_arm_x_min = -25;
top_jaw_arm_x_max = 65;
top_jaw_arm_y_min = 23.4;
top_jaw_arm_y_max = 28.4;

// Hole parameters
hole_diameter = 20;
hole_radius = hole_diameter / 2;
hole_x = 42;
hole_z_positions = [17.5, 52.5, 87.5];

$fn = 64;

// Build the part
difference() {
    // Main body: extrude the C-shaped profile along Z
    linear_extrude(height = extrusion_length, convexity = 10) {
        union() {
            // Spine
            square([spine_x_max - spine_x_min, spine_y_max - spine_y_min], center = false);
            translate([spine_x_min, spine_y_min])
                square([spine_x_max - spine_x_min, spine_y_max - spine_y_min]);

            // Bottom jaw
            translate([bottom_jaw_x_min, bottom_jaw_y_min])
                square([bottom_jaw_x_max - bottom_jaw_x_min, bottom_jaw_y_max - bottom_jaw_y_min]);

            // Top jaw and arm
            translate([top_jaw_arm_x_min, top_jaw_arm_y_min])
                square([top_jaw_arm_x_max - top_jaw_arm_x_min, top_jaw_arm_y_max - top_jaw_arm_y_min]);
        }
    }

    // Three holes through the arm along Z
    for (z_pos = hole_z_positions) {
        translate([hole_x, 0, z_pos])
            rotate([90, 0, 0])
            cylinder(r = hole_radius, h = extrusion_length + 2, center = true);
    }
}