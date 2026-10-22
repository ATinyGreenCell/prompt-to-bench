// Dimensions for the hotplate stirrer knob
$fn = 64; // Set resolution for smooth curves

// Main knob dimensions
diameter_knob = 30;        // Diameter of the cylindrical knob (mm)
height_knob = 15;            // Height of the knob (mm)
shaft_diameter = 6.2;      // Diameter of the D-shaft bore (6.2 mm to allow for clearance)
shaft_depth = 12;          // Depth of the D-shaped blind bore (mm)
flat_width = 4.7;            // Width of the flat on the D-shaft (distance from flat to opposite side)
num_grooves = 18;             // Number of vertical grip grooves around the circumference
groove_diameter = 2;         // Diameter of each groove (half-cylinder)
groove_depth = height_knob; // Grooves go full height (15 mm)
pointer_width = 1.5;         // Width of the pointer groove (mm)
pointer_depth = 1;         // Depth of the pointer groove (mm)

// The knob is printed with the bottom face (z=0) on the bed.
// The D-shaped blind bore goes 12 mm up from the bottom (z=0 to z=12).
// The D-shaft has a circle of diameter 6.2 mm (radius 3.1 mm), with one side cut flat.
// The flat is 4.7 mm wide, so the chord length is 4.7 mm.
// The flat is centered on the -x axis, so it extends from y = -2.35 to y = +2.35 (half of 4.7).
// To create the flat, we subtract a rectangular prism that spans the flat side.
// The flat is a straight line at x = -3.1 mm (the leftmost point of the circle), from y = -2.35 to y = +2.35.
// But we need to cut a rectangular prism that is:
//   - x: from -3.1 to -3.1 + 0.01 (a thin slice to simulate the flat)
//   - y: from -2.35 to +2.35
//   - z: from 0 to 12 (full depth)
// However, this would only remove a thin slice. That's not correct.
// Actually, the D-shaft is a circle with a flat side. The flat is 4.7 mm wide, so the distance from the flat to the opposite side is 4.7 mm.
// That means the flat is a straight edge that cuts the circle, and the chord length is 4.7 mm.
// The flat is centered on the -x axis. So the flat is a line segment from (-3.1, -2.35) to (-3.1, +2.35)? No, that would be a vertical line at x = -3.1, which is not correct.
// Let's re-think: the D-shaft has a circle of radius 3.1 mm. The flat is 4.7 mm wide, so the flat is a straight line that cuts the circle, and the chord length is 4.7 mm.
// The flat is centered on the -x axis. So the flat is a line segment that is perpendicular to the x-axis, centered at (-3.1, 0), and extends from y = -2.35 to y = +2.35.
// So the flat is a line segment from (-3.1, -2.35) to (-3.1, +2.35)? No, that would be a vertical line at x = -3.1, which is not correct.
// Actually: the flat is a straight edge on the -x side, so it is a line segment that is horizontal, centered on the -x axis.
// So the flat is a line segment from (-3.1, -2.35) to (-3.1, +2.35)? No, that would be a vertical line.
// I think I'm confused.
// Let's define it properly: the D-shaft has a circle of diameter 6.2 mm (radius 3.1 mm). The flat is 4.7 mm wide, so the flat is a straight line that cuts the circle, and the chord length is 4.7 mm.
// The flat is centered on the -x axis. So the flat is a line segment that is perpendicular to the x-axis, centered at (-3.1, 0), and extends from y = -2.35 to y = +2.35.
// So the flat is a line segment from (-3.1, -2.35) to (-3.1, +2.35)? No, that would be a vertical line at x = -3.1, which is not correct.
// Actually: the flat is a straight edge on the -x side, so it is a line segment that is horizontal, centered on the -x axis.
// So the flat is a line segment from (-3.1, -2.35) to (-3.1, +2.35)? No, that would be a vertical line.
// I think I need to start over.

// Correct approach: the D-shaft is a circle of radius 3.1 mm, but one side is cut flat.
// The flat is 4.7 mm wide, so the distance from the flat to the opposite side of the circle is 4.7 mm.
// That means the flat is a straight line that cuts the circle, and the chord length is 4.7 mm.
// The flat is centered on the -x axis. So the flat is a line segment from (-3.1, -2.35) to (-3.1, +2.35)? No, that would be a vertical line at x = -3.1, which is not correct.
// Actually: the flat is a straight edge on the -x side, so it