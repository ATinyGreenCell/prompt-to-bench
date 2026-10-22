// Sowing Template for 90 mm Petri Dish
// Dimensions measured with calipers

// Disc dimensions
disc_diameter = 85;
disc_radius = disc_diameter / 2;
disc_thickness = 2;

// Hole grid parameters
hole_diameter = 3;
hole_radius = hole_diameter / 2;
grid_spacing = 9;
grid_size = 7; // 7x7 grid

// Orientation notch parameters
notch_width = 10;
notch_depth = 4;

// Print quality
$fn = 64;

// Main disc body
translate([0, 0, disc_thickness/2])
    cylinder(r = disc_radius, h = disc_thickness, center = true);

// Through-holes: 7x7 grid centered on origin
for (row = [-(grid_size-1)/2 : (grid_size-1)/2]) {
    for (col = [-(grid_size-1)/2 : (grid_size-1)/2]) {
        translate([col * grid_spacing, row * grid_spacing, disc_thickness/2])
            cylinder(r = hole_radius, h = disc_thickness + 0.02, center = true);
    }
}

// Orientation notch on +Y side, centered on Y axis
// The notch is cut into the rim, 10 mm wide in X, 4 mm deep in Y
// It extends through the full thickness of the disc
translate([0, disc_radius - notch_depth/2, disc_thickness/2])
    cube([notch_width, notch_depth, disc_thickness + 0.02], center = true);