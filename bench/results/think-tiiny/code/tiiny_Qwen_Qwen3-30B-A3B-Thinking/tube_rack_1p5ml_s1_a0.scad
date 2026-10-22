$fn = 64;

// Rack dimensions (mm)
rack_length = 106;   // X-axis length (front to back)
rack_width = 72;          // Y-axis width (left to right)
rack_height = 30;         // Z-axis height (bottom to top)

// Hole specifications (mm)
hole_diameter = 11.2;       // Diameter of each hole
hole_radius = hole_diameter / 2;
hole_depth = 25.0;        // Depth of hole from top surface (leaving 5mm solid floor)
hole_extension = 0.01;      // Extra depth to avoid coplanar faces (0.01mm past top)
hole_height = hole_depth + hole_extension;

// Hole grid parameters (mm)
hole_spacing = 16.0;      // Center-to-center spacing between holes
num_holes_x = 6;          // Number of holes along X (length)
num_holes_y = 4;          // Number of holes along Y (width)

// Build rack centered on origin (X, Y) and resting on XY plane (Z=0)
rack = 
  translate([-rack_length/2, -rack_width/2, 0])
  cube([rack_length, rack_width, rack_height]);

// Build holes (24 holes, 4 rows of 6, centered grid)
holes = 
  for (i = [0 : num_holes_x - 1])
    for (j = [0 : num_holes_y - 1])
      {
        // Calculate hole center coordinates relative to rack center (X,Y)
        hole_x = (i - (num_holes_x - 1)/2.0) * hole_spacing;
        hole_y = (j - (num_holes_y - 1)/2.0) * hole_spacing;
        
        // Create hole cylinder (25.01mm deep, starting at Z=5mm to leave 5mm solid floor)
        translate([hole_x, hole_y, 5])
          cylinder(r = hole_radius, h = hole_height, center = false);
      };

difference() {
  rack;
  holes;
}