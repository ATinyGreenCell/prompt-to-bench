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
// Left Edge is at -W_BLOCK_X / 2. Back Edge is assumed to be +Y direction.
X_CHAMFER_CORNER = (-W_BLOCK_X / 2); 
Y_CHAMFER_CORNER = (W_BLOCK_Y / 2); 

// --- Main Geometry Construction ---

difference() {
    
    // 1. Create the main block centered at origin
    main_block = cube([W_BLOCK_X, W_BLOCK_Y, H_BLOCK_Z], center=true);

    // 2. Cut holes using a loop
    for (i = 0; i < N_COLS; i++) {
        x_hole_center_i = X_CHAMFER_CORNER + O_X_LEFT + i * C_SPACING_X;
        
        for (j = 0; j < N_ROWS; j++) {
            // Determine Y direction. 
            // Row A is at the back edge (+Y). Rows go towards Front (-Y).
            y_hole_center_j = Y_CHAMFER_CORNER - O_Y_BACK + (N_ROWS - 1 - j) * C_SPACING_Y; 
            
            cylinder(h = H_BLOCK_Z, r = D_HOLE / 2, center=[x_hole_center_i, y_hole_center_j]);
        }
    }

    // 3. Cut Chamfer at A1 Corner (Left-Back vertical edge)
    // We create a "void" shape that represents the material to be removed by the chamfer.
    // The void is defined on the face X = -half_X, near Y = half_Y.
    
    // Define points for the cut profile at Z=0 (bottom of block). 
    // Since we are cutting a vertical edge, the shape extends from bottom to top? 
    // No, standard chamfers in 3D printing files often mean "cutting off the corner".
    // We will subtract an extruded polygon that matches the cut volume.
    
    // The cut removes material where X < -half_X + CHAMFER_LEG and Y > half_Y - CHAMFER_LEG? 
    // Actually, a 45 deg chamfer on a vertical edge usually means cutting into the face.
    // Let's define the plane equation: (X - (-half_X)) * cos(0) + (Y - half_Y) * sin(90)? No.
    
    // Simplest way to cut a corner with OpenSCAD primitives without complex planes:
    // Create a shape that is exactly the block but missing the chamfer wedge, then subtract? 
    // Or create just the wedge and subtract it from the main_block.
    
    // Let's define the wedge geometry relative to the global origin.
    // The corner is at (X_CHAMFER_CORNER, Y_CHAMFER_CORNER).
    // We want to remove a triangular prism along this edge.
    // Points of the cut face on X = -half_X: from y = half_Y down to y = half_Y - CHAMFER_LEG? 
    // Wait, if it's 45 degrees with leg 5mm, then dx=5, dy=5.
    
    // Let's construct the "Chamfer Wedge" solid explicitly using a polygon extrusion or simple union of primitives.
    // The wedge is bounded by:
    // X = -half_X (Left face) -> Cut starts here? No, we cut INTO the block from this edge.
    // So the material removed is between x=-half_X and some plane.
    
    // Let's build the "Chamfer Cutter" as a separate object to subtract.
    // It sits at X < -half_X + CHAMFER_LEG? No, it replaces the corner.
    
    // Correct Logic: 
    // The block exists from x=-W/2 to W/2.
    // We want to cut off the material near (-W/2, W/2).
    // The new face will be a plane connecting ( -W/2 + L, W/2 ) and ( -W/2, W/2 - L ).
    
    x_start = X_CHAMFER_CORNER; 
    y_end = Y_CHAMFER_CORNER; 
    
    // Define the points of the cut face on the bottom surface (Z=0) to extrude up.
    p1 = [x_start + CHAMFER_LEG, y_end];       // Point 1: On Left Face, moved down? No.
    // Let's visualize: Corner is Top-Left in a standard view if Y goes Up/Back and X goes Right/Front? 
    // If we assume standard Cartesian (X right, Y up/back):
    // Corner is (-W/2, W/2). This is Left and Back.
    // We cut the edge between x=-W/2 and y=W/2.
    // The plane cuts through:
    // Point A on X-face: [ -W/2 + CHAMFER_LEG , W/2 ] ? No, that's moving right along Y? 
    // Let's assume the leg is measured along both axes equally for 45 deg.
    
    p1 = [-half_X + CHAMFER_LEG, half_Y];       // Point on Left face (X), shifted in Y? No.
    // If we cut a corner at (-W/2, W/2):
    // The plane passes through: 
    // 1. On the line X=-W/2: y = W/2 - CHAMFER_LEG ? Or is it removing from both sides?
    // Usually "chamfer off the vertical edge" means creating a bevel on that specific corner.
    
    // Let's define the polygon for the cut at Z=0 (and extrude to H_BLOCK_Z).
    // The material removed is bounded by:
    // x >= -half_X + CHAMFER_LEG  AND y <= half_Y ? No, we are removing the corner (-W/2, W/2).
    
    // Let's try a different approach for robustness: 
    // Create a shape that fills the space of the chamfered void.
    // The void is defined by vertices on the bottom face (Z=0):
    v1 = [-half_X + CHAMFER_LEG, half_Y];       // On Left Face? No, X must be -half_X for left edge.
    
    // Let's restart the coordinate logic for the chamfer to ensure it works:
    // Corner is at (-W/2, W/2).
    // We want a 45 deg cut with leg L=5.
    // The plane equation in local corner coords (u = x - (-W/2), v = y - W/2) is u + v <= L? 
    // If we remove the region where u+v > L, then:
    // Region to keep: u >= 0 AND v >= 0 ? No.
    
    // Let's just define the polygon vertices for the cut face at Z=H_BLOCK_Z (top) and Z=-something?
    // Actually, we can use `difference` with a specific shape extruded from Z=0 to Z=20.
    // The shape is: A rectangle of size W x H minus the corner triangle.
    
    // Let's create the "Chamfer Void" explicitly using polygon_extrude or hull? 
    // No, let's use a simple difference with a custom extruded profile.
    
    // Profile points for the void at Z=0:
    p1 = [-half_X + CHAMFER_LEG, half_Y];       // On Left Face (X), Y is max minus leg? Or X plus leg?
    // If we cut from (-W/2, W/2):
    // Point 1 on Bottom Edge of the block: [ -half_X , half_Y ] -> This is the corner.
    // We want to remove material near this point.
    
    // Let's define the polygon that represents the "missing" chunk