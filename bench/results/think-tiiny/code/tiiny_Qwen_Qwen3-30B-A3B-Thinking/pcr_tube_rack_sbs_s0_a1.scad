$fn = 64;

// Dimensions for the rack
rack_length = 127.76;   // X-axis length (left to right)
rack_width = 85.48;        // Y-axis width (back to front)
rack_height = 20.0;        // Z-axis height (base to top)

// Hole grid parameters
hole_diameter = 6.2;     // Diameter of each PCR tube hole
hole_spacing = 9.0;        // Center-to-center spacing between holes
num_columns = 12;          // Number of columns (X-axis)
num_rows = 8;              // Number of rows (Y-axis)
hole_offset_x = 14.38;     // From left edge to first hole center (X)
hole_offset_y = 11.24;     // From back edge to first hole center (Y)

// Chamfer parameters
chamfer_leg = 5.0;        // Length of each leg of the 45-degree chamfer

// Calculate rack center for translation
rack_center_x = -rack_length / 2;
rack_center_y = -rack_width / 2;

// Create the rack base (centered at origin)
rack = 
  translate([rack_center_x, rack_center_y, 0])
  cube([rack_length, rack_width, rack_height], center = false);

// Subtract holes (each hole extends 0.01mm beyond rack for clean subtraction)
holes = 
  for (col = [0:num_columns-1])
    for (row = [0:num_rows-1])
      let (
        x = rack_center_x + hole_offset_x + col * hole_spacing,
        y = rack_center_y + hole_offset_y + row * hole_spacing
      )
      {
        translate([x, y, -0.01])
        cylinder(h = rack_height + 0.02, r = hole_diameter / 2, center = false);
      };

// Create chamfer at very back-left corner (A1 corner) - 45-degree chamfer with 5mm legs
chamfer_points = [
  [rack_center_x, rack_center_y, rack_height],          // Top-back-left corner
  [rack_center_x + chamfer_leg, rack_center_y, rack_height], // 5mm right along top
  [rack_center_x, rack_center_y + chamfer_leg, rack_height], // 5mm forward along top
  [rack_center_x, rack_center_y, rack_height - chamfer_leg] // 5mm down from top
];

chamfer = 
  hull() {
    for (p = chamfer_points)
      translate(p) sphere(0.1);
  };

// Assemble the final rack by subtracting holes and chamfer from the rack base
difference() {
  rack;
  holes;
  chamfer;
}