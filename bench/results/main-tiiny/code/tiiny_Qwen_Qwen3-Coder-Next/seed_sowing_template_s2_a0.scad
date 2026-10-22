// Sowing template for 90 mm Petri dish
// Dimensions based on user specifications

$fn = 64;

// Main disc parameters
disc_diameter = 85;
disc_thickness = 2;

// Grid parameters
grid_size = 7;
hole_diameter = 3;
spacing = 9;

// Orientation notch parameters
notch_width = 10;
notch_depth = 4;

// Calculate grid center offset (to center the 7x7 grid on the disc)
// Grid spans (7-1)*spacing = 6*9 = 54 mm, so center is at (0,0)
// But we need to position the grid so it's centered on the disc (which has radius 42.5 mm)
// Grid half-width = 54/2 = 27 mm, disc radius = 42.5 mm, so grid fits comfortably

// Build the base disc
module base_disc() {
    cylinder(h = disc_thickness, d = disc_diameter);
}

// Build the hole grid
module hole_grid() {
    // Calculate start position for the grid to be centered
    // Grid spans 6 intervals of 9 mm = 54 mm, so from -27 to +27 in both X and Y
    for (i = [-3:3]) {
        for (j = [-3:3]) {
            translate([i * spacing, j * spacing, -0.01]) {
                cylinder(h = disc_thickness + 0.02, d = hole_diameter);
            }
        }
    }
}

// Build the orientation notch
module orientation_notch() {
    // Notch is 10 mm wide (X direction), 4 mm deep (Y direction, measured in from rim)
    // Rim is at radius = 42.5 mm, so inner edge of notch is at y = 42.5 - 4 = 38.5
    // Notch is centered on +Y axis, so X ranges from -5 to +5
    translate([0, 42.5 - notch_depth/2, -0.01]) {
        cube([notch_width, notch_depth + 0.02, disc_thickness + 0.02]);
    }
}

// Combine all parts
module sowing_template() {
    difference() {
        base_disc();
        hole_grid();
        orientation_notch();
    }
}

sowing_template();