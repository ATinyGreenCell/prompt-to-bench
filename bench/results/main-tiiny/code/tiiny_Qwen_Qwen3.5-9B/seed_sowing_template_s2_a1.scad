$fn = 128; // High resolution for smooth curves and accurate hole sizing

// --- Dimensions ---
// Disc dimensions
disc_outer_diameter = 85;
disc_thickness = 2;

// Grid dimensions
grid_rows = 7;
grid_cols = 7;
hole_diameter = 3;
hole_spacing = 9; // Centre-to-centre

// Notch dimensions (on the +Y side)
notch_width = 10; // X width
notch_depth = 4;  // Y depth measured in from the rim

// --- Derived Variables ---
// Calculate the radius of the disc
disc_radius = disc_outer_diameter / 2;

// Calculate the offset for the grid to center it
// The grid spans (grid_rows - 1) * hole_spacing in Y
// The grid spans (grid_cols - 1) * hole_spacing in X
grid_span_y = (grid_rows - 1) * hole_spacing;
grid_span_x = (grid_cols - 1) * hole_spacing;

// Grid offset from center to center the grid
// Center of the grid is at (0,0). The first hole is at (-offset, -offset).
// Offset = (Total Span / 2) - (Spacing / 2)
grid_offset_x = (grid_span_x / 2) - (hole_spacing / 2);
grid_offset_y = (grid_span_y / 2) - (hole_spacing / 2);

// Notch position calculation
// The notch is on the +Y side, centred on the Y axis.
// It starts at the rim (y = disc_radius) and goes inward by notch_depth.
notch_start_y = disc_radius - notch_depth;
notch_end_y = disc_radius;
notch_center_x = 0;
notch_center_y = (notch_start_y + notch_end_y) / 2;

// --- Main Part Construction ---

difference() {
    // 1. Create the main disc
    // Centered at origin, lying on XY plane, building up Z
    translate([0, 0, 0])
    cylinder(
        h = disc_thickness,
        r = disc_radius,
        $fn = 128
    );

    // 2. Cut the 7x7 grid of holes
    // Loop through rows and columns
    for (row = [0 : grid_rows - 1], col = [0 : grid_cols - 1]) {
        // Calculate position of this specific hole
        current_x = grid_offset_x + col * hole_spacing;
        current_y = grid_offset_y + row * hole_spacing;
        
        translate([current_x, current_y, 0])
        cylinder(
            h = disc_thickness + 1, // Extend slightly past the bottom to ensure clean cut
            r = hole_diameter / 2,
            $fn = 128
        );
    }

    // 3. Cut the rectangular orientation notch
    // Location: +Y side, centred on X axis
    // Dimensions: notch_width (X) x notch_depth (Y)
    // Depth of cut: full thickness of the disc
    
    translate([
        notch_center_x, 
        notch_center_y, 
        disc_thickness / 2
    ])
    cube([
        notch_width, 
        notch_depth, 
        disc_thickness + 0.1 // Extend slightly past the top/bottom to ensure clean cut
    ]);
}