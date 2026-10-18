// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Orientation: Bottom face (with D-bore) rests on Z=0.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Knob Body
D_KNOB = 30;      // Outer diameter
H_KNOB = 15;      // Total height
R_KNOB = D_KNOB / 2;

// D-Shaft Bore
SHAFT_D = 6.2;    // Nominal bore diameter
SHAFT_H = 12;     // Depth of bore
SHAFT_R = SHAFT_D / 2;
SHAFT_FLAT_WIDTH = 4.7; // Distance from flat to opposite side (defines the cut)

// Grip Grooves
N_GROOVES = 18;   // Number of grooves
D_GROOVE = 2;     // Groove diameter (half-cylinder)
H_GROOVE = H_KNOB; // Full height

// Top Pointer
W_POINTER = 1.5;  // Width of pointer groove
D_POINTER = 1;    // Depth of pointer groove

// --- Calculations ---
// Calculate the radius of the flat side of the D-bore
// Distance from center to flat = (Diameter - FlatWidth) / 2
SHAFT_FLAT_RADIUS = (SHAFT_D - SHAFT_FLAT_WIDTH) / 2;

// --- Main Body ---
// Cylinder with D-shaped cross-section
// We create a full circle and subtract the segment that makes the flat side.
// The flat side is at angle 0 (positive X).
difference() {
    // 1. Main D-shaped Cylinder
    union() {
        // Full cylinder
        cylinder(h = H_KNOB, d = D_KNOB, center = [0, 0, H_KNOB/2]);
        
        // Subtract the "flat" segment to make it D-shaped
        // The segment is defined by the chord at distance SHAFT_FLAT_RADIUS from center
        // We use a polygon rotated around Z to create the flat face profile
        // Profile points: Top of circle, Right of circle, Bottom of circle, Left of circle (flat side)
        // Actually, simpler: Create a D-shape polygon and extrude.
        
        // Let's build the D-shape polygon explicitly
        // Points: (R, 0), (R, R), (-R, R), (-R, -R), (R, -R) -> This is a square.
        // We need a circle with a flat side.
        // Points: (R, 0) [Right], (0, R) [Top], (-R, 0) [Left], (0, -R) [Bottom]
        // Flat side connects (-SHAFT_FLAT_RADIUS, 0) to (SHAFT_FLAT_RADIUS, 0)? 
        // No, the flat side is the chord. The distance from center to chord is SHAFT_FLAT_RADIUS.
        // The chord endpoints are at y = +/- sqrt(R^2 - SHAFT_FLAT_RADIUS^2).
        
        // Let's define the D-shape using a polygon for the cross section
        // Center of knob is at [0,0,H_KNOB/2].
        // We will extrude a polygon along Z.
        
        polygon(
            points = [
                [R_KNOB, 0],           // Rightmost point
                [R_KNOB, R_KNOB],      // Top
                [-R_KNOB, R_KNOB],     // Left
                [-R_KNOB, -R_KNOB],    // Bottom
                [R_KNOB, -R_KNOB]      // Right
            ],
            extrude_height = H_KNOB,
            convexity = 3
        );
        
        // Wait, the above polygon creates a square. I need a circle with a flat side.
        // Let's use a different approach: Union of a cylinder and a "cap" or just subtract the segment.
        // Approach: Start with full cylinder, subtract the segment defined by the flat.
        
        // To subtract the flat side segment:
        // We need a shape that is a rectangle of width (SHAFT_FLAT_WIDTH) and height (D_KNOB), 
        // but curved on the sides? No.
        // The flat side is a straight line. The rest is circular.
        // Let's construct the D-shape by unioning a rectangle and a semi-circle? No, the flat isn't necessarily diameter.
        
        // Correct approach for D-shape:
        // 1. Full Cylinder.
        // 2. Subtract a "segment" cylinder.
        // The segment is bounded by the chord (the flat) and the arc.
        // The chord is at x = SHAFT_FLAT_RADIUS (if flat is on the right).
        // Wait, the user said "distance from the flat to the opposite side of the circle is 4.7mm".
        // Diameter = 6.2mm.
        // So the flat is at x = (6.2 - 4.7)/2 = 0.75mm from center?
        // Let's re-read: "distance from the flat to the opposite side of the circle is 4.7 mm".
        // Opposite side is the far edge of the circle.
        // So Flat is at x = R - 4.7.
        // R = 3.1.
        // Flat position x = 3.1 - 4.7 = -1.6? That would mean the flat is on the left.
        // Or is it: The flat face has a width of 4.7mm?
        // "distance from the flat to the opposite side" usually means the depth of the flat cut.
        // If the circle diameter is 6.2, and the flat is 4.7 deep from the edge, then the flat is 1.5mm from the center.
        // Let's assume the flat is a chord. The distance from the center to the chord is (R - 4.7).
        // R = 3.1. Distance = 3.1 - 4.7 = -1.6. This implies the flat is on the other side?
        // Let's try the other interpretation: The flat side width is 4.7mm.
        // If the flat side width is 4.7mm, then the distance from center to flat is sqrt(3.1^2 - (4.7/2)^2) = sqrt(9.61 - 5.5225) = sqrt(4.0875) = 2.02mm.
        // This seems physically plausible for a D-shaft (flat is near the edge).
        // BUT the prompt says: "distance from the flat to the opposite side of the circle is 4.7 mm".
        // This phrasing "distance from A to B" usually implies the linear distance between them.
        // A = Flat surface. B = Opposite side (edge of circle).
        // So the length of the flat segment is 4.7mm? No, "distance from the flat... to the opposite side".
        // If I measure from the flat face to the back of the knob, it's 4.7mm.
        // So the flat face is located at x = R - 4.7 = 3.1 - 4.7 = -1.6mm.
        // This means the flat is on the LEFT side (negative X).
        // The "opposite side" is the rightmost point of the circle (x = +3.1).
        // Distance = 3.1 - (-1.6) = 4.7. Correct.
        // So the flat is a chord at x = -1.6mm.
        // The width of this chord is 2 * sqrt(R^2 - x^2) = 2 * sqrt(3.1^2 - 1.6^2) = 2 * sqrt(9.61 - 2.56) = 2 * sqrt(7.05) = 2 * 2.655 = 5.31mm.
        
        // Let's proceed with this geometry:
        // Flat is at x = -1.6mm.
        // We need to subtract the segment defined by x < -1.6mm.
        
        // To do this in OpenSCAD:
        // Create a cylinder of diameter D_KNOB.
        // Subtract a shape that is a rectangle of width (D_KNOB - 4.7) and height D_KNOB? No.
        // We need to subtract the area where x < -1.6.
        // This area is bounded by x = -1.6 and the circle arc.
        // We can create a polygon profile for this subtraction.
        // Points: (-1.6, -R), (-1.6, R), (R, R), (R, -R), (-1.6, -R).
        // Extrude this polygon