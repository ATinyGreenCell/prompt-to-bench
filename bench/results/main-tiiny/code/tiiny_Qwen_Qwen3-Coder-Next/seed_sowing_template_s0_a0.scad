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
grid_radius = grid_width / 2;           // Distance from centre to outermost holes

// Safety margin: ensure holes stay within disc
// Max radius for holes: disc_radius - hole_radius
disc_radius = diameter / 2;
hole_radius = hole_diameter / 2;

// Verify grid fits: grid_radius + hole_radius < disc_radius
// For given values: (6 * 9)/2 = 27 mm + 1.5 mm = 28.5 mm < 42.5 mm -> OK

// Build the base disc
module base_disc() {
    cylinder(h = thickness, d = diameter, center = true);
}

// Build the hole grid
module hole_grid() {
    // Calculate offset to centre the grid
    offset = (grid_size - 1) * spacing / 2;
    
    for (i = [-grid_size/2 : 1 : grid_size/2]) {
        for (j = [-grid_size/2 : 1 : grid_size/2]) {
            translate([i * spacing, j * spacing, -0.01]) {
                cylinder(h = thickness + 0.02, d = hole_diameter, center = true);
            }
        }
    }
}

// Build the orientation notch
module notch() {
    // Notch is centered on +Y axis, so X spans from -notch_width/2 to +notch_width/2
    // Depth is measured from rim inward, so we cut from Y = disc_radius - notch_depth to disc_radius
    x_half = notch_width / 2;
    y_start = disc_radius - notch_depth;
    y_end = disc_radius + 0.01; // Extend past the disc edge
    
    translate([0, y_start + (notch_depth/2), -0.01]) {
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