// Dimensions
$fn = 64;

// Knob overall dimensions
knob_diameter = 30;
knob_height = 15;

// D-shaft bore dimensions
d_shaft_diameter = 6.2;
d_shaft_flat_width = 4.7;
d_shaft_depth = 12;

// Groove dimensions
groove_diameter = 2;
groove_count = 18;
groove_depth = knob_height; // full height

// Pointer groove
pointer_width = 1.5;
pointer_depth = 1;

// Center the knob on origin in X and Y, bottom at z = 0
// Print orientation: bottom face (z=0) on bed, builds upward

// Create base knob cylinder
cylinder(h = knob_height, d = knob_diameter, center = false);

// Cut D-shaped blind bore from bottom (z=0) up to z = d_shaft_depth
// Use difference to remove material from the cylinder

// First, create the D-shaped bore: a circle with one side flat
// The D-shape has a flat side of width d_shaft_flat_width, and the full diameter is d_shaft_diameter
// So the circle has radius = d_shaft_diameter / 2 = 3.1 mm
// The flat is on one side, so we'll make a rectangle of width d_shaft_flat_width and height d_shaft_diameter,
// and subtract a half-circle from one side to form the D-shape

// But easier: use a cylinder with a rectangular cutout on one side
// We'll use a cylinder of diameter d_shaft_diameter, and subtract a rectangular prism from one side,
// but only for the depth of the bore

// Create a D-shaped hole: a circle with a flat side
// We'll make a cylinder of diameter d_shaft_diameter, and subtract a rectangular prism from one side,
// but only for the depth of the bore

// Instead, use a polygon to define the D-shape in the XY plane, then extrude it

// Define the D-shape: a semicircle with a flat side
// The flat side is d_shaft_flat_width = 4.7 mm, so the radius is 3.1 mm
// The D-shape is a circle of radius 3.1 mm, but with one side cut flat to 4.7 mm
// So the D-shape has a flat side of 4.7 mm and a curved side of radius 3.1 mm

// We'll define the D-shape as a polygon: start at the center of the flat side, go along the flat, then follow the arc

// Actually, simpler: use a cylinder of diameter d_shaft_diameter, and subtract a rectangular prism that is 4.7 mm wide and 6.2 mm high,
// but offset so it cuts one side of the cylinder

// But we need a D-shape, so we'll define a polygon that is a D-shape

// D-shape: a semicircle with a flat side of 4.7 mm
// The full diameter is 6.2 mm, so radius = 3.1 mm
// The flat side is 4.7 mm, so the D-shape is not a perfect semicircle — it's a circle with a flat side of 4.7 mm
// That means the chord length is 4.7 mm, and the radius is 3.1 mm

// We can compute the angle of the chord: angle = 2 * asin( (4.7/2) / 3.1 ) = 2 * asin(2.35 / 3.1) ≈ 2 * 50.3° ≈ 100.6°

// So the D-shape is a circle of radius 3.1 mm, with a chord of 4.7 mm, so the arc is 100.6° on one side, and the flat is 4.7 mm

// But for OpenSCAD, we can define the D-shape as a polygon: start at the center of the flat side, go to the end of the flat, then follow the arc

// Actually, let's do it differently: create a cylinder of diameter 6.2 mm, and subtract a rectangular prism that is 4.7 mm wide and 6.2 mm long, but only for the depth of the bore

// But that would leave a flat side of 4.7 mm, but the hole would be a rectangle with semicircular ends? No.

// Better: use a cylinder of diameter 6.2 mm, and subtract a rectangular prism that is 4.7 mm wide and 6.2 mm long, but only for the depth of the bore

// But that would not give a D-shape.

// Correct way: the D-shape is a circle with a flat side. So we can define a polygon that is a D-shape.

// Let's define the D-shape as a polygon with:
// - Start at (0, -3.1) — bottom of the circle
// - Go to (2.35, -3.1) — right end of flat
// - Then follow the arc of the circle to (2.35, 3.1) — top right
// - Then to (0, 3.1) — top of the circle
// - Then to (-2.35, 3.1) — top left
// - Then follow the arc to (-2.35, -3.1) — bottom left
// - Then to (0, -3.1) — back to start

// But that's a full circle. We want a D-shape: a circle with a flat side.

// Actually, the D-shape has a flat side of 4.7 mm, so the chord is 4.7 mm, so the two points are at (±2.35, y) where y is such that the distance from center is 3.1 mm

// The flat side is at the bottom, so the flat side is from (-2.35, -3.1) to (2.35, -3.1), and the rest is a semicircle

// But that would make the flat side at the bottom, and the curved side on top

// But the D-shaft has the flat side on one side, so we want the flat side to be on the side

// Actually, the D-shaft has a flat side of 4.7 mm, so the diameter is 6.2 mm, so the radius is 3.1 mm, and the flat side is 4.7 mm, so the chord length is 4.7 mm

// The angle θ from the center to each end of the flat side is: θ = asin( (4.7/2) / 3.1 ) = asin(2.35 / 3.1) ≈ 50.3°

// So the D-shape is a circle of radius 3.1 mm, with a flat side that spans from angle -50.3° to +50.3° on the bottom

// So the D-shape polygon: start at the center of the flat side (0, -3.1), go to (2.35, -3.1), then follow the arc from angle 50.3° to 180° to 230.3°? No.

// Actually, the D-shape has a flat side of 4.7 mm, so the two points are at:
// - (2.35, -3.1) and (-2.35, -3.1), and the rest is a semicircle from (-2.35, -3.1) to (2.35, -3.1) through the top

// But that would be a semicircle of radius 3.1 mm, but the chord is 4.7 mm, so the height of the arc is 3.1 mm, so the total height of the D-shape is 6.2 mm

// But the D-shaft has a flat side of 4.7 mm, so the D-shape has a flat side of 4.7 mm and a curved side of radius 3.1 mm

// So the D-shape polygon: start at (-2.35, -3.1), go to (2.35, -3.1), then follow the arc of the circle from angle 0° to 180° (but centered at origin)

// Actually, the circle is centered at (0,0), so the points are:
// - (-2.35, -3.1) and (2.35, -3.1) are on the circle: x^2 + y^2 = 3.1^2 = 9.61
// - (-2.35)^2 + (-3.1)^2 = 5.5225 + 9.61 = 15.1325 ≠ 9.61 — not on the circle

// So they are not on the circle.

// Let's calculate the correct points.

// The flat side is 4.7 mm, so the two points are at (±2.35, y), and they are on the circle of radius 3.