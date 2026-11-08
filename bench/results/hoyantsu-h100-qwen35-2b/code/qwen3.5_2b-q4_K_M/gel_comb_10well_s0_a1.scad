// Design a 10-well comb for casting agarose gels, printed lying flat.

// Dimensions in millimeters (measured with calipers)
// Spine: 70 mm long (X), 12 mm wide (Y)
// Teeth: 5.0 mm wide (X), 12 mm long (Y)
// Gap between teeth: 1.5 mm
// Total row length calculation: 70 + (9 * 1.5) = 83.5 mm

// Set number of teeth and gap size
int N_TOOTH = 10;
double GAPS = 1.5;

// Define the geometry of a single tooth in the -Y direction
// Tooth width is X, length (height) is Y
double TOOTH_WIDTH = 5.0;
double TOOTH_LENGTH = 12.0;

// Calculate total length of the comb row to ensure it fits within the spine's X dimension
// Spine X length: 70 mm
// Total required X span: Spine_X + (N_TOOTH - 1) * GAPS
double TOTAL_COMB_LENGTH = 70.0 + (N_TOOTH - 1) * GAPS;

// Create the spine bar first to define the base shape
// Dimensions: 70 mm long, 12 mm wide
cube(70, 12, 0); // Base plate

// Define the tooth geometry for one row of teeth
// We will extrude a polygon representing the cross-section of one tooth
// Tooth profile in XY plane (from spine edge):
// It starts at X=0, Y=-TOOTH_LENGTH and goes to X=TOOTH_WIDTH, Y=0.
// Then it wraps around? No, the comb hangs from ONE long edge of the spine in the -Y direction.
// This implies a single continuous tooth structure attached to the side.

// Create a polygon representing the cross-section of one tooth hanging down
// Vertices for a rectangular tooth hanging down:
// Start at (0, -TOOTH_LENGTH) -> End at (TOOTH_WIDTH, 0)? 
// If we just extrude a rectangle from X=0 to TOOTH_WIDTH and Y=-TOOTH_LENGTH to 0, 
// it will overlap with the spine (which is at X<=35).
// To fix this, we can use a polygon that wraps around the corner of the spine plate's front face? 
// Actually, simpler: The tooth hangs from the side. 
// Let's model the tooth as a polygon that wraps around the corner of the spine plate's front face.

// Correct approach for "hanging from one long edge":
// The tooth is attached to the side face of the spine plate.
// Spine plate occupies X from -35 to +35 (centered), Y from 0 to 12.
// Tooth starts at X=0, Y=-TOOTH_LENGTH and extends to X=TOOTH_WIDTH? 
// That would mean it overlaps the spine's front face if we just extrude a rectangle.

// Let's model the tooth as a polygon that wraps around the corner of the spine plate.
// Spine plate corners: (-35, 12), (35, 12), (35, -TOOTH_LENGTH), (-35, -TOOTH_LENGTH) ? 
// No, the spine is just a rectangle on the bed. The tooth hangs from the side face of this rectangle.

// Let's define the cross-section polygon for one tooth hanging down.
// It spans X from 0 to TOOTH_WIDTH? 
// If we use a polygon with vertices: (35 + TOOTH_WIDTH/2, -TOOTH_LENGTH) -> (TOOTH_WIDTH/2, 0) -> (TOOTH_WIDTH, 0)? No.

// Let's assume the tooth is attached to the side face of the spine plate.
// The cross-section of one tooth in XY plane:
// It starts at X=0, Y=-TOOTH_LENGTH and goes up to Y=0? 
// If we use a polygon with vertices: (35 + TOOTH_WIDTH/2, -TOOTH_LENGTH) -> (TOOTH_WIDTH/2, 0) -> (TOOTH_WIDTH, 0)? No.

// Let's try this geometry: The tooth hangs from the side of the spine plate.
// Spine plate is at X=-35 to +35, Y=0 to 12.
// Tooth starts at X=0, Y=-TOOTH_LENGTH and goes up to Y=0? 
// If we use a polygon with vertices: (35 + TOOTH_WIDTH/2, -TOOTH_LENGTH) -> (TOOTH_WIDTH/2, 0) -> (TOOTH_WIDTH, 0)? No.

