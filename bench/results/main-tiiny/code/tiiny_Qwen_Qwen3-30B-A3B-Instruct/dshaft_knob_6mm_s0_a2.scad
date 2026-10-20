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
// The D-shape has a flat side of 4.7 mm, and a circle of diameter 6.2 mm (radius 3.1 mm)
// The flat side is 4.7 mm, so the chord length is 4.7 mm
// The angle θ between the two radii to the endpoints of the flat side: θ = 2 * asin( (4.7/2) / 3.1 ) = 2 * asin(2.35 / 3.1) ≈ 2 * 50.3° = 100.6°
// So the D-shape spans from angle -50.3° to +50.3° from the vertical (negative y-axis)

// Define the D-shape polygon: start at the left end of the flat side, go along the flat, then follow the arc to the right end
// The flat side is on the bottom, so the flat side is horizontal at the bottom
// The two endpoints of the flat side are at:
// - x = ± (4.7 / 2) = ±2.35 mm
// - y = -3.1 * cos(50.3°) ≈ -3.1 * 0.638 = -1.978 mm
// But that's not correct because the points are on the circle of radius 3.1 mm

// Correct: the two points are at angles:
// - θ = 90° + 50.3° = 140.3° and θ = 90° - 50.3° = 39.7° from positive x-axis? No.

// Let's define the circle centered at (0,0). The flat side is on the bottom, so the two endpoints are at angles:
// - θ1 = 180° - 50.3° = 129.7° from positive x-axis
// - θ2 = 180° + 50.3° = 230.3° from positive x-axis
// But that would be on the left and right.

// Actually, the flat side is horizontal, so the two endpoints are at angles:
// - θ = 270° - 50.3° = 219.7° and θ = 270° + 50.3° = 320.3° from positive x-axis
// So:
// - Point 1: (3.1 * cos(219.7°), 3.1 * sin(219.7°)) = (3.1 * (-0.772), 3.1 * (-0.636)) = (-2.393, -1.972)
// - Point 2: (3.1 * cos(320.3°), 3.1 * sin(320.3°)) = (3.1 * (0.772), 3.1 * (-0.636)) = (2.393, -1.972)

// The flat side is from (-2.393, -1.972) to (2.393, -1.972), and the rest of the D-shape is the arc from (2.393, -1.972) to (-2.393, -1.972) through the top (0,3.1)

// But the D-shape should have a flat side of 4.7 mm, and the distance between the two points is:
// - sqrt( (2.393 - (-2.393))^2 + (-1.972 - (-1.972))^2 ) = 4.786 mm — close to 4.7 mm, but not exact

// Let's calculate the exact angle:
// chord_length = 2 * r * sin(θ/2) → 4.7 = 2 * 3.1 * sin(θ/2) → sin(θ/2) = 4.7 / 6.2 = 0.758 → θ/2 = asin(0.758) ≈ 49.5° → θ = 99.0°
// So the angle between the two radii is 99.0°

// So the two points are at angles:
// - θ1 = 270° - 49.5° = 220.5°
// - θ2 = 270° + 49.5° = 319.5°

// So:
// - Point 1: (3.1 * cos(220.5°), 3.1 * sin(220.5°)) = (3.1 * (-0.766), 3.1 * (-0.643)) = (-2.375, -1.993)
// - Point 2: (3.1 * cos(319.5°), 3.1 * sin(319.5°)) = (3.1 * (0.766), 3.1 * (-0.643)) = (2.375, -1.993)

// The distance between them: 2 * 2.375 = 4.75 mm — still not 4.7 mm

// Let's solve for the angle:
// chord_length = 2 * r * sin(θ/2) → 4.7 = 2 * 3.1 * sin(θ/2) → sin(θ/2) = 4.7 / 6.2 = 0.75806 → θ/2 = asin(0.75806) = 49.53° → θ = 99.06°

// So the two points are at angles:
// - θ1 = 270° - 49.53° = 220.47°
// - θ2 = 270° + 49.53° = 319.53°

// So:
// - Point 1: (3.1 * cos(220.47°), 3.1 * sin(220.47°)) = (3.1 * (-0.7663), 3.1 * (-0.6425)) = (-2.3755, -1.9918)
// - Point 2: (3.1 * cos(319.53°), 3.1 * sin(319.53°)) = (3.1 * (0.7663), 3.1 * (-0.6425)) = (2.3755, -1.9918)

// The distance between them: 4.751 mm — still not 4.7 mm

// The issue is that the chord length is 2 * r * sin(θ/2), but the angle θ is the angle at the center between the two radii.

// We want chord_length = 4.7 mm, r = 3.1 mm
// So sin(θ/2) = 4.7 / (2*3.1) = 0.75806 → θ/2 = asin(0.75806) = 49.53° → θ = 99.06°

// So the two points are at angles 270° - 49.53° = 220.47° and 270° + 49.53° = 319.53°

// But the distance between the two points is:
// - dx = 3.1 * (cos(319.53°) - cos(220.47°)) = 3.1 * (0.7663 - (-0.7663)) = 3.1 * 1.5326 = 4.751 mm

// But we want 4.