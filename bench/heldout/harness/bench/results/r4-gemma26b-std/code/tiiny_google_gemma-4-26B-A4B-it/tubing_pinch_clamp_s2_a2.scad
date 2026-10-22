// --- Parameters ---
// Dimensions in mm
thickness = 8;               // Extrusion depth along Z
lower_bar_len = 50;          // Length of lower bar
lower_bar_width = 4;         // Width of lower bar
lower_tongue_len = 6;         // Length of lower tongue (50 to 56)
lower_tongue_width = 1.5;    // Width of lower tongue (4 - 2.5 = 1.5)
lower_tongue_start_y = 2.5; // Y-offset for tongue

upper_bar_len = 60;          // Length of upper bar
upper_bar_width = 4;         // Width of upper bar
upper_bar_y_start = 12;      // Y-position of upper bar start
upper_bar_y_end = 16;        // Y-position of upper bar end

hinge_radius_inner = 7.2;    // Inner radius of hinge
hinge_radius_outer = 8.0;    // Outer radius of hinge
hinge_center_x = 0;          // X-center of hinge
hinge_center_y = 8;          // Y-center of hinge

pinch_ridge_radius = 1.5;    // Radius of the half-round ridge
pinch_ridge_x = 27.5;        // X-position of the ridge

latch_leg_x_start = 57;       // Start of latch leg
latch_leg_x_end = 60;         // End of latch leg
latch_leg_y_start = 4.5;      // Start of latch leg Y
latch_leg_y_end = 12;        // End of latch leg Y

latch_nose_x_start = 54.5;    // Start of latch nose
latch_nose_x_end = 57;        // End of latch nose
latch_nose_y_start = 4.5;     // Start of latch nose Y
latch_nose_y_end = 5.5;       // End of latch nose Y
latch_nose_z_offset = 0.5;    // Z-offset for the nose relative to the tongue

$fn = 64;

// --- Construction ---

module pinch_clamp() {
    // The specification describes a 2D profile extruded 8mm along Z.
    // The latch nose is "0.5mm above the tongue". 
    // To satisfy the "2D profile extruded 8mm" while including the nose,
    // the nose must be part of the profile geometry. 
    // However, "0.5mm above" implies a Z-offset. 
    // To ensure a single watertight solid that matches the bounding box 
    // and the "2D profile extruded" description, we treat the nose 
    // as a separate volume that is part of the single solid.
    
    union() {
        difference() {
            union() {
                // 1. Lower Jaw Bar
                cube([lower_bar_len, lower_bar_width, thickness]);
                
                // 2. Lower Jaw Tongue
                translate([lower_bar_len, lower_tongue_start_y, 0])
                    cube([lower_tongue_len, lower_tongue_width, thickness]);
                
                // 3. Upper Jaw Bar
                translate([0, upper_bar_y_start, 0])
                    cube([upper_bar_len, upper_bar_width, thickness]);
                
                // 4. Hinge (Half-ring on the left)
                // Centered at (0,8), radii 7.2 and 8.0.
                // The hinge is on the x < 0 side.
                translate([hinge_center_x, hinge_center_y, 0])
                difference() {
                    cylinder(r = hinge_radius_outer, h = thickness);
                    cylinder(r = hinge_radius_inner, h = thickness + 0.1);
                    // Cut the right half to leave the left half (x < 0)
                    translate([0, -hinge_radius_outer - 1, -0.5])
                        cube([hinge_radius_outer + 1, hinge_radius_outer * 2, thickness + 1]);
                }
                
                // 5. Latch Leg
                translate([latch_leg_x_start, latch_leg_y_start, 0])
                    cube([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start, thickness]);
            }

            // --- Subtractions (Cuts) ---

            // 6. Lower Pinch Ridge (Half-round cut into the inner face)
            // Inner face of lower bar is at y = 4.
            // The ridge is a "half-round" ridge on the inner face.
            // This means the ridge protrudes into the space, so we subtract a cylinder.
            translate([pinch_ridge_x, lower_bar_width, thickness/2])
                rotate([0, 90, 0])
                cylinder(r = pinch_ridge_radius, h = 10, center = true);
            
            // 7. Upper Pinch Ridge (Half-round cut into the inner face)
            // Inner face of upper bar is at y = 12.
            translate([pinch_ridge_x, upper_bar_y_start, thickness/2])
                rotate([0, 90, 0])
                cylinder(r = pinch_ridge_radius, h = 10, center = true);
        }

        // 8. Latch Nose (The part that snaps)
        // "0.5 mm above the tongue" -> Z-offset.
        // To ensure it's part of the same solid and watertight:
        translate([latch_nose_x_start, latch_nose_y_start, latch_nose_z_offset])
            cube([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start, thickness]);
    }
}

// Render the part
pinch_clamp();