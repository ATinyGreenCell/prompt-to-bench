// Dimensions for the snap-on clip
// Rod specifications
rod_id = 12.7; // Inner diameter of the rod ring (1/2 inch)
rod_wall = 3;   // Wall thickness of the rod ring
rod_od = rod_id + 2 * rod_wall; // Outer diameter of the rod ring (18.7 mm)
rod_center_x = 0; // X position of the rod ring center
rod_center_y = 0; // Y position of the rod ring center

// Tubing specifications
tubing_id = 6; // Inner diameter of the tubing ring
tubing_wall = 2; // Wall thickness of the tubing ring
tubing_od = tubing_id + 2 * tubing_wall; // Outer diameter of the tubing ring (10 mm)
tubing_center_x = 15; // X position of the tubing ring center
tubing_center_y = 0; // Y position of the tubing ring center

// Bridge specifications
bridge_x1 = 8; // Left X coordinate of the bridge
bridge_x2 = 12; // Right X coordinate of the bridge
bridge_width_y = 6; // Width of the bridge in Y direction

// Opening specifications
rod_opening_y_half = 5; // Half-width of the opening on the rod ring
tubing_opening_y_half = 2.25; // Half-width of the opening on the tubing ring

// Print orientation
print_height = 10; // Height of the extrusion in Z direction

// $fn for curved shapes to ensure roundness
$fn = 64;

// Main part construction - 2D profile extruded to 3D
linear_extrude(height = print_height) {
    difference() {
        // Union of all 2D shapes
        union() {
            // 1. Rod Ring (2D) - centered at origin
            difference() {
                circle(r = rod_od / 2);
                circle(r = rod_id / 2);
            }
            translate([rod_center_x, rod_center_y]);
            
            // 2. Tubing Ring (2D) - centered at x = 15, y = 0
            difference() {
                circle(r = tubing_od / 2);
                circle(r = tubing_id / 2);
            }
            translate([tubing_center_x, tubing_center_y]);
            
            // 3. Solid Bridge (2D) - between x = 8 and x = 12
            square([bridge_x2 - bridge_x1, bridge_width_y]);
            translate([bridge_x1 + (bridge_x2 - bridge_x1) / 2, 0]);
        }
        
        // Cutout 1: -X side of rod ring (x < 0, -5 < y < 5)
        // Box extends past the ring face to satisfy Rule 5
        square([20, rod_opening_y_half * 2]);
        translate([-10, 0]);
        
        // Cutout 2: +X side of tubing ring (x > 15, -2.25 < y < 2.25)
        // Box extends past the ring face to satisfy Rule 5
        square([10, tubing_opening_y_half * 2]);
        translate([tubing_center_x + 5, 0]);
    }
}