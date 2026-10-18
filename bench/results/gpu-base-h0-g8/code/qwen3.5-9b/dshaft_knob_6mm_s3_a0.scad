// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Designed for FDM printing. Orientation: Bottom face on Z=0.

// --- Dimensions ---
// Knob outer diameter
$D_out = 30;
// Knob height
$H_total = 15;
// Shaft bore depth
$H_bore = 12;
// Shaft bore diameter (circle part)
$D_bore_circle = 6.2;
// Shaft bore flat width (distance from flat to opposite arc)
$W_bore_flat = 4.7;
// Groove count
$N_grooves = 18;
// Groove diameter
$D_groove = 2;
// Pointer groove width
$W_pointer = 1.5;
// Pointer groove depth
$D_pointer = 1;

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// --- Helper Functions ---
// Function to create a D-shape cylinder with a flat on one side
// flat_side: 1 for +X, -1 for -X, 0 for +Y, -1 for -Y (relative to local coords)
// Here we define the D-shape logic inline for clarity in the main block.

module d_shape_cylinder(D, H, flat_width, flat_side = 1) {
    // flat_side: 1 = +X, -1 = -X, 2 = +Y, -3 = -Y
    // We will rotate the cylinder so the flat is on the correct side relative to the knob orientation.
    // For the knob, the flat of the D-shaft bore must align with the pointer groove on top.
    // Let's define the D-shape in a local coordinate system where the flat is on the +X axis.
    
    // Calculate the radius of the circle part
    R = D / 2;
    
    // The flat width is the chord length. 
    // We need to ensure the geometry matches: distance from flat to opposite arc is flat_width.
    // Actually, the prompt says "distance from the flat to the opposite side of the circle is 4.7mm".
    // This implies the flat is a chord, and the max distance across the shape is 4.7mm.
    // Let's calculate the chord length required to make the max width 4.7mm.
    // Max width = R + (R - distance_from_center_to_chord).
    // Wait, simpler interpretation: The shape is a circle of diameter D_bore_circle (6.2), 
    // but one side is cut flat such that the total width across that axis is 4.7mm.
    // So the chord length is 4.7mm.
    
    chord_len = flat_width;
    
    // Calculate the distance from center to the chord (apothem)
    // (chord/2)^2 + apothem^2 = R^2
    apothem = sqrt((R*R) - (chord_len/2)*(chold_len/2)); // Typo fix below
    apothem = sqrt((R*R) - (chord_len/2)*(chord_len/2));
    
    // We construct the D-shape by rotating a polygon around the Z axis? 
    // No, a D-shape cylinder is usually a circle with a rectangular cutout or a polygon extruded.
    // Since it's a blind bore, we can model the solid D-shape and subtract it, or model the void directly.
    // Modeling the void directly is easier for a blind hole.
    // The void is a cylinder of diameter D_bore_circle, but with a flat face on one side.
    // Actually, the prompt says "D-shaped blind bore... 6.2 mm diameter circle with one side cut flat".
    // This means the hole is a circle, but the opening is a rectangle (flat) and the rest is round?
    // No, "D-shaped" usually means the cross section is a D.
    // Let's model the hole as a cylinder of diameter D_bore_circle, then subtract a rectangular prism 
    // that cuts the flat side, ensuring the resulting width is flat_width.
    
    // Wait, if I have a circle of 6.2mm, the max width is 6.2mm.
    // If I cut a flat side such that the width becomes 4.7mm, I am removing material.
    // The hole is the empty space.
    // So, start with a cylinder of diameter 6.2mm.
    // Then, cut a rectangular prism from the side to make the width 4.7mm.
    // The cut should go all the way through the cylinder diameter? No, just enough to make the width 4.7mm.
    // The flat face will be the new surface of the hole.
    
    // Let's define the hole geometry:
    // It is a cylinder of diameter 6.2mm.
    // We cut a rectangular slot on the side.
    // The slot width (along the diameter) should be (6.2 - 4.7) = 1.5mm.
    // The slot depth (radial) should be R - (flat_width/2).
    // R = 3.1. flat_width/2 = 2.35. Depth = 3.1 - 2.35 = 0.75mm.
    // The slot length (along the axis of the cylinder) is the full depth of the hole ($H_bore).
    
    // Orientation:
    // The knob sits on Z=0. The bore goes up +Z.
    // The flat side of the D-bore must align with the pointer groove on top.
    // Let's align the flat side of the D-bore to the +X direction.
    
    // 1. The main cylindrical hole
    translate([0, 0, 0])
    cylinder(h = $H_bore, d = $D_bore_circle, center = [0,0,0]);
    
    // 2. The flat cut
    // We need to cut a rectangular prism.
    // The prism is centered on the X axis (since flat is on +X).
    // Width of the cut (along X): The total diameter is 6.2. The remaining width is 4.7.
    // So the cut removes (6.2 - 4.7) = 1.5mm from the total width.
    // Since it's symmetric around the center line? No, a D-shape usually has the flat on one side.
    // "Distance from the flat to the opposite side".
    // This implies the flat is one face, and the opposite arc is the other boundary.
    // So the flat is a chord.
    // The cut is a rectangular prism.
    // Position: The flat face is at X = (flat_width / 2).
    // The cut extends from X = (flat_width / 2) to X = R.
    // Width of cut (X direction): R - (flat_width / 2).
    // Height of cut (Y direction): 2 * R (full diameter).
    // Depth of cut (Z direction): $H_bore.
    
    cut_width = ($D_bore_circle / 2) - ($W_bore_flat / 2);
    cut_height = $D_bore_circle;
    
    // Cut the flat side
    translate([cut_width/2, 0, 0]) // Center of the cut block
    cube([cut_width, cut_height, $H_bore]);
}

// --- Main Part Construction ---

// 1. Base Cylinder
// Diameter $D_out, Height $H_total
translate([0, 0, 0])
difference() {
    // Outer Shell
    cylinder(h = $H_total, d = $D_out, center = [0,0,0]);
    
    // 2. D-Shaped Bore
    // We use the helper logic inside a difference block to cut the hole
    translate([0, 0, 0])
    difference() {
        // The solid that would be the hole if it were a perfect circle
        cylinder(h = $H_bore, d = $D_bore_circle, center = [0,0,0]);
        
        // The flat cut to make it D-shaped
        // Cut from the center of the circle outwards to the edge?
        // No, the D-shape is defined by the flat width.
        // The flat face is at X = W_bore_flat / 2.
        // The cut removes material from X = W_bore_flat / 2 to X = R.
        // Wait, if I cut a cube, I am removing material.
        // The hole is the void.
        // So I need to subtract a rectangular prism that represents the "flat" part of the hole.
        // The rectangular prism should be:
        // X range: [W_bore_flat/2, R] -> Width = R - W_bore_flat/2
        // Y range: [-R, R] -> Height = 2R
        // Z range: