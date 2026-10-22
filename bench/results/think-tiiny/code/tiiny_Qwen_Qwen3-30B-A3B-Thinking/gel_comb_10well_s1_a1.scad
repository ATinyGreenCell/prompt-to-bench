$fn = 64;

spine_length = 70;    // mm, length of the spine (X-axis)
spine_width = 12;    // mm, width of the spine (Y-axis)
tooth_width = 5.0;   // mm, width of each tooth (X-axis)
tooth_length = 12;    // mm, length of each tooth (Y-axis, extending from spine)
gap = 1.5;           // mm, gap between neighbouring teeth (X-axis)
num_teeth = 10;      // number of teeth
thickness = 1.5;     // mm, thickness of the comb (Z-axis)

total_teeth_width = num_teeth * tooth_width + (num_teeth - 1) * gap;
start_x = -total_teeth_width / 2;

// Shift the entire comb up by 0.75 mm so that the bottom is at z=0.
translate([0, 0, 0.75])
union() {
  // Spine: centered at origin in X and Y, placed at Z=0 (so from Z=0 to Z=thickness)
  translate([-spine_length/2, -spine_width/2, 0])
    cube([spine_length, spine_width, thickness]);
  
  // Teeth: 10 teeth, each 5.0mm x 12mm x 1.5mm, placed along the spine's bottom edge (Y = -spine_width/2 = -6) 
  // The teeth extend from Y = -spine_width/2 - tooth_length to Y = -spine_width/2.
  // So the top of the tooth (attached to the spine) is at Y = -spine_width/2 = -6.
  // Therefore, the translation for Y is -6 - tooth_length = -6 - 12 = -18.
  for (i = [0 : num_teeth - 1]) {
    x_pos = start_x + i * (tooth_width + gap);
    translate([x_pos, -18, 0])
      cube([tooth_width, tooth_length, thickness]);
  }
}