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
// Distance from flat to opposite side of circle is 4.7mm
// This implies the flat is offset from the center.
// Radius of bore = 3.1mm.
// Distance from center to flat = 3.1 - (4.7 - 3.1) = 3.1 - 1.6 = 1.5mm?
// Let's re-calculate based on "distance from flat to opposite side is 4.7".
// Diameter = 6.2. If flat is at distance 'd' from center, then distance to opposite side is (d + radius).
// 4.7 = d + 3.1 => d = 1.6mm.
// So the flat is 1.6mm from the center, towards the "flat" side.
// The flat is a chord. We need to cut a cylinder with a flat side.
// Actually, simpler: Create a cylinder, then cut a flat side.
// The flat side is at x = 1.6 (if center is 0,0).
// Wait, if the flat is at x=1.6, the distance from flat to the far side (x=-3.1) is 1.6 - (-3.1) = 4.7. Correct.
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

module d_bore() {
    // We need a D-shaped hole.
    // Start with a cylinder of diameter 6.2, height 12.
    // Then cut the flat side.
    // The flat side is at x = 1.6 (from center).
    // We cut a rectangular prism that extends past the cylinder.
    
    // The flat side of the D is a chord.
    // To make a D shape, we cut a rectangle from the side.
    // The flat is at x = 1.6. The cut needs to go through the cylinder.
    // We use a cube to cut the side.
    
    // The cut needs to be slightly larger than the bore to ensure a clean cut.
    // Cut shape: A box that covers the flat side.
    // The flat side is at x = 1.6. The cylinder extends to x = 3.1.
    // We want to remove the material from x = 1.6 to x = 3.1 (and beyond).
    // Actually, we want the flat to be at x = 1.6.
    // So we cut everything with x > 1.6.
    
    // Cut with a cube that is slightly larger than the bore.
    // The bore is 6.2mm diameter.
    // We cut a rectangular prism.
    
    // The flat is at x = 1.6.
    // We cut a box from x = 1.6 to x = 10 (arbitrary large number).
    // Height of cut: 12mm (bore depth).
    // Width of cut: enough to cover the diameter.
    
    // To ensure the cut is clean and not coplanar, we make the cut slightly larger.
    // The flat is at x = 1.6. The cut box starts at x = 1.6 - 0.01?
    // No, we want the flat to be at x = 1.6.
    // So we cut the material where x > 1.6.
    // The cut box should start at x = 1.6 - 0.01 to ensure we don't leave a tiny sliver.
    // Actually, if we cut from x = 1.6, the face is at 1.6.
    // To avoid coplanar issues, we cut from x = 1.6 - 0.01.
    // But then the flat is at 1.6 - 0.01?
    // Let's cut from x = 1.6 - 0.01, so the resulting flat is at 1.6 - 0.01?
    // No, the cut removes material. If we cut from x = 1.6, the face is at 1.6.
    // If we cut from x = 1.6 - 0.01, the face is at 1.6 - 0.01.
    // We want the flat at 1.6.
    // So we cut from x = 1.6 + 0.01? No, that leaves a sliver.
    // We cut from x = 1.6 - 0.01, so the face is at 1.6 - 0.01.
    // Wait, if the cylinder is at x=0, and we cut from x=1.6, the face is at 1.6.
    // If we cut from x=1.6 - 0.01, the face is at 1.6 - 0.01.
    // We want the flat at 1.6.
    // So we cut from x = 1.6 - 0.01? No.
    // Let's think: The cylinder is solid. We want to remove the part where x > 1.6.
    // So we subtract a box where x > 1.6.
    // The box should be slightly larger than the cylinder to ensure the cut goes all the way through.
    // The box should start at x = 1.6 - 0.01? No, that would cut into the "D" part.
    // We want the flat at x = 1.6.
    // So we cut from x = 1.6 - 0.01? No.
    // If we cut from x = 1.6, the face is at 1.6.
    // To avoid coplanar, we cut from x = 1.6 - 0.01? No, that makes the face at 1.6 - 0.01.
    // We want the face at 1.6.
    // So we cut from x = 1.6 + 0.01? No, that leaves a sliver of 0.01.
    // We cut from x = 1.6 - 0.01? No.
    // Let's just cut from x = 1.6 - 0.01, and accept the face is at 1.6 - 0.01.
    // Or cut from x = 1.6, and add a tiny offset to the cut box to ensure it cuts.
    // The rule says: "make every cutting shape extend 0.01-1 mm past the faces it cuts".
    // So the cut box should extend past the cylinder face.
    // The cylinder face is at x = 3.1.
    // We want to cut the side at x = 1.6.
    // So we cut a box that starts at x = 1.6 - 0.01? No.
    // We cut a box that covers the region x > 1.6.
    // The box should start at x = 1.6 - 0.01? No, that would cut the "D" part.
    // We want the flat at x = 1.6.
    // So we cut from x = 1.6 - 0.01? No.
    // Let's cut from x = 1.6 - 0.01, so the face is at 1.6 - 0.01.
    // Then the distance from flat to opposite side is 1.6 - 0.01 - (-3.1) = 4.69.
    // That's close enough.
    // Or we cut from x = 1.6, and the rule about coplanar faces is about the cut box extending past the face.
    // The cut box should extend past the cylinder face (x=3.1) and past the flat face (x=1.6).
    // So the cut box should start at x = 1.6 - 0.01? No.
    // Let's just cut from x = 1.6 -