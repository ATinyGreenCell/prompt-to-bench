// PCR 96-well plate holder (ANSI/SLAS standard microplate format)

// Block dimensions (mm)
block_length_x = 127.76;  // X dimension (length)
block_width_y = 85.48;    // Y dimension (width)  
block_height_z = 20;      // Z dimension (height)

// Well specifications (mm)
well_diameter = 6.2;      // well diameter
well_rows = 8;            // number of rows (Y direction)
well_cols = 12;           // number of columns (X direction)
well_spacing = 9.0;       // center-to-center spacing

// Well A1 offset from block edges (mm)
a1_from_left = 14.38;     // distance from left edge
a1_from_back = 11.24;     // distance from back edge

// Orientation marker chamfer (mm)
chamfer_size = 5;         // 45-degree chamfer with 5 mm sides

// Resolution for smooth holes
$fn = 64;

// Calculate A1 well position (block centered at origin in X,Y)
a1_x = -block_length_x / 2 + a1_from_left;
a1_y = block_width_y / 2 - a1_from_back;

// Calculate corner position for chamfer marker
corner_x = -block_length_x / 2;
corner_y = block_width_y / 2;
corner_z = block_height_z;

difference() {
    // Main block body
    translate([0, 0, block_height_z / 2])
    cube([block_length_x, block_width_y, block_height_z], center = true);
    
    // Drill 96 PCR wells (8 rows, 12 columns)
    for (row = [0:well_rows-1]) {
        for (col = [0:well_cols-1]) {
            well_x = a1_x + col * well_spacing;
            well_y = a1_y - row * well_spacing;
            translate([well_x, well_y, -0.5])
            cylinder(h = block_height_z + 1, d = well_diameter, $fn = 64);
        }
    }
    
    // Chamfer at A1 corner (top-left-back corner) for orientation marker
    // Create tetrahedral cut using hull of tiny spheres at corner and 3 points
    hull() {
        translate([corner_x, corner_y, corner_z]) 
            sphere(r = 0.01);
        translate([corner_x + chamfer_size, corner_y, corner_z]) 
            sphere(r = 0.01);
        translate([corner_x, corner_y - chamfer_size, corner_z]) 
            sphere(r = 0.01);
        translate([corner_x, corner_y, corner_z - chamfer_size]) 
            sphere(r = 0.01);
    }
}