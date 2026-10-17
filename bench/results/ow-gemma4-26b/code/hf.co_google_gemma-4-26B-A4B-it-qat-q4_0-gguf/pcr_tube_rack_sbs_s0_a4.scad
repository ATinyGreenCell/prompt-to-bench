// --- Dimensions (mm) ---
block_x = 127.76;      // Total length (X)
block_y = 85.48;       // Total width (Y)
block_z = 20.00;       // Total height (Z)

hole_dia = 6.2;        // Diameter of PCR tube holes
hole_spacing = 9.0;    // Center-to-center spacing

rows = 8;              // Number of rows (Y direction)
cols = 12;             // Number of columns (X direction)

// Offset from edges to the first hole center (A1)
offset_x = 14.38;      // Distance from left edge to first hole center
offset_y = 11.24;      // Distance from back edge to first hole center

// Chamfer settings
chamfer_leg = 5.0;     // Leg length of the 45-degree chamfer on the corner

// Resolution
$fn = 64;

// --- Implementation ---

module pcr_rack() {
    difference() {
        // 1. The Main Block
        // The part must rest on the XY plane at z = 0.
        // Using center = true and translating by Z/2 ensures the base is at Z=0.
        translate([0, 0, block_z/2])
        cube([block_x, block_y, block_z], center = true);

        // 2. The 96 PCR Tube Holes
        // Holes are vertical through-holes.
        // We calculate the center of A1 relative to the block's center.
        // Corner (0,0) in a centered block is at (-block_x/2, -block_y/2).
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([
                    -block_x/2 + offset_x + (c * hole_spacing), 
                    -block_y/2 + offset_y + (r * hole_spacing), 
                    0 // Through-hole from Z=0 to Z=block_z
                ])
                cylinder(h = block_z + 0.1, d = hole_dia);
            }
        }

        // 3. The Orientation Chamfer
        // "Cut a 45-degree chamfer with 5 mm legs off the vertical edge at the A1 corner"
        // The A1 corner is the (0,0) corner of the block.
        // In a centered block, this corner is at (-block_x/2, -block_y/2).
        // A 45-degree chamfer on a vertical edge means we remove the corner 
        // such that the cut plane passes through (5,0) and (0,5) relative to the corner.
        
        // We define a wedge that covers the corner and subtract it.
        // The wedge is a prism with a triangular cross-section in the XY plane.
        // The triangle vertices in the block's local coordinate system:
        // Corner: (-block_x/2, -block_y/2)
        // X-edge: (-block_x/2 + chamfer_leg, -block_y/2)
        // Y-edge: (-block_x/2, -block_y/2 + chamfer_leg)
        
        // To ensure the cut is clean, we use a polygon and extrude it.
        // We translate the polygon to the corner and extrude it through the full height.
        translate([-block_x/2, -block_y/2, -0.1])
        linear_extrude(height = block_z + 0.2)
        polygon(points=[
            [0, 0], 
            [chamfer_leg, 0], 
            [0, chamfer_leg]
        ]);
    }
}

// Execute the module
pcr_rack();