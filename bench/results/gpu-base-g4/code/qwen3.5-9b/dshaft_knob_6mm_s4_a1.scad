// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Dimensions measured with calipers.
// Print orientation: Bottom face (D-shaft side) on Z=0, building upward.

$fn = 128; // High resolution for smooth curves and accurate D-shape

// --- Main Dimensions ---
D_shaft_diameter = 6.0;
Knob_diameter = 30.0;
Knob_height = 15.0;
Bore_depth = 12.0;

// --- D-Shaft Bore Dimensions ---
// Circle diameter for the D-shape
Bore_circle_diameter = 6.2;
// Distance from flat side to opposite arc (chord to arc height)
Bore_flat_to_arc = 4.7;

// --- Groove Dimensions ---
Num_grooves = 18;
Groove_diameter = 2.0; // Full diameter of the half-cylinder cut
Groove_depth = 1.0;    // Depth of the half-cylinder cut

// --- Pointer Groove Dimensions ---
Pointer_width = 1.5;
Pointer_depth = 1.0;

// --- Calculations ---
// Radius of the main knob
R_knob = Knob_diameter / 2;
// Radius of the D-shaft bore circle
R_bore_circle = Bore_circle_diameter / 2;
// Radius of the D-shaft bore flat side (half the chord)
R_bore_flat = Bore_flat_to_arc / 2;
// Height of the D-shaft bore arc above the flat
H_bore_arc = Bore_flat_to_arc - R_bore_flat;

// --- Build ---

// 1. Create the main D-shaped cylinder body
// We extrude a 2D D-shape along Z.
// The D-shape is defined by a circle with a rectangular cut on one side.
// To ensure the flat side is at the bottom (Z=0) and the arc is on top,
// we define the 2D profile such that the flat is at y=0 and the arc extends to y=H_bore_arc.

// Define the D-shape in a temporary coordinate system where the flat is at Y=0
// and the center of the circle is at (0, H_bore_arc).
// Wait, the user said "distance from the flat to the opposite side of the circle is 4.7mm".
// This means the flat is a chord. The distance from the chord to the arc is 4.7.
// The circle diameter is 6.2, so radius is 3.1.
// If the flat is a chord, the distance from the center of the circle to the chord is:
// d = sqrt(R^2 - (chord/2)^2).
// Chord length = 2 * R_bore_flat = 4.7.
// d = sqrt(3.1^2 - 2.35^2) = sqrt(9.61 - 5.5225) = sqrt(4.0875) ≈ 2.02.
// So the flat is 2.02mm from the center. The distance from flat to arc is R - d = 3.1 - 2.02 = 1.08mm.
// BUT the user specified the distance is 4.7mm. This implies the "flat" is not a chord of the 6.2mm circle in the standard sense,
// OR the 6.2mm is the diameter of the hole, and the 4.7mm is the specific dimension of the D-shape cut.
// Re-reading: "a 6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
// This describes a D-shape where the bounding box height is 4.7mm.
// The width is 6.2mm.
// We will construct this shape explicitly using a polygon to ensure exact dimensions.

// Polygon points for the D-shape (Flat at bottom, Arc on top):
// Width = 6.2, Height = 4.7.
// The top corners of the polygon will be on the circle arc.
// Let's define the polygon vertices.
// Bottom: (-3.1, 0) to (3.1, 0).
// Top: We need the arc of a circle with diameter 6.2 (Radius 3.1).
// The center of this circle must be at (0, 4.7 - 3.1) = (0, 1.6).
// Let's verify: Distance from (0, 1.6) to (3.1, 0) is sqrt(3.1^2 + 1.6^2) = sqrt(9.61 + 2.56) = sqrt(12.17) = 3.49. Not 3.1.
// Okay, the shape is a circle of diameter 6.2, but the flat cut makes the total height 4.7.
// This means the flat is NOT a chord of the 6.2mm circle. The 6.2mm is the diameter of the *original* cylinder hole,
// and the D-shape is formed by cutting a flat into it.
// So the width is 6.2mm. The height is 4.7mm.
// The top curve is part of the 6.2mm circle.
// So the polygon is:
// (-3.1, 0) -> (3.1, 0) -> (3.1, 4.7) is wrong because the top is curved.
// The top corners are at x = +/- 3.1. The y-coordinate at x=3.1 on the circle (centered at 0, 1.6) is:
// y = 1.6 + sqrt(3.1^2 - 3.1^2) = 1.6.
// So the height at the edges is 1.6mm. But the user says the distance from flat to opposite side is 4.7mm.
// This implies the "opposite side" is the peak of the arc.
// So the shape is: Flat bottom at y=0. Top peak at y=4.7. Width at bottom = 6.2.
// The curve connects (3.1, 0) to (0, 4.7) to (-3.1, 0)? No, that's not a circle.
// Let's assume the standard D-shape: A circle of diameter 6.2, cut by a flat plane.
// If the diameter is 6.2, the radius is 3.1.
// If the distance from the flat to the peak is 4.7, then the flat is 4.7 - 3.1 = 1.6mm below the center.
// The width of the flat would be 2 * sqrt(3.1^2 - 1.6^2) = 2 * sqrt(9.61 - 2.56) = 2 * 2.69 = 5.38mm.
// But the user says "6.2 mm diameter circle... distance... is 4.7".
// This phrasing usually implies the bounding box is 6.2 wide and 4.7 high.
// Let's construct the shape as a circle of diameter 6.2, centered at (0, 1.6), and then cut a rectangle from the bottom.
// The rectangle will be from y=0 to y=1.6, and x from -3.1 to 3.1.
// This creates a shape that is 6.2 wide at the bottom and has a peak height of 4.7.
// The sides will be vertical from y=0 to y=1.6, then curve inwards.
// This matches the description "6.2 mm diameter circle with one side cut flat".

// Define the D-shape profile in the XY plane.
// We will create a circle and subtract a rectangle.
// Circle center: (0, 1.6). Radius: 3.1.
// Rectangle to subtract: x from -3.1 to 3.1, y from 0 to 1.6.
// This results in a shape with width 6.2 at the bottom and height 4.7 at the peak.

// Create the base cylinder (Circle)
// Translate so the center is at (0, 1.6) relative to the flat base at y=0.
// Actually, let's build the solid directly.
// Base cylinder: Radius 3.1, Height 4.7. Centered at (0, 1.6, 0) in local coords?
// No, let's use the difference approach.
// Start with a cylinder of radius 3.1 and height 4.7.
// Translate it so the top of the cylinder is at y=4.7 and the center is at y=1.6.
// Then subtract a cylinder of radius 3.1 and height 1.6