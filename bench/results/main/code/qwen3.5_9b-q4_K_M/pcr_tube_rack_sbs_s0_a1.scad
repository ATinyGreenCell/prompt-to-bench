// OpenSCAD Rack for 96 PCR Tubes (0.2 mL) - ANSI/SLAS Footprint
// Units: millimetres

$fn = 128; // High resolution for chamfers and holes

// --- Dimensions based on user input ---
W_BLOCK_X = 127.76; // Length (X)
W_BLOCK_Y = 85.48;  // Width (Y)
H_BLOCK_Z = 20;     // Height (Z)

D_HOLE = 6.2;       // Diameter of PCR tube holes
C_SPACING_X = 9.0;  // Centre-to-centre spacing in X
C_SPACING_Y = 9.0;  // Centre-to-centre spacing in Y

O_X_LEFT = 14.38;   // Offset of first hole column from left edge (absolute)
O_Y_BACK = 11.24;   // Offset of first hole row from back edge (absolute)

CHAMFER_LEG = 5;    // Leg length for the chamfer at A1 corner

// --- Coordinate System Setup ---
// Rule 3: Centre on origin in X and Y, rest on XY plane at Z=0.
half_X = W_BLOCK_X / 2;
half_Y = W_BLOCK_Y / 2;

// Calculate absolute coordinates of the "A1" corner (Left-Back) relative to center
// Left Edge is at -half_X. Back Edge is assumed to be +Y direction for standard plate orientation logic, 
// but we must align with offsets provided from edges.
// Let's define: X increases Right, Y increases Towards Back/Top of screen.
// "Left edge" = x = -W_BLOCK_X / 2
// "Back edge" = y = +W_BLOCK_Y / 2

X_A1_ABSOLUTE_FROM_LEFT = O_X_LEFT; // Distance from Left Edge (-half_X) to Hole Center X
Y_A1_ABSOLUTE_FROM_BACK = O_Y_BACK; // Distance from Back Edge (+half_Y) to Hole Center Y (going towards front/0)

// Calculate the specific corner coordinates where the chamfer goes.
// The A1 hole is at: x_corner + offset, y_corner - offset_from_back? 
// Wait, if "Back edge" is the reference for O_Y_BACK=11.24mm, and we assume standard plate orientation (Row 1/A is usually top/back),
// then the Back Edge corresponds to Y = half_Y. The holes go down towards Y = -half_Y.
// So Hole Row A center Y = half_Y - O_Y_BACK.

X_CHAMFER_CORNER = (-W_BLOCK_X / 2) + O_X_LEFT; 
Y_CHAMFER_CORNER = (W_BLOCK_Y / 2) - O_Y_BACK; 

