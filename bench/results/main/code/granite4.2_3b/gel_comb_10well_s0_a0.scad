// Dimensions in millimeters
spine_length = 70;      // length of the straight spine along X direction
spine_width = 12;       // width of the spine along Y direction
comb_thickness = 1.5;   // thickness of the whole comb (Z)
tooth_width = 5.0;       // width of each tooth in X direction
tooth_length = 12;       // length of each tooth in Y direction (along spine edge)
gap_between_teeth = 1.5;  // gap between neighboring teeth along the spine edge
num_teeth = 10;          // number of rectangular teeth hanging from one long edge of the spine

// Build the comb as a flat plate lying on the XY plane at z=0, building upward (+Z)
// The comb rests with its spine centered in X and Y.

// Define the base rectangle for the comb (the spine area)
base_x = spine_length;   // from -spine_length/2 to +spine_length/2 along X
base_y = spine_width;    // from -spine_width/2 to +spine_width/2 along Y

// Create the main comb plate (the spine and teeth region) using union of shapes.

// First, create a rectangular prism for the spine area (central rectangle).
spine_prism = translate([0, 0, 0]) * cube([base_x, base_y, comb_thickness]);

// For each tooth, create a rectangular prism extending upward from the spine edge.
for (i = [0 : num_teeth - 1]) {
    // Position of the i-th tooth along the spine edge (-Y direction).
    // The teeth are centered on the spine in X, spaced evenly with gaps.
    tooth_x = base_x / 2 + (i * gap_between_teeth) / 2;   // centering offset due to gaps and teeth width? Actually simpler: place centers at intervals of tooth_width + gap.
    // Better approach: place tooth centers along the spine edge with spacing = tooth_width + gap.
    // The total length occupied by one tooth plus its following gap is (tooth_width + gap).
    // So tooth i starts at offset = i * (tooth_width + gap) from the center line of the spine edge.
    
    // Let's define:
    // - Spine runs along X from -base_x/2 to +base_x/2.
    // - The teeth hang from one long edge of the spine in the -Y direction, centered on that edge.
    //   So we consider the edge at Y = base_y / 2 (the top half of the spine width).
    
    // Actually: the spine is a rectangle of size [base_x, base_y] along X and Y axes.
    // The teeth hang from one long edge of the spine in the -Y direction.
    // That means we take the edge at Y = base_y / 2 (the top half), and attach teeth extending downward (-Y).
    
    // Place tooth i such that its center along X is offset by cumulative spacing.
    // The centers are equally spaced along the spine edge, with gap between tooth edges.
    
    // Let's define:
    //   tooth_center_x = base_x / 2 + (i * (tooth_width + gap_between_teeth)) / 2;
    // But simpler: place tooth centers at positions along the spine edge with spacing equal to tooth_width + gap.
    
    // We'll use a loop that accumulates position based on cumulative spacing.
}