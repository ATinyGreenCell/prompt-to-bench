// Dimensions for the snap-on clip
rod_inner_diameter = 12.7;  // Inner diameter of the rod ring
rod_wall_thickness = 3;     // Wall thickness of the rod ring
rod_outer_diameter = rod_inner_diameter + 2 * rod_wall_thickness;  // 18.7 mm
rod_opening_width = 10;     // Width of the opening on the -X side of the rod ring

tubing_inner_diameter = 6;  // Inner diameter of the tubing ring
tubing_wall_thickness = 2;  // Wall thickness of the tubing ring
tubing_outer_diameter = tubing_inner_diameter + 2 * tubing_wall_thickness;  // 8 mm
tubing_opening_width = 4.5; // Width of the opening on the +X side of the tubing ring
tubing_offset_x = 15;       // X offset for the tubing ring
tubing_offset_y = 0;        // Y offset for the tubing ring

bridge_width = 6;           // Width of the bridge in Y direction
bridge_start_x = 8;         // Start X position of the bridge
bridge_end_x = 12;          // End X position of the bridge
bridge_center_y = 0;         // Y position of the bridge (centered)

// Define the rod ring with an opening on the -X side
rod_ring = union() {
    // Rod ring (full circle)
    cylinder(r = rod_outer_diameter / 2, h = 10, $fn = 64);
    
    // Cut out the opening on the -X side
    difference() {
        // Full ring (rod_outer_diameter)
        cylinder(r = rod_outer_diameter / 2, h = 10, $fn = 64);
        
        // Opening on -X side
        translate([-rod_inner_diameter / 2, 0, 0]) {
            cube([rod_opening_width, rod_inner_diameter, 10], center=true);
        }
    }
};

// Define the tubing ring with an opening on the +X side
tubing_ring = union() {
    // Tubing ring (full circle)
    translate([tubing_offset_x, tubing_offset_y, 0]) {
        cylinder(r = tubing_outer_diameter / 2, h = 10, $fn = 64);
    }
    
    // Cut out the opening on the +X side
    difference() {
        // Full ring (tubing_outer_diameter)
        translate([tubing_offset_x, tubing_offset_y, 0]) {
            cylinder(r = tubing_outer_diameter / 2, h = 10, $fn = 64);
        }
        
        // Opening on +X side
        translate([tubing_offset_x + tubing_outer_diameter / 2, 0, 0]) {
            cube([tubing_opening_width, tubing_inner_diameter, 10], center=true);
        }
    }
};

// Define the bridge between the two rings
bridge = union() {
    // Solid bridge
    translate([bridge_start_x, bridge_center_y, 0]) {
        cube([bridge_end_x - bridge_start_x, bridge_width, 10], center=true);
    }
    
    // Ensure bridge does not block the rod or tubing holes
    // Cut a small notch on the rod side to avoid blocking
    translate([bridge_start_x - 0.5, bridge_center_y - bridge_width / 2, 0]) {
        cube([0.5, bridge_width, 10], center=true);
    }
    
    // Cut a small notch on the tubing side to avoid blocking
    translate([bridge_end_x + 0.5, bridge_center_y - bridge_width / 2, 0]) {
        cube([0.5, bridge_width, 10], center=true);
    }
};

// Combine all parts
final_clip = union() {
    rod_ring
    tubing_ring
    bridge
};

// Final output
final_clip;