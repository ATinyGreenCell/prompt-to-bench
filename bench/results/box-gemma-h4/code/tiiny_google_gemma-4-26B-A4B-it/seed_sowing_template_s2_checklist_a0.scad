// Sowing template for a 90mm Petri dish
// A flat disc with a grid of holes and an orientation notch.

disc_diameter = 85.0;    // Diameter of the template disc
disc_thickness = 2.0;   // Thickness of the template
grid_size = 7;          // Number of holes in X and Y directions
hole_diameter = 3.0;    // Diameter of the through-holes
hole_spacing = 9.0;     // Center-to-center distance between holes
notch_width = 10.0;     // Width of the orientation notch (X axis)
notch_depth = 4.0;      // Depth of the orientation notch (Y axis)

$fn = 100;              // High resolution for smooth curves

// Calculate the radius of the disc
radius = disc_diameter / 2;

// Calculate the offset for the notch to ensure it cuts into the rim
// The notch is 4mm deep from the rim, so it extends from radius-4 to radius+1
notch_inner_y = radius - notch_depth;

difference() {
    // Main Disc Body
    cylinder(h = disc_thickness, d = disc_diameter);

    // Grid of through-holes
    // Using (i - (grid_size - 1) / 2) * hole_spacing to center the grid on origin
    for (i = [0 : grid_size - 1]) {
        for (j = [0 : grid_size - 1]) {
            translate([
                (i - (grid_size - 1) / 2) * hole_spacing, 
                (j - (grid_size - 1) / 2) * hole_spacing, 
                -0.5 // Extend slightly below to ensure clean cut
            ]) {
                cylinder(h = disc_thickness + 1, d = hole_diameter);
            }
        }
    }

    // Orientation Notch on the +Y side
    // We use a cube to cut the notch. 
    // To ensure it cuts through the rim, we make it wider than the notch_width 
    // and taller than the disc thickness.
    translate([-notch_width / 2, notch_inner_y, -1]) {
        cube([notch_width, notch_depth + 1, disc_thickness + 2]);
    }
}