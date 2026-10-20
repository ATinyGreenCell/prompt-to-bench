// --- Dimensions (mm) ---
block_x = 127.76;          // Total length (X)
block_y = 85.48;           // Total width (Y)
block_z = 20.00;           // Total height (Z)

hole_dia = 6.2;            // Diameter of PCR tube holes
hole_spacing = 9.0;        // Center-to-center spacing

rows = 8;                  // Number of rows (Y direction)
cols = 12;                 // Number of columns (X direction)

// Offset from edges to the center of the first hole (A1)
offset_x = 14.38;          // Distance from left edge to first hole center
offset_y = 11.24;          // Distance from back edge to first hole center

// Chamfer parameters
chamfer_leg = 5.0;         // Length of the chamfer legs

// --- Rendering Settings ---
$fn = 64;

// --- Main Construction ---

// The user requested the part to rest on the XY plane at z = 0 and build upward (+Z).
// The previous version used center=true for the cube, which placed the base at z = -10.
// We must translate the geometry so the bottom face is at z = 0.

module pcr_rack() {
    difference() {
        // The main block
        // We place the block so it starts at z=0 and goes to z=block_z.
        // To keep it centered on X and Y, we use the center=true and then translate.
        // However, it is simpler to define the cube from 0 to block_z.
        translate([-block_x/2, -block_y/2, 0])
            cube([block_x, block_y, block_z]);

        // The 96 holes
        // Holes are vertical through-holes.
        // We iterate through columns (X) and rows (Y).
        // The center of the first hole (A1) is at:
        // X = -block_x/2 + offset_x
        // Y = block_y/2 - offset_y (since offset is from the "back edge" at Y_max)
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                translate([
                    (-block_x / 2) + offset_x + (i * hole_spacing), 
                    (block_y / 2) - offset_y - (j * hole_spacing), 
                    -1 // Extend below Z=0 to ensure clean cut
                ])
                cylinder(h = block_z + 2, d = hole_dia);
            }
        }

        // The 45-degree chamfer at the A1 corner
        // The A1 corner is the "left-back" corner.
        // In our coordinate system: X = -block_x/2, Y = block_y/2.
        // We create a wedge to cut this vertical edge.
        // The wedge is a prism with a triangular base.
        // We translate it to the corner and rotate it to align with the edge.
        
        // We use a large enough wedge to ensure the cut is clean.
        // The wedge is placed at the corner and extends along the Z axis.
        translate([-block_x/2 - 1, block_y/2 - chamfer_leg, -1])
        rotate([0, 0, 0])
        linear_extrude(height = block_z + 2)
        polygon(points=[[0, 0], [chamfer_leg, 0], [0, chamfer_leg]]);
    }
}

// Execute the model
// The part is built from Z=0 upwards.
pcr_rack();