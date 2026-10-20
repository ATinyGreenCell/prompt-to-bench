// Sowing template for 90 mm Petri dish
// Flat disc: 85 mm diameter, 2 mm thick
// 7x7 grid of 3 mm diameter holes, 9 mm spacing, centred
// Orientation notch: 10 mm wide (X), 4 mm deep (Y), centred on +Y axis

$fn = 64;

// Main disc dimensions
disc_diameter = 85;
disc_thickness = 2;

// Grid dimensions
hole_diameter = 3;
grid_spacing = 9;
grid_size = 7; // 7x7 grid

// Notch dimensions
notch_width = 10;
notch_depth = 4;

// Calculate grid radius (distance from centre to outermost holes)
grid_radius = (grid_size - 1) * grid_spacing / 2;

// Disc radius
disc_radius = disc_diameter / 2;

// Create the base disc
module base_disc() {
    cylinder(h = disc_thickness, r = disc_radius / 2, center = true);
}

// Create holes in a 7x7 grid
module hole_grid() {
    for (i = [0 : grid_size - 1]) {
        for (j = [0 : grid_size - 1]) {
            x = (i - (grid_size - 1) / 2) * grid_spacing;
            y = (j - (grid_size - 1) / 2) * grid_spacing;
            translate([x, y, -disc_thickness / 2 + 0.01]) {
                cylinder(h = disc_thickness + 0.02, r = hole_diameter / 2, center = true);
            }
        }
    }
}

// Create orientation notch (rectangular cutout on +Y side, centred on Y axis)
module notch() {
    // Notch is 10 mm wide in X, 4 mm deep in Y (from rim inward)
    // Disc radius is 42.5 mm, so notch starts at y = disc_radius - notch_depth = 38.5 mm
    // Notch is centred on Y axis, so x ranges from -notch_width/2 to +notch_width/2
    x_half = notch_width / 2;
    y_start = disc_radius - notch_depth;
    
    translate([0, y_start, -disc_thickness / 2 + 0.01]) {
        cube([notch_width, notch_depth + 0.02, disc_thickness + 0.02], center = true);
    }
}

// Combine everything
module sowing_template() {
    difference() {
        base_disc();
        hole_grid();
        notch();
    }
}

// Build the final part
sowing_template();