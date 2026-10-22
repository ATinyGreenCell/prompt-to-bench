// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed (z=0), walls rise up. Flipped after print.

// Plate dimensions
plate_x = 130;
plate_y = 90;
plate_z = 4;

// Hole parameters
hole_diameter = 30.5;
hole_radius = hole_diameter / 2;
hole_spacing_x = 40;
hole_spacing_y = 40;
num_rows = 2; // along Y
num_cols = 3; // along X

// Wall parameters
wall_length_x = 130;
wall_thickness_y = 4;
wall_height = 70;

// Ensure round holes
$fn = 64;

// Calculate hole positions (centred on plate)
// X positions: centred, spacing 40mm
x_positions = [
    -hole_spacing_x,
    0,
    hole_spacing_x
];

// Y positions: centred, spacing 40mm
y_positions = [
    -hole_spacing_y / 2,
    hole_spacing_y / 2
];

// Build the rack
difference() {
    // Main plate
    union() {
        // Flat plate
        translate([0, 0, 0])
            cube([plate_x, plate_y, plate_z], center = false);
        
        // Two walls along long edges (X-direction)
        // Front wall (positive Y)
        translate([0, plate_y / 2 - wall_thickness_y, 0])
            cube([wall_length_x, wall_thickness_y, wall_height], center = false);
        
        // Back wall (negative Y)
        translate([0, -plate_y / 2 + wall_thickness_y, 0])
            cube([wall_length_x, wall_thickness_y, wall_height], center = false);
    }
    
    // Cut through-holes for tubes
    for (x = x_positions) {
        for (y = y_positions) {
            translate([x, y, -0.01])
                cylinder(r = hole_radius, h = plate_z + 0.02, center = false);
        }
    }
}