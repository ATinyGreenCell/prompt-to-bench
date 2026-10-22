// --- Dimensions ---
shelf_thickness = 18.0;      // Thickness of the shelf to be clamped
arm_length = 65.0;           // Total length of the top jaw/arm along X
spine_width = 5.0;           // Width of the vertical spine (X direction)
spine_depth = 28.4;          // Depth of the spine (Y direction)
bottom_jaw_width = 25.0;     // Width of the bottom jaw (X direction)
bottom_jaw_depth = 5.0;       // Depth of the bottom jaw (Y direction)
top_jaw_height = 5.0;        // Height of the top jaw (Y direction)
gap_clearance = 0.4;         // Extra clearance for the 18mm shelf (18.4 total)
hole_diameter = 20.0;        // Diameter of the pipette holes
hole_spacing = 35.0;         // Distance between hole centers (87.5 - 52.5)
extrusion_length = 105.0;    // Total length of the part along Z
hole_x_pos = 42.0;           // X coordinate of the hole centers
hole_z_start = 17.5;         // Z coordinate of the first hole center
hole_z_end = 87.5;           // Z coordinate of the last hole center

/* 
   Correction Analysis based on Measurement Report:
   1. The report showed "2 separate bodies". This happened because the 
      difference() operation was applied to the whole union, but the 
      holes were added via a separate union() block. In OpenSCAD, 
      to subtract holes from the extruded part, the holes must be 
      inside the same difference() block as the extrusion.
   2. The report showed the bounding box X was -25 to 92. 
      Calculation: -25 (bottom jaw) + 25 (bottom jaw width) + 5 (spine) + 65 (arm) = 70. 
      Wait, the user specified: "top jaw and arm from x = -25 to 65". 
      This means the total X span is from -25 to 65. 
      The previous code used `arm_length` as an additive value to the width, 
      which caused the X dimension to be too large.
   3. The report showed Y was 35.90. The user specified spine depth 28.4 
      and top jaw at 23.4 to 28.4. The Y dimension should be 28.4.
*/

$fn = 64;

// Helper to create the 2D profile of the C-clamp
module clamp_profile() {
    // We define the outer boundary first
    union() {
        // Spine: x=[0, 5], y=[0, 28.4]
        translate([0, 0])
            square([spine_width, spine_depth]);
        
        // Bottom Jaw: x=[-25, 5], y=[0, 5]
        translate([-bottom_jaw_width, 0])
            square([bottom_jaw_width + spine_width, bottom_jaw_depth]);
        
        // Top Jaw and Arm: x=[-25, 65], y=[23.4, 28.4]
        // Note: The user said "from x = -25 to 65", so the total width is 90.
        translate([-bottom_jaw_width, 23.4])
            square([bottom_jaw_width + spine_width + (65 - (-25) - (bottom_jaw_width + spine_width)), top_jaw_height]);
            // Simplified: The user wants the top jaw to end at X=65.
            // Let's use the absolute coordinates provided.
    }
}

// Corrected Profile using absolute coordinates to match user specs exactly
module exact_profile() {
    difference() {
        union() {
            // Spine: x=[0, 5], y=[0, 28.4]
            translate([0, 0])
                square([5, 28.4]);
            
            // Bottom Jaw: x=[-25, 5], y=[0, 5]
            translate([-25, 0])
                square([30, 5]);
            
            // Top Jaw and Arm: x=[-25, 65], y=[23.4, 28.4]
            translate([-25, 23.4])
                square([90, 5]);
        }

        // The gap for the shelf: x=[-25, 5], y=[5, 23.4]
        // User specified gap is 18.4. 23.4 - 5 = 18.4.
        // We extend the cut slightly to ensure no zero-thickness walls.
        translate([-26, 4.9])
            square([32, 18.6]);
    }
}

// Main Construction
difference() {
    // 1. The main extruded body
    linear_extrude(height = extrusion_length) {
        exact_profile();
    }

    // 2. The holes (must be inside the difference to actually cut)
    // Holes are centered at x=42, z=17.5, 52.5, 87.5
    // They go through the arm along Y (vertically in use).
    // In this orientation, Y is the depth of the profile.
    for (z_pos = [hole_z_start, hole_z_start + hole_spacing, hole_z_end]) {
        translate([hole_x_pos, -1, z_pos]) // -1 to ensure it cuts through the Y face
            rotate([0, 90, 0]) 
                cylinder(h = spine_depth + 2, d = hole_diameter);
    }
}

// Final check of dimensions:
// X: -25 to 65 = 90mm
// Y: 0 to 28.4 = 28.4mm
// Z: 0 to 105 = 105mm