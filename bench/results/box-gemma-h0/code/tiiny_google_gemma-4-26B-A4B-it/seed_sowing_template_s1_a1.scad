// --- Dimensions (mm) ---
disc_diameter = 85.0;      // Diameter of the main disc
disc_thickness = 2.0;      // Thickness of the disc
hole_diameter = 3.0;       // Diameter of the sowing holes
grid_spacing = 9.0;        // Center-to-center distance between holes
grid_count = 7;            // Number of holes in X and Y directions

notch_width = 10.0;        // Width of the notch (X direction)
notch_depth = 4.0;         // Depth of the notch from the rim (Y direction)
notch_height = 2.1;        // Height of the notch (slightly taller than disc)

// --- Constants ---
$fn = 64;                  // Smoothness for circles/cylinders

// --- Implementation ---

// The part is modeled resting on the XY plane (Z=0)
module sowing_template() {
    difference() {
        // Main Disc Body
        cylinder(h = disc_thickness, d = disc_diameter, center = false);

        // 1. The Grid of Holes
        // Calculate the offset to center the grid on the disc
        // The grid spans (grid_count - 1) * grid_spacing
        grid_span = (grid_count - 1) * grid_spacing;
        offset = grid_span / 2;

        for (i = [0 : grid_count - 1]) {
            for (j = [0 : grid_count - 1]) {
                // Fixed: Removed the 'x=', 'y=', 'z=' labels which caused the 'undef' errors
                // OpenSCAD translate() expects a vector [x, y, z]
                translate(
                    [i * grid_spacing - offset, j * grid_spacing - offset, -0.5]
                )
                cylinder(h = disc_thickness + 1, d = hole_diameter);
            }
        }

        // 2. The Orientation Notch
        // Located on the +Y side, centered on X axis.
        // Notch is 10mm wide (X) and 4mm deep (Y) from the rim.
        
        // The rim is at Y = disc_diameter / 2. 
        // The notch goes 4mm deep into the disc, so the inner edge is at:
        // (disc_diameter / 2) - notch_depth
        
        notch_y_inner_edge = (disc_diameter / 2) - notch_depth;
        // To ensure a clean cut through the rim, we extend the notch slightly past the rim
        notch_y_outer_edge = (disc_diameter / 2) + 1.0; 
        
        translate([-(notch_width / 2) - 0.5, notch_y_inner_edge, -0.5])
        cube([notch_width + 1.0, notch_y_outer_edge - notch_y_inner_edge, disc_thickness + 1.0]);
    }
}

// Render the part
sowing_template();