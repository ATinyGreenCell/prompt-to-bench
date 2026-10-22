// Pinch clamp for silicone tubing with living hinge and snap latch
// Designed for FDM printing: printed flat in the XY plane.
// The part is constructed as a single 2-D profile extruded 8mm along Z.

// --- Dimensions ---
lower_bar_l      = 50.0;   // Length of lower bar
lower_bar_w       = 4.0;    // Width of lower bar
tongue_l          = 6.0;    // Length of tongue
tongue_y_start    = 2.5;    // Y start of tongue
tongue_y_end      = 4.0;    // Y end of tongue

upper_bar_l       = 60.0;   // Length of upper bar
upper_bar_w       = 4.0;    // Width of upper bar
upper_bar_y_start = 12.0;   // Y start of upper bar
upper_bar_y_end   = 16.0;   // Y end of upper bar

hinge_center_x    = 0.0;    // Hinge center X
hinge_center_y    = 8.0;    // Hinge center Y
hinge_r_inner      = 7.2;    // Inner radius of hinge
hinge_r_outer      = 8.0;    // Outer radius of hinge

ridge_radius      = 1.5;    // Radius of the pinch ridge
ridge_x           = 27.5;    // X position of the ridge

latch_leg_x_start  = 57.0;   // X start of latch leg
latch_leg_x_end    = 60.0;   // X end of latch leg
latch_leg_y_start  = 4.5;    // Y start of latch leg
latch_leg_y_end    = 12.0;   // Y end of latch leg

latch_nose_x_start = 54.5;   // X start of latch nose
latch_nose_x_end   = 57.0;   // X end of latch nose
latch_nose_y_start = 4.5;    // Y start of latch nose
latch_nose_y_end   = 5.5;    // Y end of latch nose

thickness          = 8.0;    // Extrusion height (Z)

$fn = 64;

// --- 2D Profile Construction ---
// We build the 2D silhouette using a union of shapes.
// To ensure the ridges are "half-round" on the inner face, 
// we add semi-circles to the profile.

module final_2d_profile() {
    union() {
        // 1. Lower Bar
        square([lower_bar_l, lower_bar_w]);
        
        // 2. Tongue
        translate([lower_bar_l, tongue_y_start])
            square([tongue_l, tongue_y_end - tongue_y_start]);
            
        // 3. Upper Bar
        translate([0, upper_bar_y_start])
            square([upper_bar_l, upper_bar_w]);
            
        // 4. Hinge (Half-ring on the x < 0 side)
        translate([hinge_center_x, hinge_center_y])
        difference() {
            circle(r = hinge_r_outer);
            circle(r = hinge_r_inner);
            // Cut to keep only the part where x < 0
            // We use a large square to ensure the cut is clean
            translate([-hinge_r_outer - 1, -hinge_r_outer - 1])
                square([hinge_r_outer + 2, hinge_r_outer * 2 + 2]);
        }
        
        // 5. Latch Leg
        translate([latch_leg_x_start, latch_leg_y_start])
            square([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start]);
            
        // 6. Latch Nose
        translate([latch_nose_x_start, latch_nose_y_start])
            square([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start]);
            
        // 7. Ridges (Half-rounds)
        // To make them "half-round" on the inner face, we add semi-circles 
        // to the profile at the specified locations.
        
        // Lower Ridge (centered at ridge_x, 4)
        // Since the bar is y=0 to 4, the ridge extends from y=4 upwards.
        translate([ridge_x, 4])
            circle(r = ridge_radius);
            
        // Upper Ridge (centered at ridge_x, 12)
        // Since the bar is y=12 to 16, the ridge extends from y=12 downwards.
        translate([ridge_x, 12])
            circle(r = ridge_radius);
    }
}

// --- Final 3D Model ---
// The prompt asks for the profile to be extruded 8mm along Z.
// We use a difference to ensure the ridges are semi-circles 
// (protrusions) rather than full circles by cutting the "outside" 
// part of the circle from the profile.

difference() {
    // The main extruded body
    linear_extrude(height = thickness) 
        final_2d_profile();
    
    // Subtract the "outer" half of the ridge circles to make them semi-circles
    // Lower ridge subtraction (cut everything below y=4)
    translate([ridge_x, 4 - ridge_radius])
        square([ridge_radius * 2 + 2, ridge_radius]);
        
    // Upper ridge subtraction (cut everything above y=12)
    translate([ridge_x, 12])
        square([ridge_radius * 2 + 2, ridge_radius]);
        
    // Subtract the "inner" part of the hinge to ensure it's a ring
    // (Already handled by difference in the hinge module, but we ensure 
    // the extrusion doesn't fill the center of the hinge)
    translate([hinge_center_x, hinge_center_y])
        circle(r = hinge_r_inner);
}

// Note: The hinge is a "half-ring" on the x < 0 side. 
// The logic above creates a solid part with a hinge-shaped cutout 
// on the left side.