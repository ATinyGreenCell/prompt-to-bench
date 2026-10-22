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
    // The user wants a 2D profile extruded 8mm along Z.
    // The latch nose is "0.5mm above the tongue". 
    // In a single extrusion, this implies the nose is a separate volume 
    // or the profile is complex. To maintain a single watertight solid 
    // that is a "2D profile extruded 8mm", the nose must be part of the 
    // 2D profile, but the prompt says "0.5mm above", implying Z-offset.
    // To ensure a single solid, we union the extruded profile and the nose.
    
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
                // To be a single solid, we use a hull or union of cylinders.
                translate([hinge_center_x, hinge_center_y, 0])
                rotate([0, 0, 180])
                difference() {
                    cylinder(r = hinge_radius_outer, h = thickness);
                    cylinder(r = hinge_radius_inner, h = thickness + 0.1);
                    // Cut to make it a half-ring (left side)
                    // Since we rotated 180, the "left" is now the "right" relative to the rotation.
                    // We cut the right half to leave the left half.
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