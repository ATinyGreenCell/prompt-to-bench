// Dimensions
thickness = 1.5; // mm
spine_length = 70; // mm
spine_width = 12; // mm
tooth_width = 5.0; // mm
tooth_length = 12; // mm
gap = 1.5; // mm

// Main comb plate
comb_plate = cube([spine_length, spine_width, thickness]);

// Teeth
teeth = for (i = [0:9])
  translate([i * (tooth_width + gap) - spine_length / 2 + tooth_width / 2, -spine_width / 2, 0])
    cube([tooth_width, tooth_length, thickness]);

// Final comb
comb = comb_plate - teeth;

// Render the comb
comb;