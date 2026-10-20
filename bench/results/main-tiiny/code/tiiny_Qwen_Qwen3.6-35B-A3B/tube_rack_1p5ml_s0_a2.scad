// Dimensions for 1.5 mL microcentrifuge tube rack
// Block size
BLOCK_X = 106;
BLOCK_Y = 72;
BLOCK_Z = 30;

// Hole grid parameters
GRID_ROWS = 4;      // Along Y
GRID_COLS = 6;      // Along X
SPACING_X = 16;     // Centre-to-centre along X
SPACING_Y = 16;     // Centre-to-centre along Y
HOLE_DIAM = 11.2;   // Hole diameter
HOLE_DEPTH = 25;    // Depth of hole from top
FLOOR_THICK = 5;    // Solid floor thickness (BLOCK_Z - HOLE_DEPTH = 30 - 25 = 5)

// Chamfer parameters to make holes print without supports
// Chamfer depth (vertical) and angle. 
// A 1mm deep 45-degree chamfer removes the flat bottom surface.
CHAMFER_DEPTH = 1.0;
CHAMFER_ANGLE = 45; // Degrees

// Calculate grid offset to centre the grid on the block
// The block is placed at origin [0,0,0] with size [BLOCK_X, BLOCK_Y, BLOCK_Z].
// Block centre is at (BLOCK_X/2, BLOCK_Y/2).
BLOCK_CX = BLOCK_X / 2;
BLOCK_CY = BLOCK_Y / 2;

// Grid dimensions
GRID_W = (GRID_COLS - 1) * SPACING_X;
GRID_D = (GRID_ROWS - 1) * SPACING_Y;

// Hole radius
HOLE_R = HOLE_DIAM / 2;

// Clearance for difference operation
CLEARANCE = 0.01;

// Main block
difference() {
    // Base block
    cube([BLOCK_X, BLOCK_Y, BLOCK_Z], center = false);
    
    // Holes
    for (i = [0 : GRID_COLS - 1]) {
        for (j = [0 : GRID_ROWS - 1]) {
            // Calculate hole position relative to block origin (0,0)
            // X: Start from BLOCK_CX - GRID_W/2, step by SPACING_X
            hx = BLOCK_CX - GRID_W / 2 + i * SPACING_X;
            // Y: Start from BLOCK_CY - GRID_D/2, step by SPACING_Y
            hy = BLOCK_CY - GRID_D / 2 + j * SPACING_Y;
            
            // 1. Cut the main vertical hole
            // Hole is open at top (z=0), depth 25mm.
            // Cylinder extends slightly past the bottom to ensure clean cut
            translate([hx, hy, 0]) {
                $fn = 64;
                cylinder(h = HOLE_DEPTH + CLEARANCE, d = HOLE_DIAM, center = false);
            }
            
            // 2. Cut the chamfer at the bottom of the hole
            // The chamfer is a cone (or truncated cone) at the bottom of the hole.
            // It starts at z = HOLE_DEPTH - CHAMFER_DEPTH
            // It extends down to z = HOLE_DEPTH (or slightly past)
            // The diameter at the top of the chamfer (z=HOLE_DEPTH-CHAMFER_DEPTH) is the hole diameter.
            // The diameter at the bottom of the chamfer (z=HOLE_DEPTH) is smaller.
            // For 45 degrees, the radius reduction equals the depth.
            
            chamfer_top_z = HOLE_DEPTH - CHAMFER_DEPTH;
            chamfer_bottom_z = HOLE_DEPTH + CLEARANCE; // Extend slightly to cut cleanly
            
            // Diameter at top of chamfer = HOLE_DIAM
            // Diameter at bottom of chamfer = HOLE_DIAM - 2 * CHAMFER_DEPTH (for 45 deg)
            d_top = HOLE_DIAM;
            d_bottom = HOLE_DIAM - 2 * CHAMFER_DEPTH;
            
            // Ensure d_bottom is not negative or too small
            if (d_bottom > 0) {
                translate([hx, hy, chamfer_top_z]) {
                    $fn = 64;
                    // Cylinder from chamfer_top_z to chamfer_bottom_z
                    // Note: cylinder() in OpenSCAD is centered on its axis, but we use center=false
                    // and position it correctly.
                    // Height of this segment:
                    h_seg = chamfer_bottom_z - chamfer_top_z;
                    
                    // We use a cylinder with different top/bottom radii? 
                    // OpenSCAD cylinder() only supports uniform radius.
                    // To make a chamfer, we can use a cone (cylinder with r1 != r2 is not built-in directly 
                    // in older versions, but in modern OpenSCAD, cylinder(r1, r2, h) works).
                    // Let's use the 2-argument cylinder if available, otherwise use a cone approximation.
                    // Modern OpenSCAD supports cylinder(r1, r2, h).
                    cylinder(d_bottom, d_top, h_seg, center = false);
                }
            }
        }
    }
}