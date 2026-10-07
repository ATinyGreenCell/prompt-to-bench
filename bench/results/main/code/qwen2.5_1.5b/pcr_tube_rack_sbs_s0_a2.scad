// Dimensions in millimeters
$fn = 64; // for round holes

// Block dimensions
block_length_mm = 127.76;
block_width_mm = 85.48;
block_height_mm = 20;

// Hole diameter and spacing
hole_diameter_mm = 6.2;
row_spacing_mm = 9.0;
column_spacing_mm = 12 * hole_diameter_mm; // 12 columns, each with a hole

// Calculate coordinates for the first hole (A1)
x_offset_mm = block_length_mm / 2 - column_spacing_mm / 2;
y_offset_mm = block_width_mm / 2 - row_spacing_mm / 2;

hole_center_x_mm = x_offset_mm + column_spacing_mm * 0.5;
hole_center_y_mm = y_offset_mm + row_spacing_mm * 0.5;

// Chamfer dimensions
chamfer_legs_mm = 5;
chamfer_angle_degrees = 45;

// Define the block and holes
block = translate([x_offset_mm, y_offset_mm, -block_height_mm]) 
    cube([block_length_mm, block_width_mm, block_height_mm]);

holes = for(i, [i in range(1, 97)]) {
    hole_center_x_mm = i * column_spacing_mm + x_offset_mm;
    hole_center_y_mm = row_spacing_mm / 2 - (i % 8) * row_spacing_mm + y_offset_mm;

    translate([hole_center_x_mm, hole_center_y_mm, block_height_mm]) 
        cube([column_spacing_mm, row_spacing_mm], center: true);
};

// Chamfer the vertical edge
translate([x_offset_mm, y_offset_mm - chamfer_legs_mm, 0])
    linear_extrude(height = chamfer_legs_mm * 2)
        translate([chamfer_angle_degrees / 180 * pi, 0, 0]) 
            cube([block_length_mm, block_width_mm], center: true);

// Chamfer the top edge
translate([x_offset_mm, y_offset_mm + row_spacing_mm - chamfer_legs_mm, 0])
    linear_extrude(height = chamfer_legs_mm * 2)
        translate([chamfer_angle_degrees / 180 * pi, 0, 0]) 
            cube([block_length_mm, block_width_mm], center: true);

// Chamfer the bottom edge
translate([x_offset_mm - block_length_mm + chamfer_legs_mm, y_offset_mm, 0])
    linear_extrude(height = chamfer_legs_mm * 2)
        translate([chamfer_angle_degrees / 180 * pi, 0, 0]) 
            cube([block_length_mm