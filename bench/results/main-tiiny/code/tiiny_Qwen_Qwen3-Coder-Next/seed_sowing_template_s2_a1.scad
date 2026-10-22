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

// Build the base disc
module base_disc() {
    cylinder(h = disc_thickness, d = disc_diameter);
}

// Build the hole grid
module hole_grid() {
    // Grid spans 6 intervals of 9 mm = 54 mm, centered at origin
    // So holes are at positions: -27, -18, -9, 0, 9, 18, 27 mm
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
    // Notch is centered on +Y axis, 10 mm wide in X, 4 mm deep from rim
    // Rim is at radius = 42.5 mm, so notch goes from Y = 42.5 - 4 = 38.5 to Y = 42.5
    // X ranges from -5 to +5
    translate([0, 42.5 - notch_depth, -0.01]) {
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