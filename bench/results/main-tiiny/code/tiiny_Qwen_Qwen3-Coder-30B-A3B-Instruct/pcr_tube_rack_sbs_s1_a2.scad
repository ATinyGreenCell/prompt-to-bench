// PCR Tube Rack for 96 PCR Tubes (0.2 mL)
// ANSI/SLAS standard microplate footprint

// Dimensions
length = 127.76;     // X dimension
width = 85.48;       // Y dimension
height = 20;         // Z dimension
hole_diameter = 6.2; // PCR tube hole diameter
hole_spacing = 9.0;  // Centre-to-centre spacing
rows = 8;            // Rows along Y
cols = 12;           // Columns along X
offset_x = 14.38;    // X offset of first hole from left edge
offset_y = 11.24;    // Y offset of first hole from back edge
chamfer_length = 5;  // Chamfer leg length
chamfer_angle = 45;  // Chamfer angle

// Main block
main_block = union() {
  // Base block
  cube([length, width, height], center = false);
  
  // Chamfer at A1 corner (left-back)
  translate([0, 0, 0]) {
    chamfer = rotate(chamfer_angle, [0, 0, 1]) 
      cube([chamfer_length, chamfer_length, height], center = false);
    translate([0, 0, 0]) {
      rotate([0, 0, 180]) {
        translate([-chamfer_length, -chamfer_length, 0]) {
          chamfer;
        }
      }
    }
  }
};

// Holes for PCR tubes
holes = union() {
  for (row = [0 : rows - 1]) {
    for (col = [0 : cols - 1]) {
      translate([
        offset_x + col * hole_spacing,
        offset_y + row * hole_spacing,
        0
      ]) {
        cylinder(h = height + 0.02, d = hole_diameter, center = false, $fn = 64);
      }
    }
  }
};

// Final assembly
difference() {
  main_block;
  holes;
}