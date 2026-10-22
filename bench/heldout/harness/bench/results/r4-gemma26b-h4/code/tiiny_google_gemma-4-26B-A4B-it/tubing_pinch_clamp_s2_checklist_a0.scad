// Pinch clamp for silicone tubing with living hinge and snap latch
// Designed for FDM printing: printed flat in the XY plane.

// Dimensions
lower_bar_l      = 50.0;   // Length of lower bar
lower_bar_w       = 4.0;    // Width of lower bar
tongue_l          = 6.0;    // Length of tongue
tongue_w          = 1.5;    // Width of tongue (4 - 2.5)
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

// Helper module for the half-ring hinge
module hinge_half_ring() {
    difference() {
        // Outer half-ring
        rotate([0, 0, 180])
            cylinder(h = thickness, d = hinge_r_outer * 2, center = true);
        // Inner half-ring (cutout)
        rotate([0, 0, 180])
            cylinder(h = thickness + 2, d = hinge_r_inner * 2, center = true);
        // Cut the ring in half to make it a "half-ring" on the x < 0 side
        translate([-hinge_r_outer - 1, 0, -thickness - 1])
            cube([hinge_r_outer + 2, hinge_r_outer * 2 + 2, thickness + 2]);
    }
}

// Helper module for the ridge (half-round)
module ridge_profile() {
    // We use a 2D shape and extrude it, but since it's a ridge on a face, 
    // we'll model it as a cylinder segment in 3D.
    // The ridge is centered at (ridge_x, y_center) and is perpendicular to the jaw face.
    // However, the prompt implies the ridge is part of the profile.
    // To keep it simple and robust for 3D printing, we'll use a hull of two cylinders.
    // But the prompt says "one 2-D profile... extruded 8mm". 
    // This implies the ridge is a protrusion on the side.
    // To follow the "one 2D profile" instruction strictly, we model the 2D shape 
    // including the ridge and extrude it.
}

// Since the prompt asks for "one 2-D profile in the XY plane extruded 8mm", 
// we must define the 2D shape including the ridge and the latch.
// Note: A ridge on a vertical face is technically a 3D feature, 
// but if the profile is extruded along Z, the ridge must be part of the 2D silhouette.
// However, a ridge "on the inner face" usually means it sticks out in the Y direction.
// If we extrude a 2D profile along Z, the ridge must be a protrusion in the Y direction.

difference() {
    // Main Body
    union() {
        // Lower Jaw
        translate([0, 0, 0])
            cube([lower_bar_l, lower_bar_w, thickness]);
        
        // Lower Jaw Tongue
        translate([lower_bar_l, tongue_y_start, 0])
            cube([tongue_l, tongue_w, thickness]);
            
        // Upper Jaw
        translate([0, upper_bar_y_start, 0])
            cube([upper_bar_l, upper_bar_w, thickness]);
            
        // Hinge
        translate([hinge_center_x, hinge_center_y, 0])
            rotate([0, 0, 180]) // Align half-ring to x < 0
            difference() {
                cylinder(h = thickness, r = hinge_r_outer, center = true);
                cylinder(h = thickness + 2, r = hinge_r_inner, center = true);
                // Cut to make it a half-ring on the left
                translate([-hinge_r_outer - 1, -hinge_r_outer - 1, -thickness - 1])
                    cube([hinge_r_outer + 2, hinge_r_outer * 2 + 2, thickness + 2]);
            }

        // Latch Leg
        translate([latch_leg_x_start, latch_leg_y_start, 0])
            cube([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start, thickness]);
            
        // Latch Nose
        translate([latch_nose_x_start, latch_nose_y_start, 0])
            cube([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start, thickness]);

        // Ridges (Modeled as extrusions in Y to be part of the 2D profile logic)
        // Since the prompt says "one 2-D profile... extruded 8mm", 
        // the ridge must be a protrusion in the Y direction.
        // Ridge 1: centered at (27.5, 4) with radius 1.5. 
        // This means it extends from y=4 to y=5.5 (if it's a half-circle).
        // However, the lower bar is y=0 to 4. So the ridge is a half-circle on the edge.
        
        // Lower Ridge
        translate([ridge_x, 4, 0])
            rotate([0, 0, 180])
            cylinder(h = thickness, r = ridge_radius, center = true);
            
        // Upper Ridge
        translate([ridge_x, 12, 0])
            rotate([0, 0, 180])
            cylinder(h = thickness, r = ridge_radius, center = true);
    }
    
    // The prompt implies the ridges are "half-round". 
    // To ensure they are half-rounds on the face, we subtract the "outside" part.
    // But the prompt says "one 2-D profile... extruded". 
    // This means the ridge is part of the silhouette.
    // Let's refine the shape to be a single 2D polygon/path.
}

// RE-IMPLEMENTING AS A SINGLE 2D PROFILE TO BE EXTRUDED (Strict adherence to prompt)
// This approach creates the silhouette of the entire part in 2D, then extrudes.

module part_profile() {
    // We use a union of 2D shapes to define the silhouette
    union() {
        // Lower Bar
        square([lower_bar_l, lower_bar_w]);
        // Tongue
        translate([lower_bar_l, tongue_y_start])
            square([tongue_l, tongue_w]);
        // Upper Bar
        translate([0, upper_bar_y_start])
            square([upper_bar