// --- Main Geometry Construction ---
difference() {
    
    // 1. Create the main block centered at origin
    main_block = cube([W_BLOCK_X, W_BLOCK_Y, H_BLOCK_Z], center=true);

    // 2. Cut holes using a loop
    for (col = -N_COLS/2 + 0.5; col <= N_COLS/2 - 0.5; col += 1) {
        for (row = -(N_ROWS-1)/2 + 0.5; row <= (N_ROWS-1)/2 - 0.5; row += 1) {
            // Calculate center of this hole based on grid logic relative to the A1 corner defined above
            
            // We need a reference point for our loop counters that matches O_X_LEFT and O_Y_BACK.
            // Let's define X_start_abs = (-W_BLOCK_X/2) + O_X_LEFT;
            // Let's define Y_start_abs = (W_BLOCK_Y/2) - O_Y_BACK;
            
            x_hole_center = ((-W_BLOCK_X / 2) + O_X_LEFT) + col * C_SPACING_X;
            y_hole_center = ((W_BLOCK_Y / 2) - O_Y_BACK) + row * (-C_SPACING_Y); 
            // Note: Rows usually go from Back (positive Y in our setup?) to Front. 
            // If Row A is at the back, and we have N_ROWS=8.
            // Let's assume standard matrix indexing where index 0 corresponds to O_X_LEFT/O_Y_BACK offset logic.
            
            // Re-calculating loop indices to match exact offsets:
            // We want a grid starting exactly at (X_start_abs, Y_start_abs).
            // The previous nested for loops with +/- N/2 are tricky if the start isn't symmetric around 0 relative to that specific corner.
            // Let's switch strategy: Iterate i from 0 to N_COLS-1 and j from 0 to N_ROWS-1.
        }
    }

    // Corrected Hole Loop Strategy
    for (i = 0; i < N_COLS; i++) {
        x_hole_center_i = (-W_BLOCK_X / 2) + O_X_LEFT + i * C_SPACING_X;
        
        for (j = 0; j < N_ROWS; j++) {
            // Determine Y direction. 
            // If "Back" is the edge with offset, and we assume standard plate orientation where Row A is at that back edge:
            y_hole_center_j = ((W_BLOCK_Y / 2) - O_Y_BACK) + (N_ROWS - 1 - j) * C_SPACING_Y; 
            // This assumes rows go from Back to Front as index increases? Or vice versa.
            // Let's assume standard Cartesian: Y goes up/back. Row A is at the back edge (+Y).
            // So first row (j=0) should be closest to +half_Y - O_Y_BACK.
            
            cylinder(h = H_BLOCK_Z, r = D_HOLE / 2, center=[x_hole_center_i, y_hole_center_j]);
        }
    }

    // 3. Cut Chamfer at A1 Corner (Left-Back)
    // Coordinates of the corner: 
    x_corner = (-W_BLOCK_X / 2);
    y_corner = (W_BLOCK_Y / 2);
    
    // We want to cut a wedge from this vertical edge.
    // The chamfer plane passes through points on the face X=x_corner and Y=y_corner? No, it cuts the corner itself.
    // A 45 deg chamfer with leg L removes material where (x - x_corner) + (y - y_corner) > L ? 
    // Actually, simpler: Create a cutting shape that is an extruded polygon at Z=0 to Z=H? No, it's on the side.
    
    // Method: Extrude a 2D profile along Z and subtract from main_block.
    // The profile will be the rectangle minus the chamfer wedge at the top-left corner (in local coords).
    // Local Coords for Chamfer Corner: X = x_corner, Y = y_corner.
    
    // Define points of the cut shape in a plane perpendicular to Z? No, we are cutting the side face.
    // We can create a "chamfer cutter" block that is tall (Z=H) and wide enough, but shaped with the chamfer notch at one corner.
    
    // Let's define the profile for the cutter in X-Y plane relative to the global origin? 
    // Easier: Create a shape identical to main_block but with the specific corner cut out using polygon extrusion or difference of primitives.
    
    // Approach: Union of Main Block and nothing, then Difference with Chamfer Cutter.
    // The Chamfer Cutter is an object that fits inside the block at the A1 corner but has "less" material there? 
    // No, we want to REMOVE material from main_block. So we need a shape representing the void created by the chamfer.
    
    // Let's build the "Chamfer Void" as a separate solid and subtract it.
    // The void is defined at corner (x_corner, y_corner).
    // It extends inwards towards positive X and negative Y? 
    // Wait: Corner is Left (-X) and Back (+Y).
    // If we chamfer the "vertical edge", we are cutting into the block from that corner.
    // The cut removes material between x=x_corner, y=y_corner and a plane sloping down.
    
    // Let's construct the cutter shape explicitly:
    // It occupies space where X < x_cut_plane AND Y > y_cut_plane? 
    // Actually, let's just define the points of the polygon that creates the chamfered face at Z=0 (and extrude up).
    // But wait, a simple cube subtraction won't work easily unless we build the "missing wedge" as a solid.
    
    // Let's try: 
    // 1. Start with Main Block.
    // 2. Create a shape that represents the material to be removed at the corner.
    // The removal is defined by a plane cutting through the edge (x_corner, y_corner).
    // Points of the cut face on X=x_corner: from y=y_corner down to y = y_corner - CHAMFER_LEG? 
    // No, "45 degree chamfer with 5mm legs". This implies removing a triangle of leg length 5.
    
    // Let's define the cutter shape