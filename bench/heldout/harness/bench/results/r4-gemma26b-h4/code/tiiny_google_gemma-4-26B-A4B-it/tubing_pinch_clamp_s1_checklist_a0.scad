// Pinch clamp for silicone tubing (up to 6.4 mm)
// Designed for FDM printing: printed flat in the XY plane.

// --- Dimensions ---
thickness = 8.0;           // Extrusion height (Z)
lower_len = 50.0;          // Length of lower jaw bar
lower_wid = 4.0;           // Width of lower jaw bar
lower_tongue_len = 6.0;    // Length of lower jaw tongue
lower_tongue_wid = 1.5;    // Width of lower jaw tongue (4 - 2.5)
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

// --- Construction ---

module hinge_half_ring() {
    // A half-ring on the x < 0 side
    difference() {
        // Outer half-circle
        translate([hinge_center_x, hinge_center_y, 0])
            rotate([0, 0, 180])
            cylinder(h = thickness, r = hinge_r_outer);
        
        // Inner half-circle (to create the ring)
        translate([hinge_center_x, hinge_center_y, -1])
            rotate([0, 0, 180])
            cylinder(h = thickness + 2, r = hinge_r_inner);
            
        // Cut the right side to make it a half-ring
        translate([hinge_center_x - 1, hinge_center_y - hinge_r_outer - 1, -1])
            cube([2, hinge_r_outer * 2 + 2, thickness + 2]);
    }
}

module ridge() {
    // Half-round ridge on the inner face
    rotate([0, 90, 0])
    cylinder(h = 2, r = ridge_radius);
}

module clamp_body() {
    union() {
        // Lower Jaw Bar
        cube([lower_len, lower_wid, thickness]);
        
        // Lower Jaw Tongue
        translate([lower_len, lower_tongue_y_start, 0])
            cube([lower_tongue_len, lower_tongue_wid, thickness]);
            
        // Upper Jaw Bar
        translate([0, upper_y_start, 0])
            cube([upper_len, upper_wid, thickness]);
            
        // Hinge
        hinge_half_ring();
        
        // Latch Leg
        translate([latch_leg_x_start, latch_leg_y_start, 0])
            cube([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start, thickness]);
            
        // Latch Nose
        translate([latch_nose_x_start, latch_nose_y_start, thickness - latch_nose_z_offset])
            cube([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start, latch_nose_z_offset + 0.1]);
    }
}

module ridges_and_cutouts() {
    // The ridges are added to the inner faces
    // The ridges are modeled as 3D objects, but since we want them to be "half-round" 
    // protruding from the face, we use a union of the body and the ridge.
    // However, to keep the code clean, we will build the body and then add ridges.
    
    // Ridge 1 (Lower Jaw)
    translate([ridge_x, ridge_radius, thickness/2])
        rotate([0, 90, 0])
        cylinder(h = 1, r = ridge_radius);
        
    // Ridge 2 (Upper Jaw)
    translate([ridge_x, upper_y_end - ridge_radius, thickness/2])
        rotate([0, 90, 0])
        cylinder(h = 1, r = ridge_radius);
}

// Final Assembly
// We use a union of the main body and the ridges.
// Note: The user description implies the ridges are on the "inner face".
// For the lower jaw, the inner face is at y = 4.
// For the upper jaw, the inner face is at y = 12.

union() {
    clamp_body();
    
    // Lower ridge (at y=4)
    translate([ridge_x, lower_wid - ridge_radius, thickness/2])
        rotate([0, 90, 0])
        cylinder(h = 1, r = ridge_radius);
        
    // Upper ridge (at y=12)
    translate([ridge_x, upper_y_start + ridge_radius, thickness/2])
        rotate([0, 90, 0])
        cylinder(h = 1, r = ridge_radius);
}