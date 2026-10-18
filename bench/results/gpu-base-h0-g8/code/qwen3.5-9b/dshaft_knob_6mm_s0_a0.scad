// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Print Orientation: Bottom face (Z=0) rests on bed.
// Shaft fits into bottom D-bore.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Knob Body
D_KNOB = 30;      // Outer Diameter
H_KNOB = 15;      // Total Height
R_KNOB = D_KNOB / 2;

// Shaft Bore (Bottom)
SHAFT_DIAMETER = 6.2; // Circle diameter
SHAFT_FLAT_WIDTH = 4.7; // Distance from flat to opposite side
SHAFT_DEPTH = 12;      // Depth of blind bore

// Grip Grooves (Side)
NUM_GROOVES = 18;
GROOVE_DEPTH = 1;      // Depth of groove (radius of half-cylinder)
GROOVE_RADIUS = 1;     // Radius of the 2mm diameter half-cylinder

// Pointer Groove (Top)
POINTER_WIDTH = 1.5;   // Width of groove
POINTER_DEPTH = 1;     // Depth of groove

// --- Calculations ---
// Calculate the radius of the D-shape based on the given flat width and circle diameter
// Distance from center to flat = (Diameter - Flat_Width) / 2
R_FLAT_OFFSET = (SHAFT_DIAMETER - SHAFT_FLAT_WIDTH) / 2;

// --- Construction ---

// 1. Main Body (D-Cylinder)
// We create a D-shape in XY and extrude it up.
// The D-shape is defined by a circle with a rectangular cutout on one side.
// To ensure the flat is exactly 4.7mm and the circle is 6.2mm:
// The cutout width must be: Diameter - Flat_Width = 6.2 - 4.7 = 1.5mm.
// The cutout is centered on the X-axis (assuming flat is on -X side).

difference() {
    // Base Cylinder (Circle)
    cylinder(
        h = H_KNOB,
        r = R_KNOB,
        center = [0, 0, H_KNOB/2]
    );

    // Cutout for D-shape (Side)
    // We subtract a rectangle from the side of the cylinder to create the flat.
    // The rectangle extends from the center of the cylinder outwards.
    // Width = 1.5mm, Height = H_KNOB.
    // Position: Centered at X=0, Y=0, Z=H_KNOB/2.
    // We extend slightly past the faces to ensure clean cut.
    translate([0, 0, H_KNOB/2]) {
        difference() {
            // The shape we are subtracting (the "hole" in the D)
            // We make it slightly larger than the theoretical cut to avoid coplanar faces
            cube([SHAFT_DIAMETER - SHAFT_FLAT_WIDTH + 0.1, H_KNOB, 0.1], center = [0, 0, H_KNOB/2]);
            
            // The actual D-shape profile (to keep the rest of the cylinder)
            // This is a bit tricky in difference. Instead of subtracting a rectangle,
            // we can build the D-shape directly using a union of a circle and a rectangle,
            // then subtract that union from the full cylinder.
        }
    }
    
    // Alternative approach for the D-shape to be robust:
    // Build the D-shape explicitly and subtract it from the full cylinder.
    // D-Shape Profile:
    // 1. Full Circle
    // 2. Subtract Rectangle on one side.
    
    // Let's rebuild the body logic for clarity and robustness:
    // We will create the D-shape volume and subtract it from a larger cylinder? 
    // No, simpler: Start with Cylinder, subtract the "missing" rectangle part.
    
    // Re-doing the subtraction logic for the D-shape:
    // The missing part is a rectangle of width (6.2 - 4.7) = 1.5mm.
    // It is located at the center of the circle.
    // To make the flat face exactly 4.7mm, we cut a rectangle of width 1.5mm centered at X=0.
    
    translate([0, 0, H_KNOB/2]) {
        // The rectangle to remove. 
        // Width = 1.5mm. Height = 15mm. Depth = 0.01mm (to act as a plane cutter)
        // We extend slightly in Z to ensure it cuts through.
        cube([SHAFT_DIAMETER - SHAFT_FLAT_WIDTH + 0.05, H_KNOB + 0.05, 0.05], center = [0, 0, H_KNOB/2]);
    }
}

// Wait, the logic above inside the difference() block was nested incorrectly.
// Let's restart the main block structure for the D-shape.

// --- Revised Main Body Construction ---
// Start with a full cylinder.
// Subtract a rectangular prism from the side to create the flat.
// The rectangular prism must be centered on the X-axis.
// Width = SHAFT_DIAMETER - SHAFT_FLAT_WIDTH = 1.5mm.
// Height = H_KNOB.
// Z-position = H_KNOB/2.

difference() {
    // Full Cylinder
    cylinder(h = H_KNOB, r = R_KNOB, center = [0, 0, H_KNOB/2]);
    
    // D-Shape Cutout
    // We subtract a rectangle that goes all the way through the cylinder diameter-wise?
    // No, we subtract a rectangle that removes the "flat" part.
    // The flat part is the segment of the circle cut off.
    // Width of cut = 1.5mm.
    // The cut is centered at X=0.
    translate([0, 0, H_KNOB/2]) {
        // Add a small buffer to ensure clean cut
        cube([SHAFT_DIAMETER - SHAFT_FLAT_WIDTH + 0.1, H_KNOB + 0.1, 0.1], center = [0, 0, H_KNOB/2]);
    }
}

// --- Shaft Bore ---
// D-shaped blind bore starting from bottom (Z=0) going up 12mm.
// The D-shape is defined by the same geometry as the outside but smaller.
// Circle diameter = 6.2mm. Flat width = 4.7mm.
// Center of the bore is at [0, 0, SHAFT_DEPTH/2].

difference() {
    // The Knob Body (re-created here to allow subtraction of the bore)
    // To avoid re-defining the whole knob, we can use a boolean operation on the existing logic,
    // but since we are in a single script, we must define the base shape again or use a variable.
    // Let's define the base D-cylinder as a variable or re-construct it.
    
    // Base D-Cylinder
    d_cylinder_base = cylinder(h = H_KNOB, r = R_KNOB, center = [0, 0, H_KNOB/2]);
    
    // D-Cutout (Rectangle)
    d_cutout = translate([0, 0, H_KNOB/2]) cube([SHAFT_DIAMETER - SHAFT_FLAT_WIDTH + 0.1, H_KNOB + 0.1, 0.1], center = [0, 0, H_KNOB/2]);
    
    // Combine Base and Cutout
    union() {
        d_cylinder_base;
        d_cutout; // This adds the cutout? No, we need to subtract.
        // Actually, the previous block was: difference(cylinder, cutout).
        // Let's just rebuild the body here.
    }
}

// Correct approach: Define the body, then subtract the bore.
// Since OpenSCAD doesn't support variables for complex boolean operations easily in one go without re-defining,
// we will define the body once, then subtract the bore from it.

// --- Final Assembly ---

// 1. Define the Base D-Cylinder
// We use a temporary variable for the body to subtract the bore.
// Note: In OpenSCAD, we cannot easily pass a boolean result to another difference.
// So we must construct the body with the bore already included, OR construct the body, then subtract the bore.
// Let's construct the body with the bore included by subtracting the bore shape from the cylinder.

difference() {
    // A. The Main D-Cylinder Body
    // We create a temporary union of the cylinder and the "cutout" to define the shape?
    // No, standard way: Cylinder minus Rectangle.
    
    // Cylinder
    cylinder(h = H_KNOB, r