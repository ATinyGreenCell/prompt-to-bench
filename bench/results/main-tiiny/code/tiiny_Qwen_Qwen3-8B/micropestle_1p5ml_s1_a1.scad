// Pestle dimensions
handle_diameter = 8;  // Diameter of the handle in mm
handle_length = 45;   // Length of the handle from z=0 to z=45
cone_start_diameter = 8;  // Diameter at the start of the cone
cone_end_diameter = 3;     // Diameter at the end of the cone
cone_length = 17;          // Length of the cone from z=45 to z=62
sphere_diameter = 3;      // Diameter of the rounded tip
sphere_z_position = 62;   // Z position of the sphere center

// Groove parameters
groove_width = 2;         // Width of each groove in Z direction
groove_depth = 1;         // Depth of each groove
groove_spacing = 5;       // Spacing between groove centers in Z
groove_start_z = 10;       // Starting Z position for the first groove
groove_count = 4;          // Number of circumferential grooves

// Define the pestle as a union of handle, cone, and sphere
union() {
  // Handle: cylinder from z=0 to z=45
  cylinder(r = handle_diameter / 2, h = handle_length, $fn = 64);

  // Cone: tapers from 8mm to 3mm over 17mm height
  // Create a cone by extruding a polygon
  difference() {
    // Create a larger cylinder to form the base of the cone
    cylinder(r = cone_start_diameter / 2, h = cone_length, $fn = 64);
    // Create a smaller cylinder to cut out the cone
    translate([0, 0, cone_length]) {
      cylinder(r = cone_end_diameter / 2, h = 0.1, $fn = 64);
    }
  }

  // Sphere: 3mm diameter, centered at z=62
  sphere(d = sphere_diameter, $fn = 64);

  // Grooves: four circumferential grooves on the handle
  for (i = [0:groove_count]) {
    // Calculate Z position for each groove
    groove_z = groove_start_z + i * groove_spacing;
    // Create a groove as a rectangular prism with a circular cutout
    difference() {
      // Full cylinder for the groove
      translate([0, 0, groove_z]) {
        cylinder(r = handle_diameter / 2, h = groove_width, $fn = 64);
      }
      // Cut out the circular part of the groove
      translate([0, 0, groove_z]) {
        cylinder(r = (handle_diameter - groove_depth) / 2, h = groove_width, $fn = 64);
      }
    }
  }
}