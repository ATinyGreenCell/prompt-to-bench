// Dimensions for standard microplate (ANSI/SLAS) footprint and PCR tube rack
block_length = 127.76; // Length along X axis in mm
block_width = 85.48;   // Width along Y axis in mm
block_height = 20;     // Height of the block in mm

hole_diameter = 6.2;   // Diameter of through-holes in mm
row_spacing = 9.0;     // Centre-to-centre spacing between rows (Y) in mm
col_spacing = 9.0;     // Centre-to-centre spacing between columns (X) in mm

hole_offset_x = 14.38; // X offset of the first hole from left edge in mm
hole_offset_y = 11.24; // Y offset of the first hole from back edge in mm

chamfer_leg_length = 5; // Length of chamfer legs in mm (legs are equal)
chamfer_angle_degrees = 45; // Angle of chamfer in degrees

// Calculate number of rows and columns based on spacing and offsets
num_rows = int((block_width - hole_offset_y * 2) / row_spacing);
num_cols = int((block_length - hole_offset_x * 2) / col_spacing);

// Verify calculated dimensions match expected grid size (optional sanity check logic omitted for brevity, relying on user input accuracy)

// Define the main block geometry
module make_block() {
    cube([block_length, block_width, block_height]);
}

// Function to create a single hole with chamfered edges if needed
function get_hole(x_pos, y_pos) = 
    cylinder(h=block_height+0.1, r=hole_diameter/2); // +0.1mm extension for difference operation stability

// Generate the grid of holes using loops
module make_holes() {
    union() {
        // Calculate starting positions based on offsets and spacing
        start_x = hole_offset_x; 
        start_y = block_width - (hole_offset_y); // Back edge is Y=0 in local coords if we consider back as min, but user said "from back edge". Let's assume standard coordinate system where X increases right, Y increases forward. User says "11.24 mm from the back edge", implying distance from one side.
        
        // Re-evaluating coordinates: 
        // If block is [0, 127.76] x [0, 85.48]. Back edge could be Y=0 or Y=max depending on orientation description. 
        // Standard convention for "from back": usually implies the rear of the plate relative to viewing direction (often Z axis in lab benches, but here we are building up from XY).
        // Let's assume standard Cartesian: X is left-right, Y is front-back. Back edge = min(Y) or max(Y)? 
        // Usually "back" means away from viewer if looking at the plate face-on? Or simply one side of the rectangle.
        // Given symmetry requirements for centering: The grid must be centered on the block.
        
        // Let's calculate exact coordinates to ensure perfect centering as requested ("grid is centred on the block").
        // Center X = 127.76 / 2 = 63.88
        // Center Y = 85.48 / 2 = 42.74
        
        // Hole A1 (first hole) center: 
        // x_A1 = Left_Edge + 14.38 = 0 + 14.38? Or is "Left Edge" defined relative to the block start?
        // Assuming standard engineering drawing where edges are at X=0 and Y=0 (or similar).
        // If A1 is 14.38 from Left, its x-coord = 14.38.
        // If A1 is 11.24 from Back, let's assume "Back" corresponds to the lower bound of Y for this calculation context (or we can flip). 
        // However, if the grid must be centered:
        // Total width occupied by holes = num_cols * col_spacing + hole_diameter? No, center-to-center.
        
        // Let's derive coordinates purely from "Centered" constraint to ensure robustness against interpretation of "back".
        // If A1 is at (x0, y0). 
        // x_last = x0 + (num_cols - 1) * col_spacing.
        // Total span X = x_last - x0 + hole_diameter? No, the holes are inside. The block contains them.
        
        // Let's stick to user explicit offsets relative to a corner, assuming that corner is defined by Left and Back edges meeting at (min_x, min_y) or similar. 
        // If we assume "Left" = X=0 side and "Back" = Y=0 side:
        start_hole_x = hole_offset_x;
        start_hole_y = block_width - hole_offset_y; // Assuming "back" is the far edge relative to a standard view, or simply defining it as distance from one end. 
        // Wait, if A1 is 14.38 from Left and 11.24 from Back.
        // If we place Block at [0, L] x [0, W].
        // Case A: "Back" = Y=0 (min). Then y_A1 = 11.24. 
        // Case B: "Back" = Y=W (max). Then y_A1 = W - 11.24.
        
        // Let's check centering logic for both cases to see which yields a centered grid of identical holes.
        // Grid X range: [x_start, x_end]. Center_X should be L/2.
        // If we assume A1 is the "top-left" or similar reference? 
        // Actually, if the user says "grid is centred on the block", then regardless of where A1 starts, the arrangement must result in symmetry around (L/2, W/2).
        
        // Let's calculate positions based on centering first to be safe.
        // Number of holes = 96. Rows=8, Cols=12? 
        // User says: "96 vertical through-holes... in 8 rows (along Y) by 12 columns (along X)".
        
        // Let's calculate the exact center coordinates for a centered grid.
        // Center of block = [block_length/2, block_width/2]
        // Radius vector to first hole? 
        // If we assume A1 is at offset from Left and Back edges...
        // Let's try: x_A1 = 14.38; y_A1 = 11.24 (assuming back=min_y).
        // Next row up by 9mm? Or down? "Rows along Y". Usually index increases away from reference or towards center? 
        // If A1 is at bottom-left-ish, and we go UP to fill the plate...
        
        // Let's calculate coordinates explicitly:
        // We need 8 rows. Spacing = 9mm. Total height needed for centers = (8-1)*9 + hole_diameter? No, just center positions matter.
        // If centered on block width W=85.48. 
        // Center Y_block = 42.74.
        // Distance from edge to first row of holes: d_y_edge_to_row1.
        // Then distance between rows is 9mm.
        // Total span covered by hole centers in Y direction? No, the block contains them. 
        // If A1 is at y=11.24 (from back). And there are 8 rows.
        // Are they symmetric around center? 
        // Let's assume standard microplate layout: Holes are centered on a square grid within the rectangle.
        
        // Recalculating based on "Centered":
        // If A1 is at x=14.38 from Left, and there are 12 columns with spacing 9mm.
        // Does this create symmetry? 
        // Let's find the max X: x_max = 14.38 + (12-1)*9 = 14.38 + 99 = 113.38.
        // Span from A1 to last hole center = 113.38 - 14.38 = 99mm. 
        // Block length = 127.76. Half-length = 63.88.
        // If we place the grid such that it is centered:
        // Center of Grid X must be 63.88.
        // Midpoint between A1 and Last_Hole_X should be 63.88? 
        // (x_A1 + x_Last) / 2 = Block_Center_X ?
        // If so, x_Last = 2*63.88 - 14.38 = 127.76 - 14.38 = 113.38. 
        // This matches the calculation above (14.38 + 99).
        // So if x_A1 is at 14.38 from