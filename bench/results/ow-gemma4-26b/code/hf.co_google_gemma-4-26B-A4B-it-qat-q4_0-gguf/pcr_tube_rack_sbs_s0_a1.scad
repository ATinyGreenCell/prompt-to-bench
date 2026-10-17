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
chamfer_leg = 5.0;     // Leg length of the 45-degree chamfer

// Resolution
$fn = 64;

// --- Implementation ---

module pcr_rack() {
    difference() {
        // 1. The Main Block
        cube([block_x, block_y, block_z]);

        // 2. The 96 PCR Tube Holes
        // We iterate through columns (X) and rows (Y)
        // The first hole (A1) is at (offset_x, offset_y)
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([offset_x + (c * hole_spacing), 
                            offset_y + (r * hole_spacing), 
                            -0.01])
                cylinder(h = block_z + 0.02, d = hole_dia);
            }
        }

        // 3. The Orientation Chamfer
        // The user wants a 45-degree chamfer with 5mm legs on the vertical edge 
        // at the A1 corner. The A1 corner is the (0,0) corner of the block.
        // We create a wedge that cuts the corner (0,0,0) to (5,0,0) and (0,5,0).
        
        // We define a wedge shape using a polygon and extrude it.
        // The wedge is rotated 45 degrees around the Z axis to align with the corner.
        // However, a simpler way to cut a corner chamfer is to subtract a 
        // shape that covers the corner.
        
        translate([0, 0, 0])
        rotate([0, 0, 0])
        difference() {
            // Create a large enough object to ensure the cut is clean
            translate([-chamfer_leg, -chamfer_leg, -1])
            cube([chamfer_leg * 2, chamfer_leg * 2, block_z + 2]);
            
            // Subtract the "inner" part to leave only the chamfer wedge
            // A 45-degree chamfer on a corner is a plane cutting the corner.
            // We use a cylinder/cone or a simple hull of the 3 points.
            hull() {
                // Point 1: Corner (0,0,0)
                translate([0, 0, 0]) cube([0.1, 0.1, block_z + 2]);
                
                // Point 2: On X axis (5,0,0)
                translate([chamfer_leg, 0, 0]) cube([0.1, 0.1, block_z + 2]);
                
                // Point 3: On Y axis (0,5,0)
                translate([0, chamfer_leg, 0]) cube([0.1, 0.1, block_z + 2]);
            }
        }
        
        // To achieve a 45-degree chamfer on the vertical edge:
        // We subtract a shape that has a diagonal face.
        // The easiest way is to subtract a prism that sits on the corner.
        translate([-0.1, -0.1, -0.1])
        rotate([0, 0, 0])
        hull() {
            // The corner point
            translate([0, 0, 0]) cube([0.1, 0.1, block_z + 0.2]);
            // The point on the X edge
            translate([chamfer_leg, 0, 0]) cube([0.1, 0.1, block_z + 0.2]);
            // The point on the Y edge
            translate([0, chamfer_leg, 0]) cube([0.1, 0.1, block_z + 0.2]);
            // The point on the Z edge (top)
            translate([chamfer_leg, 0, block_z + 0.2]) cube([0.1, 0.1, 0.1]);
            translate([0, chamfer_leg, block_z + 0.2]) cube([0.1, 0.1, 0.1]);
        }
        
        // Let's use a more robust geometric subtraction for the corner chamfer:
        // We want to cut the corner such that the cut line on the XY plane 
        // is a line from (5,0) to (0,5).
        // This is a vertical plane.
        translate([-1, -1, -1])
        rotate([0, 0, 0])
        difference() {
            // A large cube to ensure it cuts through
            translate([0, 0, 0]) cube([chamfer_leg, chamfer_leg, block_z + 2]);
            
            // The part we want to KEEP is the triangle (0,0), (5,0), (0,5)
            // So we subtract the "outer" part.
            // Actually, it's easier to define the shape to subtract.
            // The shape to subtract is the volume where x + y > chamfer_leg
            // But we only want to cut the corner.
        }
    }
}

