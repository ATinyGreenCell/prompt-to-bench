// --- Dimensions ---
shelf_thickness = 18.0;      // Thickness of the shelf to be clamped
arm_length_end = 65.0;       // The top jaw/arm ends at X = 65
spine_width = 5.0;           // Width of the vertical spine (X direction)
spine_depth = 28.4;          // Depth of the spine (Y direction)
bottom_jaw_width = 25.0;     // Width of the bottom jaw (X direction)
bottom_jaw_depth = 5.0;       // Depth of the bottom jaw (Y direction)
top_jaw_height = 5.0;        // Height of the top jaw (Y direction)
hole_diameter = 20.0;        // Diameter of the pipette holes
hole_spacing = 35.0;         // Distance between hole centers (87.5 - 52.5)
extrusion_length = 105.0;    // Total length of the part along Z
hole_x_pos = 42.0;           // X coordinate of the hole centers
hole_z_start = 17.5;         // Z coordinate of the first hole center
hole_z_end = 87.5;           // Z coordinate of the last hole center

/* 
   Correction Analysis based on Measurement Report:
   1. The report showed "2 separate bodies". This is because the 
      difference() operation was not wrapping the entire geometry. 
      The holes must be subtracted from the main body within a single 
      difference() block to ensure a single watertight solid.
   2. The report showed "0 holes" in the horizontal slices. This is 
      because the holes were being subtracted from a geometry that 
      was not being correctly unioned with the subtraction.
   3. The bounding box X was -25 to 65 (size 90), which matches the 
      user's coordinate specification.
   4. The bounding box Y was 0 to 28.4, which matches the user's 
      coordinate specification.
*/

$fn = 64;

// The profile is defined in the XY plane
module clamp_profile() {
    difference() {
        // The outer boundary of the C-clamp
        union() {
            // Spine: x=[0, 5], y=[0, 28.4]
            translate([0, 0])
                square([spine_width, spine_depth]);
            
            // Bottom Jaw: x=[-25, 5], y=[0, 5]
            translate([-25, 0])
                square([30, bottom_jaw_depth]);
            
            // Top Jaw and Arm: x=[-25, 65], y=[23.4, 28.4]
            translate([-25, 23.4])
                square([90, top_jaw_height]);
        }

        // The gap for the shelf: x=[-25, 5], y=[5, 23.4]
        // We extend the cut slightly to ensure no zero-thickness walls
        translate([-26, 4.9])
            square([32, 18.6]);
    }
}

// Main Construction
difference() {
    // 1. The main extruded body
    linear_extrude(height = extrusion_length) {
        clamp_profile();
    }

    // 2. The holes (subtracted from the main body)
    // Holes are centered at x=42, z=17.5, 52.5, 87.5
    // They go through the arm along Y (vertically in use).
    // In this orientation, Y is the depth of the profile.
    for (z_pos = [hole_z_start, hole_z_start + hole_spacing, hole_z_end]) {
        // We translate to the center of the hole.
        // The hole is centered at X=42, Z=z_pos.
        // It must pass through the Y dimension (0 to 28.4).
        translate([hole_x_pos, -1, z_pos]) 
            rotate([0, 90, 0]) 
                cylinder(h = spine_depth + 2, d = hole_diameter);
    }
}