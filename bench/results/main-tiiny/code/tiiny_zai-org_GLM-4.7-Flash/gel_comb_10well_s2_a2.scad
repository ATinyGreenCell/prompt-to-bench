// Dimensions for the 10-well agarose gel comb
// All dimensions are in millimetres (mm)

// Overall geometry
plate_thickness = 1.5;      // Thickness of the flat plate (Z)
spine_length = 70.0;       // Length of the spine (X)
spine_width = 12.0;        // Width of the spine (Y)
tooth_width = 5.0;         // Width of each tooth (X)
tooth_length = 12.0;       // Length of each tooth (Y)
tooth_gap = 1.5;           // Gap between neighbouring teeth (X)
tooth_offset = 2.0;        // Distance from spine edge to tooth start (Y)

// Derived dimensions
num_teeth = 10;            // Number of teeth
total_teeth_width = num_teeth * tooth_width + (num_teeth - 1) * tooth_gap;
spine_x_start = -spine_length / 2;
spine_y_start = -spine_width / 2;
tooth_y_start = -spine_width / 2 - tooth_offset;

// Render settings
$fn = 64;                  // High resolution for curved surfaces

// Main Assembly
module gel_comb() {
    union() {
        // 1. The Spine (Back Bar)
        translate([0, spine_y_start, 0])
            cube([spine_length, spine_width, plate_thickness]);

        // 2. The Teeth
        // Loop to create 10 teeth
        for (i = [0 : num_teeth - 1]) {
            // Calculate X position for this tooth
            // Center the row of teeth on the spine
            // The teeth start at 0 relative to the spine center, so we subtract half the total width
            tooth_x_center = (i * (tooth_width + tooth_gap)) - (total_teeth_width / 2);
            
            translate([tooth_x_center, tooth_y_start, 0])
                cube([tooth_width, tooth_length, plate_thickness]);
        }
    }
}

// Render the part
gel_comb();