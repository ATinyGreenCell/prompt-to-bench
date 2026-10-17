// --- Dimensions (mm) ---
block_x = 127.76;      // Total length (X)
block_y = 85.48;       // Total width (Y)
block_z = 20.00;       // Total height (Z)

hole_dia = 6.2;        // Diameter of PCR tube holes
hole_spacing = 9.0;    // Center-to-center spacing

rows = 8;              // Number of rows (Y direction)
cols = 12;             // Number of columns (X direction)

// Offset from edges to the first hole center (A1)
// A1 is at (14.38, 11.24) relative to the (0,0) corner.
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
        // Centered on XY as per instructions (rests on XY plane at z=0)
        // To center a block of [127.76, 85.48] on origin:
        translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

        // 2. The 96 PCR Tube Holes
        // The first hole (A1) is at (offset_x, offset_y) relative to the corner.
        // Since the block is translated by -block_x/2, the corner (0,0) 
        // is actually at (-block_x/2, -block_y/2).
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([
                    -block_x/2 + offset_x + (c * hole_spacing), 
                    -block_y/2 + offset_y + (r * hole_spacing), 
                    -0.01
                ])
                cylinder(h = block_z + 0.02, d = hole_dia);
            }
        }

        // 3. The Orientation Chamfer
        // "Cut a 45-degree chamfer with 5 mm legs off the vertical edge at the A1 corner"
        // The A1 corner is the corner (0,0) of the block.
        // A 45-degree chamfer on a vertical edge means we cut the corner 
        // such that the cut plane passes through (5,0,z) and (0,5,z).
        // This is a vertical cut (a wedge shape).
        
        // We create a large wedge and subtract it.
        // The wedge is a prism with a triangular cross-section in the XY plane.
        // The triangle vertices in XY: (0,0), (5,0), (0,5).
        // To subtract the corner, we actually subtract the part that contains the corner.
        // We'll use a hull of a large cube and the chamfer plane.
        
        // A simpler way: Define the chamfer as a subtraction of a shape 
        // that covers the corner area.
        translate([-0.1, -0.1, -0.1])
        rotate([0, 0, 0])
        hull() {
            // The corner point (extended slightly to ensure clean cut)
            translate([0, 0, 0]) cube([0.1, 0.1, block_z + 2]);
            
            // The point on the X edge (5mm from corner)
            translate([chamfer_leg, 0, 0]) cube([0.1, 0.1, block_z + 2]);
            
            // The point on the Y edge (5mm from corner)
            translate([0, chamfer_leg, 0]) cube([0.1, 0.1, block_z + 2]);
            
            // The top points to ensure the hull covers the full height
            translate([chamfer_leg, 0, block_z + 1]) cube([0.1, 0.1, 0.1]);
            translate([0, chamfer_leg, block_z + 1]) cube([0.1, 0.1, 0.1]);
            translate([0, 0, block_z + 1]) cube([0.1, 0.1, 0.1]);
        }
        
        // Wait, the hull above creates a shape that INCLUDES the corner.
        // Subtracting it would remove the corner. 
        // However, a "chamfer" usually means the edge is beveled.
        // If we subtract the hull of (0,0), (5,0), and (0,5), we are left 
        // with a flat face between (5,0) and (0,5).
        // This is exactly what a corner chamfer is.
        
        // To make the cut clean, we use a prism that is larger than the corner.
        // We define a triangle in the XY plane: (0,0), (5,0), (0,5)
        // and extrude it in Z.
        // But we need to subtract the corner, so we subtract the "outside" 
        // of the chamfer.
        // Actually, the easiest way to do a corner chamfer is to subtract 
        // a shape that represents the corner itself.
        
        // Let's use a simpler method: 
        // Create a large cube that covers the corner, and subtract a 
        // shape that leaves only the chamfer.
        // Actually, the most robust way:
        // Define a polygon for the corner cut and extrude it.
        // The polygon is the triangle (0,0), (5,0), (0,5).
        // We want to REMOVE the corner.
        // So we subtract a shape that is the corner.
        
        // Let's use a wedge:
        translate([-0.1, -0.1, -0.1])
        rotate([0, 0, 0])
        linear_extrude(height = block_z + 2)
        polygon(points=[[0,0], [chamfer_leg, 0], [0, chamfer_leg]]);
    }
}

// Execute the module
pcr_rack();