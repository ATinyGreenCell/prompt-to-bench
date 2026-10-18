// 96-well PCR tube rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Overall block dimensions
L     = 127.76;
W     = 85.48;
H     = 20;

// Grid parameters
n_rows = 8;   // along Y
n_cols = 12;  // along X
pitch_x = 9.0;
pitch_y = 9.0;

// Hole parameters
hole_d = 6.2;

// Position of first hole (A1) relative to block edges
x_offset = 14.38;
y_offset = 11.24;

// Chamfer parameters
chamfer_leg = 5;

$fn = 64;

difference() {
    union() {
        // Main block
        cube([L, W, H]);
        
        // Chamfer at the A1 corner (bottom-left-front).
        // We subtract a wedge defined by the triangle (0,0), (5,0), (0,5) extruded to height H.
        // This creates a 45 degree cut on the corner.
        polygon = [[0, 0], [chamfer_leg, 0], [0, chamfer_leg]];
        wedge = linear_extrude(height = H) polygon;
        translate([0, 0, 0]) wedge;
    }
    
    // Cut the holes
    for (i = [0 : n_cols - 1]) {
        for (j = [0 : n_rows - 1]) {
            // Calculate position
            cx = x_offset + i * pitch_x;
            cy = y_offset + j * pitch_y;
            
            // Cut the hole (extend slightly past Z=H to ensure clean cut)
            translate([cx, cy, 0]) cylinder(h = H + 0.1, d = hole_d);
        }
    }
}