$fn = 64;

spine_length = 70;    // mm, length of the spine (X-axis)
spine_width = 12;    // mm, width of the spine (Y-axis)
tooth_width = 5.0;   // mm, width of each tooth (X-axis)
tooth_length = 12;    // mm, length of each tooth (Y-axis, extending from spine)
gap = 1.5;           // mm, gap between neighbouring teeth (X-axis)
num_teeth = 10;      // number of teeth
thickness = 1.5;   // mm, thickness of the comb (Z-axis)

total_teeth_width = num_teeth * tooth_width + (num_teeth - 1) * gap;
start_x = -total_teeth_width / 2;

union() {
  // Spine: centered at origin (X and Y), 70mm x 12mm x 1.5mm
  cube([spine_length, spine_width, thickness], center = true);
  
  // Teeth: 10 teeth, each 5.0mm x 12mm x 1.5mm, placed along the spine's bottom edge
  for (i = [0 : num_teeth - 1]) {
    x_pos = start_x + i * (tooth_width + gap);
    translate([x_pos, -18, 0])
      cube([tooth_width, tooth_length, thickness]);
  }
}
translate([0, 6, 0]); // Center entire comb at origin (X and Y)