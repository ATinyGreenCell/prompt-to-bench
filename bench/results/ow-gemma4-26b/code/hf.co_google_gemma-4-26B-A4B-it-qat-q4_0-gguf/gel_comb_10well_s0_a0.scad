// 10-Well Agarose Gel Comb
// Designed for FDM printing, lying flat on the XY plane.

// --- Dimensions (mm) ---
spine_length = 70.0;      // X dimension of the spine
spine_width = 12.0;       // Y dimension of the spine
plate_thickness = 1.5;    // Z dimension (height)

num_teeth = 10;           // Number of teeth
tooth_width = 5.0;        // X dimension of each tooth
tooth_length = 12.0;      // Y dimension of each tooth (extending from spine)
gap_width = 1.5;          // Y dimension of the gap between teeth

// --- Derived Calculations ---
// Total width of the teeth/gap array
// Total width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width)
total_teeth_array_width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width);

// Calculate starting X to center the teeth array on the spine
x_offset = (spine_length - total_teeth_array_width) / 2;

// --- Rendering Settings ---
$fn = 64;

// --- Main Model ---
union() {
    // 1. The Spine (The main plate)
    // Centered on X and Y, resting on Z=0
    translate([-spine_length/2, -spine_width/2, 0])
        cube([spine_length, spine_width, plate_thickness]);

    // 2. The Teeth
    // We iterate through the number of teeth to place them along the -Y edge
    for (i = [0 : num_teeth - 1]) {
        // Calculate X position for this specific tooth
        // Starts at x_offset, then moves by (width + gap) for each tooth
        current_tooth_x = -spine_length/2 + x_offset + (i * (tooth_width + gap_width));
        
        // We use a difference/union approach to ensure teeth are part of the solid.
        // Since teeth hang from the edge, we place them such that they overlap the spine slightly
        // to ensure a manifold solid.
        translate([current_tooth_x, -spine_width/2 - tooth_length + 0.01, 0])
            cube([tooth_width, tooth_length, plate_thickness]);
    }
}

// Note: The teeth are modeled as being attached to the -Y edge of the spine.
// The spine is centered on Y, so its edge is at -spine_width/2.
// The teeth extend from -spine_width/2 down to -spine_width/2 - tooth_length.