// Replacement knob for hotplate stirrer with 6mm D-shaft
// Dimensions in mm, printed with bottom face on z=0

// Overall knob dimensions
knob_diameter = 30;
knob_height = 15;

// D-shaft bore dimensions
shaft_diameter = 6.2;
flat_depth = 4.7;  // Distance from flat to opposite side

// Grip grooves
num_grooves = 18;
groove_diameter = 2;

// Pointer groove
pointer_width = 1.5;
pointer_depth = 1;

// Safety margin for boolean operations
safety = 0.05;

// Calculate D-shaft geometry
// The flat is on the +X side (same side as pointer groove)
// Center of circle is at origin in XY
d_center_x = (shaft_diameter/2 - flat_depth) * -1;  // Shift center so flat is at +X

// Groove radius
groove_radius = groove_diameter / 2;

// Groove angular spacing
groove_spacing = 360 / num_grooves;

// Pointer groove angular position (on +X side, same as flat)
pointer_angle = 0;

// Build the main knob cylinder
knob = cylinder(r = knob_diameter/2, h = knob_height, $fn = 64);

// Build the D-shaft bore
// Start with a cylinder slightly larger than needed
bore_cylinder = cylinder(r = shaft_diameter/2, h = 12 + safety, $fn = 64);

// Cut the flat side using a cube
// The flat is at x = d_center_x + shaft_diameter/2
flat_x = d_center_x + shaft_diameter/2;
flat_cut = cube([shaft_diameter + safety*2, shaft_diameter + safety*2, 12 + safety*2], center = false);
flat_cut_pos = [flat_x + shaft_diameter/2 + safety, 0, 0];

// Combine bore and flat cut
d_bore = difference(bore_cylinder, flat_cut);
d_bore_pos = translate([0, 0, 12 - safety]);

// Build grip grooves
grooves = [];
for (i = [0 : num_grooves-1]) {
    angle = i * groove_spacing;
    // Position groove on outer surface
    groove_x = (knob_diameter/2 - groove_radius) * cos(angle);
    groove_y = (knob_diameter/2 - groove_radius) * sin(angle);
    
    // Half-cylinder groove
    groove = cylinder(r = groove_radius, h = knob_height + safety*2, $fn = 32);
    groove_pos = translate([groove_x, groove_y, -safety]);
    grooves = concat(grooves, [groove_pos]);
}

// Build pointer groove
// Runs from center to edge on +X side
pointer_length = knob_diameter/2;
pointer_cut = cube([pointer_width, pointer_depth, pointer_depth], center = false);
pointer_pos = translate([pointer_length/2, 0, knob_height - pointer_depth]);

// Assemble the knob
final_knob = union(knob, d_bore_pos);

// Apply grip grooves
for (i = [0 : num_grooves-1]) {
    final_knob = difference(final_knob, grooves[i]);
}

// Apply pointer groove
final_knob = difference(final_knob, pointer_pos);

// Output the final model
final_knob;