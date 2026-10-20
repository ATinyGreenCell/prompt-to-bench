// Sowing template for 90mm Petri dish
// Dimensions in millimetres
$fn = 64;

// Disc properties
disc_diameter = 85;           // Diameter of the flat disc
disc_thickness = 2;          // Thickness of the disc

// Grid properties
num_holes = 7;               // 7x7 grid
hole_diameter = 3;           // Diameter of each through-hole
hole_spacing = 9;            // Centre-to-centre spacing

// Notch properties
notch_width = 10;            // Width of notch in X direction
notch_depth = 4;             // Depth of notch in Y direction (from rim)

// Create the base disc
disc = cube([disc_diameter, disc_diameter, disc_thickness], center = true);

// Create the 7x7 grid of holes
for (i = [0 : num_holes - 1]) {
  for (j = [0 : num_holes - 1]) {
    // Position of hole: centered at (x, y) with spacing
    x_pos = (i * hole_spacing) - (num_holes * hole_spacing / 2);
    y_pos = (j * hole_spacing) - (num_holes * hole_spacing / 2);
    
    // Cut a hole with 0.1 mm extension to avoid coplanar faces
    hole = cylinder(r = hole_diameter / 2, h = disc_thickness + 0.1, center = false, f = 64);
    translate([x_pos, y_pos, 0]) hole;
    disc = difference() {
      disc;
      hole;
    };
  }
}

// Create the rectangular notch on the +Y side, centered on Y axis
// Notch is cut from the rim inward, 4 mm deep, 10 mm wide, on the +Y side
notch_x_start = (disc_diameter / 2) - (notch_width / 2);
notch_x_end = (disc_diameter / 2) + (notch_width / 2);

// Notch is a rectangular prism cut from the top surface
notch = cube([notch_width, notch_depth, disc_thickness], center = false);
translate([0, -disc_thickness/2 + notch_depth, 0]) // Position at bottom of disc
  translate([notch_x_start, 0, 0])
  rotate(90, [1, 0, 0])
  cube([notch_width, notch_depth, disc_thickness], center = false);

// Final part: base disc minus holes and notch
// Use difference to cut holes and notch from the disc
final = disc;

// Subtract the holes
for (i = [0 : num_holes - 1]) {
  for (j = [0 : num_holes - 1]) {
    x_pos = (i * hole_spacing) - (num_holes * hole_spacing / 2);
    y_pos = (j * hole_spacing) - (num_holes * hole_spacing / 2);
    
    hole = cylinder(r = hole_diameter / 2, h = disc_thickness + 0.1, center = false, f = 64);
    translate([x_pos, y_pos, 0]) hole;
    final = difference() {
      final;
      hole;
    };
  }
}

// Subtract the notch
notch = cube([notch_width, notch_depth, disc_thickness], center = false);
translate([0, -disc_thickness/2 + notch_depth, 0])
  translate([notch_x_start, 0, 0])
  rotate(90, [1, 0, 0])
  cube([notch_width, notch_depth, disc_thickness], center = false);

final = difference() {
  final;
  notch;
};

// Final output
final;