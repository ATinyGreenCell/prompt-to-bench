// 96-Well PCR Tube Rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Block dimensions
L     = 127.76;
W     = 85.48;
H     = 20;

// Grid parameters
n_rows = 8;
n_cols = 12;
pitch_x = 9.0;
pitch_y = 9.0;

// Hole parameters
hole_d = 6.2;
hole_r = hole_d / 2;

// Orientation chamfer
chamfer_leg = 5;

// Calculate grid start positions to center the grid on the block
// Total grid width = n_cols * pitch_x
// Total grid height = n_rows * pitch_y
// Offset from edge = (Block Size - Grid Size) / 2
offset_x = (L - n_cols * pitch_x) / 2;
offset_y = (W - n_rows * pitch_y) / 2;

// Verify first hole position (A1) matches spec:
// x = offset_x + 0 * pitch_x = offset_x
// y = offset_y + 0 * pitch_y = offset_y
// Spec says 14.38 and 11.24. Let's check:
// (127.76 - 12*9)/2 = (127.76 - 108)/2 = 19.76/2 = 9.88. 
// Wait, the prompt says "centre of the first hole (A1) is 14.38 mm from the left edge".
// My calculation based on centering the grid gives 9.88.
// The prompt explicitly states the position. I must follow the explicit position given in the text
// rather than deriving it from "centred on the block" if they conflict, OR assume the "centred"
// description implies the grid is centered relative to the *holes* but the block has a specific offset.
// However, usually "grid is centred on the block" means the bounding box of holes is centered.
// Let's re-read carefully: "The centre of the first hole (A1) is 14.38 mm from the left edge and 11.24 mm from the back edge, so the grid is centred on the block."
// This implies the user's measurement defines the centering.
// Let's calculate the implied total grid size from the start position and pitch.
// If A1 is at 14.38, and there are 12 holes with 9mm pitch:
// Last hole (H12) x = 14.38 + 11 * 9 = 14.38 + 99 = 113.38.
// Center of grid X = (14.38 + 113.38) / 2 = 63.88.
// Block center X = 127.76 / 2 = 63.88. Matches!
// If A1 is at 11.24, and there are 8 holes with 9mm pitch:
// Last hole (A8) y = 11.24 + 7 * 9 = 11.24 + 63 = 74.24.
// Center of grid Y = (11.24 + 74.24) / 2 = 42.74.
// Block center Y = 85.48 / 2 = 42.74. Matches!
// So the explicit coordinates are correct and consistent with "grid centred on the block".
// I will use the explicit offsets calculated from the A1 position.

start_x = 14.38;
start_y = 11.24;

$fn = 64;

difference() {
    // Main block
    translate([0, 0, 0]) cube([L, W, H]);

    // Holes
    for (r = [0 : n_rows - 1]) {
        for (c = [0 : n_cols - 1]) {
            // Calculate position
            cx = start_x + c * pitch_x;
            cy = start_y + r * pitch_y;
            
            // Cut hole (extend slightly past Z=H to ensure clean cut)
            translate([cx, cy, 0]) cylinder(h = H + 0.1, d = hole_d);
        }
    }

    // Orientation chamfer at A1 corner (bottom-left in XY, front face is Z=H)
    // The corner is at (start_x, start_y).
    // We need to cut a 45 deg chamfer with leg 5mm.
    // This removes material from the block corner.
    // The chamfer plane passes through (start_x + leg, start_y, H) and (start_x, start_y + leg, H)
    // and goes down to (start_x, start_y, H - leg).
    // Actually, a standard chamfer on a corner removes a pyramid.
    // Vertices of the removed pyramid:
    // Top face: (start_x, start_y, H), (start_x + leg, start_y, H), (start_x, start_y + leg, H)
    // Bottom point: (start_x, start_y, H - leg)
    // Wait, the chamfer is on the vertical edge? "Cut a 45-degree chamfer ... off the vertical edge".
    // Usually this means the corner of the block.
    // Let's define the cutting shape as a pyramid with apex at (start_x, start_y, H-leg)
    // and base on the top face Z=H defined by the square [start_x, start_x+leg] x [start_y, start_y+leg].
    // But we only want the chamfered face, not a full pyramid if it interferes with holes.
    // Given the hole at A1 is at (14.38, 11.24) with radius 3.1mm.
    // The chamfer leg is 5mm.
    // The chamfer will cut into the area around the hole.
    // The corner of the block is at (0,0). The hole center is at (14.38, 11.24).
    // The chamfer starts at the corner (0,0) and goes 5mm in.
    // The hole is at 14.38, so the chamfer (0 to 5) does not touch the hole center.
    // The chamfer plane equation: x + y = leg (relative to corner).
    // At z=H, the cut is the line x+y=5.
    // At z=0, the cut is the point (0,0) if it's a full pyramid, or a line if it's a bevel.
    // "45-degree chamfer ... off the vertical edge" usually implies a bevel on the edge, 
    // but "corner" implies a chamfer on the corner.
    // Let's assume a corner chamfer: remove the pyramid defined by the corner.
    // Apex at (start_x, start_y, H - chamfer_leg).
    // Base vertices on top face: (start_x, start_y, H), (start_x + chamfer_leg, start_y, H), (start_x, start_y + chamfer_leg, H).
    // Wait, the corner of the block is at (0,0). The hole is at (start_x, start_y).
    // The chamfer is at the A1 corner. A1 is the first hole.
    // Is the chamfer at the physical corner of the block (0,0) or at the hole center?
    // "off the vertical edge at the A1 corner". This likely means the corner of the block corresponding to the A1 position.
    // Since A1 is the first hole, and the grid is centered, the "A1 corner" of the rack is the physical corner (0,0).
    // So we chamfer the corner (0,0).
    
    // Define the pyramid to subtract.
    // Apex (bottom point of chamfer): [0, 0, H - chamfer_leg]
    // Base (top face cut): Square [0, chamfer_leg] x [0, chamfer_leg] at Z = H.
    // But we only want the chamfer face, not the full pyramid if it creates a weird shape?
    // No, subtracting the pyramid creates the chamfer.
    // Vertices of the pyramid to subtract:
    // 1. Apex: [0, 0, H - chamfer_leg]
    // 2. Top-Left: [0, 0, H]
    // 3. Top-Front: [chamfer_leg, 0, H]
    // 4. Top-Right: [0, chamfer_leg, H]
    // Wait, a pyramid has 4 faces. We want to remove the material "inside" the corner.