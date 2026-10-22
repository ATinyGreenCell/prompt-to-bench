// 96-Well PCR Tube Rack (ANSI/SLAS Footprint)
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block Dimensions
$block_length = 127.76; // X
$block_width  = 85.48;  // Y
$block_height = 20.0;   // Z

// Hole Dimensions
$hole_diameter = 6.2;
$hole_radius   = $hole_diameter / 2;

// Grid Configuration
$grid_rows    = 8; // Along Y
$grid_cols    = 12; // Along X
$spacing_x    = 9.0; // Centre-to-centre X
$spacing_y    = 9.0; // Centre-to-centre Y

// Grid Positioning (from left/back edge)
$offset_x_start = 14.38;
$offset_y_start = 11.24;

// Chamfer Dimensions
$chamfer_leg   = 5.0;
$chamfer_angle = 45;

// Quality Settings
$fn = 64; // Ensure smooth holes and chamfers

// --- Main Module ---
module pcr_rack() {
    // 1. Create the main block
    block = cube([
        $block_length,
        $block_width,
        $block_height
    ]);

    // 2. Create holes using a for loop
    // We subtract cylinders from the block
    holes = difference() {
        // The base block
        translate([0, 0, 0]) cube([
            $block_length,
            $block_width,
            $block_height
        ]);

        // Loop through rows (Y) and columns (X)
        for (row = [0 : $grid_rows - 1], col = [0 : $grid_cols - 1]) {
            // Calculate position of current hole center
            // X position: start offset + col * spacing
            // Y position: start offset + row * spacing
            pos_x = $offset_x_start + col * $spacing_x;
            pos_y = $offset_y_start + row * $spacing_y;

            // Create cylinder for the hole
            // Extend slightly past the top and bottom faces to ensure clean cut
            // Rule 5: extend 0.01-1 mm past faces
            h_ext = 0.5; 
            
            cylinder(
                h = $block_height + (h_ext * 2),
                r = $hole_radius,
                center = [pos_x, pos_y, $block_height / 2],
                $fn = $fn
            );
        }
    };

    // 3. Apply Chamfer
    // The prompt asks for a 45-degree chamfer with 5mm legs off the vertical edge at the A1 corner.
    // A1 is the first hole (top-left in standard notation, but here defined by offset).
    // Based on offsets (14.38 from left, 11.24 from back), A1 is at the "front-left" or "back-left" depending on view.
    // Assuming standard coordinate system: X is Left->Right, Y is Back->Front (or vice versa).
    // Let's assume the "back edge" is the negative Y direction relative to the start offset if we view from front.
    // Actually, simpler interpretation: The corner defined by the minimum X and minimum Y coordinates of the block.
    // We need to chamfer the vertical face at this corner.
    
    // To do this cleanly in OpenSCAD without complex boolean logic on edges, 
    // we can create a "mask" that is the block shape but with the corner chamfered, 
    // and then subtract the holes from that mask.
    
    // Let's rebuild the logic:
    // Start with a block.
    // Cut the chamfered corner.
    // Cut the holes.
    
    // Step 3a: Chamfer the corner
    // We can achieve this by intersecting the block with a chamfered plane or by using a difference with a chamfered block.
    // Easier approach: Create a block with the chamfer already applied using a large chamfered block shape?
    // No, standard OpenSCAD doesn't have a "chamfer block" primitive.
    // We can create a "cut" shape that removes the corner.
    
    // Let's define the chamfer cut.
    // The corner is at X = -$block_length/2, Y = -$block_width/2.
    // We want to remove a wedge defined by a plane passing through the top face and the bottom face?
    // No, a vertical edge chamfer usually means cutting the vertical face itself.
    // "Cut a 45-degree chamfer... off the vertical edge".
    // This implies the vertical face at that corner is beveled.
    
    // Strategy:
    // 1. Create the solid block with holes.
    // 2. Create a "chamfer cutter" which is a block of the same size but with the corner rounded/beveled, 
    //    then intersect? No, that rounds the whole corner.
    // 3. Better: Use `difference` to cut the corner off the main block.
    //    The cut shape should be the block MINUS the corner wedge.
    
    // Let's construct the final object by starting with the block, cutting holes, then cutting the chamfer.
    // Actually, the chamfer is on the *vertical edge*.
    // We can create a "chamfer mask" that is the block, but with the corner cut away.
    
    // Let's try a different approach:
    // Create the block.
    // Create the holes.
    // Create a "chamfer block" which is the block with the corner cut.
    // Intersect them.
    
    // How to make a block with a chamfered corner in OpenSCAD?
    // We can use `hull` of points or `linear_extrude` of a 2D polygon.
    // Let's use `linear_extrude` on a 2D polygon representing the top view of the chamfered block.
    
    // Top view of the block: Rectangle [-L/2, L/2] x [-W/2, W/2].
    // Chamfer at corner (-L/2, -W/2).
    // The cut is 5mm leg.
    // So the polygon vertices for the top face would be:
    // Start at (-L/2, -W/2 + leg) -> go to (-L/2 + leg, -W/2 + leg) -> go to (-L/2 + leg, -W/2) -> ... wait.
    // A 45 deg chamfer on a rectangle corner replaces the corner vertex with two vertices.
    // The vertices are:
    // 1. (-L/2, -W/2 + leg)
    // 2. (-L/2 + leg, -W/2 + leg)
    // 3. (-L/2 + leg, -W/2)
    // 4. (L/2, -W/2)
    // 5. (L/2, W/2)
    // 6. (-L/2, W/2)
    // 7. (-L/2, -W/2 + leg) -> Close loop? No, we need to close the loop properly.
    // Actually, the polygon should be:
    // (-L/2, -W/2 + leg) -> (-L/2 + leg, -W/2 + leg) -> (-L/2 + leg, -W/2) -> (L/2, -W/2) -> (L/2, W/2) -> (-L/2, W/2) -> (-L/2, -W/2 + leg).
    // Wait, the last point should connect to the first.
    // (-L/2, W/2) connects to (-L/2, -W/2 + leg).
    // Yes.
    
    // Let's define the polygon vertices.
    // Center of block is (0,0).
    // Left edge X = -$block_length/2.
    // Back edge Y = -$block_width/2.
    // Corner is (-$block_length/2, -$block_width/2).
    // Chamfer leg = 5.
    
    // Vertices:
    // 1. (-$block_length/2, -$block_width/2 + $chamfer_leg)
    // 2. (-$block_length/2 + $chamfer_leg, -$block_width/2 + $chamfer_leg)
    // 3. (-$block_length/2 + $chamfer_leg, -$block_width/2)
    // 4. ($block_length/2, -$block_width/2)
    // 5. ($block_length/2, $block