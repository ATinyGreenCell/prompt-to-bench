// Pinch clamp for silicone tubing with living hinge and snap latch
// Designed for FDM printing: printed flat in the XY plane.
// The part is constructed as a single 2D profile extruded 8mm along Z.

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
// We build the 2D silhouette using a union of shapes, then extrude.
// To ensure a single solid, we use union() for all additive parts.

module profile_2d() {
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
        // We create the ring and then use a large square to cut it in half
        difference() {
            circle(r = hinge_r_outer);
            circle(r = hinge_r_inner);
            // Cut the ring to keep only the part where x < 0
            // We use a large square to ensure the cut is clean
            translate([-hinge_r_outer - 1, -hinge_r_outer - 1])
                square([hinge_r_outer + 1, hinge_r_outer * 2 + 2]);
        }
        // Note: The hinge is centered at (0, 8). The circle() is centered at (0,0) by default.
        // We must translate the hinge to its center.
        // Since we are inside a union, we must wrap the hinge in a translate.
        // However, the circle() is already at (0,0). Let's fix the hinge logic.
    }
}

// Corrected 2D Profile logic using a single union and proper translations
module final_2d_profile() {
    union() {
        // Lower Bar
        square([lower_bar_l, lower_bar_w]);
        
        // Tongue
        translate([lower_bar_l, tongue_y_start])
            square([tongue_l, tongue_y_end - tongue_y_start]);
            
        // Upper Bar
        translate([0, upper_bar_y_start])
            square([upper_bar_l, upper_bar_w]);
            
        // Hinge (Half-ring)
        // We define the ring at origin, then translate to (0, 8)
        translate([hinge_center_x, hinge_center_y])
        difference() {
            circle(r = hinge_r_outer);
            circle(r = hinge_r_inner);
            // Cut to keep only x < 0
            translate([-hinge_r_outer - 1, -hinge_r_outer - 1])
                square([hinge_r_outer + 1, hinge_r_outer * 2 + 2]);
        }
        
        // Latch Leg
        translate([latch_leg_x_start, latch_leg_y_start])
            square([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start]);
            
        // Latch Nose
        translate([latch_nose_x_start, latch_nose_y_start])
            square([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start]);
            
        // Ridges (Half-rounds)
        // Ridge 1: centered at (27.5, 4)
        translate([ridge_x, 4])
            circle(r = ridge_radius);
            
        // Ridge 2: centered at (27.5, 12)
        translate([ridge_x, 12])
            circle(r = ridge_radius);
    }
}

// --- Final 3D Model ---
// The prompt asks for the profile to be extruded 8mm along Z.
// To ensure the ridges (which are circles in 2D) are "half-round" 
// and not full cylinders, we must subtract the "inner" part of the circle.
// However, the prompt says "one 2-D profile... extruded". 
// This implies the ridge is a protrusion in the XY plane.
// To make the ridge a "half-round" on the inner face, the 2D profile 
// should include the semi-circle.

difference() {
    // The main extruded body
    linear_extrude(height = thickness) 
        final_2d_profile();
    
    // To make the ridges "half-round" on the inner face (meaning they are 
    // protrusions in the Y direction), the 2D profile already includes 
    // the circle. But a circle in 2D extruded along Z is a cylinder.
    // The prompt says "half-round pinch ridge... on its inner face".
    // In a 2D profile extruded along Z, a circle becomes a cylinder.
    // To get a "half-round" (a cylinder cut in half), the 2D profile 
    // should have been a semi-circle.
    
    // Let's refine the 2D profile to use semi-circles for the ridges.
}

// RE-REFINING: The prompt says "one 2-D profile... extruded".
// If the profile is 2D, and we extrude it, the ridges are cylinders.
// To make them "half-round" (semi-cylinders), the 2D profile must 
// contain a semi-circle.

module corrected_2d_profile() {
    union() {
        // Lower Bar
        square([lower_bar_l, lower_bar_w]);
        // Tongue
        translate([lower_bar_l, tongue_y_start])
            square([tongue_l, tongue_y_end - tongue_y_start]);
        // Upper Bar
        translate([0, upper_bar_y_start])
            square([upper_bar_l, upper_bar_w]);
        // Hinge
        translate([hinge_center_x, hinge_center_y])
        difference() {
            circle(r = hinge_r_outer);
            circle(r = hinge_r_inner);
            translate([-hinge_r_outer