// Pinch clamp for silicone tubing (up to 6.4 mm)
// Designed for FDM printing: printed flat in the XY plane.

// --- Dimensions ---
thickness    = 8.0;    // Extrusion height (Z)
lower_len    = 50.0;   // Length of lower jaw bar
lower_y_w    = 4.0;    // Width of lower jaw bar
lower_tongue_len = 6.0; // Length of lower tongue (50 to 56)
lower_tongue_y_start = 2.5;
lower_tongue_y_end   = 4.0;

upper_len    = 60.0;   // Length of upper jaw bar
upper_y_start = 12.0;
upper_y_end   = 16.0;

hinge_center_y = 8.0;
hinge_r_in     = 7.2;
hinge_r_out    = 8.0;

ridge_radius   = 1.5;
ridge_x_pos    = 27.5;
ridge_y_low    = 4.0;
ridge_y_high   = 12.0;

latch_leg_x_start = 57.0;
latch_leg_x_end   = 60.0;
latch_leg_y_start = 4.5;
latch_leg_y_end   = 12.0;

latch_nose_x_start = 54.5;
latch_nose_x_end   = 57.0;
latch_nose_y_start = 4.5;
latch_nose_y_end   = 5.5;
latch_nose_z_offset = 0.5; // 0.5mm above the tongue

$fn = 64;

// --- 2D Profile Construction ---
module profile_2d() {
    // Lower Jaw Bar
    square([lower_len, lower_y_w]);
    
    // Lower Tongue
    translate([lower_len, lower_tongue_y_start])
        square([lower_tongue_len, lower_tongue_y_end - lower_tongue_y_start]);
    
    // Upper Jaw Bar
    translate([0, upper_y_start])
        square([upper_len, upper_y_end - upper_y_start]);
    
    // Hinge (Half-ring on the left side)
    // We use a difference of two half-circles to create the ring profile
    difference() {
        // Outer half-circle
        translate([0, hinge_center_y])
            circle(r = hinge_r_out);
        // Inner half-circle
        translate([0, hinge_center_y])
            circle(r = hinge_r_in);
        // Cut the right half to make it a "half-ring" on the left side
        translate([0, -hinge_r_out])
            square([hinge_r_out, hinge_r_out * 2]);
    }
    
    // Latch Leg
    translate([latch_leg_x_start, latch_leg_y_start])
        square([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start]);
    
    // Latch Nose
    translate([latch_nose_x_start, latch_nose_y_start])
        square([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start]);
}

// --- 3D Model Construction ---
// We build the main body by extruding the 2D profile
// Then we subtract the pinch ridges and the latch clearance

difference() {
    // Main Body
    linear_extrude(height = thickness) {
        profile_2d();
    }

    // Pinch Ridges (Subtracted from the inner faces)
    // Lower ridge
    translate([ridge_x_pos, ridge_y_low, -0.01])
        rotate([0, 0, 0]) // Ensure it's oriented correctly
        cylinder(h = thickness + 0.02, r = ridge_radius);
    
    // Upper ridge
    translate([ridge_x_pos, ridge_y_high, -0.01])
        cylinder(h = thickness + 0.02, r = ridge_radius);

    // Latch Clearance (The space for the nose to snap under the tongue)
    // The nose is at z = 0.5 relative to the tongue. 
    // Since the tongue is at z=0 (bottom), the nose is at z=0.5.
    // We create a cutout in the lower jaw to allow the nose to enter.
    translate([latch_nose_x_start - 0.1, lower_tongue_y_start - 0.1, thickness - 1.0])
        cube([lower_tongue_len + 2, lower_y_w + 0.2, 2.0]);
}

// Note: The user requested the part be printed flat on the XY plane.
// The code above builds the part from Z=0 upwards.