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
grid_size = 7;

// Notch dimensions
notch_width = 10;
notch_depth = 4;

// Disc radius
disc_radius = disc_diameter / 2;

// Create the base disc (bottom at z=0)
module base_disc() {
    translate([0, 0, 0]) {
        cylinder(h = disc_thickness, r = disc_radius, center = false);
    }
}

// Create holes in a 7x7 grid
module hole_grid() {
    half_grid = (grid_size - 1) / 2;
    for (i = [0 : grid_size - 1]) {
        for (j = [0 : grid_size - 1]) {
            x = (i - half_grid) * grid_spacing;
            y = (j - half_grid) * grid_spacing;
            translate([x, y, -0.01]) {
                cylinder(h = disc_thickness + 0.02, r = hole_diameter / 2, center = false);
            }
        }
    }
}

// Create orientation notch (rectangular cutout on +Y side, centred on Y axis)
module notch() {
    y_start = disc_radius - notch_depth;
    translate([0, y_start, -0.01]) {
        cube([notch_width, notch_depth + 0.02, disc_thickness + 0.02], center = false);
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