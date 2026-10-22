// --- Parameters ---
// Dimensions are in mm. 
// The part is printed flat in the XY plane, extruded 8mm along Z.

// Lower Jaw
lower_bar_x_end = 50;
lower_bar_y_start = 0;
lower_bar_y_end = 4;

// Lower Jaw Tongue
tongue_x_start = 50;
tongue_x_end = 56;
tongue_y_start = 2.5;
tongue_y_end = 4;

// Upper Jaw
upper_bar_x_end = 60;
upper_bar_y_start = 12;
upper_bar_y_end = 16;

// Hinge (Half-ring on the left)
hinge_center_x = 0;
hinge_center_y = 8;
hinge_outer_radius = 8;
hinge_inner_radius = 7.2;

// Pinch Ridges (Half-round profiles)
ridge_radius = 1.5;
ridge_x_pos = 27.5;
ridge_lower_y = 4;
ridge_upper_y = 12;

// Latch Assembly
latch_leg_x_start = 57;
latch_leg_x_end = 60;
latch_leg_y_start = 4.5;
latch_leg_y_end = 12;

latch_nose_x_start = 54.5;
latch_nose_x_end = 57;
latch_nose_y_start = 4.5;
latch_nose_y_end = 5.5;
latch_nose_z_offset = 0.5; // Height above the tongue

// Extrusion Depth
thickness = 8;

// Resolution
$fn = 64;

// --- Main Construction ---

union() {
    // 1. Lower Jaw Bar
    cube([lower_bar_x_end, lower_bar_y_end - lower_bar_y_start, thickness]);
    translate([0, lower_bar_y_start, 0])
        cube([lower_bar_x_end, lower_bar_y_end - lower_bar_y_start, thickness]);
    
    // 2. Lower Jaw Tongue
    translate([tongue_x_start, tongue_y_start, 0])
        cube([tongue_x_end - tongue_x_start, tongue_y_end - tongue_y_start, thickness]);

    // 3. Upper Jaw Bar
    translate([0, upper_bar_y_start, 0])
        cube([upper_bar_x_end, upper_bar_y_end - upper_bar_y_start, thickness]);

    // 4. Hinge (Half-ring)
    // We create a full ring and subtract the right half to ensure a clean edge at x=0
    difference() {
        translate([hinge_center_x, hinge_center_y, 0])
            cylinder(h = thickness, r = hinge_outer_radius);
        
        translate([hinge_center_x, hinge_center_y, -1])
            cylinder(h = thickness + 2, r = hinge_inner_radius);
        
        // Cut the right half of the ring to keep only the left side (x < 0)
        translate([hinge_center_x, hinge_center_y - hinge_outer_radius, -1])
            cube([hinge_outer_radius * 2, hinge_outer_radius * 2, thickness + 2]);
    }

    // 5. Latch Leg
    translate([latch_leg_x_start, latch_leg_y_start, 0])
        cube([latch_leg_x_end - latch_leg_x_start, latch_leg_y_end - latch_leg_y_start, thickness]);

    // 6. Latch Nose
    translate([latch_nose_x_start, latch_nose_y_start, latch_nose_z_offset])
        cube([latch_nose_x_end - latch_nose_x_start, latch_nose_y_end - latch_nose_y_start, thickness]);
}

// --- Subtraction of Pinch Ridges ---
// We use a difference to "carve" the half-round grooves into the inner faces
difference() {
    // This block is just a wrapper to apply the difference to the whole assembly
    // However, in OpenSCAD, it's cleaner to wrap the whole union in a difference
    // but since I've already used union, I will re-structure the logic mentally:
    // The user wants ridges on the "inner face". 
    // This means the ridge is a protrusion, but usually, in clamps, 
    // a "pinch ridge" is a protrusion. If it's a "half-round ridge", 
    // it adds material. If it's a "groove", it removes it.
    // Given "pinch ridge", I will treat it as a protrusion (adding material).
    // If the user meant a groove, they would say "groove".
}

// Correcting logic: The user says "Each jaw has a half-round pinch ridge... on its inner face".
// This implies the ridge is an addition to the geometry.
// I will add the ridges using a union.

// Re-calculating: The previous union included the bars. I will add the ridges to that union.
// Since I cannot rewrite the whole block easily without breaking the structure, 
// I will use a separate union for the ridges.

// (Self-correction: I will combine everything into one single union block)

// --- Final Assembly Logic ---

// Since I cannot "add" to a union after it's defined, I will rewrite the structure.

// [REWRITTEN CODE BELOW]