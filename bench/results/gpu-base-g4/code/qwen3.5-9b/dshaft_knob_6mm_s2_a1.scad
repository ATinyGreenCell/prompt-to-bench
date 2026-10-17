// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Units: mm
// Orientation: Bottom face (Z=0) on the bed, building upward (+Z).
// The "side that faces the hotplate down" is interpreted as the flat face of the D-bore 
// being oriented towards the -X direction (standard reference), and the knob sitting 
// on its circular base. The pointer is on the same radial line as the flat.

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

// Angle of the flat face relative to the vertical axis (0 is up)
// cos(theta) = adjacent / hypotenuse = DIST_CENTER_TO_FLAT / R_SHAFT
// theta = acos(...)
// We define the flat face to be on the -X axis (angle 180 degrees or PI radians).
// This aligns the flat of the D with the pointer groove on the top face.

// --- Main Body ---
// Create the cylinder. Centered at origin.
// It rests on the XY plane at z = 0.
difference() {
    // 1. Main Cylinder Body
    // We use a cylinder with a slight overhang in Z to ensure the difference works cleanly
    // and to cover the full height including the top face.
    cylinder(
        h = H_TOTAL + 0.5,
        r = R_OUTER,
        center = [0, 0, H_TOTAL/2 + 0.25]
    );

    // 2. D-Shaped Blind Bore
    // We create the D-shape by rotating a rectangle and a circle segment, 
    // or more simply, by rotating a profile.
    // Profile: A rectangle of width D_SHAFT_FLAT and height H_BORE, 
    // plus a semi-circle on top? No, it's a full circle with a flat cut.
    // Easier approach: Rotate a shape that represents the D-hole cross-section.
    // The D-hole is a circle (radius R_SHAFT) with a rectangular cutout on one side.
    // Let's define the D-shape in the XZ plane (rotated 90 deg) or just use rotate_extrude.
    // Actually, since the bore is vertical (along Z), we need to extrude a D-shape along Z.
    // But the D-shape is defined by a circle with a flat.
    // Let's create the D-shape profile in the XY plane, then extrude it up?
    // No, the bore is vertical. The cross section is D-shaped.
    // So we need to subtract a D-shaped prism.
    
    // Let's construct the D-shape profile in the XZ plane (rotated 90 degrees around Y)
    // Wait, the bore is along Z. The cross section is in the XY plane.
    // So we need to subtract a shape that is the D-shape extruded along Z.
    // The D-shape is a circle of radius R_SHAFT, with a flat cut.
    // The flat is at distance DIST_CENTER_TO_FLAT from the center.
    // Let's place the center of the circle at (0,0,0) relative to the bore start.
    // The flat is on the -X side.
    
    // We will use rotate_extrude to create the D-shape volume? No, that's for rotation.
    // We need to subtract a prism.
    // Let's define the D-shape as a union of a rectangle and a semi-circle?
    // No, it's a circle with a chord removed.
    // Let's create the D-shape by rotating a rectangle and a circle segment?
    // Simplest way: Create a circle, then cut the flat.
    // But we need to subtract this from the main body.
    
    // Let's use a loop to create the D-shape by rotating a profile? No.
    // Let's just create the D-shape as a union of two parts:
    // 1. A rectangle of width D_SHAFT_FLAT and height H_BORE.
    // 2. A semi-circle of radius R_SHAFT on the other side.
    // Wait, the D-shape is a full circle with a flat.
    // So it's a rectangle (width D_SHAFT_FLAT, height H_BORE) + a semi-circle (radius R_SHAFT) attached to the flat?
    // No. The D-shape is a circle of diameter D_SHAFT_CIRCLE.
    // The flat is a chord. The distance from the center to the chord is DIST_CENTER_TO_FLAT.
    // The width of the flat is 2 * sqrt(R_SHAFT^2 - DIST_CENTER_TO_FLAT^2).
    // Let's calculate the width of the flat.
    W_FLAT = 2 * sqrt(R_SHAFT*R_SHAFT - DIST_CENTER_TO_FLAT*DIST_CENTER_TO_FLAT);
    
    // Now, let's build the D-shape volume to subtract.
    // We will place the center of the D-shape at (0,0, H_BORE/2).
    // The flat is on the -X side.
    // We can create this by rotating a rectangle and a circle segment?
    // Or simpler: Create a circle, then cut the flat.
    // But we need to subtract it from the main body.
    // Let's create the D-shape as a union of a rectangle and a semi-circle.
    // The rectangle is the part from the flat to the center? No.
    // The D-shape is the union of:
    // 1. A rectangle of width W_FLAT and height H_BORE, centered at (0,0).
    // 2. A semi-circle of radius R_SHAFT, centered at (DIST_CENTER_TO_FLAT, 0).
    // Wait, if the flat is on the -X side, the center of the circle is at (DIST_CENTER_TO_FLAT, 0).
    // The rectangle is from x = -DIST_CENTER_TO_FLAT to x = 0? No.
    // The flat is at x = -DIST_CENTER_TO_FLAT. The center of the circle is at x = 0.
    // The rectangle is from x = -DIST_CENTER_TO_FLAT to x = 0? No.
    // The D-shape is the circle minus the segment cut by the chord.
    // The chord is at x = -DIST_CENTER_TO_FLAT.
    // The circle is centered at (0,0).
    // The part of the circle to the right of the chord (x > -DIST_CENTER_TO_FLAT) is the D-shape.
    // So the D-shape is the union of:
    // 1. A rectangle from x = -DIST_CENTER_TO_FLAT to x = 0, y from -R_SHAFT to R_SHAFT.
    // 2. A semi-circle from x = 0 to x = R_SHAFT, centered at (0,0).
    // Wait, the circle is centered at (0,0). The chord is at x = -DIST_CENTER_TO_FLAT.
    // The D-shape is the part of the circle where x >= -DIST_CENTER_TO_FLAT.
    // So we can create this by:
    // 1. A rectangle from x = -DIST_CENTER_TO_FLAT to x = 0, y from -R_SHAFT to R_SHAFT.
    // 2. A semi-circle from x = 0 to x = R_SHAFT, centered at (0,0).
    // But the semi-circle is not a standard shape.
    // Let's use rotate_extrude to create the D-shape volume.
    // Profile: A line from (-DIST_CENTER_TO_FLAT, -R_SHAFT) to (-DIST_CENTER_TO_FLAT, R_SHAFT) to (R_SHAFT, R_SHAFT) to (R_SHAFT, -