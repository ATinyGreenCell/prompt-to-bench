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

// Create base knob cylinder: centered on origin, bottom at z=0
// Use center=false so bottom is at z=0
cylinder(h = knob_height, d = knob_diameter, center = false);

// Cut D-shaped blind bore: 12 mm deep, from z=0 to z=12
// The D-shape has a flat side of 4.7 mm, and a circle of diameter 6.2 mm
// So the circle has radius 3.1 mm
// The flat side is 4.7 mm, so the chord length is 4.7 mm
// The angle θ from center to each end of the flat side: θ = asin( (4.7/2) / 3.1 ) = asin(2.35 / 3.1) ≈ 50.3°
// So the D-shape spans from -50.3° to +50.3° on the bottom, and the rest is a semicircle

// Define the D-shape polygon: start at the left end of the flat side, go along the flat, then follow the arc to the right end
// The flat side is at the bottom, so the flat side is from (-2.35, -3.1) to (2.35, -3.1), but these points are not on the circle

// Correct: the flat side is a straight line of length 4.7 mm, and the curved side is a circle of radius 3.1 mm
// The two endpoints of the flat side are at angle θ = -90° ± 50.3° from the vertical? No.

// Actually, the D-shape has the flat side on one side, so the flat side is vertical? No, the D-shaft has the flat side on one side, so the flat side is on the side of the shaft

// The D-shaft has a flat side of 4.7 mm, so the diameter is 6.2 mm, so the radius is 3.1 mm
// The flat side is 4.7 mm, so the two points on the circle are at angle θ from the center, where the chord length is 4.7 mm
// The angle between the two radii to the endpoints of the flat side is: θ = 2 * asin( (4.7/2) / 3.1 ) = 2 * asin(2.35 / 3.1) ≈ 2 * 50.3° = 100.6°
// So the D-shape is a circle of radius 3.1 mm, with a chord of 4.7 mm, spanning an angle of 100.6°

// But the flat side is on the side, so the chord is on the side, so the D-shape is a circle with a flat side on the side

// We'll define the D-shape as a polygon: start at the bottom of the circle (0, -3.1), go to the left end of the flat side, then follow the arc to the right end of the flat side, then back to the bottom

// Actually, the D-shape has a flat side of 4.7 mm, so the two endpoints are at angle -50.3° and +50.3° from the vertical? No.

// Let's define the D-shape: the flat side is 4.7 mm, so the two points are at:
// - x = 3.1 * sin(θ), y = -3.1 * cos(θ), where θ is from the negative y-axis
// - The chord length between two points at angles θ1 and θ2 is 2 * 3.1 * sin( (θ2 - θ1)/2 )
// - We want chord length = 4.7 mm, so 2 * 3.1 * sin(Δθ/2) = 4.7 → sin(Δθ/2) = 4.7 / (2*3.1) = 4.7 / 6.2 = 0.758 → Δθ/2 = asin(0.758) ≈ 49.5° → Δθ ≈ 99.0°

// So the D-shape spans an angle of 99.0° on one side, and the flat side is 4.7 mm

// But for simplicity, we can define the D-shape as a polygon with:
// - Start at (0, -3.1) — bottom of the circle
// - Go to (2.35, -3.1) — right end of flat side
// - Then follow the arc of the circle from angle 0° to 180° to 360°? No.

// Actually, the D-shape has a flat side of 4.7 mm, so the two endpoints are at:
// - (3.1 * sin(α), -3.1 * cos(α)) and (3.1 * sin(α), -3.1 * cos(α)) with α = 49.5°? No.

// Let's do it numerically:
// The two points on the circle are at angles θ and -θ from the vertical, where the chord length is 2 * 3.1 * sin(θ) = 4.7 → sin(θ) = 4.7 / (2*3.1) = 0.758 → θ = asin(0.758) ≈ 49.5°
// So the two points are at angles 90° - 49.5° = 40.5° and 90° + 49.5° = 139.5° from the positive x-axis? No.

// Let's define the circle centered at (0,0). The flat side is on the bottom, so the two endpoints are at angles:
// - θ1 = 180° - 49.5° = 130.5° from positive x-axis
// - θ2 = 180° + 49.5° = 229.5° from positive x-axis
// But that would be on the left and right.

// Actually, the flat side is on the bottom, so the two endpoints are at angles:
// - θ = 90° + 49.5° = 139.5° and θ = 90° - 49.5° = 40.5° from positive x-axis? No.

// Let's define: the flat side is horizontal, so the two endpoints are at angles θ and -θ from the negative y-axis.

// The negative y-axis is 270° from positive x-axis.
// So the two points are at 270° - 49.5° = 220.5° and 270° + 49.5° = 319.5° from positive x-axis.

// So the D-shape polygon: start at (3.1 * cos(220.5°), 3.1 * sin(220.5°)) = (3.1 * cos(220.5), 3.1 * sin(220.5))
// But we want the flat side to be on the bottom, so the flat side is from (x1, y1) to (x2, y2), where y1 = y2 = -3.1 * cos(49.5°) ≈ -3.1 * 0.65 = -2.015, and x1 = -3.1 * sin(49.5°) ≈ -3.1 * 0.76 = -2.356, x2 = 3.1 * sin(49.5°) ≈ 2.356

// So the two points are at (-2.356, -2.015) and (2.356, -2.015), and the rest of the circle is from (2.356, -2.015) to (-2.356, -2.015) through the top (0,3.1)

// But that would be a semicircle of radius 3.1 mm, but the points are not at the bottom.

// The distance from center to each point: sqrt(2.356^2 + (-2.015)^2) = sqrt(5.55 + 4.06) = sqrt(9.61) = 3.1 —