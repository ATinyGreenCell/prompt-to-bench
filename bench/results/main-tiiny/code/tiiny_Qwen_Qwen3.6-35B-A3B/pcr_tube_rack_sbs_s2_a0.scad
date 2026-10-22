// Dimensions
BLOCK_X = 127.76;
BLOCK_Y = 85.48;
BLOCK_Z = 20;
HOLE_DIA = 6.2;
COLS = 12;
ROWS = 8;
SPACING_X = 9.0;
SPACING_Y = 9.0;
ORIGIN_X = 14.38; // Distance from left edge to first hole center
ORIGIN_Y = 11.24; // Distance from back edge to first hole center
CHAMFER_LEN = 5;
CHAMFER_ANGLE = 45;

// Calculate grid bounds to ensure centering
// Total width of hole grid
GRID_W = (COLS - 1) * SPACING_X;
// Total height of hole grid
GRID_H = (ROWS - 1) * SPACING_Y;

// Calculate margins to center the grid on the block
MARGIN_X = (BLOCK_X - GRID_W) / 2;
MARGIN_Y = (BLOCK_Y - GRID_H) / 2;

// Verify that the calculated margins match the user's specified origin
// User says A1 is 14.38 from left.
// Calculated margin: (127.76 - (11 * 9.0)) / 2 = (127.76 - 99) / 2 = 28.76 / 2 = 14.38. Matches.
// User says A1 is 11.24 from back.
// Calculated margin: (85.48 - (7 * 9.0)) / 2 = (85.48 - 63) / 2 = 22.48 / 2 = 11.24. Matches.

$fn = 64;

module main_part() {
    // Base block
    difference() {
        // Main block
        cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = false);
        
        // 96 Holes
        for (x_idx = [0 : COLS - 1]) {
            for (y_idx = [0 : ROWS - 1]) {
                hx = ORIGIN_X + x_idx * SPACING_X;
                hy = ORIGIN_Y + y_idx * SPACING_Y;
                
                // Hole extends through the block and slightly past the bottom (z=0) 
                // and top (z=BLOCK_Z) to ensure clean cutting.
                // Extending past bottom: -0.1mm. Extending past top: +0.1mm.
                translate([hx, hy, -0.1]) {
                    cylinder(h = BLOCK_Z + 0.2, d = HOLE_DIA, center = false);
                }
            }
        }
        
        // Chamfer at A1 corner (Bottom-Left in XY view, assuming Y is depth/back)
        // A1 is at (ORIGIN_X, ORIGIN_Y).
        // The corner of the block is (0, 0).
        // We need to cut a 45-degree chamfer off the vertical edge at the A1 corner.
        // This usually means cutting off the corner of the block itself, or a specific feature.
        // "Cut a 45-degree chamfer with 5 mm legs off the vertical edge at the A1 corner"
        // This implies a chamfer on the block's corner closest to A1? 
        // Or a chamfer on the hole? No, "off the vertical edge at the A1 corner" usually refers to the block corner.
        // However, A1 is an internal hole. The "A1 corner" of the *rack* usually refers to the physical corner of the block 
        // corresponding to position A1 in a microplate layout. In standard microplates, A1 is top-left or bottom-left depending on orientation.
        // Given ORIGIN_X is from Left and ORIGIN_Y is from Back, and Y increases towards front? 
        // Let's assume standard Cartesian: X right, Y up (on paper) or Y depth. 
        // In OpenSCAD, X is right, Y is up (on screen), Z is out. 
        // Let's assume X is length (127.76), Y is width (85.48).
        // "Back edge" usually implies the edge farthest from the user. If Y=0 is back, Y=BLOCK_Y is front.
        // A1 is 11.24 from back (Y=11.24).
        // A1 is 14.38 from left (X=14.38).
        // The "A1 corner" of the block would be the corner at (0, 0) if we align the grid such that A1 is the first hole.
        // Wait, the grid is centered. The hole A1 is at (14.38, 11.24).
        // The corner of the block is (0,0).
        // The chamfer is "at the A1 corner". This phrasing is slightly ambiguous. 
        // Does it mean a chamfer on the block corner (0,0)? Or a chamfer on the hole A1?
        // "off the vertical edge at the A1 corner" -> likely the block corner closest to A1? 
        // But A1 is not at the corner. 
        // Standard interpretation: The "A1 corner" of the *plate* is the corner at (0,0) of the plate footprint.
        // The hole A1 is the first hole. The corner of the block is (0,0).
        // So we cut a 5mm x 5mm chamfer off the block corner at (0,0).
        
        // Define the chamfer cut. 
        // It's a 45-degree chamfer. 
        // We can model this as a triangular prism cut from the corner.
        // The cut removes material from the corner (0,0,z).
        // The legs are 5mm along X and 5mm along Y.
        // The cut goes through the entire height Z.
        
        // To cut a 45-degree chamfer from the corner (0,0):
        // We can use a rotated box or a polygon extrusion.
        // Let's use a box rotated 45 degrees? No, that's complex.
        // Let's use a simple triangular prism.
        // The triangle is in the XY plane.
        // Vertices: (0,0), (5,0), (0,5).
        // This triangle is extruded through Z.
        // However, we must ensure it doesn't cut into the holes.
        // Hole A1 is at (14.38, 11.24). The chamfer is at (0,0) to (5,5).
        // Distance from (0,0) to (14.38, 11.24) is > 5mm. So it's safe.
        
        linear_extrude(height = BLOCK_Z + 0.1) { // Extend slightly past Z faces
            polygon([
                [0, 0],
                [CHAMFER_LEN, 0],
                [0, CHAMFER_LEN]
            ]);
        }
    }
}

main_part();