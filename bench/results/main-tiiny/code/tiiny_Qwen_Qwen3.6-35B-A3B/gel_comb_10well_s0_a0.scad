// --- Dimensions ---
plate_thickness = 1.5;    // Z height of the plate
spine_length = 70;        // X length of the spine
spine_width = 12;         // Y width of the spine
num_teeth = 10;           // Number of teeth
tooth_width = 5.0;        // X width of each tooth
tooth_length = 12;        // Y length of each tooth (hanging in -Y)
gap_width = 1.5;          // Y gap between teeth

// --- Calculated Values ---
// Total width of one tooth + one gap
feature_pitch = tooth_width + gap_width;
// Total width of the tooth row (10 teeth, 9 gaps)
total_tooth_row_width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width);
// Offset to center the tooth row on the spine in X
// The spine is centered at X=0. The tooth row spans from -total_tooth_row_width/2 to +total_tooth_row_width/2.
// We need to position the teeth such that they hang from the spine.
// The spine is at Y=[0, spine_width] (or similar). Let's place the spine at Y=[0, spine_width].
// The teeth hang in -Y direction. So the teeth are at Y=[-tooth_length, 0].
// The spine is at Y=[0, spine_width].
// The teeth are attached to the edge at Y=0.

// --- Module Definitions ---

module spine() {
    // Spine is centered on X, starts at Y=0, goes to Y=spine_width
    // To center on X: X goes from -spine_length/2 to +spine_length/2
    translate([-spine_length/2, 0, 0]) {
        cube([spine_length, spine_width, plate_thickness], center=false);
    }
}

module tooth(i) {
    // Each tooth is i-th tooth (0 to 9)
    // Center X of the i-th tooth:
    // The first tooth (i=0) is at the left? Or right? Let's assume i=0 is left.
    // The center of the entire row is X=0.
    // The left edge of the first tooth is at -total_tooth_row_width/2.
    // The center of the first tooth is at -total_tooth_row_width/2 + tooth_width/2.
    // Let's calculate the center X for tooth i.
    // Center X_i = -total_tooth_row_width/2 + tooth_width/2 + i * feature_pitch
    
    tooth_center_x = -total_tooth_row_width/2 + tooth_width/2 + i * feature_pitch;
    tooth_center_y = -tooth_length/2; // Hanging in -Y, so center is at -tooth_length/2
    
    translate([tooth_center_x, tooth_center_y, 0]) {
        cube([tooth_width, tooth_length, plate_thickness], center=true);
    }
}

// --- Main Assembly ---
union() {
    spine();
    
    for (i = [0 : num_teeth - 1]) {
        tooth(i);
    }
}