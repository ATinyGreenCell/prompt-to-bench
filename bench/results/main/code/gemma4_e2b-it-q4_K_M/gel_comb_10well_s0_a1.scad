// Dimensions for the 10-well comb design

// Overall dimensions
spine_length = 70;    // Length of the spine (X dimension) in mm
spine_width = 12;      // Width of the spine (Y dimension) in mm
plate_thickness = 1.5; // Thickness of the plate (Z dimension)

// Tooth dimensions
num_teeth = 10;        // Number of teeth
tooth_width = 5.0;     // Width of each tooth (X dimension)
tooth_length = 12;     // Length of each tooth (Y dimension - this is the depth/hang length in the -Y direction)
gap_width = 1.5;       // Gap between neighboring teeth (Y dimension)

// Positioning calculations
// Total width occupied by teeth and gaps along the Y-axis
total_tooth_and_gap_width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width);

// Calculate the starting X position for the first tooth, centered along the spine_length (X-axis).
x_center = spine_length / 2;
tooth_start_x = x_center - (total_tooth_and_gap_width / 2);


// --- Main Body Construction ---

difference() {
    // 1. Base block for the entire comb structure (Spine)
    color("gray")
    cube([spine_length, spine_width, plate_thickness]);

    // 2. Cut out the spaces where teeth should be (the gaps/slots)
    for (i = [0 : num_teeth - 1]) {
        // Calculate the center X position for the i-th tooth slot
        tooth_center_x = tooth_start_x + (i * (tooth_width + gap_width));

        // Define the rectangular cutout shape. It runs along X, has width tooth_width, and extends into -Y by tooth_length.
        // The cut starts at Y = spine_width (12mm) and goes down by tooth_length (12mm).
        // We translate to the center of the tooth slot in X, and position it such that its extent covers the required area.

        translate([tooth_center_x - tooth_width/2, 0, 0]) {
            // The cube dimensions must match the feature being cut:
            // X dimension = tooth_width (5.0 mm)
            // Y dimension = tooth_length (12.0 mm) -> This defines how far it hangs into the negative Y space relative to its starting point.
            // Z dimension = plate_thickness (1.5 mm)
            cube([tooth_width, tooth_length, plate_thickness]);
        }
    }
}