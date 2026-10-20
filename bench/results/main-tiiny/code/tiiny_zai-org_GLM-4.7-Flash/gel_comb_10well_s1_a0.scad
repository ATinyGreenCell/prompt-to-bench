// Dimensions for the 10-well agarose gel comb
// All units in millimetres

// Overall Geometry
plate_thickness = 1.5;   // Thickness of the flat plate (Z)
spine_length = 70;       // Length of the spine (X)
spine_width = 12;        // Width of the spine (Y)

// Tooth Geometry
tooth_width = 5.0;       // Width of a single tooth (X)
tooth_length = 12;       // Length of a single tooth (Y)
tooth_gap = 1.5;         // Gap between neighbouring teeth (Y)

// Positioning
num_teeth = 10;          // Number of teeth on the comb
tooth_offset = 0.5;      // Offset of the first tooth from the spine edge (Y)

// Rendering
$fn = 64;               // High resolution for curved surfaces

// Main Body
module gel_comb() {
    union() {
        // The Spine (Back bar)
        translate([0, spine_width / 2, 0])
            cube([spine_length, spine_width, plate_thickness], center = true);

        // The Teeth
        // Calculate total width occupied by teeth and gaps
        total_teeth_width = num_teeth * tooth_width;
        total_gaps_width = (num_teeth - 1) * tooth_gap;
        total_row_width = total_teeth_width + total_gaps_width;

        // Calculate starting Y position to center the row of teeth
        // The row starts at the edge of the spine (Y = spine_width/2)
        // and extends into -Y.
        start_y = (spine_width / 2) + tooth_offset;

        for (i = [0 : num_teeth - 1]) {
            // Calculate Y position for each tooth
            // The first tooth is at start_y, the next is start_y + tooth_width + tooth_gap, etc.
            current_y = start_y + i * (tooth_width + tooth_gap);

            translate([0, current_y, 0])
                cube([tooth_width, tooth_length, plate_thickness], center = true);
        }
    }
}

// Render the part
gel_comb();