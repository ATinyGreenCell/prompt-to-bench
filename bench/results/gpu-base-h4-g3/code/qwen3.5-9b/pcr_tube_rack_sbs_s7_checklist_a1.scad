// 96-Well PCR Tube Rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Overall block dimensions
L_total = 127.76;
W_total = 85.48;
H_total = 20;

// Hole specifications
hole_d = 6.2;
hole_r = hole_d / 2;
n_cols = 12; // Along X
n_rows = 8;  // Along Y
pitch_x = 9.0;
pitch_y = 9.0;

// Position of first hole (A1) relative to block edge
offset_x = 14.38;
offset_y = 11.24;

// Chamfer specifications
chamfer_leg = 5;

$fn = 128;

// Calculate grid start positions based on A1 center location
// A1 is at index (0, 0) in the loop.
// The grid is defined by centers.
// A1 Center X = offset_x
// A1 Center Y = offset_y
// Grid starts at A1 and goes +X and +Y.

// Chamfer logic:
// Cut a 45 deg chamfer with 5mm legs off the vertical edge at the A1 corner.
// The A1 corner of the block is at X=0, Y=0.
// The chamfer removes material near this edge.
// The cut surface is a plane passing through (chamfer_leg, 0, 0), (0, chamfer_leg, 0) and (0, 0, chamfer_leg).
// This creates a bevel at the bottom-left-back corner.

difference() {
    // Main block
    translate([0, 0, 0])
        cube([L_total, W_total, H_total]);

    // Holes
    // Loop j for columns (X), i for rows (Y)
    // A1 is at j=0, i=0.
    for (j = [0 : n_cols - 1]) {
        for (i = [0 : n_rows - 1]) {
            // Calculate center of hole
            cx = offset_x + j * pitch_x;
            cy = offset_y + i * pitch_y;
            
            // Cut hole
            translate([cx, cy, 0])
                cylinder(h = H_total + 1, d = hole_d); // +1 to ensure clean cut
        }
    }

    // Chamfer at A1 corner (X=0, Y=0)
    // We create a plane that cuts the corner.
    // The plane equation is x + y + z = chamfer_leg.
    // We can approximate this by cutting with a large cylinder or a custom polyhedron.
    // Using a polyhedron for the chamfer cut.
    // Vertices of the chamfered corner block to subtract:
    // (0,0,0) to (chamfer_leg, chamfer_leg, chamfer_leg) but cut by the plane.
    // The vertices of the material to remove are:
    // (0,0,0), (chamfer_leg, 0, 0), (0, chamfer_leg, 0), (0, 0, chamfer_leg)
    // And the points on the plane: (chamfer_leg, 0, 0), (0, chamfer_leg, 0), (0, 0, chamfer_leg)
    // Wait, the cut removes the corner. The remaining part of the cube is outside the plane x+y+z <= chamfer_leg.
    // So we subtract the tetrahedron defined by (0,0,0), (chamfer_leg,0,0), (0,chamfer_leg,0), (0,0,chamfer_leg).
    
    polyhedron(
        points = [
            [0, 0, 0],
            [chamfer_leg, 0, 0],
            [0, chamfer_leg, 0],
            [0, 0, chamfer_leg]
        ],
        faces = [
            [0, 1, 2], // Base on XY plane (part of original cube face, but we are cutting the corner)
            [0, 1, 3], // Side on XZ plane
            [0, 2, 3], // Side on YZ plane
            [1, 2, 3]  // The chamfer plane
        ]
    );
}