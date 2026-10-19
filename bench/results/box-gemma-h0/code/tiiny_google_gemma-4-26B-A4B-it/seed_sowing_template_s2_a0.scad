// --- Dimensions (mm) ---
disc_diameter = 85.0;      // Diameter of the main disc
disc_thickness = 2.0;      // Thickness of the disc
hole_diameter = 3.0;       // Diameter of the sowing holes
grid_size = 7;             // Number of holes in X and Y directions
grid_spacing = 9.0;        // Center-to-center spacing of holes
notch_width = 10.0;        // Width of the orientation notch (X axis)
notch_depth = 4.0;         // Depth of the notch from the rim (Y axis)

// --- Constants ---
$fn = 64;                  // Smoothness for curves
offset = 0.1;             // Small offset to prevent coplanar artifacts

// --- Main Model ---
difference() {
    // The main disc body
    cylinder(h = disc_thickness, d = disc_diameter, center = false);

    // 1. The Grid of Holes
    // Calculate the total span of the grid to center it
    // The grid is (size-1) * spacing. 
    // We center it by translating by half the total span.
    grid_span = (grid_size - 1) * grid_spacing;
    
    for (i = [0 : grid_size - 1]) {
        for (j = [0 : grid_size - 1]) {
            // Calculate X and Y positions relative to center
            pos_x = (i * grid_spacing) - (grid_span / 2);
            pos_y = (j * grid_spacing) - (grid_span / 2);
            
            translate([pos_x, pos_y, -offset])
                cylinder(h = disc_thickness + 2 * offset, d = hole_diameter);
        }
    }

    // 2. The Orientation Notch
    // Located on the +Y side, centered on Y axis.
    // Notch is 10mm wide (X) and 4mm deep (Y).
    // We define the notch as a box that cuts into the rim.
    // To ensure it cuts the rim properly, we make it slightly taller than the disc.
    translate([-notch_width / 2, (disc_diameter / 2) - notch_depth, -offset])
        cube([notch_width, notch_depth + offset, disc_thickness + 2 * offset]);
}

// Note: The model is built on the XY plane (Z=0) as requested.