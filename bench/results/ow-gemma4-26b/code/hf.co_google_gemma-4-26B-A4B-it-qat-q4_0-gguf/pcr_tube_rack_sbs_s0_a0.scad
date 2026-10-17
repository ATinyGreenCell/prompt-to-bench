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
chamfer_size = 5.0;    // Leg length of the 45-degree chamfer

// Resolution
$fn = 64;

// --- Implementation ---

// The part is built on the XY plane, centered on X and Y.
// Note: In OpenSCAD, Y+ is "up" on the screen, but for a block, 
// we treat the "back edge" as the minimum Y value.

module pcr_rack() {
    difference() {
        // Main Block
        cube([block_x, block_y, block_z], center = false);

        // 96 PCR Tube Holes
        // We iterate through columns (X) and rows (Y)
        // The first hole (A1) is at (offset_x, offset_y)
        // We subtract a small amount from Z to ensure clean through-holes
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([offset_x + (c * hole_spacing), 
                            offset_y + (r * hole_spacing), 
                            -0.01])
                cylinder(h = block_z + 0.02, d = hole_dia);
            }
        }

        // Orientation Chamfer at A1 corner
        // A1 is at (offset_x, offset_y) relative to the corner (0,0)
        // The user wants a chamfer on the "vertical edge at the A1 corner".
        // This implies the corner of the block closest to A1.
        // Since A1 is offset from the "left" and "back" edges, 
        // the corner is (0,0,0).
        
        // We create a wedge to cut the corner. 
        // To make a 45-degree chamfer with 5mm legs on the corner:
        translate([-0.01, -0.01, -0.01]) // Extend slightly to ensure clean cut
        rotate([0, 0, 0])
        hull() {
            // The three points defining the cut on the corner
            translate([chamfer_size, 0, 0]) cube([0.01, 0.01, chamfer_size]); // Edge 1
            translate([0, chamfer_size, 0]) cube([0.01, 0.01, chamfer_size]); // Edge 2
            // This is a bit complex for a simple hull, let's use a simpler approach:
            // A cylinder/cone cut at 45 degrees is standard for chamfers.
        }
        
        // Corrected Chamfer approach: 
        // A chamfer on a corner is a plane cutting the corner.
        // We'll use a large cube rotated to slice the corner.
        translate([-1, -1, -1])
        rotate([0, 45, 0]) // Tilt to 45 degrees
        // This is tricky with standard primitives. Let's use a polygon-based extrusion.
        // A chamfer at (0,0) with 5mm legs:
        // Points on the edges: (5,0), (0,5)
        // We'll use a difference with a shape that covers the corner.
        
        // Let's define the chamfer as a subtraction of a wedge
        // The wedge is a prism with a triangular cross-section
        // We'll place it at the corner (0,0,0)
        translate([-0.01, -0.01, -0.01])
        rotate([0, 45, 0]) // Rotate around X axis to create the 45 deg slope
        cube([chamfer_size * 2, chamfer_size * 2, block_z + 2]); 
        // Wait, the above is a bit messy. Let's use a more robust method:
        // A cylinder/cone is best for corner chamfers.
    }
}

// Final refined model
module final_rack() {
    difference() {
        // The main body
        cube([block_x, block_y, block_z]);

        // The holes
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([offset_x + (c * hole_spacing), 
                            offset_y + (r * hole_spacing), 
                            -0.01])
                cylinder(h = block_z + 0.02, d = hole_dia);
            }
        }

        // The Chamfer at the A1 corner (0,0,0)
        // We use a cylinder to cut the corner at 45 degrees
        // To get a 5mm leg chamfer: 
        // The distance from the corner to the cut line on the face is 5mm.
        // We'll use a cylinder with a radius that creates that 5mm leg.
        // For a 45 deg chamfer on a corner, it's actually a "corner chamfer" 
        // (cutting the vertical edge).
        
        // Let's use a simple subtraction of a shape that represents the corner cut.
        // A cylinder tilted 45 degrees.
        translate([0, 0, 0])
        rotate([0, 45, 0])
        cylinder(h = block_z + 2, r = chamfer_size * 1.414, $fn=3); // Triangle-ish
        
        // Actually, the most reliable way to do a corner chamfer in OpenSCAD:
        // Create a large cylinder/cone and subtract it.
        // But for a 5mm leg chamfer on the corner:
        translate([-0.01, -0.01, -0.01])
        rotate([0, 45, 0])
        cube([chamfer_size * 2, chamfer_size * 2, block_z + 2]);
        // The above is still not quite right for a corner.
        
        // Let's use a simple wedge:
        translate([-1, -1, -1])
        rotate([0, 45, 0])
        // This creates a wedge that cuts the corner.
        // To get 5mm legs:
        // The intersection of the wedge with the XY plane should be a triangle 
        // with vertices (0,0), (5,0), (0,5).
        // A cylinder with radius 5*sqrt(2)/2? No.
        
        // Let's use a polygon-based extrusion for the chamfer wedge.
        // The wedge is a prism. The cross section is a triangle.
        // We'll rotate it to sit on the corner.
        translate([0,0,0])
        rotate([0, 45, 0])
        linear_extrude(height = block_z + 2)
        polygon(points=[[0,0], [chamfer_size*1.414, 0], [0, chamfer_size*1.414]]);
        // This is still not quite right. Let's use the most direct method:
        // A cylinder with radius 5, but we only care about the corner.
    }
}

// --- Final Corrected Model ---
// Using a simple subtraction of a cylinder to create the corner chamfer
module actual_rack() {
    difference() {
        // Main block
        cube([block_x, block_y, block_z]);

        // Holes
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([offset_x + (c * hole_spacing), 
                            offset_y + (r *