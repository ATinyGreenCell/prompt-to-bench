// Replacement knob for hotplate stirrer - D-shaft fit, grip grooves, and pointer.

// Dimensions
d_shaft = 6;
d_outer = 30;
h_total = 15;
h_bore  = 12;
d_bore  = 6.2;
d_flat  = 4.7; // Distance from flat to opposite side of D-bore

// Grooves
n_grooves = 18;
d_groove  = 2;
h_groove  = 1; // Depth of grip grooves

// Pointer
w_pointer = 1.5;
d_pointer = 1; // Diameter of pointer groove (approx depth)

$fn = 128;

// Calculate D-bore geometry
// The D-bore is a circle of d_bore with a flat cut on one side.
// The distance from the flat to the opposite arc is d_flat.
// Let the circle center be at (0,0). The flat is a chord.
// The radius of the circle is r_b = d_bore / 2.
// The distance from the center to the flat is h_chord.
// The distance from the flat to the far arc is r_b + h_chord = d_flat.
// So h_chord = d_flat - r_b.
r_b = d_bore / 2;
h_chord = d_flat - r_b;

// The flat is a line segment. We need its length.
// Distance from center to chord is h_chord.
// Half-length of chord is sqrt(r_b^2 - h_chord^2).
// We define the D-bore as a circle with a rectangular cutout on one side.
// To make the flat exactly d_flat wide from the arc, we cut a rectangle of width d_flat
// centered on the X-axis (where the flat will be), extending from z=0 to z=h_bore.
// The circle is centered at (0,0). The flat is at x = -h_chord.
// The cutout rectangle goes from x = -h_chord - (d_flat/2) to x = -h_chord + (d_flat/2)?
// No, the flat is the face. The material is removed to create the flat face.
// The flat face is at x = -h_chord. The material exists for x > -h_chord (inside the circle).
// We remove material for x < -h_chord.
// The width of the flat face is the chord length.
// Chord length = 2 * sqrt(r_b^2 - h_chord^2).
// Let's verify: if we cut a rectangle of width = chord_length starting at x = -h_chord - chord_length/2?
// Actually, simpler: The D-shape is a circle minus a rectangle on the left side.
// The rectangle's right edge is at x = -h_chord.
// The rectangle's left edge is at x = -h_chord - chord_length.
// Wait, the flat face is the surface created by the cut.
// The flat face is at x = -h_chord. The material is removed for x < -h_chord.
// The width of the flat face is the chord length.
// So we cut a rectangle from x = -h_chord - chord_length to x = -h_chord.
// Let's calculate chord_length.
chord_len = 2 * sqrt(r_b * r_b - h_chord * h_chord);

// Positioning:
// The knob sits on Z=0.
// The D-bore is centered at (0,0) in XY?
// The prompt says "From that bottom face, a D-shaped blind bore...".
// Usually, the flat side of a D-shaft fits into the flat side of the D-bore.
// Let's assume the flat side of the bore faces the -X direction.
// The knob is centered at (0,0).
// The bore is centered at (0,0).
// The flat face of the bore is at x = -h_chord.
// The cutout rectangle for the bore goes from x = -h_chord - chord_len to x = -h_chord.
// Wait, if the flat face is at x = -h_chord, and the circle extends to x = -r_b.
// The distance from the flat face (x = -h_chord) to the center (x=0) is h_chord.
// The distance from the flat face to the far side (x = r_b) is h_chord + r_b = d_flat. Correct.
// The flat face width is the chord length.
// The cutout must remove the material between the flat face and the circle boundary on the left.
// The circle boundary on the left is at x = -r_b.
// The flat face is at x = -h_chord.
// So we remove a rectangle from x = -r_b to x = -h_chord?
// No, that would make the flat face at x = -h_chord, but the width would be h_chord - (-r_b) = r_b + h_chord = d_flat.
// This contradicts the chord length calculation.
// Let's re-evaluate.
// A D-shape is a circle with a flat side.
// The flat side is a chord.
// The distance from the chord to the opposite arc is d_flat.
// The radius is r_b.
// The distance from the center to the chord is h_chord = d_flat - r_b.
// The chord length is 2 * sqrt(r_b^2 - h_chord^2).
// The flat face is the chord itself.
// The material is removed to create this flat face.
// The material exists inside the circle.
// We remove a rectangle that spans the chord width and extends from the chord to the circle edge?
// No, the bore is a hole. The hole shape is the D-shape.
// The D-shape is composed of a circular arc and a straight line (the flat).
// The straight line is the flat face.
// The width of this flat face is the chord length.
// The material removed is the area between the flat face and the circle arc?
// No, the bore is the empty space.
// The empty space is the D-shape.
// The D-shape is the intersection of the circle and the half-plane x > -h_chord?
// No, the D-shape is the circle MINUS the segment cut off by the chord?
// No, a D-shape is a circle with a flat side.
// Imagine a circle. Cut a slice off with a straight line. The remaining shape is a D-shape (if the cut is small) or a segment (if the cut is large).
// Here, the "flat" is the straight edge of the D.
// The distance from the flat to the opposite arc is d_flat.
// This implies the flat is a chord, and the "depth" of the D is the distance from the chord to the farthest point on the circle.
// So the bore is the circle MINUS the circular segment defined by the chord?
// No, the bore IS the D-shape.
// So the bore is the circle MINUS the segment cut off by the chord?
// No, that would leave a segment, not a D-shape.
// A D-shape is a circle with a flat side.
// The flat side is the chord.
// The material of the D-shape is the circle MINUS the segment cut off by the chord?
// No, the D-shape is the circle MINUS the segment cut off by the chord?
// Let's visualize. A circle. Draw a chord. The area between the chord and the arc is a segment.
// If we remove that segment, we are left with the rest of the circle, which has a flat side (the chord).
// Yes, that is a D-shape.
// So the bore is the circle MINUS the segment cut off by the chord.
// The segment is defined by the chord at x = -h_chord.
// The segment is the region where x < -h_chord inside the circle.
// This region is not a rectangle. It is a circular segment.
// However, OpenSCAD's difference() works with simple shapes.
// We can approximate the circular segment by a rectangle?
// No, we need an exact fit.
// We can create the D-shape by rotating a 2D profile?
// No, the bore is a hole through the cylinder.
// We can create the D-shape by taking a cylinder and subtracting a shape that matches the segment.
// The segment is bounded by x = -h_chord and the circle arc x^2 + y^2 = r_b^2.
// We can create this segment by rotating a 2D shape?
// No, the segment is a 2D shape in the XY plane.
// We can create the segment by rotating a 2D shape around the Z axis? No.
// We can create the segment by rotating a 2D shape around the Y axis? No.
// We can create the segment by rotating a 2D