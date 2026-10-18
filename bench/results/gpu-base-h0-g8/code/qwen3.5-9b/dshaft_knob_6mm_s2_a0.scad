// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Units: mm
// Orientation: Bottom face (D-flat side) on Z=0, building upward.

$fn = 128; // High resolution for smooth curves and precise D-shape

// --- Dimensions ---
// Outer Cylinder
D_OUTER = 30;
H_TOTAL = 15;

// Shaft Bore (D-shape)
D_SHAFT_CIRCLE = 6.2;
D_SHAFT_FLAT = 4.7; // Distance from flat to opposite arc
H_BORE = 12;

// Grip Grooves
N_GROOVES = 18;
D_GROOVE = 2; // Diameter of the half-cylinder groove
H_GROOVE = H_TOTAL; // Full height

// Top Pointer Groove
W_POINTER = 1.5;
D_POINTER = 1; // Depth

// --- Calculations ---
// Radius of the outer cylinder
R_OUTER = D_OUTER / 2;

// Geometry of the D-shape bore
// The D-shape is defined by a circle of D_SHAFT_CIRCLE with a chord cut.
// The distance from the center of the circle to the flat face is:
// R_shaft = D_SHAFT_CIRCLE / 2
// Distance from center to flat = R_shaft - (D_SHAFT_FLAT / 2)
R_SHAFT = D_SHAFT_CIRCLE / 2;
DIST_CENTER_TO_FLAT = R_SHAFT - (D_SHAFT_FLAT / 2);

// Angle of the flat face relative to the vertical axis (Z)
// cos(theta) = adjacent / hypotenuse = DIST_CENTER_TO_FLAT / R_SHAFT
// theta is the angle from the Z-axis to the flat face normal.
// We need the angle of the flat face itself.
// If the flat is at distance 'd' from center, the angle from the vertical (Z) to the flat plane is acos(d/R).
// Let's define the rotation such that the flat face is at a specific angle.
// We will rotate the bore 90 degrees around X so the flat is vertical initially, 
// then rotate around Z to align the flat with the pointer groove.

// --- Main Body ---
difference() {
    // 1. Create the main D-shaped cylinder
    // We extrude a 2D D-shape profile.
    // The D-shape profile: A circle with a rectangular cutout on one side.
    // To make it a solid D-cylinder, we can use a polygon or a difference of a cylinder and a prism.
    // Method: Extrude a polygon representing the D-cross-section.
    
    // Define the D-profile in 2D (X, Y plane)
    // Center at (0,0). Circle radius R_SHAFT.
    // Flat face is vertical at x = -DIST_CENTER_TO_FLAT.
    // The flat extends from y = -R_SHAFT to y = R_SHAFT.
    
    // We will build the solid by rotating a 2D profile 360 degrees.
    // The 2D profile is a circle minus a rectangle.
    
    // Let's create the solid D-cylinder directly using a polygon extrusion for the cross section,
    // then rotate it 360.
    // Actually, simpler: Create a cylinder, then subtract a prism that creates the flat.
    
    // Step A: Base Cylinder (Round)
    // We need a cylinder with diameter D_SHAFT_CIRCLE.
    // But we want the final part to be D_OUTER.
    // So we start with a full cylinder of D_OUTER, then cut the D-bore.
    
    // Let's construct the D-bore as a separate object to subtract.
    // The D-bore is a cylinder of diameter D_SHAFT_CIRCLE, but with one side flat.
    // We can make this by taking a cylinder of D_SHAFT_CIRCLE and subtracting a rectangular prism
    // that removes the "flat" part of the circle? No, that's complex.
    
    // Better approach for the D-bore:
    // Create a cylinder of diameter D_SHAFT_CIRCLE.
    // Cut a rectangular slot on the side? No, the flat is part of the bore wall.
    // The bore is the space inside.
    // The solid material is outside the bore.
    // So we need to subtract a shape that represents the D-shaped hole.
    
    // Shape to subtract: A cylinder of diameter D_SHAFT_CIRCLE, but with a flat side.
    // This shape can be created by rotating a 2D D-profile (circle with a flat side) 360 degrees.
    // The 2D profile is a circle of radius R_SHAFT, but the boundary is modified.
    // Actually, the "D" shape usually means a circle with a chord cut off.
    // The chord length is D_SHAFT_FLAT.
    // The distance from the circle center to the chord is DIST_CENTER_TO_FLAT.
    
    // Let's create the D-bore solid using a polygon extrusion rotated 360.
    // The polygon is in the XZ plane (or XY). Let's use XY for the cross section.
    // Points:
    // Start at bottom of circle: (0, -R_SHAFT)
    // Go along arc to top: (0, R_SHAFT)
    // Go down the flat side: (0, R_SHAFT) -> (-DIST_CENTER_TO_FLAT, R_SHAFT)
    // Go along flat: (-DIST_CENTER_TO_FLAT, R_SHAFT) -> (-DIST_CENTER_TO_FLAT, -R_SHAFT)
    // Go down to start: (-DIST_CENTER_TO_FLAT, -R_SHAFT) -> (0, -R_SHAFT)
    
    // Wait, the flat is a straight line. The arc connects the ends of the flat.
    // The flat is vertical in our local coordinate system before rotation?
    // Let's define the D-shape in the XZ plane, where Z is the axis of the knob.
    // The flat face will be at some angle.
    
    // Let's create the D-bore as a rotated extrusion.
    // Profile in XZ plane:
    // A circle of radius R_SHAFT centered at (0,0).
    // Cut a rectangle of width (D_SHAFT_FLAT) and height (2*R_SHAFT) ? No.
    // The D-shape is the area inside the circle, bounded by the arc and the flat chord.
    // The flat chord is a straight line segment.
    // The distance from the center of the circle to the chord is DIST_CENTER_TO_FLAT.
    // The chord is perpendicular to the radius that bisects it.
    
    // Let's define the profile in the XZ plane.
    // The "flat" side of the D will be at X = -DIST_CENTER_TO_FLAT.
    // The arc is part of the circle x^2 + z^2 = R_SHAFT^2.
    // The flat connects (-DIST_CENTER_TO_FLAT, -R_SHAFT) to (-DIST_CENTER_TO_FLAT, R_SHAFT).
    // Wait, if the flat is at x = -d, and the circle is x^2+z^2=R^2.
    // At x = -d, z = +/- sqrt(R^2 - d^2).
    // But we want the flat to be the full diameter of the "D" part?
    // The problem says: "6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
    // This implies the flat face is a chord of the circle.
    // The distance from the flat face to the farthest point on the arc is 4.7 mm.
    // The diameter is 6.2 mm.
    // So the flat face is a chord.
    // The distance from the center of the circle to the flat face is:
    // R - (4.7 / 2) = 3.1 - 2.35 = 0.75 mm.
    // So the flat face is at x = -0.75 (if center is 0).
    // The flat face extends from z = -sqrt(3.1^2 - 0.75^2) to +sqrt(...).
    // Let's calculate the half-width of the flat face.
    // h_flat = sqrt(R_SHAFT^2 - DIST_CENTER_TO_FLAT^2)
    // h_flat = sqrt(3.1^2 - 0.75^2) = sqrt(9.61 - 0.5625) = sqrt(9.0475) = 3.0079 mm.
    // Total width of flat face = 6.0158 mm.
    // This is very close to the diameter 6.2.
    
    // So the D-bore profile in XZ plane:
    // It is the area enclosed by:
    // 1. The arc of the circle from (h_flat, -R_SHA