// Dimensions
BLOCK_X = 127.76;
BLOCK_Y = 85.48;
BLOCK_Z = 20;
HOLE_DIA = 6.2;
COLS = 12;
ROWS = 8;
SPACING_X = 9.0;
SPACING_Y = 9.0;
OFFSET_X = 14.38;
OFFSET_Y = 11.24;
CHAMFER_LEN = 5;

// Calculate grid centering offsets to ensure the block is centred in X/Y
// The grid spans (COLS-1)*SPACING_X in X and (ROWS-1)*SPACING_Y in Y
GRID_W = (COLS - 1) * SPACING_X;
GRID_H = (ROWS - 1) * SPACING_Y;

// The offset from the block edge to the first hole is given.
// We need to ensure the block is centred.
// Let's verify if the given offsets result in a centred grid.
// Left margin = OFFSET_X
// Right margin = BLOCK_X - (OFFSET_X + GRID_W)
// Top margin (Back) = OFFSET_Y
// Bottom margin (Front) = BLOCK_Y - (OFFSET_Y + GRID_H)

LEFT_MARGIN = OFFSET_X;
RIGHT_MARGIN = BLOCK_X - (OFFSET_X + GRID_W);
BACK_MARGIN = OFFSET_Y;
FRONT_MARGIN = BLOCK_Y - (OFFSET_Y + GRID_H);

// If the margins are not equal, the grid is not centred. 
// However, the prompt says "so the grid is centred on the block".
// Let's check:
// 14.38 vs 127.76 - (14.38 + 11*9) = 127.76 - 113.38 = 14.38. Matches.
// 11.24 vs 85.48 - (11.24 + 7*9) = 85.48 - 74.24 = 11.24. Matches.
// So the given offsets naturally centre the grid.

// Hole positions
// A1 is at (OFFSET_X, OFFSET_Y) in the block's coordinate system.
// X coordinates: OFFSET_X + i * SPACING_X for i in 0..COLS-1
// Y coordinates: OFFSET_Y + j * SPACING_Y for j in 0..ROWS-1

module hole() {
    $fn = 64;
    // Extend past the faces by 0.01mm to ensure clean boolean operations
    // The block is 20mm tall. We cut through from top (z=20) to bottom (z=0).
    // We model the hole as a cylinder extending slightly beyond the block bounds.
    cylinder(h = BLOCK_Z + 0.1, d = HOLE_DIA, center = false);
}

module rack() {
    // 1. Main Block
    // Resting on XY plane at z=0
    block = cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = false);
    
    // 2. Holes
    // We will subtract the holes from the block.
    // To keep the code clean, we create a union of all holes.
    holes = union() {
        for (i = [0 : COLS - 1]) {
            for (j = [0 : ROWS - 1]) {
                x = OFFSET_X + i * SPACING_X;
                y = OFFSET_Y + j * SPACING_Y;
                translate([x, y, 0]) {
                    hole();
                }
            }
        }
    };
    
    // 3. Chamfer
    // 45-degree chamfer with 5mm legs off the vertical edge at the A1 corner.
    // A1 is at (OFFSET_X, OFFSET_Y).
    // The chamfer removes material from the corner defined by x < OFFSET_X and y < OFFSET_Y?
    // No, the corner of the block is at (0,0). A1 is inside the block.
    // "Cut a 45-degree chamfer ... off the vertical edge at the A1 corner"
    // This phrasing is slightly ambiguous. Does it mean the corner of the block near A1?
    // Or does it mean the corner of the block itself, and A1 is just used to identify which corner?
    // "A1 corner" usually refers to the corner of the microplate where well A1 is located.
    // However, A1 is not at the corner of the block. It is offset.
    // Let's re-read: "Cut a 45-degree chamfer ... off the vertical edge at the A1 corner as an orientation mark."
    // In microplate terminology, "A1 corner" often refers to the top-left corner of the plate footprint.
    // But here, the block has physical corners.
    // If the chamfer is at the "A1 corner", it likely means the corner of the block that is closest to A1?
    // Or does it mean the corner of the block itself, and the user calls it the A1 corner because A1 is near it?
    // Given "orientation mark", it is typically on a physical corner of the part.
    // Let's assume the chamfer is on the corner of the block at (0,0) to (5,5) area.
    // Why? Because A1 is the first well. The corner of the block near A1 is the back-left corner (0,0) in our coordinate system if we align the grid such that A1 is at (OFFSET_X, OFFSET_Y).
    // Let's verify the position. A1 is at x=14.38, y=11.24.
    // The corner of the block is at (0,0).
    // A 5mm chamfer on the corner (0,0) would cut into the area x<5, y<5.
    // This is far from A1.
    // Is it possible the user wants the chamfer at the corner of the *grid*? No, "vertical edge at the A1 corner".
    // Let's look at the wording again: "at the A1 corner".
    // In many contexts, the "A1 corner" of a rack refers to the corner of the rack where the A1 well is located.
    // But A1 is not at the corner.
    // Perhaps the user means the corner of the block that is *associated* with A1.
    // Usually, A1 is top-left. So the top-left corner of the block.
    // In our coordinates, if Y increases towards the front, and X increases towards the right.
    // A1 is at (14.38, 11.24).
    // The corner closest to A1 is (0,0) if we consider the block's origin.
    // Let's assume the chamfer is on the block corner at (0,0).
    // It cuts a 5x5 triangle from the vertical edge.
    
    // To cut a chamfer from the corner (0,0) along the top and side faces:
    // We need to subtract a triangular prism.
    // The chamfer is 45 degrees, 5mm legs.
    // It removes material from x in [0,5], y in [0,5], z in [0,20].
    // The cut surface is defined by x + y <= 5? No, that would be a diagonal cut from (5,0) to (0,5).
    // A 45-degree chamfer on the corner usually means the face is at 45 degrees to the sides.
    // So the cut plane is x + y = 5? No, that's a slope.
    // Let's define the volume to remove.
    // It's a triangular prism along the Z axis.
    // Base triangle in XY plane: vertices (0,0), (5,0), (0,5).
    // Wait, if we remove this, the remaining part has a flat face at 45 degrees.
    // The face would be the plane passing through (5,0,z), (0,5,z), and the top/bottom edges?
    // No, a chamfer is a bevel.
    // If we cut a 5mm leg from the vertical edge, we are removing the corner.
    // The new surface is a plane.
    // The plane intersects the top face (z=20) along the line connecting (5,0,20) and (0,5,20)?
    // And the side face (y=0) along the line connecting (5,0,0) and (5,0,20)?
    // And the back face (x=0) along the line connecting (0,5,0) and (0,5,20)?
    // This creates a bevel.
    // The volume to remove is the region where x >= 0, y >= 0, x + y <= 5?
    // No, if x