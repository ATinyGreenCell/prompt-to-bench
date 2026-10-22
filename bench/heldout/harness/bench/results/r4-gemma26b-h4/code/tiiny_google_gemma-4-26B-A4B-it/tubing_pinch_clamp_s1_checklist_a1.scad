// Pinch clamp for silicone tubing (up to 6.4 mm)
// Designed for FDM printing: printed flat in the XY plane.

// --- Dimensions ---
thickness = 8.0;           // Extrusion height (Z)
lower_len = 50.0;          // Length of lower jaw bar
lower_wid = 4.0;           // Width of lower jaw bar
lower_tongue_len = 6.0;    // Length of lower jaw tongue
lower_tongue_y_start = 2.5;
lower_tongue_y_end = 4.0;

upper_len = 60.0;          // Length of upper jaw bar
upper_wid = 4.0;           // Width of upper jaw bar
upper_y_start = 12.0;
upper_y_end = 16.0;

hinge_center_x = 0;
hinge_center_y = 8;
hinge_r_inner = 7.2;
hinge_r_outer = 8.0;

ridge_radius = 1.5;
ridge_x = 27.5;

latch_leg_x_start = 57.0;
latch_leg_x_end = 60.0;
latch_leg_y_start = 4.5;
latch_leg_y_end = 12.0;

latch_nose_x_start = 54.5;
latch_nose_x_end = 57.0;
latch_nose_y_start = 4.5;
latch_nose_y_end = 5.5;
latch_nose_z_offset = 0.5; // Height above the tongue

$fn = 64;

module hinge_half_ring() {
    // A half-ring on the x < 0 side
    // We use a difference of two cylinders, then cut it in half.
    difference() {
        // Outer half-circle
        translate([hinge_center_x, hinge_center_y, 0])
            rotate([0, 0, 180])
            cylinder(h = thickness, r = hinge_r_outer);
        
        // Inner half-circle
        translate([hinge_center_x, hinge_center_y, -1])
            rotate([0, 0, 180])
            cylinder(h = thickness + 2, r = hinge_r_inner);
            
        // Cut the right side to make it a half-ring (x > 0 side)
        translate([hinge_center_x - 1, hinge_center_y - hinge_r_outer - 1, -1])
            cube([hinge_r_outer * 2 + 2, hinge_r_outer * 2 + 2, thickness + 2]);
    }
}

module ridge_geometry() {
    // A half-round ridge on the inner face.
    // The ridge axis is along X. The cross-section is a semi-circle in YZ.
    // Since it's printed flat, we model it as a rotate_extrude of a semi-circle.
    rotate_extrude($fn=64)
        translate([ridge_radius, 0, 0])
        semi_circle_profile(ridge_radius);
}

// Helper to create the semi-circle profile for the ridge
module semi_circle_profile(r) {
    // This creates a semi-circle in the YZ plane
    // We use a polygon to ensure it's a clean 2D shape for rotate_extrude
    // The ridge is on the inner face, so it protrudes into the gap.
    // For lower jaw (y=4), ridge center is (27.5, 4, 4)
    // For upper jaw (y=12), ridge center is (27.5, 12, 4)
    // However, the ridge is a "half-round ridge on its inner face".
    // This implies the ridge is a cylinder with axis parallel to X.
    // We'll use a simpler approach: a cylinder rotated.
    
    // To make it a ridge along X:
    // We'll build the ridge as a cylinder and rotate it.
}

// Corrected Ridge: A cylinder with axis along X
module ridge_on_face(x_pos, y_pos, z_pos, r) {
    translate([x_pos, y_pos, z_pos])
    rotate([0, 90, 0])
    cylinder(h = 1, r = r); // This is just a placeholder logic
}

// Final Assembly
union() {
    // 1. Lower Jaw Bar
    cube([lower_len, lower_wid, thickness]);
    
    // 2. Lower Jaw Tongue
    translate([lower_len, lower_tongue_y_start, 0])
        cube([lower_tongue_len, lower_tongue_wid, thickness]);
        
    // 3. Upper Jaw Bar
    translate([0, upper_y_start, 0])
        cube([upper_len, upper_wid, thickness]);
        
    // 4. Hinge
    hinge_half_ring();
    
    // 5. Latch Leg
    translate([latch_leg_x_start, latch_leg_y_start, 0])
        cube([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start, thickness]);
        
    // 6. Latch Nose
    translate([latch_nose_x_start, latch_nose_y_start, thickness - latch_nose_z_offset])
        cube([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start, latch_nose_z_offset + 0.1]);

    // 7. Ridges (Half-cylinders along X axis)
    // Lower ridge: center at (27.5, 4, 4), radius 1.5
    // It protrudes from the face y=4. Since the jaw is y=0 to 4, 
    // the ridge center is at y=4, and it extends from y=4 to y=5.5.
    // But the ridge is "on its inner face", so it's a protrusion.
    // To be a "half-round ridge", the center of the circle is on the face.
    
    // Lower Ridge
    translate([ridge_x - 1.5, 4, thickness/2])
    rotate([0, 90, 0])
    cylinder(h = 3, r = ridge_radius); // This is a placeholder; let's be precise