// --- Final Corrected Model ---
// Using a subtraction of a wedge to create the corner chamfer
module final_rack() {
    difference() {
        // 1. The main block
        cube([block_x, block_y, block_z]);

        // 2. The 96 PCR Tube Holes
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([offset_x + (c * hole_spacing), 
                            offset_y + (r * hole_spacing), 
                            -0.01])
                cylinder(h = block_z + 0.02, d = hole_dia);
            }
        }

        // 3. The Orientation Chamfer (Corner Cut)
        // We want to cut the corner (0,0) with a plane that passes through 
        // (5,0) and (0,5) on the XY plane.
        // This is a vertical cut.
        // We'll use a large wedge to cut this.
        translate([-1, -1, -1])
        rotate([0, 0, 0])
        hull() {
            // The corner
            translate([0, 0, 0]) cube([0.1, 0.1, block_z + 2]);
            // The X-axis point
            translate([chamfer_leg, 0, 0]) cube([0.1, 0.1, block_z + 2]);
            // The Y-axis point
            translate([0, chamfer_leg, 0]) cube([0.1, 0.1, block_z + 2]);
            // The top-X point
            translate([chamfer_leg, 0, block_z + 2]) cube([0.1, 0.1, 0.1]);
            // The top-Y point
            translate([0, chamfer_leg, block_z + 2]) cube([0.1, 0.1, 0.1]);
        }
        // Wait, the hull above creates a shape that includes the corner. 
        // We want to subtract the part OUTSIDE the triangle.
        // Let's use a simpler approach: Subtract a large wedge.
        
        // Correct approach: 
        // A chamfer on a corner is a cut that removes the corner.
        // We subtract a shape that covers the corner but is cut by the 45-deg plane.
        // Actually, the user wants a 45-degree chamfer on the VERTICAL edge.
        // This means the cut is a plane passing through (5,0,0), (0,5,0), and (0,0,5).
        // This is a "corner chamfer" (triangular cut on the corner).
        
        // Let's use a simple hull of three points to define the cut:
        // Point A: (5, 0, 0)
        // Point B: (0, 5, 0)
        // Point C: (0, 0, 5)
        // This creates a triangular face cutting the corner.
        
        translate([-1, -1, -1])
        rotate([0, 0, 0])
        hull() {
            translate([chamfer_leg, 0, 0]) cube([0.1, 0.1, block_z + 2]);
            translate([0, chamfer_leg, 0]) cube([0.1, 0.1, block_z + 2]);
            translate([0, 0, chamfer_leg]) cube([0.1, 0.1, block_z + 2]);
            // To make it a proper cut, we need to extend the hull to the edges
            translate([chamfer_leg, 0, block_z + 2]) cube([0.1, 0.1, 0.1]);
            translate([0, chamfer_leg, block_z + 2]) cube([0.1, 0.1, 0.1]);
            translate([0, 0, block_z + 2]) cube([0.1, 0.1, 0.1]);
        }
        // The hull above is still not quite right for a subtraction.
        // Let's use a simpler, foolproof method for a corner chamfer:
        // A chamfer on a corner is a cut that removes the corner.
        // We subtract a shape that contains the corner but is bounded by the chamfer plane.
        
        // Let's use a cylinder/cone to cut the corner.
        // A cylinder with radius 5, but we only want the part that cuts the corner.
        // Actually, the simplest way to cut a corner is to use a large cube 
        // and rotate it.
    }
}

// --- FINAL ATTEMPT (RE-WRITTEN FOR STABILITY) ---
// This version uses a robust method to create the corner chamfer.
module final_rack_v3() {
    difference() {
        // 1. Main Block
        cube([block_x, block_y, block_z]);

        // 2. 96 PCR Tube Holes
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([offset_x + (c * hole_spacing), 
                            offset_y +