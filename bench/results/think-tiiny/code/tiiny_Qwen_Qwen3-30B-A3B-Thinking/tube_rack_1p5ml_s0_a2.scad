$fn = 64;

// Dimensions in mm
rack_length = 106;   // X-axis length (106 mm)
rack_width = 72;     // Y-axis width (72 mm)
rack_height = 30;    // Z-axis height (30 mm)
hole_diameter = 11.2; // Hole diameter (11.2 mm)
hole_depth = 25;     // Hole depth (25 mm)
hole_spacing = 16;   // Center-to-center spacing (16 mm)
num_holes_x = 6;   // Number of holes along X (6)
num_holes_y = 4;   // Number of holes along Y (4)

// Create the rack (centered on origin in X/Y, bottom at Z=0)
rack = translate([-rack_length/2, -rack_width/2, 0]) 
       cube([rack_length, rack_width, rack_height]);

// Subtract holes (24 holes in 4x6 grid)
difference() {
  rack;
  for (i = [0 : num_holes_x - 1]) {
    for (j = [0 : num_holes_y - 1]) {
      // Calculate hole center coordinates (centered on rack)
      hole_x = hole_spacing * i - (num_holes_x - 1) * hole_spacing / 2;
      hole_y = hole_spacing * j - (num_holes_y - 1) * hole_spacing / 2;
      
      // Subtract cylinder (extended 0.01 mm beyond top to avoid coplanar faces)
      translate([hole_x, hole_y, 5])
        cylinder(d = hole_diameter, h = hole_depth + 0.01, center = false);
    }
  }
}