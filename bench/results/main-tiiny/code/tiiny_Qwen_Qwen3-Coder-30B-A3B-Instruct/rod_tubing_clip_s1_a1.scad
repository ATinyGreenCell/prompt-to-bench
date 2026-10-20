// Dimensions
rod_inner_diameter = 12.7; // mm
rod_wall_thickness = 3; // mm
rod_outer_diameter = rod_inner_diameter + 2 * rod_wall_thickness; // mm
rod_hole_width = 10; // mm
tubing_inner_diameter = 6; // mm
tubing_wall_thickness = 2; // mm
tubing_outer_diameter = tubing_inner_diameter + 2 * tubing_wall_thickness; // mm
tubing_hole_width = 4.5; // mm
bridge_width = 6; // mm
bridge_x_start = 8; // mm
bridge_x_end = 12; // mm
clip_height = 10; // mm

// Rod ring
rod_ring_inner_radius = rod_inner_diameter / 2;
rod_ring_outer_radius = rod_outer_diameter / 2;

// Tubing ring
tubing_ring_inner_radius = tubing_inner_diameter / 2;
tubing_ring_outer_radius = tubing_outer_diameter / 2;

// Create the 2D profile
profile_2d = union() {
    // Rod ring
    difference() {
        circle(d = rod_outer_diameter, $fn = 64);
        circle(d = rod_inner_diameter, $fn = 64);
    }
    
    // Tubing ring
    translate([15, 0, 0]) {
        difference() {
            circle(d = tubing_outer_diameter, $fn = 64);
            circle(d = tubing_inner_diameter, $fn = 64);
        }
    }
    
    // Bridge
    translate([bridge_x_start, -bridge_width/2, 0]) {
        square([bridge_x_end - bridge_x_start, bridge_width], center = true);
    }
};

// Create the 3D clip by extruding the 2D profile
linear_extrude(height = clip_height) {
    // Cut out the rod hole
    translate([-rod_hole_width/2, 0, 0]) {
        square([rod_hole_width, 10], center = true);
    }
    
    // Cut out the tubing hole
    translate([15 + tubing_hole_width/2, 0, 0]) {
        square([tubing_hole_width, 5], center = true);
    }
    
    // The profile is already defined above
    profile_2d;
}