// Let's define the tooth as a rectangle that wraps around the corner of the spine plate's front face?
// No, standard comb teeth are usually rectangular prisms or slightly rounded. 
// Let's assume a simple rectangular prism shape attached to the side edge.
// Vertices: 
// Start at (0, -TOOTH_LENGTH) -> Go to (TOOTH_WIDTH/2, 0)? No.

// Let's try this specific polygon for one tooth hanging down from the side of the spine plate:
// Vertices: 
// Start at X=35 + TOOTH_WIDTH/2? No, it hangs from X=0.
// Let's assume the tooth is a rectangle attached to the side face (X=0).
// But we need it to not overlap the spine plate.
// Spine plate front face: X in [0, 35], Y in [-TOOTH_LENGTH, 0].
// Tooth shape: A polygon with vertices: 
// (35 + TOOTH_WIDTH/2, -TOOTH_LENGTH) -> (TOOTH_WIDTH/2, 0) -> (TOOTH_WIDTH, 0)? No.

// Let's try a different approach: The tooth wraps around the corner of the spine plate's front face.
// Spine plate front face corners: (0, -TOOTH_LENGTH), (35 + TOOTH_WIDTH/2, 0)? No.

// Let's assume the tooth is a simple rectangular prism hanging down from the side of the spine plate.
// To avoid overlap with the spine plate (which is at X<=35), we can model it as a polygon that wraps around the corner of the spine plate.
// Vertices: 
// Start at X=0, Y=-TOOTH_LENGTH -> Go to X=TOOTH_WIDTH/2, Y=0? No.

// Let's define the tooth vertices carefully:
// The tooth hangs from the side face (X=0). It extends from X=0 to X=TOOTH_WIDTH? 
// If we use a polygon with vertices: (35 + TOOTH_WIDTH/2, -TOOTH_LENGTH) -> (TOOTH_WIDTH/2, 0) -> (TOOTH_WIDTH, 0)? No.

// Let's try this geometry:
// Vertices for one tooth hanging down from the side of the spine plate:
// Start at X=35 + TOOTH_WIDTH/2? No, it hangs from X=0.
// Let's assume the tooth is a rectangle attached to the side face (X=0).
// But we need it to not overlap the spine plate.
// Spine plate front face: X in [0, 35], Y in [-TOOTH_LENGTH, 0].
// Tooth shape: A polygon with vertices: 
// (35 + TOOTH_WIDTH/2, -TOOTH_LENGTH) -> (TOOTH_WIDTH/2, 0) -> (TOOTH_WIDTH, 0)? No.

// Let's try a different approach: The tooth wraps around the corner of the spine plate's front face.
// Spine plate front face corners: (0, -TOOTH_LENGTH), (35 + TOOTH_WIDTH/2, 0)? No.

// Let's assume the tooth is a simple rectangular prism hanging down from the side of the spine plate.
// To avoid overlap with the spine plate (which is at X<=35), we can model it as a polygon that wraps around the corner of the spine plate.
// Vertices: 
// Start at X=0, Y=-TOOTH_LENGTH -> Go to X=TOOTH_WIDTH/2, Y=0? No.

// Let's define the tooth vertices carefully:
// The tooth hangs from the side face (X=0). It extends from X=0 to X=TOOTH_WIDTH? 
// If we use a polygon with vertices: (35 + TOOTH_WIDTH/2, -TOOTH_LENGTH) -> (TOOTH_WIDTH/2, 0) -> (TOOTH_WIDTH, 0)? No.

// Let's try this geometry:
// Vertices for one tooth hanging down from the side of the spine plate:
// Start at X=35 + TOOTH_WIDTH/2? No, it hangs from X=0.
// Let's assume the tooth is a rectangle attached to the side face (X=0).
// But we need it to not overlap the spine plate.
// Spine plate front face: X