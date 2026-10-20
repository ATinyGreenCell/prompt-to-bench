// Dimensions for the 96-well PCR tube rack
block_x = 127.76;      // Total length of the block (X)
block_y = 85.48;       // Total width of the block (Y)
block_z = 20.0;        // Total height of the block (Z)
hole_dia = 6.2;        // Diameter of the 0.2 mL PCR tube holes
rows = 8;              // Number of rows (along Y)
cols = 12;             // Number of columns (along X)
spacing = 9.0;         // Center-to-center spacing between holes
offset_x = 14.38;      // X distance from the left edge to the center of A1
offset_y = 11.24;      // Y distance from the back edge to the center of A1
chamfer_leg = 5.0;     // Leg length of the 45-degree orientation chamfer

// Resolution for curved surfaces
$fn = 64;

// The rack is built by taking a solid block and subtracting the holes and the chamfer
difference() {
    // The main rectangular block
    cube([block_x, block_y, block_z]);

    // 96 vertical through-holes for the PCR tubes
    // The grid is centered on the block based on the provided offsets
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            // Calculate the center of the current hole
            // A1 is at (-block_x/2 + offset_x, -block_y/2 + offset_y)
            translate((-block_x / 2 + offset_x) + i * spacing, 
                       (-block_y / 2 + offset_y) + j * spacing, 
                       -1) {
                cylinder(d = hole_dia, h = block_z + 2);
            }
        }
    }

    // Orientation mark: 45-degree chamfer at the A1 corner
    // We subtract a triangular prism from the corner of the block
    // The prism is translated to the corner and extends through the whole height
    translate([-block_x / 2 - 1, -block_y / 2 - 1, -1]) {
        linear_extrude(block_z + 2) {
            // The polygon defines a triangle that cuts the corner
            // Vertices: (0, chamfer_leg), (chamfer_leg, 0), and (0, 0)
            polygon([
                [0, chamfer_leg], 
                [chamfer_leg, 0], 
                [0, 0]
            ]);
        }
    }
}