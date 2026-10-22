// --- Dimensions ---
// Thickness of the plate (Z-axis)
plate_thickness = 1.5;

// Spine dimensions (X, Y)
spine_length = 70;
spine_width = 12;

// Tooth dimensions (X, Y)
tooth_width = 5.0;
tooth_length = 12;

// Gap between teeth
gap_width = 1.5;

// Number of teeth
num_teeth = 10;

// --- Calculated Values ---
// Total width of the tooth row (teeth + gaps)
// There are 10 teeth and 9 gaps between them.
tooth_row_width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width);

// Start X position for the first tooth's left edge
// The total width of the tooth row is tooth_row_width.
// Centered at X=0, the first tooth starts at:
start_x = -(tooth_row_width / 2);

// Step between teeth (width + gap)
step_x = tooth_width + gap_width;

// Set global resolution
$fn = 64;

// --- Main Model ---
union() {
    // 1. The Spine
    // Centered at origin, lying on XY plane.
    // X: -spine_length/2 to +spine_length/2
    // Y: -spine_width/2 to +spine_width/2
    // Z: 0 to plate_thickness
    translate([0, 0, 0]) {
        cube([spine_length, spine_width, plate_thickness], center = false);
    }

    // 2. The Teeth
    // Each tooth hangs from the bottom edge of the spine (Y = -spine_width/2).
    // They extend in the -Y direction.
    for (i = [0 : num_teeth - 1]) {
        // Calculate X position for the current tooth
        // Center of the tooth
        tooth_center_x = start_x + (i * step_x) + (tooth_width / 2);
        
        // Y position: 
        // Top of tooth is at Y = -spine_width/2
        // Bottom of tooth is at Y = -spine_width/2 - tooth_length
        tooth_y_start = -spine_width / 2;
        tooth_y_end = -spine_width / 2 - tooth_length;
        
        // Translate to the center of the tooth in X, and the top edge in Y
        // We want the tooth to be printed as part of the solid.
        // The tooth is a block of size [tooth_width, tooth_length, plate_thickness]
        // positioned such that its top edge aligns with the spine's bottom edge.
        
        translate([tooth_center_x, tooth_y_start, 0]) {
            cube([tooth_width, tooth_length, plate_thickness], center = false);
        }
    }
}