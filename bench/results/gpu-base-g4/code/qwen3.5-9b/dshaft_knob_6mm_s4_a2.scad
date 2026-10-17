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
// Height of the D-shaft bore arc above the flat
H_bore_arc = Bore_flat_to_arc;

// --- Build ---

// 1. Create the main D-shaped cylinder body
// We construct the D-shape by taking a cylinder of diameter 6.2 and height 4.7,
// and subtracting a rectangular prism from the bottom to create the flat side.
// The resulting shape has a flat bottom face (for printing on Z=0) and a curved top.
// The flat side of the D is at the bottom (Z=0). The arc is on top.
// The width of the flat face is 6.2mm. The height of the arc is 4.7mm.

// Start with the full cylinder (Circle extruded)
// Center this cylinder at (0, 0, 0) initially, then we will translate it.
// Actually, let's define the shape in a local coordinate system where the flat face is at Z=0.
// The D-shape is a cylinder of diameter 6.2 and height 4.7, with a rectangular cutout on the bottom.
// The cutout is a cylinder of diameter 6.2 and height (4.7 - 3.1) = 1.6? No.
// Let's visualize:
// Full cylinder: Radius 3.1, Height 4.7. Center at (0, 0, 2.35).
// We want the bottom face to be flat.
// We want the "flat side" of the D to be the face at Z=0.
// The "flat side" of a D-shape usually refers to the flat face of the cross-section.
// The user says: "a 6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
// This implies the cross-section is a D-shape with width 6.2 and height 4.7.
// The flat face of the D-shape is at the bottom (Z=0).
// The arc is on top.
// The sides are vertical from the flat face up to the start of the arc?
// No, a D-shape is a circle with a chord cut off.
// If the width is 6.2 (diameter) and height is 4.7, the flat face is a chord.
// The distance from the chord to the arc is 4.7.
// The radius is 3.1.
// The distance from the center of the circle to the chord is:
// d = sqrt(R^2 - (W/2)^2) = sqrt(3.1^2 - 3.1^2) = 0?
// Wait, if the width is 6.2 and the diameter is 6.2, the chord is the diameter.
// If the chord is the diameter, the distance from the chord to the arc is the radius (3.1).
// But the user says the distance is 4.7.
// This implies the width of the flat face is NOT 6.2.
// OR, the "6.2 mm diameter circle" refers to the hole size, and the D-shape is formed by cutting a flat into it.
// If we cut a flat into a 6.2mm diameter cylinder, the width of the flat face will be less than 6.2mm.
// The user says "distance from the flat to the opposite side of the circle is 4.7 mm".
// This is the height of the D-shape.
// The width of the flat face is determined by the geometry of the circle cut.
// Let's assume the "6.2 mm diameter circle" is the bounding box width of the D-shape?
// No, "6.2 mm diameter circle" usually means the original cylinder.
// If the original cylinder is 6.2mm diameter, and we cut a flat, the resulting D-shape has a flat face.
// The distance from the flat face to the peak of the arc is 4.7mm.
// The radius of the circle is 3.1mm.
// The distance from the center of the circle to the flat face is:
// h_center = 4.7 - 3.1 = 1.6mm.
// The width of the flat face is:
// w_flat = 2 * sqrt(R^2 - h_center^2) = 2 * sqrt(3.1^2 - 1.6^2) = 2 * sqrt(9.61 - 2.56) = 2 * sqrt(7.05) = 2 * 2.655 = 5.31mm.
// So the D-shape has a flat face of width 5.31mm and height 4.7mm.
// The user might have measured the width as 6.2mm (the diameter of the shaft) and the height as 4.7mm.
// But geometrically, if the height is 4.7 and the radius is 3.1, the width cannot be 6.2.
// Let's assume the user's measurement of "6.2 mm diameter circle" refers to the width of the flat face,
// and the "distance from the flat to the opposite side" is 4.7mm.
// This would mean the shape is a rectangle 6.2x4.7 with a semi-circle on top?
// Or a circle of diameter 6.2, cut by a flat, resulting in a height of 4.7?
// If it's a circle of diameter 6.2 cut by a flat, the max height is 3.1 (if cut through center) or less.
// It cannot be 4.7.
// Therefore, the shape is likely a rectangle of width 6.2 and height 4.7, with a semi-circular top?
// Or a circle of diameter 6.2, and the "distance from the flat to the opposite side" is measured differently?
// Let's re-read carefully: "a 6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
// This is physically impossible for a single circle of diameter 6.2. The max distance from a chord to the arc is the radius (3.1).
// Unless the "6.2 mm diameter circle" is not the circle defining the curve, but the width of the flat part?
// Or maybe the user means the bounding box is 6.2 wide and 4.7 high, and the top is a circle arc?
// Let's assume the user wants a D-shape that fits a 6mm shaft, so the width is ~6mm.
// And the height is 4.7mm.
// The most logical interpretation for a printable part is:
// A shape with a flat bottom face (Z=0), a flat side face (the "flat" of the D), and a curved top.
// The width of the flat face is 6.2mm.
// The height of the shape is 4.7mm.
// The top is an arc of a circle with radius 3.1mm.
// This creates a shape that is 6.2mm wide at the bottom, and has a peak height of 4.7mm.
// The sides will be vertical from the bottom up to the start of the arc.
// The arc starts at y = 4.7 - 3.1 = 1.6mm.
// The x-coordinates of the arc start are +/- sqrt(3.1^2 - 1.6^2) = +/- 2.655mm.
// So the sides are vertical from x=3.1 to x=2.6