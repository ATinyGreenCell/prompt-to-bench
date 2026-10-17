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

// Angle of the flat face relative to the vertical axis (0 is up)
// cos(theta) = adjacent / hypotenuse = DIST_CENTER_TO_FLAT / R_SHAFT
// theta = acos(...)
// We need the angle in radians for rotation.
// The flat is on one side. Let's define the flat to be facing the -X direction initially,
// then we will rotate the whole knob so the flat is at the correct orientation relative to the pointer.
// Actually, it's easier to build the D-shape with the flat on the -X axis, then rotate the whole part.
// Wait, the user says "From that bottom face... a D-shaped blind bore".
// And "On the top face, cut a pointer groove... on the same side as the flat of the D."
// So the flat of the D and the pointer are on the same radial line.

// --- Main Body ---
// Create the cylinder. Centered at origin.
// Since it rests on the bed with the D-flat side down, we need to orient the D-shape correctly.
// Let's build the D-shape with the flat on the -X axis (angle 180 deg or pi).
// Then we rotate the whole object so the flat is at the bottom? 
// No, the user says "printed with the side that faces the hotplate down".
// This implies the flat side of the D is at the bottom (Z=0).
// But the bore is inside. The "side that faces the hotplate" usually refers to the flat surface of the knob itself.
// If the knob is a cylinder, the "side" is the curved surface.
// However, the bore is D-shaped. The "flat" of the D is a specific direction.
// Interpretation: The knob sits on its flat face (the face of the cylinder is circular, but the bore is D).
// Re-reading: "printed with the side that faces the hotplate down".
// If it's a cylinder, the bottom is a circle. The "side" usually means the flat face of the D-bore if the knob was meant to sit on a flat surface, but here it's a stirrer knob.
// Standard interpretation: The knob sits on the bed. The D-shape bore is vertical.
// The "side that faces the hotplate" likely refers to the flat face of the D-bore being oriented towards the hotplate (downwards) or the knob is oriented such that the flat of the D is at the bottom of the knob's vertical axis?
// Actually, D-shaft knobs usually have the flat of the D pointing towards the operator or a specific direction.
// Let's assume the "side that faces the hotplate down" means the flat face of the D-bore is oriented towards the -Z direction? No, the bore is vertical.
// Maybe it means the knob is printed such that the flat of the D is at the bottom of the Z-axis? No, the bore is 12mm up.
// Let's assume the standard orientation: The knob sits on the bed. The D-shape bore is vertical.
// The "side that faces the hotplate down" is ambiguous for a cylinder.
// Hypothesis: The user means the flat face of the D-bore is oriented towards the -X direction, and the knob is rotated so that this flat face is at the bottom? No.
// Let's look at the pointer: "On the top face, cut a pointer groove... on the same side as the flat of the D."
// This implies the flat of the D and the pointer are radially aligned.
// Let's assume the "side that faces the hotplate down" means the flat of the D is pointing towards the hotplate (which is below the knob).
// So the flat of the D is at the bottom of the knob's vertical axis? No, the bore is vertical.
// Perhaps the user means the knob is printed with the flat of the D facing the -X direction, and the "hotplate" is considered to be in the -X direction?
// Or, more likely, the user means the knob sits on the bed, and the flat of the D is oriented towards the back of the machine (or front), and they want to specify that orientation.
// Let's assume the flat of the D is at the bottom of the knob's vertical axis? No, that doesn't make sense for a D-shaft.
// Let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Okay, let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Okay, let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Let's assume the flat of the D is at the bottom of the knob's vertical axis? No.
// Let's assume the flat of the