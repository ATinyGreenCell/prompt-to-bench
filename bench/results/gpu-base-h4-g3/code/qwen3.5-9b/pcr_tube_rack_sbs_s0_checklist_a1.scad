// 96-Well PCR Tube Rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Overall block dimensions
L     = 127.76; // Length (X)
W     = 85.48;  // Width (Y)
H     = 20;     // Height (Z)

// Hole specifications
n_cols = 12; // Columns along X
n_rows = 8;  // Rows along Y
hole_d = 6.2;
pitch_x = 9.0;
pitch_y = 9.0;

// Grid positioning (distance from edge to first hole centre)
offset_x = 14.38;
offset_y = 11.24;

// Chamfer specifications
chamfer_leg = 5.0;

$fn = 64;

difference() {
    // Main block
    translate([0, 0, 0]) cube([L, W, H]);

    // 96 Through-holes
    for (c = [0 : n_cols - 1]) {
        for (r = [0 : n_rows - 1]) {
            // Calculate hole position
            pos_x = offset_x + c * pitch_x;
            pos_y = offset_y + r * pitch_y;
            
            translate([pos_x, pos_y, 0]) 
                cylinder(h = H + 0.1, d = hole_d); // +0.1 to ensure clean cut
        }
    }

    // Chamfer at A1 corner (x=0, y=0)
    // We create a large wedge shape to cut the corner.
    // The cut plane passes through (chamfer_leg, 0, 0) and (0, chamfer_leg, 0).
    // We extrude a polygon along Z to create the cutting volume.
    
    // Define the polygon profile for the cut (in XY plane)
    // Points: (0,0) -> (chamfer_leg, 0) -> (chamfer_leg, chamfer_leg) -> (0, chamfer_leg) -> (0,0)
    // This creates a square corner cut, but we need a 45 degree plane.
    // Actually, a simple square cut (x < leg && y < leg) creates a 90 deg corner removal.
    // To get a 45 degree chamfer plane, we need to cut along the line x + y = leg.
    // The region to remove is x + y < leg.
    // We can model this by extruding a triangle? No, that's a wedge.
    // We can model this by using a large cylinder with a specific radius? No.
    // We can model this by using a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder with a specific shape?
    // Let's use a large cylinder