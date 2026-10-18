// 96-Well PCR Tube Rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Block dimensions
L     = 127.76;
W     = 85.48;
H     = 20;

// Grid parameters
n_rows = 8;
n_cols = 12;
pitch_x = 9.0;
pitch_y = 9.0;

// Hole parameters
hole_d = 6.2;

// Orientation chamfer
chamfer_leg = 5;

// Start positions based on user specification
start_x = 14.38;
start_y = 11.24;

$fn = 64;

difference() {
    // Main block
    translate([0, 0, 0]) cube([L, W, H]);

    // Holes
    for (r = [0 : n_rows - 1]) {
        for (c = [0 : n_cols - 1]) {
            // Calculate position
            cx = start_x + c * pitch_x;
            cy = start_y + r * pitch_y;
            
            // Cut hole (extend slightly past Z=H to ensure clean cut)
            translate([cx, cy, 0]) cylinder(h = H + 0.1, d = hole_d);
        }
    }

    // Orientation chamfer at A1 corner (bottom-left in XY).
    // We cut a pyramid shape. To avoid manifold issues, we construct it as a 
    // linear_extrusion of a 2D triangle (the cross section of the chamfer)
    // and subtract it from the block.
    // The 2D shape is a right triangle with legs of length 'chamfer_leg'.
    // Vertices: (0,0), (chamfer_leg, 0), (0, chamfer_leg).
    // We extrude this downwards from Z=H to Z=H - chamfer_leg.
    
    chamfer_height = chamfer_leg;
    chamfer_z_start = H;
    chamfer_z_end = H - chamfer_height;
    
    // Define the 2D profile of the chamfer (triangle)
    // Points: [0,0], [leg,0], [0,leg]
    chamfer_profile = [
        [0, 0],
        [chamfer_leg, 0],
        [0, chamfer_leg]
    ];

    // Extrude the profile downwards
    translate([0, 0, chamfer_z_end]) 
        linear_extrude(height = chamfer_height, center = false) 
            polygon(points = chamfer_profile);
}