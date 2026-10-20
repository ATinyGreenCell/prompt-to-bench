// Sowing template for 90 mm Petri dish
// Dimensions based on user specifications

$fn = 64; // High resolution for round features

// Main disc parameters
diameter = 85;        // Overall disc diameter (mm)
thickness = 2;        // Disc thickness (mm)

// Grid parameters
grid_size = 7;        // 7x7 grid
hole_diameter = 3;    // Hole diameter (mm)
spacing = 9;          // Centre-to-centre spacing (mm)

// Orientation notch parameters
notch_width = 10;     // Notch width in X (mm)
notch_depth = 4;      // Notch depth from rim (mm)

// Calculate grid bounds
grid_width = (grid_size - 1) * spacing; // Total grid width in mm

// Build the base disc (centered at origin, thickness from -thickness/2 to +thickness/2)
module base_disc() {
    cylinder(h = thickness, d = diameter, center = true);
}

// Build the hole grid (49 holes for 7x7)
module hole_grid() {
    // Use integer indices from -3 to +3 for 7 positions
    for (i = [-3 : 1 : 3]) {
        for (j = [-3 : 1 : 3]) {
            translate([i * spacing, j * spacing, -0.01]) {
                cylinder(h = thickness + 0.02, d = hole_diameter, center = true);
            }
        }
    }
}

// Build the orientation notch
module notch() {
    // Notch is centered on +Y axis, so X spans from -notch_width/2 to +notch_width/2
    // Depth is measured from rim inward, so we cut from Y = (diameter/2 - notch_depth) to (diameter/2)
    x_half = notch_width / 2;
    y_start = diameter/2 - notch_depth;
    y_end = diameter/2 + 0.01; // Extend past the disc edge
    
    translate([0, y_start + notch_depth/2, -0.01]) {
        cube([notch_width + 0.02, notch_depth + 0.02, thickness + 0.02], center = true);
    }
}

// Combine all parts
module sowing_template() {
    difference() {
        base_disc();
        hole_grid();
        notch();
    }
}

// Render the final part
sowing_template();