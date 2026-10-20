$fn = 64;

// Plate dimensions
plate_x = 130;      // Length along X
plate_y = 90;       // Width along Y
plate_z = 4;        // Thickness

// Hole dimensions
hole_dia = 30.5;    // Diameter of tube holes

// Hole grid spacing
hole_spacing_x = 40; // Centre-to-centre along X
hole_spacing_y = 40; // Centre-to-centre along Y

// Wall dimensions
wall_x = 130;       // Length along X
wall_y = 4;         // Thickness along Y
wall_h = 66;        // Height above plate (rises to z=70)

// Hole centres (3 along X, 2 along Y)
x_centers = [-40, 0, 40];
y_centers = [-20, 20];

difference() {
  union() {
    // Base plate
    cube([plate_x, plate_y, plate_z], center = true);
    
    // Long walls (flush with plate edges)
    translate([0, plate_y/2 + wall_y/2, plate_z + wall_h/2])
      cube([wall_x, wall_y, wall_h], center = true);
      
    translate([0, -plate_y/2 - wall_y/2, plate_z + wall_h/2])
      cube([wall_x, wall_y, wall_h], center = true);
  }
  
  // Through-holes
  for (x = x_centers) {
    for (y = y_centers) {
      cylinder(d = hole_dia, h = plate_z + 0.5, center = true);
    }
  }
}