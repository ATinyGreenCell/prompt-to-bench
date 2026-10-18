// Pestle for 1.5 mL microcentrifuge tube - corrected version.
// Printed standing upright on XY plane.

// Dimensions
handle_d = 8;
handle_z_start = 0;
handle_z_end = 45;
cone_z_start = 45;
cone_z_end = 62;
tip_d = 3;
tip_center_z = 62;
groove_count = 4;
groove_width = 2;
groove_depth = 1;
groove_z_centers = [10, 15, 20, 25];

$fn = 64;

difference() {
    union() {
        // 1. Cylindrical handle
        cylinder(h = handle_z_end - handle_z_start, d = handle_d);
        
        // 2. Conical taper
        translate([0, 0, cone_z_start]) 
            cylinder(h = cone_z_end - cone_z_start, d1 = handle_d, d2 = tip_d);
        
        // 3. Rounded tip (sphere centered at tip_center_z)
        translate([0, 0, tip_center_z - tip_d / 2]) 
            sphere(d = tip_d);
    }
    
    // 4. Cut grooves
    // We subtract a "washer" shape (cylinder with a hole) for each groove
    // The hole diameter is (handle_d - 2 * groove_depth)
    // The outer diameter is handle_d
    // The height is groove_width
    hole_d = handle_d - 2 * groove_depth;
    
    for (z = groove_z_centers) {
        translate([0, 0, z - groove_width / 2]) {
            // Create a washer shape to cut out the groove
            // Outer diameter = handle_d
            // Inner diameter = hole_d
            // Height = groove_width
            difference() {
                cylinder(h = groove_width + 0.01, d = handle_d); // Outer cut
                cylinder(h = groove_width + 0.01, d = hole_d);   // Inner hole (to keep the handle solid in the middle)
            }
        }
    }
}