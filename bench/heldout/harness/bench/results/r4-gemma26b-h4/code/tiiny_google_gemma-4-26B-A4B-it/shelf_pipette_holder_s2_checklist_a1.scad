// Pipette Holder Clamp
// Designed for an 18mm thick shelf.
// Printed lying on its side (Z is the extrusion direction).

// --- Dimensions ---
shelf_thickness = 18.0;
spine_x_end     = 5.0;
spine_y_end     = 28.4;

bottom_jaw_x_start = -25.0;
bottom_jaw_x_end   = 5.0;
bottom_jaw_y_end    = 5.0;

arm_x_start      = -25.0;
arm_x_end        = 65.0;
arm_y_start      = 23.4;
arm_y_end        = 28.4;

extrusion_length = 105.0;

// Hole dimensions
hole_diameter    = 20.0;
hole_z_positions  = [17.5, 52.5, 87.5];
hole_x_pos       = 42.0;
// The hole is centered in the arm's Y-thickness. 
// Arm Y is 23.4 to 28.4 (thickness 5.0). Center is 25.9.
hole_y_center     = (arm_y_start + arm_y_end) / 2; 

$fn = 64;

module main_body() {
    union() {
        // Spine: x=0 to 5, y=0 to 28.4
        cube([spine_x_end, spine_y_end, extrusion_length]);
        
        // Bottom Jaw: x=-25 to 5, y=0 to 5
        translate([bottom_jaw_x_start, 0, 0])
            cube([bottom_jaw_x_end - bottom_jaw_x_start, bottom_jaw_y_end, extrusion_length]);
        
        // Top Jaw and Arm: x=-25 to 65, y=23.4 to 28.4
        translate([arm_x_start, arm_y_start, 0])
            cube([arm_x_end - arm_x_start, arm_y_end - arm_y_start, extrusion_length]);
    }
}

difference() {
    main_body();
    
    // Pipette Holes
    // Holes are through the arm along Y (vertically in use).
    // In print orientation (Z extrusion), the arm is in the XY plane.
    // "Through the arm along Y" means the cylinder axis is the Y axis.
    for (z_pos = hole_z_positions) {
        translate([hole_x_pos, hole_y_center, z_pos])
            rotate([0, 90, 0])
                cylinder(h = 100, d = hole_diameter); // h > 2*arm_thickness to ensure clean cut
    }
}