// 96-Well PCR Tube Rack (0.2 mL) - ANSI/SLAS footprint.
// Dimensions: 127.76 x 85.48 x 20 mm.
// 96 holes (6.2 mm) in 8 rows x 12 columns.
// Chamfer at A1 corner (bottom-left-back) for orientation.

// Main block dimensions
L     = 127.76;
W     = 85.48;
H     = 20;

// Hole specifications
hole_d = 6.2;
n_cols = 12; // along X
n_rows = 8;  // along Y
pitch_x = 9.0;
pitch_y = 9.0;

// Grid origin offset (distance from left/back edge to first hole centre)
offset_x = 14.38;
offset_y = 11.24;

// Chamfer specifications (at A1 corner: bottom-left-back)
chamfer_leg = 5;

$fn = 64;

// Calculate total grid size to ensure symmetry
total_x = (n_cols - 1) * pitch_x;
total_y = (n_rows - 1) * pitch_y;

// Verify symmetry:
// L = 127.76, total_x = 99. Diff = 28.76. Half = 14.38. Matches offset_x.
// W = 85.48, total_y = 63. Diff = 22.48. Half = 11.24. Matches offset_y.

difference() {
    // 1. Create the main block
    translate([0, 0, 0])
        cube([L, W, H]);

    // 2. Create the 96 holes
    // Loop through columns (X) and rows (Y)
    for (c = [0 : n_cols - 1]) {
        for (r = [0 : n_rows - 1]) {
            // Calculate position of the hole centre
            pos_x = offset_x + c * pitch_x;
            pos_y = offset_y + r * pitch_y;
            pos_z = H / 2; // Centre of the block
            
            // Cut the hole
            // Extend slightly in Z to ensure full depth
            translate([pos_x, pos_y, -1])
                cylinder(h = H + 2, d = hole_d);
        }
    }

    // 3. Create the chamfer at the A1 corner (bottom-left-back)
    // A1 is at X=0, Y=0, Z=0.
    // We subtract a pyramid defined by the corner and the three points on the axes at distance 'chamfer_leg'.
    // Vertices:
    // P1: (chamfer_leg, 0, 0)
    // P2: (0, chamfer_leg, 0)
    // P3: (0, 0, chamfer_leg)
    // P4: (0, 0, 0) - The corner
    
    // Define vertices for the pyramid to subtract
    pts = [
        [chamfer_leg, 0, 0],
        [0, chamfer_leg, 0],
        [0, 0, chamfer_leg],
        [0, 0, 0]
    ];
    
    // Define faces for the pyramid.
    // We need the normals to point OUTWARDS from the pyramid volume so that difference() removes it.
    // Face 1: Base on X-Y plane (Z=0). Normal (0,0,-1). Vertices: P1, P2, P4.
    // Face 2: Base on Y-Z plane (X=0). Normal (-1,0,0). Vertices: P2, P3, P4.
    // Face 3: Base on X-Z plane (Y=0). Normal (0,-1,0). Vertices: P1, P3, P4.
    // Face 4: Slanted top. Normal points towards origin? No, away from origin.
    // Let's order vertices counter-clockwise looking from outside.
    // Face 4 (Slanted): P1, P2, P3.
    
    faces = [
        [0, 1, 3], // P1, P2, P4 (XY face)
        [1, 2, 3], // P2, P3, P4 (YZ face)
        [0, 2, 3], // P1, P3, P4 (XZ face)
        [0, 1, 2]  // P1, P2, P3 (Slanted face)
    ];
    
    // Subtract the pyramid
    translate([0, 0, 0])
        polyhedron(points = pts, faces = faces);
}