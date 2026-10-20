// Define dimensions
rod_inner_diameter = 12.7;          // Inner diameter of the rod ring
rod_wall_thickness = 3;             // Wall thickness of the rod ring
rod_outer_diameter = rod_inner_diameter + 2 * rod_wall_thickness;  // Outer diameter of the rod ring
rod_height = 10;                     // Height of the extrusion (Z-axis)
rod_opening_width = 10;              // Width of the opening on the -X side of the rod ring

tubing_inner_diameter = 6;          // Inner diameter of the tubing ring
tubing_wall_thickness = 2;           // Wall thickness of the tubing ring
tubing_outer_diameter = tubing_inner_diameter + 2 * tubing_wall_thickness;  // Outer diameter of the tubing ring
tubing_x_offset = 15;                // X offset for the tubing ring
tubing_y_offset = 0;                 // Y offset for the tubing ring
tubing_opening_width = 4.5;           // Width of the opening on the +X side of the tubing ring
tubing_opening_half_width = tubing_opening_width / 2;  // Half of the opening width for symmetry

bridge_width = 6;                    // Width of the bridge in Y direction
bridge_start_x = 8;                   // Start X position of the bridge
bridge_end_x = 12;                    // End X position of the bridge
bridge_y_offset = 0;                  // Y position of the bridge (centered)

$fn = 64;  // For curved shapes to ensure smoothness

// Create the rod ring
rod_ring = difference() {
    // Outer ring
    cylinder(r = rod_outer_diameter / 2, h = rod_height, $fn = 64);
    // Inner cutout
    cylinder(r = rod_inner_diameter / 2, h = rod_height, $fn = 64);
    // Opening on -X side
    translate([-rod_outer_diameter / 2 - 0.1, 0, 0])  // Slight offset to avoid coplanar faces
        square([rod_opening_width, rod_height], center = true);
};

// Create the tubing ring
tubing_ring = difference() {
    // Outer ring
    cylinder(r = tubing_outer_diameter / 2, h = rod_height, $fn = 64);
    // Inner cutout
    cylinder(r = tubing_inner_diameter / 2, h = rod_height, $fn = 64);
    // Opening on +X side
    translate([tubing_x_offset + 0.1, -tubing_opening_half_width, 0])  // Slight offset to avoid coplanar faces
        square([tubing_opening_width, rod_height], center = true);
};

// Create the bridge
bridge = cube([bridge_end_x - bridge_start_x, bridge_width, rod_height], center = true);

// Combine all parts
union() {
    rod_ring;
    translate([tubing_x_offset, tubing_y_offset, 0]) tubing_ring;
    translate([bridge_start_x, bridge_y_offset, 0]) bridge;
}