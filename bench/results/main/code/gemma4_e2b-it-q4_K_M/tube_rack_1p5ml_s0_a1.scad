// Dimensions for the bench rack design

// Overall dimensions of the rectangular block
length_x = 106;  // Length along the X-axis (mm)
width_y = 72;     // Width along the Y-axis (mm)
height_z = 30;    // Total height of the rack (mm)

// Hole dimensions
hole_diameter = 11.2; // Diameter of the microcentrifuge tubes (mm)
hole_depth = 25;      // Depth of the holes (mm). Since total height is 30, and floor is 5, hole top should be at Z=30. Hole bottom should be at Z=5.
floor_thickness = 5;  // Thickness of the solid floor (mm)

// Grid spacing
center_to_center = 16; // Center-to-center distance for holes (mm)

// Hole grid configuration
num_holes_x = 6;      // Number of holes along the X-axis
num_holes_y = 4;      // Number of holes along the Y-axis

// Calculate positioning to center the grid on the block
total_span_x = (num_holes_x - 1) * center_to_center;
start_x = (length_x - total_span_x) / 2;

total_span_y = (num_holes_y - 1) * center_to_center;
start_y = (width_y - total_span_y) / 2;

// Calculate the radius for the circular holes
hole_radius = hole_diameter / 2;

// --- Main Module ---
module bench_rack() {
    // 1. Create the main solid block (from Z=0 to Z=height_z)
    cube([length_x, width_y, height_z], center = true);

    // 2. Define the volume to be subtracted (the holes)
    difference() {
        // The initial solid block is defined above. Now subtract the cylindrical holes.

        for (i = [0 : num_holes_x - 1]) {
            for (j = [0 : num_holes_y - 1]) {
                // Calculate the center coordinates for the current hole
                hole_center_x = start_x + (i * center_to_center) + (center_to_center / 2);
                hole_center_y = start_y + (j * center_to_center) + (center_to_center / 2);

                // The cylinder must span from the floor thickness (Z=5) up to the top of the block (Z=30).
                // Depth calculation: Total height (30) - Floor thickness (5) = 25 mm. This matches hole_depth.
                translate([hole_center_x, hole_center_y, floor_thickness]) {
                    cylinder(r = hole_radius, h = hole_depth, $fn = 64);
                }
            }
        }
    }
}

bench_rack();