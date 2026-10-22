// Sowing template for 90mm Petri dish
// Flat disc 85mm diameter, 2mm thick, with 7x7 grid of 3mm holes (9mm center-to-center)
// Rectangular notch on +Y side: 10mm wide (X), 4mm deep (Y, inward from rim)

// Dimensions in mm
disc_diameter = 85;
disc_thickness = 2;
hole_diameter = 3;
hole_spacing = 9;
notch_width = 10;
notch_depth = 4;
grid_size = 7;

// Base disc (cylinder, bottom at Z=0)
base = cylinder(r = disc_diameter / 2, h = disc_thickness, center = false);

// Holes: 7x7 grid centered at origin
// Hole centers at (x, y) where x and y range from -27 to 27 in steps of 9
// (7 holes: -27, -18, -9, 0, 9, 18, 27)
holes = 
  for (x = [-27, -18, -9, 0, 9, 18, 27])
    for (y = [-27, -18, -9, 0, 9, 18, 27])
      cylinder(r = hole_diameter / 2, h = disc_thickness, center = false, $fn = 64)
        translate([x, y, 0]);

// Notch: rectangular notch on +Y side, centered on Y-axis
// Notch extends from Y = (disc_diameter/2 - notch_depth) to Y = disc_diameter/2 (rim)
notch = 
  cube([notch_width, notch_depth, disc_thickness], center = false)
    translate([0, disc_diameter / 2 - notch_depth, 0]);

// Assemble the part: base minus holes minus notch
difference() {
  base;
  holes;
  notch;
}