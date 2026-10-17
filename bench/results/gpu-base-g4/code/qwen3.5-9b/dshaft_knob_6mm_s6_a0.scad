// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Print Orientation: Bottom face (with D-bore) on Z=0, building upward.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and precise D-shape

// Main Body
D_KNOB_DIAMETER = 30;
D_KNOB_HEIGHT = 15;
D_KNOB_RADIUS = D_KNOB_DIAMETER / 2;

// Shaft Bore (D-shape)
SHAFT_DIAMETER = 6.2;
SHAFT_RADIUS = SHAFT_DIAMETER / 2;
SHAFT_DEPTH = 12;
// D-shape geometry: Distance from flat to opposite arc
D_SHAPE_CHORD = 4.7;
// Calculate the radius of the arc segment based on chord length and total diameter
// Total diameter = Chord + 2 * Arc_Height
// Arc_Height = (Total Diameter - Chord) / 2
// Arc_Height = (6.2 - 4.7) / 2 = 0.75
// Radius = (Chord^2 + 4 * Arc_Height^2) / (8 * Arc_Height)
D_SHAPE_ARC_HEIGHT = (SHAFT_DIAMETER - D_SHAPE_CHORD) / 2;
D_SHAPE_ARC_RADIUS = (D_SHAPE_CHORD*D_SHAPE_CHORD + 4*D_SHAPE_ARC_HEIGHT*D_SHAPE_ARC_HEIGHT) / (8*D_SHAPE_ARC_HEIGHT);

// Grip Grooves
NUM_GROOVES = 18;
GROOVE_DEPTH = 2; // Radius of the half-cylinder cut
GROOVE_DIAMETER = 2;

// Top Pointer
POINTER_WIDTH = 1.5;
POINTER_DEPTH = 1; // Depth from top surface

// --- Construction ---

// 1. Main Cylinder Body
difference() {
    // Outer Cylinder
    cylinder(h = D_KNOB_HEIGHT, r = D_KNOB_RADIUS, center = true);
    
    // 2. D-Shaped Blind Bore
    translate([0, 0, D_KNOB_HEIGHT - SHAFT_DEPTH]) {
        difference() {
            // Create the D-shape profile
            // We construct the D-shape using a large circle and a subtracted segment
            // The flat side is at Y = -D_SHAPE_ARC_HEIGHT relative to the center of the circle
            // The circle center is at (0, D_SHAPE_ARC_HEIGHT) relative to the flat face
            
            // The "Positive" part of the D (the arc)
            // We use a circle of radius SHAFT_RADIUS, but we need to offset it to create the flat
            // Actually, easier approach: Draw the full circle, then subtract the segment that makes the flat.
            
            // Full Circle
            circle(r = SHAFT_RADIUS);
            
            // The flat part is a rectangle cut from the circle
            // Width = D_SHAPE_CHORD
            // Height = SHAFT_RADIUS - D_SHAPE_ARC_HEIGHT (distance from circle center to flat)
            // Wait, let's re-verify the geometry.
            // Circle Center at (0,0). Flat line at y = -D_SHAPE_ARC_HEIGHT.
            // Distance from center to flat = D_SHAPE_ARC_HEIGHT.
            // So the flat line is at y = -D_SHAPE_ARC_HEIGHT.
            // The chord length at this y is 2 * sqrt(r^2 - y^2).
            // Let's check: r=3.1, y=-0.75. sqrt(3.1^2 - 0.75^2) = sqrt(9.61 - 0.5625) = sqrt(9.0475) = 3.007.
            // 2 * 3.007 = 6.014. This is close to 6.2 but not exact.
            // The prompt specifies: "6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
            // This implies the resulting shape has a max width of 6.2 and a min width (flat) of 4.7.
            // If we start with a 6.2 diameter circle (r=3.1), and cut a flat such that the remaining arc height is 4.7.
            // Arc Height = r - distance_to_flat.
            // 4.7 = 3.1 - distance_to_flat => distance_to_flat = 3.1 - 4.7 = -1.6.
            // This means the flat is 1.6mm BELOW the center.
            // Let's check the chord length at y = -1.6.
            // x = sqrt(3.1^2 - 1.6^2) = sqrt(9.61 - 2.56) = sqrt(7.05) = 2.655.
            // Chord = 2 * 2.655 = 5.31. This is not 4.7.
            
            // Re-reading carefully: "6.2 mm diameter circle... distance from the flat to the opposite side... is 4.7 mm."
            // This usually describes the final D-shape dimensions.
            // Max Width (Arc to Arc) = 6.2.
            // Min Width (Flat) = 4.7.
            // If Max Width = 6.2, Radius = 3.1.
            // If Min Width = 4.7, then the flat chord is 4.7.
            // Let y be the distance from center to flat.
            // 4.7 = 2 * sqrt(3.1^2 - y^2)
            // 2.35 = sqrt(9.61 - y^2)
            // 5.5225 = 9.61 - y^2
            // y^2 = 4.0875
            // y = 2.0216 mm.
            // So the flat is 2.0216 mm from the center.
            // The distance from the flat to the opposite side (top of circle) is:
            // Radius + y = 3.1 + 2.0216 = 5.1216 mm.
            // BUT the prompt says this distance is 4.7 mm.
            
            // Contradiction in prompt interpretation?
            // Interpretation A: Start with 6.2 diameter circle. Cut a flat. The resulting shape has a flat-to-arc distance of 4.7.
            // If flat-to-arc = 4.7 and Radius = 3.1, then the flat must be 1.6mm from center (3.1 - 1.6 = 1.5? No. 3.1 - 1.6 = 1.5. 3.1+1.6=4.7).
            // If flat is 1.6mm from center, chord = 2*sqrt(3.1^2 - 1.6^2) = 5.31mm.
            // Interpretation B: The "6.2 mm diameter circle" is the reference, but the "4.7 mm" is the flat width.
            // If Flat Width = 4.7 and Radius = 3.1, then distance to flat = 2.02mm.
            // Then flat-to-arc distance = 3.1 + 2.02 = 5.12mm.
            
            // Let's try Interpretation C: The "6.2 mm diameter" refers to the bounding box of the D-shape? No, "circle".
            // Maybe the "6.2 mm diameter circle" is the hole before cutting, and the "4.7 mm" is the flat width.
            // If I assume the flat width is 4.7mm (standard D-shaft tolerance often varies, but 4.7 is specific).
            // And the arc radius is 3.1mm (from 6.2 diameter).
            // Then the flat is at y = sqrt(3.1^2 - 2.35^2) = 2.02mm from center.
            // The distance from flat to top is 3.1 + 2.02 = 5.12mm.
            // The prompt says "distance from the flat to the opposite side of the circle is 4.7 mm".
            // This implies the total height of the D-shape is 4.7mm.
            // If Total Height = 4.7 and Radius = 3.1, then the flat is at y = 4.7 - 3.1 = 1.6mm from center.
            // If flat is at y=1.6, then Chord = 2 * sqrt(3.1^2 - 1.6^2) = 5.31mm.
            // So the flat width is 5.31mm, not 4.7mm.
            
            //