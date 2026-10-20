// Sowing template for 90 mm Petri dish
disc_diameter = 85;        // Overall disc diameter
disc_thickness = 2;        // Disc thickness
hole_diameter = 3;         // Through-hole diameter
hole_spacing = 9;          // Centre-to-centre spacing of holes
grid_half_span = 3;        // Half-span of the 7x7 grid in hole units
notch_width = 10;          // Width of the orientation notch
notch_depth = 4;           // Depth of the orientation notch

$fn = 64;

disc_radius = disc_diameter / 2;

difference() {
    // Base disc
    cylinder(h = disc_thickness, r = disc_radius, center = false);
    
    // Grid holes
    for (i = [-grid_half_span:1:grid_half_span]) {
        for (j = [-grid_half_span:1:grid_half_span]) {
            translate([i * hole_spacing, j * hole_spacing, 0]) {
                cylinder(h = disc_thickness + 0.1, r = hole_diameter / 2);
            }
        }
    }
    
    // Orientation notch
    translate([0, disc_radius - notch_depth / 2, 0]) {
        cube([notch_width, notch_depth, disc_thickness + 0.1], center = true);
    }
}