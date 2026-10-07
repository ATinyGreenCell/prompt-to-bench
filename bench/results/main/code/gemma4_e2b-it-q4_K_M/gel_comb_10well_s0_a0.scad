// Dimensions for the 10-well comb design

// Overall dimensions
spine_length = 70;    // Length of the spine (X dimension) in mm
spine_width = 12;      // Width of the spine (Y dimension) in mm
plate_thickness = 1.5; // Thickness of the plate (Z dimension)

// Tooth dimensions
num_teeth = 10;        // Number of teeth
tooth_width = 5.0;     // Width of each tooth (X dimension)
tooth_length = 12;     // Length of each tooth (Y dimension)
gap_width = 1.5;       // Gap between neighboring teeth (Y dimension)

// Positioning calculations
// The row of teeth is centered on the spine in X.
// Total width occupied by teeth and gaps: (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width)
total_tooth_and_gap_width = (num_teeth * tooth_width) + ((num_teeth - 1) * gap_width);

// Calculate the starting position for centering the teeth along the spine (X-axis).
// The total width of the comb structure in Y is determined by the teeth arrangement.
// We center this arrangement within the spine_width (12 mm).
// Center offset = (spine_width - total_tooth_and_gap_width) / 2
x_offset = (spine_width - total_tooth_and_gap_width) / 2;

// Calculate the starting X position for the first tooth.
start_x = x_offset;

// The spine extends from X=0 to X=spine_length (70 mm).
// We center the entire structure in X if necessary, but the prompt implies the spine is 70mm long.
// Let's assume the spine runs from X=0 to X=70 for simplicity of placement relative to the origin,
// and we will center the tooth arrangement within this length.

// Center the tooth arrangement along the spine_length (X-axis)
x_center = spine_length / 2;

// Calculate the starting position for the first tooth based on centering it around x_center
tooth_start_x = x_center - (total_tooth_and_gap_width / 2);


// --- Main Body Construction ---

// 1. The main flat plate (Spine)
difference() {
    // Base block for the entire comb structure
    cube([spine_length, spine_width, plate_thickness]);

    // Cut out the space for the teeth (This is complex as teeth hang down from one edge)
    // We will define the main body first and then subtract the empty spaces where teeth should be.

    // For simplicity in modeling a flat comb lying on XY plane:
    // The spine is defined by its length (X) and width (Y).
    // Teeth hang in the -Y direction from one long edge. Let's assume the teeth hang from Y = spine_width (12mm side).

    // Define the area where teeth will be cut out (the space between them)
    for (i = [0 : num_teeth - 1]) {
        // Calculate the center X position for the i-th tooth
        tooth_center_x = tooth_start_x + (i * (tooth_width + gap_width));

        // Define the rectangular slot to be removed (Tooth space)
        // Tooth runs along X, has width tooth_width. It hangs down in Y direction.
        // Since teeth hang from one long edge, let's assume they are cut into the plate thickness area.

        // If we interpret "hang from one long edge" as extending into the Z space (which is not typical for a flat comb),
        // or if it means the tooth structure extends in the -Y direction *from* the spine surface.
        // Given the description: "10 rectangular teeth that hang from one long edge of the spine in the -Y direction."

        // Let's model the plate as the base, and the teeth as extrusions/cuts extending into negative Y space relative to the spine center line.

        // Since we are building a flat plate (Z=1.5), the teeth must be modeled as features cut *into* this plate or extruded from it.
        // Assuming the teeth are rectangular slots cut into the 1.5mm thick plate, running along X and extending in -Y.

        // Tooth slot dimensions: Width = tooth_width (X), Length = tooth_length (Y) -> This seems contradictory if Y is the direction of hanging.
        // Let's assume: Tooth runs along X (5mm wide), extends into -Y by 12mm, and has a thickness defined by plate_thickness.

        // We will model the teeth as rectangular prisms cut out from the main block.
        translate([tooth_center_x - tooth_width/2, 0, 0]) {
            cube([tooth_width, tooth_length, plate_thickness]); // This models a feature extending in +Y direction if we use Y=12mm as the extent.

            // Re-interpreting: Teeth hang from one long edge (e.g., Y=spine_width). They extend into -Y.
            // We need to define where this hanging happens relative to the spine's center line.
        }
    }
}

// --- Revised Modeling Strategy: Building the structure piece by piece for clarity and correctness ---

// 1. Build the main plate (Spine)
color("gray")
cube([spine_length, spine_width, plate_thickness]);

// 2. Model the teeth as negative space cutouts extending into -Y direction from Y=spine_width boundary.
difference() {
    // Start with the solid plate
    cube([spine_length, spine_width, plate_thickness]);

    // Cut out the spaces where teeth should be (the gaps)
    for (i = [0 : num_teeth - 1]) {
        // Calculate the center X position for the i-th tooth slot
        tooth_center_x = tooth_start_x + (i * (tooth_width + gap_width));

        // Define the rectangular cutout shape. It runs along X, has width tooth_width, and extends into -Y by tooth_length.
        translate([tooth_center_x - tooth_width/2, spine_width - 0.01, 0]) { // Start slightly inside the edge for clean cut
            cube([tooth_width, tooth_length, plate_thickness]);
        }
    }
}

// Final check: Ensure the structure is centered on X and Y (origin).
// The current model places the spine from X=0 to X=70. If centering is required around origin (X=0), we need translation.
// Since the prompt states "straight spine... 70 mm long (X)", we will keep it starting at X=0, but ensure the tooth arrangement is centered within that 70mm span.

// Final placement adjustment: Shift the entire structure so its center in X aligns with the origin if required by standard practice, or leave it as defined relative to the origin. We will stick to the calculated `tooth_start_x` based on centering the teeth along the spine length (X).