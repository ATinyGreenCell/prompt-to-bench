// Dimensions for 10-well agarose gel comb
// Overall plate thickness (Z)
thickness = 1.5;

// Spine dimensions
spine_length = 70;      // X dimension
spine_width = 12;       // Y dimension

// Tooth dimensions
tooth_width = 5.0;     // X dimension
tooth_length = 12;     // Y dimension (hanging in -Y)

// Gap dimensions
gap_width = 1.5;       // X dimension between teeth

// Calculated dimensions
num_teeth = 10;
total_tooth_width = num_teeth * tooth_width;
total_gap_width = (num_teeth - 1) * gap_width;
total_tooth_span = total_tooth_width + total_gap_width;

// Centering offset in X (to center teeth on spine)
// Spine is centered at X=0, so teeth span from -total_tooth_span/2 to +total_tooth_span/2
tooth_start_x = -total_tooth_span / 2;

// Y position of teeth (hanging from spine edge at Y = -spine_width/2)
// Spine goes from -spine_width/2 to +spine_width/2 in Y.
// Teeth hang in -Y direction from the edge at -spine_width/2.
tooth_y_start = -spine_width / 2;

// Create the base spine plate
base_plate = translate([0, 0, 0])
    cube([spine_length, spine_width, thickness], center = true);

// Create the teeth
teeth = [];
for (i = [0 : num_teeth - 1]) {
    // Calculate X position for each tooth
    // First tooth starts at tooth_start_x
    // Each subsequent tooth is shifted by (tooth_width + gap_width)
    tooth_x = tooth_start_x + i * (tooth_width + gap_width);
    
    // Create a single tooth
    tooth = translate([tooth_x, tooth_y_start, 0])
        cube([tooth_width, tooth_length, thickness], center = false);
    
    teeth = [teeth, tooth];
}

// Union the base plate with all teeth
comb = union()
    base_plate
    + for (t = teeth) t;

// Output the final comb
comb;