// --- Dimensions ---
// Overall extrusion length along X axis
length_x = 84; 

// Wall thickness of the bucket (reference)
wall_thickness = 12; 

// Vertical height of the legs
leg_height = 50; 

// Thickness of the top bridge
bridge_thickness = 4; 

// Width of the legs (Y-axis dimension)
leg_width = 4; 

// Gap between legs (16.5 - 4 = 12.5mm)
gap_width = 12.5; 

// Ledge thickness (Z-axis dimension)
ledge_thickness = 6; 

// Ledge depth (Y-axis dimension)
ledge_depth = 30; 

// PCR tube hole diameter
hole_diameter = 6.4; 

// PCR tube hole spacing (X-axis)
hole_spacing_x = 9; 

// Number of tubes
num_tubes = 8; 

// Number of tubes Y-position (offset from origin)
hole_y_pos = -15; 

// Smoothness for cylinders
fn_val = 64;

// --- Implementation ---

// The error in the previous version was caused by trying to use 
// linear_extrude on a 3D object (the profile_shape module).
// linear_extrude only works on 2D shapes.
// I will define the profile as a 2D polygon instead.

module profile_2d() {
    // We define the profile in the YZ plane
    // The X dimension is handled by linear_extrude
    union() {
        // Inner Leg: y=0 to 4, z=0 to 50
        polygon(points=[[0,0], [4,0], [4,50], [0,50]]);
        
        // Outer Leg: y=16.5 to 20.5, z=0 to 50
        polygon(points=[[16.5,0], [20.5,0], [20.5,50], [16.5,50]]);
        
        // Top Bridge: z=46 to 50, y=0 to 20.5
        polygon(points=[[0,46], [20.5,46], [20.5,50], [0,50]]);
        
        // Ledge: z=0 to 6, y=-30 to 0
        polygon(points=[[-30,0], [0,0], [0,6], [-30,6]]);
    }
}

// Final Assembly
difference() {
    // 1. Create the main body by extruding the 2D profile along X
    // Centered on X=0 means X goes from -42 to 42
    translate([-length_x/2, 0, 0])
        linear_extrude(height = length_x)
            profile_2d();

    // 2. Subtract the tube holes
    // Holes are 6.4mm diameter, vertical (Z-axis)
    // They are centered on X, at y = -15
    for (i = [0 : num_tubes - 1]) {
        // Calculate X offset to center the 8 holes
        // Total span = (7 * 9) = 63. 
        // Center of span is at (63/2) = 31.5.
        // We want the group centered on X=0.
        x_offset = (i * hole_spacing_x) - ((num_tubes - 1) * hole_spacing_x / 2);
        
        // We translate the cylinder to the hole position.
        // We extend the cylinder in Z to ensure it cuts through the ledge completely.
        translate([x_offset, hole_y_pos, -1]) 
            cylinder(h = ledge_thickness + 2, d = hole_diameter, $fn = fn_val);
    }
}