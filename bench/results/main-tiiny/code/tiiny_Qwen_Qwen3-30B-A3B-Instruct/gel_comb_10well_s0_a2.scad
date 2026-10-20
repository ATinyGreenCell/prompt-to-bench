// 10-well agarose gel comb parameters
$fn = 64;

// Overall dimensions
spine_length = 70;    // X direction
spine_width = 12;     // Y direction
tooth_width = 5.0;    // X direction (width of each tooth)
tooth_length = 12;    // Y direction (length of each tooth)
gap_between_teeth = 1.5; // Y direction gap between adjacent teeth
num_teeth = 10;
comb_thickness = 1.5;   // Z direction (thickness of the comb)

// Center the tooth row on the spine in X direction
total_tooth_and_gap_length = num_teeth * tooth_length + (num_teeth - 1) * gap_between_teeth;
offset_x = (spine_length - total_tooth_and_gap_length) / 2;

// Define the spine (back bar) - centered on origin in X and Y
// Spine is 70 mm long (X), 12 mm wide (Y), 1.5 mm thick (Z)
// Place it so that it lies flat on the bed (z = 0) and extends from z = -0.75 to z = 0.75
// So we center it in Z: z = -0.75 to 0.75

// Create the spine
spine = cube([spine_length, spine_width, comb_thickness], center = true);

// Create the teeth
// Each tooth is 5.0 mm wide (X), 12 mm long (Y), 1.5 mm thick (Z)
// They extend from the -Y edge of the spine (Y = -spine_width/2) downward (in -Y direction)
// The tooth row is centered on the spine in X

// We'll build the final comb as the union of the spine and all teeth
// But ensure that the entire comb lies on the bed at z = 0 (so the bottom is at z = -0.75, top at z = 0.75)

union() {
  // Spine: centered in X, Y, Z
  translate([0, 0, 0]) {
    cube([spine_length, spine_width, comb_thickness], center = true);
  }
  
  // Teeth: each tooth is placed so that its center is aligned with the spine
  for (i = [0 : num_teeth - 1]) {
    // Y position: start from the first tooth at Y = -spine_width/2 - tooth_length
    // Then add (tooth_length + gap_between_teeth) for each subsequent tooth
    tooth_y_start = -spine_width/2 - tooth_length - i * (tooth_length + gap_between_teeth);
    tooth_y_end = -spine_width/2 - i * (tooth_length + gap_between_teeth);
    
    // X position: offset so that the tooth row is centered on the spine
    tooth_x_start = -spine_length/2 + offset_x + i * (tooth_width + gap_between_teeth);
    tooth_x_end = tooth_x_start + tooth_width;
    
    // Center the tooth in X and Y
    tooth_center_x = (tooth_x_start + tooth_x_end) / 2;
    tooth_center_y = (tooth_y_start + tooth_y_end) / 2;
    
    // Translate to center the tooth
    translate([tooth_center_x, tooth_center_y, 0]) {
      cube([tooth_width, tooth_length, comb_thickness], center = true);
    }
  }
}