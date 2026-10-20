// Dimensions for the 6-tube rack
// Base plate dimensions
plate_length_x = 130;      // X dimension of the base plate
plate_width_y = 90;        // Y dimension of the base plate
plate_thickness_z = 4;    // Z thickness of the base plate

// Tube hole specifications
tube_diameter = 30.5;     // Diameter of the 50 mL conical tube holes
hole_radius = tube_diameter / 2;

// Hole grid layout
hole_rows = 2;            // Number of rows along Y
hole_cols = 3;            // Number of columns along X
hole_spacing_x = 40;      // Center-to-center spacing in X
hole_spacing_y = 40;      // Center-to-center spacing in Y

// Wall specifications
wall_height_z = 70;       // Height of the side walls
wall_thickness_y = 4;    // Thickness of the side walls (along Y)
wall_length_x = 130;      // Length of the side walls (along X)

// Centering the entire assembly
center_x = 0;
center_y = 0;

// Base plate
base_plate = translate([0, 0, 0])
    cube([plate_length_x, plate_width_y, plate_thickness_z], center = false);

// Calculate hole positions
// The grid is centered on the plate.
// X range: -plate_length_x/2 to +plate_length_x/2
// Y range: -plate_width_y/2 to +plate_width_y/2
// We need 3 columns and 2 rows.
// Total span for 3 cols with spacing 40: 2 * 40 = 80. Centered: -40 to +40.
// Total span for 2 rows with spacing 40: 1 * 40 = 40. Centered: -20 to +20.

// Create holes using a loop
holes = [];
for (i = [0 : hole_cols - 1]) {
    for (j = [0 : hole_rows - 1]) {
        x_pos = -((hole_cols - 1) * hole_spacing_x) / 2 + i * hole_spacing_x;
        y_pos = -((hole_rows - 1) * hole_spacing_y) / 2 + j * hole_spacing_y;
        // Cylinder extends slightly past the plate to ensure clean cut
        holes = concat(holes, translate([x_pos, y_pos, 0])
            cylinder(h = plate_thickness_z + 0.1, r = hole_radius, $fn = 64));
    }
}

// Create the two side walls
// Wall 1: Along X at Y = -plate_width_y/2 (left edge)
// Wall 2: Along X at Y = +plate_width_y/2 (right edge)
// Walls are 4mm thick in Y, 130mm long in X, 70mm high in Z.
// They sit on top of the plate (z=4 to z=70).

// Wall 1: Left side (Y = -45)
wall1 = translate([-plate_length_x/2, -plate_width_y/2, plate_thickness_z])
    cube([plate_length_x, wall_thickness_y, wall_height_z - plate_thickness_z], center = false);

// Wall 2: Right side (Y = +45)
// Note: The wall thickness is 4mm. The center of the wall is at Y = 45.
// The wall extends from Y = 43 to Y = 47.
wall2 = translate([-plate_length_x/2, plate_width_y/2 - wall_thickness_y, plate_thickness_z])
    cube([plate_length_x, wall_thickness_y, wall_height_z - plate_thickness_z], center = false);

// Combine base, walls, and subtract holes
rack = union(
    base_plate,
    wall1,
    wall2
);

// Subtract the holes
final_rack = difference(rack, holes);

// Render the final part
render() {
    translate([0, 0, 0])
        final_rack;
}