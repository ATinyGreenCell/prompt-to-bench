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

// Calculate the starting X position to center the row of teeth on the spine's length (70mm).
// The spine spans from -35 to 35. We want the total span (total_tooth_span) centered around X=0.
start_x_teeth = -(total_tooth_span / 2);


// --- Main Assembly ---

module gel_comb() {
    difference() {
        // 1. Base Plate (The solid body) - Centered at origin in XY plane
        cube([spine_length, spine_width, comb_thickness]);

        // 2. Cutting the teeth slots (using difference to create holes/slots)
        for (i = [0 : num_teeth - 1]) {
            // Calculate the X position for the current tooth center
            current_tooth_x = start_x_teeth + i * (tooth_width + gap_size);

            // The teeth are cut from one long edge of the spine.
            // Spine spans Y from -6 to 6. We cut from the positive Y edge (Y = spine_width / 2 = 6).
            // The cutter must be slightly larger than the tooth dimensions to ensure clean separation.
            cutter_x = tooth_width + 0.1; // Slightly wider cut
            cutter_y = tooth_length + 0.1; // Slightly deeper cut (must extend past the base plate)
            cutter_z = comb_thickness + 0.01; // Ensure it cuts all the way through

            // Translate to position the cutter:
            // X: current_tooth_x
            // Y: spine_width/2 - cutter_y/2 (to center the cut along the edge)
            // Z: -0.01 (to ensure the cut starts slightly below Z=0)
            translate([current_tooth_x, spine_width/2 - cutter_y/2, -0.01]) {
                // The tooth slot is a rectangular prism cut into the base plate
                cube([cutter_x, cutter_y, comb_thickness + 0.01]);
            }
        }
    }
}

gel_comb();