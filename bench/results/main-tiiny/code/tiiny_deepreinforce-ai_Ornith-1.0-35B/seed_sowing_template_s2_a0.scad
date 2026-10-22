// === Sowing Template for 90 mm Petri Dish ===
// Flat disc, 85 mm diameter, 2 mm thick, with 7x7 grid of 3 mm holes and a rim notch

// --- Disc dimensions ---
disc_diameter = 85;       // mm, overall disc diameter
disc_thickness = 2;       // mm, thickness of the disc

// --- Hole grid parameters ---
grid_rows = 7;            // number of rows in the grid
grid_cols = 7;            // number of columns in the grid
hole_diameter = 3;        // mm, diameter of each through-hole
hole_spacing = 9;         // mm, centre-to-centre spacing between holes

// --- Orientation notch ---
notch_width = 10;         // mm, width of the notch along X
notch_depth = 4;        // mm, depth of the notch cut into the rim (in Y)

// --- Derived values ---
disc_radius = disc_diameter / 2;
$fn = 64;

// --- Build the base disc ---
difference() {
    // Main disc body
    cylinder(d = disc_diameter, h = disc_thickness, center = false);

    // Cut out the 7x7 grid of holes
    for (row = 0; row < grid_rows; row++) {
        for (col = 0; col < grid_cols; col++) {
            // Calculate hole position: centred on the disc
            x_pos = (col - (grid_cols - 1) / 2) * hole_spacing;
            y_pos = (row - (grid_rows - 1) / 2) * hole_spacing;

            translate([x_pos, y_pos, 0]) {
                // Extend hole slightly past the disc faces to ensure clean cut
                cylinder(d = hole_diameter, h = disc_thickness + 0.01, center = false);
            }
        }
    }

    // Cut the rectangular orientation notch on the +Y side
    // Notch is centred on the Y axis, 10 mm wide (X), 4 mm deep (Y)
    translate([0, disc_radius - notch_depth / 2, 0]) {
        // Extend the notch cutter slightly beyond the disc edges to ensure clean cut
        cube([notch_width + 0.01, notch_depth + 0.01, disc_thickness + 0.01], center = true);
    }
}