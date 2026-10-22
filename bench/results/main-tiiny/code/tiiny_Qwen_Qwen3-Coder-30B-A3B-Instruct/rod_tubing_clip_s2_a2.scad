// Dimensions
rod_inner_diameter = 12.7; // mm
rod_wall_thickness = 3; // mm
rod_outer_diameter = rod_inner_diameter + 2 * rod_wall_thickness; // mm
rod_hole_width = 10; // mm
rod_hole_height = 10; // mm

tubing_inner_diameter = 6; // mm
tubing_wall_thickness = 2; // mm
tubing_outer_diameter = tubing_inner_diameter + 2 * tubing_wall_thickness; // mm
tubing_hole_width = 4.5; // mm
tubing_hole_height = 4.5; // mm

bridge_width = 6; // mm
bridge_x_start = 8; // mm
bridge_x_end = 12; // mm

// Rod ring
rod_ring = circle(d = rod_outer_diameter, $fn = 64);

// Cut out the rod hole
rod_hole = square([rod_hole_width, rod_hole_height], center = true);
rod_hole_pos = [-rod_hole_width/2, 0];

// Tubing ring
tubing_ring = circle(d = tubing_outer_diameter, $fn = 64);
tubing_ring_pos = [15, 0];

// Cut out the tubing hole
tubing_hole = square([tubing_hole_width, tubing_hole_height], center = true);
tubing_hole_pos = [tubing_hole_width/2 + 15, 0];

// Bridge
bridge = square([bridge_x_end - bridge_x_start, bridge_width], center = true);
bridge_pos = [(bridge_x_start + bridge_x_end)/2, 0];

// Final part
difference() {
    union() {
        // Rod ring with hole
        difference() {
            rod_ring;
            translate(rod_hole_pos) rod_hole;
        }
        
        // Tubing ring with hole
        difference() {
            translate(tubing_ring_pos) tubing_ring;
            translate(tubing_hole_pos) tubing_hole;
        }
        
        // Bridge
        translate(bridge_pos) bridge;
    }
    
    // Remove the bridge from the tubing ring
    translate(tubing_ring_pos) circle(d = tubing_inner_diameter, $fn = 64);
}