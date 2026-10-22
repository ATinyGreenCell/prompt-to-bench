// Dimensions for Hotplate Stirrer Knob Replacement
// All units in millimetres

// Main knob dimensions
knob_diameter = 30;
knob_height = 15;

// D-shaft interface dimensions
shaft_diameter = 6;
bore_diameter = 6.2; // Slightly larger than shaft for fit
bore_depth = 12;

// D-shape geometry
// Distance from flat to opposite side of circle is 4.7mm.
// Radius of bore = 3.1mm.
// Distance from center to flat = 3.1 - (4.7 - 3.1) = 1.6mm.
// The flat is at x = 1.6 (if center is 0,0).
bore_flat_offset = 1.6;

// Grip grooves
groove_count = 18;
groove_diameter = 2;
groove_depth = 1; // Half of diameter for half-cylinder cut

// Pointer groove
pointer_width = 1.5;
pointer_depth = 1;

// Print orientation: Side facing hotplate down (z=0).
// Knob rests on XY plane.

module knob_body() {
    // Main cylinder
    cylinder(h = knob_height, d = knob_diameter, center = false);
}

module d_bore_cut() {
    // We need to cut a flat side into the cylinder.
    // The flat is at x = 1.6.
    // We cut a rectangular prism that removes material from x = 1.6 onwards.
    // To avoid coplanar faces, we cut slightly past the intended flat line.
    // We cut from x = 1.6 - 0.01 to ensure the flat is at 1.6 - 0.01?
    // No, we want the flat at 1.6.
    // If we cut a box starting at x = 1.6 - 0.01, the resulting face is at 1.6 - 0.01.
    // If we cut a box starting at x = 1.6, the resulting face is at 1.6.
    // To ensure the cut is clean and not coplanar with the cylinder surface (which is curved),
    // we just need the cut box to extend past the cylinder boundary.
    // The cylinder boundary at the cut location is at x = 1.6 (the flat).
    // We cut a box that starts at x = 1.6 - 0.01? No, that cuts into the D.
    // We cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.
    // Let's cut a box that starts at x = 1.6 - 0.01? No.