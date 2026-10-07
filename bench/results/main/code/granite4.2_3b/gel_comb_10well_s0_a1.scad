// Dimensions in millimeters
spine_length = 70;      // length of the straight spine along X direction (mm)
spine_width = 12;       // width of the spine along Y direction (mm)
comb_thickness = 1.5;   // thickness of the whole comb (Z) (mm)
tooth_width = 5.0;       // width of each tooth in X direction (mm)
tooth_length = 12;       // length of each tooth in Y direction (mm, along spine edge)
gap_between_teeth = 1.5;  // gap between neighboring teeth along the spine edge (mm)
num_teeth = 10;          // number of rectangular teeth hanging from one long edge of the spine

// Build repeated features using for loops as required.
// The comb rests flat on the XY plane at z=0, building upward (+Z).
// Spine is centered in X and Y: runs along X from -spine_length/2 to +spine_length/2,
// and spans Y from -spine_width/2 to +spine_width/2.
// Teeth hang downward (-Y direction) from the top edge of the spine (Y = spine_width/2).

// Define base rectangle for the spine area using linear_extrude on a square cross-section? 
// Instead, we will build the comb as union of prisms directly with translate and cube.

// Create the main spine plate (central rectangular region) centered at origin.
spine_plate = cube([spine_length, spine_width, comb_thickness]);

// For each tooth, create a rectangular prism extending downward from the spine edge.
for (i = [0 : num_teeth - 1]) {
    // Position along X: place teeth centered on the spine edge with equal spacing.
    // The centers are spaced by (tooth_width + gap_between_teeth) to account for tooth width and gap between edges.
    tooth_center_x = base_x / 2 + (i * (tooth_width + gap_between_teeth)) / 2;
    
    // Actually, we define cumulative offset along X: start at center of spine edge, then move by spacing for each tooth.
    // Let's compute the x-position of the i-th tooth center relative to the spine edge line (Y = spine_width/2).
    // The total length occupied per tooth plus gap is tooth_width + gap_between_teeth.
    // So tooth centers are placed at intervals of that spacing along X.
    
    // Use a running variable: we can compute directly using loop index and cumulative offset.
    // We'll accumulate the x-offset as i * (tooth_width + gap_between_teeth).
    
    // Define base rectangle for spine edge line: Y = spine_width/2, X from -spine_length/2 to +spine_length/2.
    // The tooth prism will be a rectangular block extending downward (-Y) by tooth_length (in Y direction), and in X it spans [tooth_center_x - tooth_width/2, tooth_center_x + tooth_width/2].
    
    // Compute the x-coordinate of the center line for this tooth.
    // Let's define cumulative offset along X: start at 0 (center of spine edge), then each tooth moves by spacing = tooth_width + gap_between_teeth.
    // So tooth i is placed at x = i * (tooth_width + gap_between_teeth) from the center line? But we want them centered on the spine edge, which runs along X direction.
    
    // Better: define the spine edge as a line segment of length spine_length along X, starting at -spine_length/2 and ending at +spine_length/2.
    // Place tooth i such that its center is located at offset = (i * (tooth_width + gap_between_teeth)) from the center of the spine edge line? Actually we want teeth centered along the spine edge, with equal spacing between their edges.
    
    // Let's define:
    //   - The spine edge runs along X direction; its Y coordinate is fixed at Y = spine_width/2 (the top half).
    //   - Teeth hang downward (-Y) from this edge.
    //   - Each tooth has width tooth_width in X, and length tooth_length in Y (downward direction).
    //   - The gap between neighboring teeth is gap_between_teeth along the spine edge direction (i.e., along X axis? Actually gap is measured perpendicular to the teeth edges, which are aligned with Y direction; so gap is along X direction because teeth extend in Y and their width spans X).
    //   - The problem states: "gaps between neighbouring teeth are 1.5 mm", meaning the distance between the trailing edge of one tooth and the leading edge of the next tooth measured perpendicular to the teeth (i.e., along X axis if teeth hang downward in Y direction).
    
    // So we place tooth centers spaced by (tooth_width + gap_between_teeth) along X.
    // Let cumulative offset = i * (tooth_width + gap_between_teeth).
    // Then the x-coordinate of the center of tooth i is: base_x / 2 + cumulative_offset / 2? Actually we want the centers to be symmetric about the spine edge line.
    
    // Simpler approach: define a loop that accumulates position along X using the index, and place each tooth at its appropriate location without needing an explicit running variable—just compute directly from i.
    // We'll use a local variable for cumulative offset if needed; but we can just compute x_center = spine_length/2 - (i * (tooth_width + gap_between_teeth)) / 2? Not exactly centered on the whole spine edge line, which runs from -spine_length/2 to +spine_length/2.
    
    // We want the row of teeth centred on the spine in X, meaning the centers of the teeth are symmetric about the center of the spine (X=0).
    // So we place tooth i at x = spine_length/2 - (i * spacing) where spacing = (tooth_width + gap_between_teeth)/2? Actually if we have num_teeth, total span occupied by teeth and gaps along X is:
    //   total_span = num_teeth * tooth_width + (num_teeth - 1) * gap_between_teeth.
    // We want this to be centered on the spine edge line which runs from -spine_length/2 to +spine_length/2, but we don't require that the entire comb fits exactly within spine_length; it's okay if teeth are near edges as long as they fit.
    
    // The problem says: "the row of teeth is centred on the spine in X". So the centers of the teeth should be symmetric about X=0, i.e., tooth i and tooth (num_teeth-1-i) have same x offset magnitude but opposite sign.
    // Therefore we can place tooth i at:
    //   x_center = - (spine_length/2) + (i * (tooth_width + gap_between_teeth)) / 2? Not ideal.
    
    // Instead, define the positions using a loop that accumulates offset from center line of spine edge.
    // Let's define:
    //   x0 = -spine_length/2;   // left end of spine edge line (X coordinate)
    //   x1 = +spine_length/2;   // right end
    
    // But we don't need to align exactly with ends; just center the row.
    
    // We'll place tooth i such that its center is at:
    //   x_center = spine_length/2 - (i * (tooth_width + gap_between_teeth)) / 2
    // This ensures symmetric placement if we have an even number of teeth? Actually with num_teeth=10, the total span occupied is:
    //   total = num_teeth * tooth_width + (num_teeth - 1) * gap_between_teeth.
    // We want this to be centered on the spine edge line which runs from -spine_length/2 to +spine_length/2, so we set:
    //   x_center = spine_length/2 - (total / 2)
    // But then tooth i's center is not equally spaced individually; they are all at the same offset? No, that would place all teeth centers at the same X coordinate.
    
    // Correct method: define cumulative offset along X for each tooth center relative to the spine edge line's midpoint (X=0).
    // Let spacing_per_tooth = tooth_width + gap_between_teeth.
    // Then tooth i is placed at x = - (spine_length/2) + (i * spacing_per_tooth)/2? Not exactly; we want the centers to be spaced by spacing_per_tooth along X, starting from the