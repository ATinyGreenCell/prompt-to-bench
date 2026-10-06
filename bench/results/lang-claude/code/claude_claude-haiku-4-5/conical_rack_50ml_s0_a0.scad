// Dimensions (measured in mm)
base_length_x = 130;      // X dimension of base
base_width_y = 90;        // Y dimension of base
base_thickness = 4;       // Z thickness of base

hole_diameter = 30.5;     // Diameter of tube holes (50mL Falcon)
holes_spacing = 40;       // Center-to-center spacing between holes

wall_length_x = 130;      // X dimension of wall
wall_thickness_y = 4;     // Y thickness of wall
wall_height = 70;         // Z height of wall (from z=4 to z=74)

$fn = 64;

// Hole positions (2 rows × 3 columns, centered on base)
hole_positions = [
  [-40, -20],
  [0, -20],
  [40, -20],
  [-40, 20],
  [0, 20],
  [40, 20]
];

// Create the assembly
difference() {
  union() {
    // Base plate (centered in X and Y, Z from 0 to 4)
    translate([0, 0, base_thickness/2])
      cube([base_length_x, base_width_y, base_thickness], center = true);
    
    // Wall 1 (at Y = -45 edge, running from Z=4 to Z=74)
    translate([0, -(base_width_y/2 - wall_thickness_y/2), base_thickness + wall_height/2])
      cube([wall_length_x, wall_thickness_y, wall_height], center = true);
    
    // Wall 2 (at Y = +45 edge, running from Z=4 to Z=74)
    translate([0, (base_width_y/2 - wall_thickness_y/2), base_thickness + wall_height/2])
      cube([wall_length_x, wall_thickness_y, wall_height], center = true);
  }
  
  // Cut holes in the base (extends slightly past to avoid coplanar faces)
  for (pos = hole_positions) {
    translate([pos[0], pos[1], -0.5])
      cylinder(h = base_thickness + 1, r = hole_diameter / 2, $fn = 64);
  }
}