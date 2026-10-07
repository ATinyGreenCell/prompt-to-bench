// Dimensions for the 10-well comb design

// Overall dimensions
spine_length = 70;    // Length of the spine (X dimension) in mm
spine_width = 12;      // Width of the spine (Y dimension) in mm
plate_thickness = 1.5; // Thickness of the plate (Z dimension)

// Tooth dimensions
num_teeth = 10;        // Number of teeth
tooth_width = 5.0;     // Width of each tooth (X dimension)
tooth_length = 12;     // Length of each tooth (Y dimension - depth/hang length in the -Y direction)
gap_width = 1.5;       // Gap between neighboring teeth (Y dimension)

// Positioning calculations
// Total width occupied by teeth and gaps along the Y-axis
total_tooth_and_gap_width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width);

// Center the tooth arrangement along the spine_length (X-axis)
x_center = spine_length / 2;
tooth_start_x = x_center - (total_tooth_and_gap_width / 2);


// --- Main Body Construction ---

difference() {
    // 1. Base block for the entire comb structure (Spine)
    color("gray")
    cube([spine_length, spine_width, plate_thickness]);

    // 2. Cut out the spaces where teeth should be (the slots/gaps).
    // We define the cutouts as rectangular prisms that span the thickness of the plate (Z=1.5) and extend into the -Y direction.
    for (i = [0 : num_teeth - 1]) {
        // Calculate the center X position for the i-th tooth slot
        tooth_center_x = tooth_start_x + (i * (tooth_width + gap_width));

        // Define the rectangular cutout shape.
        // The cut runs along X (width=tooth_width), extends in Y by tooth_length, and has thickness plate_thickness.
        translate([tooth_center_x - tooth_width/2, 0, 0]) {
            cube([tooth_width, tooth_length, plate_thickness]);
        }
    }
}