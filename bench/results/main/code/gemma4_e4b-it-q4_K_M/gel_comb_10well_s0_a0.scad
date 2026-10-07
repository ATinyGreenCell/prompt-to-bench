// OpenSCAD code for a 10-well agarose gel comb

// --- Dimensions ---
spine_length = 70;      // Total length of the spine (X dimension)
spine_width = 12;       // Width of the spine (Y dimension)
comb_thickness = 1.5;   // Thickness of the entire plate (Z dimension)

tooth_width = 5.0;      // Width of each tooth (X dimension)
tooth_length = 12.0;    // Length/depth of each tooth (Y dimension, extending into gel)
gap_size = 1.5;         // Gap size between teeth

num_teeth = 10;         // Number of wells/teeth

// --- Constants ---
$fn = 64; // High resolution for curves

// --- Geometry Calculations ---

// Total width occupied by teeth and gaps along the X-axis (for centering)
total_tooth_span = num_teeth * tooth_width + (num_teeth - 1) * gap_size;

// Calculate the starting X position to center the row of teeth on the spine's length (70mm)
// The comb is centered in X, so we need to place the entire structure around X=0.
// Since the spine is 70mm long and centered at origin, it spans from -35 to 35.
// We will center the teeth row along the spine's length (X-axis).

// The total span of the teeth array needs to be centered on the X=0 line.
start_x_teeth = -(total_tooth_span / 2);


// --- Main Assembly ---

module gel_comb() {
    difference() {
        // 1. Base Plate (The solid body)
        cube([spine_length, spine_width, comb_thickness]);

        // 2. Cutting the teeth slots (using difference to create holes/slots)
        for (i = [0 : num_teeth - 1]) {
            // Calculate the X position for the current tooth center
            current_tooth_x = start_x_teeth + i * (tooth_width + gap_size);

            // The teeth are cut from one long edge of the spine.
            // We assume the spine is centered at Y=0, spanning from -spine_width/2 to spine_width/2.
            // Let's assume the cutting happens along the positive Y edge (Y = spine_width / 2).

            // The cutter must be slightly larger than the tooth dimensions to ensure clean separation.
            cutter_x = tooth_width + 0.1; // Slightly wider cut
            cutter_y = tooth_length + 0.1; // Slightly deeper cut (must extend past the base plate)
            cutter_z = comb_thickness + 1.0; // Ensure it cuts all the way through

            translate([current_tooth_x, spine_width/2 - cutter_y/2, -0.01]) {
                // The tooth slot is a rectangular prism cut into the base plate
                cube([cutter_x, cutter_y, comb_thickness + 0.01]);
            }
        }
    }
}

gel_comb();