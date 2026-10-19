// Sowing template for a 90mm Petri dish
// A flat disc with a 7x7 grid of holes and an orientation notch.

// --- Dimensions ---
disc_diameter = 85.0;    // Diameter of the disc
disc_thickness = 2.0;    // Thickness of the disc
grid_size = 7;           // Number of holes in X and Y directions
hole_diameter = 3.0;      // Diameter of the through-holes
hole_spacing = 9.0;      // Center-to-center distance between holes
notch_width = 10.0;      // Width of the orientation notch (X axis)
notch_depth = 4.0;       // Depth of the notch from the rim (Y axis)

$fn = 128;               // High resolution for smooth circles

// --- Calculations ---
radius = disc_diameter / 2;
// Calculate the offset for the grid so it is centered on the origin
grid_offset = (grid_size - 1) * hole_spacing / 2;

// --- Geometry ---

difference() {
    // Main Disc Body
    cylinder(h = disc_thickness, d = disc_diameter);

    // 7x7 Grid of through-holes
    for (i = [0 : grid_size - 1]) {
        for (j = [0 : grid_size - 1]) {
            // Calculate position for each hole
            pos_x = (i - (grid_size - 1) / 2) * hole_spacing;
            pos_y = (j - (grid_size - 1) / 2) * hole_spacing;
            
            translate([pos_x, pos_y, -0.5]) // Extend slightly below to ensure clean cut
                cylinder(h = disc_thickness + 1, d = hole_diameter);
        }
    }

    // Orientation Notch
    // The notch is cut into the rim on the +Y side.
    // We use a rectangle to cut the notch. 
    // To ensure it cuts through the rim properly, we position it at the edge.
    translate([-notch_width / 2, radius - notch_depth, -0.5])
        cube([notch_width, notch_depth + 1, disc_thickness + 1]);
}