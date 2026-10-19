// 10-well agarose gel comb
// Designed for FDM printing - printed lying flat on the XY plane

// --- Dimensions ---
spine_length = 70.0;      // X dimension of the spine
spine_width = 12.0;       // Y dimension of the spine
plate_thickness = 1.5;    // Z dimension (height)

tooth_width = 5.0;        // X dimension of each tooth
tooth_length = 12.0;      // Y dimension of each tooth (extending from spine)
num_teeth = 10;           // Number of teeth/wells

gap_between_teeth = 1.5;  // X dimension of the gap between teeth

// Calculated values
// Total width of the tooth array (teeth + gaps)
// There are (num_teeth - 1) gaps
total_teeth_width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_between_teeth);

// Offset to center the teeth array on the spine in X
x_offset = (spine_length - total_teeth_width) / 2;

// --- Parameters ---
$fn = 64;

// --- Geometry ---

// The main body of the comb
union() {
    // The Spine (Back bar)
    // Centered on X. Placed from Y=0 to Y=spine_width.
    translate([-spine_length/2, 0, 0])
        cube([spine_length, spine_width, plate_thickness]);

    // The Teeth
    // We iterate to create 10 teeth.
    // The teeth are attached to the edge at Y = 0 and extend to Y = -tooth_length.
    for (i = [0 : num_teeth - 1]) {
        // Calculate X position for this specific tooth
        // We use a temporary variable inside the loop to avoid 'let' syntax errors in older OpenSCAD versions
        // The first tooth starts at x_offset.
        // Each subsequent tooth starts at x_offset + (i * (tooth_width + gap))
        
        // Calculate the left edge of the current tooth
        // We use a loop variable approach to ensure compatibility
        translate([x_offset + (i * (tooth_width + gap_between_teeth)) - tooth_width/2, -tooth_length, 0])
            cube([tooth_width, tooth_length, plate_thickness]);
    }
}

// Note on orientation:
// The spine is a rectangle from X: [-35, 35], Y: [0, 12]
// The teeth extend from Y: [0, -12]
// The entire part is centered on X.
// The part rests on the XY plane (Z=0).