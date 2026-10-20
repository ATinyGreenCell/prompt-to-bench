// Dimensions
spine_length = 70;     // Length of the spine (X direction)
spine_width = 12;    // Width of the spine (Y direction)
spine_thickness = 1.5; // Thickness of the plate (Z direction)

tooth_width = 5.0;   // Width of each tooth (X direction)
tooth_length = 12;  // Length of each tooth (Y direction)
tooth_gap = 1.5;     // Gap between teeth (Y direction)

num_teeth = 10;     // Number of teeth

// Main plate
plate = union() {
  // Spine
  translate([0, 0, 0])
  cube([spine_length, spine_width, spine_thickness], center = true);

  // Teeth
  for(i = [0:num_teeth-1]) {
    translate([0, -i * (tooth_length + tooth_gap) - tooth_length/2, 0])
    cube([tooth_width, tooth_length, spine_thickness], center = true);
  }
};

// Final part
plate;