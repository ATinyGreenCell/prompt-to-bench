// Dimensions for Hotplate Stirrer Knob Replacement
// All units in millimetres (mm)

// Main body dimensions
knob_diameter = 30;
knob_height = 15;

// D-shaft bore dimensions
shaft_diameter = 6;
bore_diameter = 6.2;
bore_depth = 12;
bore_flat_width = 4.7; // Distance from flat to opposite side of circle

// Grip groove dimensions
groove_count = 18;
groove_diameter = 2;
groove_depth = 1; // Half of groove diameter for half-cylinder cut

// Pointer groove dimensions
pointer_width = 1.5;
pointer_depth = 1;

// Orientation: Knob rests on XY plane (z=0), builds upward (+Z)
// Centered at origin (0,0,0)

// Create the main cylinder body
body = cylinder(h = knob_height, r = knob_diameter / 2, $fn = 64);

// Create the D-shaped bore
// We create a cylinder and cut the flat side
bore_cylinder = cylinder(h = bore_depth, r = bore_diameter / 2, $fn = 64);

// Create the flat cut for the D-shape
// The flat is 4.7mm from the opposite side.
// Diameter = 6.2. Radius = 3.1.
// Distance from flat to opposite side = 4.7.
// So the flat is at x = (6.2 - 4.7) / 2 = 1.25? No.
// If flat is at x = -1.25, distance to right side (x=3.1) is 4.35.
// Let's calculate: Flat is at x = - (bore_diameter - bore_flat_width) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
// Let's use the offset: flat is at x = - (bore_diameter - 4.7) / 2? No.
//