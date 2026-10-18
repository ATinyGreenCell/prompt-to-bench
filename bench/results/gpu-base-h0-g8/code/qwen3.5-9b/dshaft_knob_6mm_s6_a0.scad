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
// Diameter = Chord + 2 * (Radius - Sagitta) => Sagitta = Radius - (Diameter - Chord)/2
// Actually, simpler: The flat side is a chord of the circle.
// Distance from center of circle to chord = sqrt(R^2 - (Chord/2)^2)
// Distance from flat to arc = R - distance_to_chord
// We need the flat side to be at a specific offset from the center.
// Let's define the D-shape by the flat side position relative to the circle center.
// Total width = 6.2. Flat width = 4.7.
// The flat side is a chord. The distance from the circle center to this chord is:
// d_center = sqrt(R^2 - (4.7/2)^2)
// The flat face is located at z_offset = d_center from the center of the circle.
// The "flat" side of the D will be the face facing the user (let's say +X).
// So the flat plane is at X = d_center. The arc is at X = -d_center (if center is 0)?
// No, the D-shape is symmetric around the Y-axis (in the cross section).
// Let's place the center of the circle at (0,0).
// The flat side is a vertical line segment.
// The distance from the center (0,0) to the flat line is:
// offset = sqrt(R^2 - (4.7/2)^2)
// The flat line is at X = offset. The arc is at X = -offset?
// Wait, the total width is 6.2. The flat part is 4.7.
// The remaining width is 6.2 - 4.7 = 1.5. This 1.5 is split equally on both sides of the flat?
// No, a D-shape usually has the flat side as the "back" and the arc as the "front".
// The distance from the flat side to the tip of the arc is 4.7.
// The total diameter is 6.2.
// So the distance from the flat side to the center of the circle is:
// dist_flat_to_center = SHAFT_RADIUS - (D_SHAPE_CHORD / 2) ? No.
// Let's visualize: Circle diameter 6.2. Chord length 4.7.
// Distance from center to chord = sqrt(3.1^2 - 2.35^2) = sqrt(9.61 - 5.5225) = sqrt(4.0875) ≈ 2.0217.
// So the flat side is 2.0217 mm away from the center.
// The flat side is at X = 2.0217. The arc extends from X = -2.0217 to X = 2.0217?
// No, the arc is the outer boundary. The flat is the inner boundary of the D.
// The D-shape is the area inside the circle AND to the left of the chord (if chord is at +X).
// So the flat face is at X = 2.0217. The arc is at X = -2.0217 (the back of the D).
// Wait, if the flat is at +2.0217 and the arc is at -2.0217, the distance is 4.0434.
// But we need the distance from flat to arc to be 4.7.
// Let's re-calculate.
// Let the flat side be at X = x_flat. The arc is the circle x^2 + y^2 = R^2.
// The intersection of the line X = x_flat and the circle gives the chord length.
// Chord = 2 * sqrt(R^2 - x_flat^2).
// We need Chord = 4.7.
// 2.35 = sqrt(3.1^2 - x_flat^2)
// 5.5225 = 9.61 - x_flat^2
// x_flat^2 = 4.0875
// x_flat = 2.02175.
// So the flat side is at X = 2.02175.
// The distance from this flat side (X=2.02175) to the furthest point of the arc (X=-3.1) is:
// 2.02175 - (-3.1) = 5.12175. This is not 4.7.
// Ah, the "distance from flat to opposite side" usually means the straight line distance across the D.
// If the flat is at X = x_flat, and the arc is at X = -x_flat (symmetric D), then distance is 2*x_flat.
// But a D-shape is not symmetric like that. A D-shape is a circle with a segment cut out.
// The "flat" is the cut. The "opposite side" is the tip of the arc.
// Distance = (Radius + distance_from_center_to_chord).
// We need Distance = 4.7.
// R = 3.1.
// 4.7 = 3.1 + d_center_to_chord
// d_center_to_chord = 1.6.
// So the flat side is 1.6 mm from the center.
// Let's verify the chord length with d_center_to_chord = 1.6.
// Chord = 2 * sqrt(3.1^2 - 1.6^2) = 2 * sqrt(9.61 - 2.56) = 2 * sqrt(7.05) = 2 * 2.655 = 5.31.
// This contradicts the requirement "distance from flat to opposite side is 4.7" AND "6.2 mm diameter".
// Usually, "D-shape" implies the flat side is a chord, and the distance from that chord to the arc is the "depth" of the D.
// If Diameter = 6.2 and Depth (flat to arc) = 4.7.
// Then the distance from the center to the flat chord is:
// Center_to_Flat = Radius - Depth = 3.1 - 4.7 = -1.6.
// This means the flat chord is on the OTHER side of the center?
// No, Depth = Radius + |Center_to_Flat|.
// 4.7 = 3.1 + |Center_to_Flat| => |Center_to_Flat| = 1.6.
// So the flat chord is 1.6 mm from the center.
// Let's check the chord length for a chord 1.6mm from center in a 6.2mm circle.
// Chord = 2 * sqrt(3.1^2 - 1.6^2) = 5.31 mm.
// The prompt says "6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm".
// This implies the resulting shape has a flat face and an arc face, and the distance between them is 4.7.
// The width of the flat face is determined by the geometry.
// So:
// 1. Circle Radius = 3.1.
// 2. Flat face is a chord.
// 3. Distance from flat face to arc tip = 4.7.
// 4. Distance from center to flat face = 3.1 - 4.7 = -1.6? No, distance is absolute.
//    If the flat is at X = 1.6, the arc tip is at X = -3.1. Distance = 4.7. Correct.
//    So the flat face is at X = 1.6.
//    The width of the flat face (chord length) is 2 * sqrt(3.1^2 - 1.6^2) = 5.31 mm.
//    This seems consistent. The user might have measured the "depth" of the D as 4.7.
//