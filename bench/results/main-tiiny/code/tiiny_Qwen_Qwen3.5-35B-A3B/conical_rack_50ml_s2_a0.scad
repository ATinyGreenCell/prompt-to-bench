// Dimensions for the 50 mL conical tube rack
// Base plate dimensions
plate_length_x = 130;      // X dimension of the base plate
plate_width_y = 90;        // Y dimension of the base plate
plate_thickness_z = 4;    // Z thickness of the base plate

// Tube hole dimensions
tube_diameter = 30.5;     // Diameter of the tube holes
hole_radius = tube_diameter / 2;

// Tube hole grid layout
hole_rows = 2;            // Number of rows along Y axis
hole_cols = 3;            // Number of columns along X axis
hole_spacing_x = 40;      // Center-to-center spacing in X
hole_spacing_y = 40;      // Center-to-center spacing in Y

// Wall dimensions
wall_height_z = 70;       // Height of the side walls
wall_thickness_y = 4;    // Thickness of the side walls (along Y)
wall_length_x = 130;      // Length of the side walls (along X)

// Wall offset from plate edge
wall_offset_y = 0;        // Walls are flush with the long edge (Y=0 and Y=plate_width_y)

// Print orientation: Plate on XY plane (z=0), walls rise +Z

// Base plate
base_plate = cube([plate_length_x, plate_width_y, plate_thickness_z], center = true);

// Calculate hole positions
// Center of plate is at (0,0)
// X positions: - (hole_cols-1)/2 * spacing to + (hole_cols-1)/2 * spacing
// Y positions: - (hole_rows-1)/2 * spacing to + (hole_rows-1)/2 * spacing
x_positions = [for (i = [0 : hole_cols-1]) (i - (hole_cols-1)/2) * hole_spacing_x];
y_positions = [for (j = [0 : hole_rows-1]) (j - (hole_rows-1)/2) * hole_spacing_y];

// Create holes
holes = [];
for (i = [0 : hole_cols-1]) {
    for (j = [0 : hole_rows-1]) {
        holes += [translate([x_positions[i], y_positions[j], 0])
                  cylinder(r = hole_radius, h = plate_thickness_z + 0.01, center = true)];
    }
}

// Combine base plate with holes
plate_with_holes = difference(base_plate, holes);

// Side walls
// Left wall (at Y = -plate_width_y/2)
left_wall = translate([-plate_length_x/2, -plate_width_y/2, 0])
            cube([plate_length_x, wall_thickness_y, wall_height_z], center = false);

// Right wall (at Y = +plate_width_y/2)
right_wall = translate([-plate_length_x/2, plate_width_y/2 - wall_thickness_y, 0])
             cube([plate_length_x, wall_thickness_y, wall_height_z], center = false);

// Combine plate with walls
rack = union(plate_with_holes, left_wall, right_wall);

// Final output
render() rack;