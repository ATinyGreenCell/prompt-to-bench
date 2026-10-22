// Pinch clamp for silicone tubing (up to 6.4 mm)
// Corrected: Ridges are half-cylinders on the inner faces, 
// and the nose is a solid feature starting 0.5mm above the base.

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
latch_nose_z_start = 0.5; // 0.5mm above the tongue (Z=0)
latch_nose_z_end   = 0.5 + 1.0; // Assuming 1mm thickness for the nose feature

$fn = 64;

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
    difference() {
        translate([0, hinge_center_y])
            circle(r = hinge_r_out);
        translate([0, hinge_center_y])
            circle(r = hinge_r_in);
        // Cut the right half to make it a "half-ring" on the left side
        translate([0, -hinge_r_out])
            square([hinge_r_out, hinge_r_out * 2]);
    }
    
    // Latch Leg
    translate([latch_leg_x_start, latch_leg_y_start])
        square([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start]);
    
    // Latch Nose (2D profile part)
    translate([latch_nose_x_start, latch_nose_y_start])
        square([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start]);
}

// --- 3D Model Construction ---
union() {
    // 1. Main Body
    linear_extrude(height = thickness) {
        profile_2d();
    }

    // 2. Additive Pinch Ridges (Half-cylinders)
    // The ridge is "half-round" on the inner face.
    // We place a cylinder and subtract the part that is inside the jaw.
    // Or more simply, use a cylinder and rotate it.
    
    // Lower ridge
    translate([ridge_x_pos, ridge_y_low, thickness/2])
        rotate([0, 90, 0])
            cylinder(h = 1.0, r = ridge_radius, center = true);
            
    // Upper ridge
    translate([ridge_x_pos, ridge_y_high, thickness/2])
        rotate([0, 90, 0])
            cylinder(h = 1.0, r = ridge_radius, center = true);

    // 3. Additive Latch Nose
    // The nose is 0.5mm above the tongue.
    // We extrude the nose profile from Z=0.5 to Z=1.5 (1mm thick)
    translate([latch_nose_x_start, latch_nose_y_start, latch_nose_z_start])
        cube([latch_nose_x_end - latch_nose_x_start, 
              latch_nose_y_end - latch_nose_y_start, 
              1.0]);
}