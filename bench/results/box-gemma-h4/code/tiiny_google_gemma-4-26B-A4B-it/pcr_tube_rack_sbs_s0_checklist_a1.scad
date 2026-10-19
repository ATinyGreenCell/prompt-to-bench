// 96-well PCR tube rack (0.2 mL)
// Corrected to respect specific A1 offsets and proper chamfer geometry.

// --- Dimensions ---
L = 127.76;      // Length (X)
W = 85.48;       // Width (Y)
H = 20.0;        // Height (Z)

hole_d = 6.2;    // Diameter of PCR tube holes
rows = 8;        // Number of rows (Y)
cols = 12;       // Number of columns (X)
spacing = 9.0;   // Center-to-center spacing

// Offset of the first hole (A1) from the edges
offset_x = 14.38; // Distance from left edge to A1 center
offset_y = 11.24; // Distance from back edge to A1 center

// Chamfer dimensions
chamfer_leg = 5.0;

$fn = 64;

module rack_body() {
    difference() {
        // Main block
        translate([-L/2, -W/2, 0])
            cube([L, W, H]);

        // 96 Vertical holes
        // A1 is at (-L/2 + offset_x, -W/2 + offset_y)
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                hx = (-L/2) + offset_x + (i * spacing);
                hy = (-W/2) + offset_y + (j * spacing);
                
                translate([hx, hy, -0.01])
                    cylinder(h = H + 0.02, d = hole_d);
            }
        }

        // Orientation Chamfer at A1 corner
        // The user wants a 45-degree chamfer with 5mm legs on the vertical edge.
        // This is a triangular prism cut off the corner.
        // We use a polygon in the XY plane and extrude it to cut the corner.
        
        // The corner is at (-L/2, -W/2). 
        // A 45-degree chamfer with 5mm legs creates a triangle with vertices:
        // (-L/2, -W/2 + chamfer_leg), (-L/2 + chamfer_leg, -W/2), and the corner itself.
        // However, to "cut" it, we define the shape to be removed.
        
        translate([-L/2 - 1, -W/2 - 1, -0.1])
        rotate([0, 0, 0])
        linear_extrude(height = H + 2)
        polygon(points = [
            [-1, -1], // Extend slightly to ensure clean cut
            [chamfer_leg, -1],
            [-1, chamfer_leg]
        ]);
        
        // Note: The polygon above is a simplified way to cut the corner.
        // Let's use a more robust method for a corner chamfer:
        // A triangle with vertices: (-L/2, -W/2 + chamfer_leg), (-L/2 + chamfer_leg, -W/2), (-L/2, -W/2)
        // But we want to cut the corner, so we subtract the area outside the chamfer.
        // Actually, the simplest way to cut a corner chamfer is to subtract a wedge.
        
        // Corrected Chamfer: Subtract a wedge from the corner
        translate([-L/2 - 1, -W/2 - 1, -0.1])
        rotate([0, 0, 0])
        difference() {
            // Large cube to ensure it cuts through
            cube([chamfer_leg * 2, chamfer_leg * 2, H + 2]);
            // The actual chamfer shape (the part we want to KEEP) is a triangle.
            // To cut the corner, we subtract the part that is NOT the triangle.
            // Or more simply, just define the wedge to subtract.
            
            // Let's define the wedge to subtract:
            // It's a triangle with vertices: (0,0), (chamfer_leg, 0), (0, chamfer_leg)
            // Wait, that's the part we want to keep. 
            // To cut the corner, we subtract a shape that covers the corner.
            // The shape to subtract is a triangle with vertices:
            // (0,0), (chamfer_leg, 0), (0, chamfer_leg) is NOT correct for a corner cut.
            // A corner cut (chamfer) removes the corner.
            // The vertices of the removed part are: (0,0), (chamfer_leg, 0), (0, chamfer_leg)
            // No, that's a triangle at the corner. Yes.
        }
    }
}

// Re-writing the chamfer logic for clarity and correctness
module final_rack() {
    difference() {
        // Main block
        translate([-L/2, -W/2, 0])
            cube([L, W, H]);

        // 96 Vertical holes
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                hx = (-L/2) + offset_x + (i * spacing);
                hy = (-W/2) + offset_y + (j * spacing);
                translate([hx, hy, -0.01])
                    cylinder(h = H + 0.02, d = hole_d);
            }
        }

        // Orientation Chamfer: 45-degree cut at the corner (-L/2, -W/2)
        // We subtract a shape that covers the corner area.
        // The chamfer line connects (-L/2, -W/2 + chamfer_leg) and (-L/2 + chamfer_leg, -W/2).
        // The shape to subtract is a triangle with these 3 points.
        translate([-L/2, -W/2, -0.1])
        rotate([0, 0, 0])
        linear_extrude(height = H + 2)
        polygon(points = [
            [0, 0],
            [chamfer_leg, 0],
            [0, chamfer_leg]
        ]);
    }
}

final_rack();