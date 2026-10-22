// Dimensions
length = 106; // X dimension in mm
width = 72; // Y dimension in mm
height = 30; // Z dimension in mm
hole_diameter = 11.2; // Diameter of each hole in mm
hole_depth = 25; // Depth of each hole in mm
floor_thickness = 5; // Thickness of the solid floor in mm
hole_spacing = 16; // Centre-to-centre spacing of holes in both directions in mm

// Calculate hole radius
hole_radius = hole_diameter / 2;

// Create the base block
base = cube([length, width, height]);

// Create the hole grid
holes = for (x = [0:hole_spacing:width - hole_spacing]) 
          for (y = [0:hole_spacing:height - hole_spacing]) 
            cylinder(r = hole_radius, h = hole_depth, center = true);

// Create the solid floor
floor = cube([length, width, floor_thickness], center = true);

// Combine the base, holes, and floor
result = difference() {
  union() {
    base;
    floor;
  }
  holes;
};

// Render the result
result;