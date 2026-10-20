// Sowing template for 90 mm Petri dish
// Corrected to match specifications exactly

// Overall disc dimensions
diameter_disc = 85;
thickness_disc = 2;

// Grid parameters
grid_rows = 7;
grid_cols = 7;
hole_diameter = 3;
spacing = 9;

// Notch dimensions
notch_width = 10;      // X direction
notch_depth = 4;       // Y direction, measured inward from rim

// Set resolution for smooth holes
$fn = 64;

// Center the grid on the disc
grid_origin_x = -((grid_cols - 1) * spacing) / 2;
grid_origin_y = -((grid_rows - 1) * spacing) / 2;

// Main disc body: centered on origin, lies on bed at z = 0
// Use cube centered at origin to ensure z = 0 is the bottom
module disc() {
    translate([0, 0, -thickness_disc / 2])
        cube([diameter_disc, diameter_disc, thickness_disc], center = true);
}

// Cut holes in a grid
module grid_holes() {
    for (i = [0 : grid_rows - 1]) {
        for (j = [0 : grid_cols - 1]) {
            x = grid_origin_x + j * spacing;
            y = grid_origin_y + i * spacing;
            // Extend slightly beyond the disc to ensure clean cut
            translate([x, y, -0.01])
                cylinder(h = thickness_disc + 0.02, r = hole_diameter / 2, center = true);
        }
    }
}

// Cut notch on +Y side of rim, centered on Y axis
module notch() {
    // Rim is at Y = diameter_disc / 2 = 42.5 mm
    // Notch depth is 4 mm inward from rim → Y goes from 42.5 - 4 = 38.5 to 42.5
    // Notch width is 10 mm in X direction, centered at X = 0 → X from -5 to +5
    // Cut from z = -0.01 to z = thickness_disc + 0.01 to ensure full removal
    translate([0, 0, -0.01])
        cube([notch_width, notch_depth, thickness_disc + 0.02], center = false);
}

// Assemble the template: ensure it sits flat on the bed at z = 0
difference() {
    disc();
    grid_holes();
    notch();
}