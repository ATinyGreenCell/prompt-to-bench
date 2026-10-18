// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Print Orientation: Bottom face (Z=0) rests on bed.
// Shaft fits into bottom D-bore.

$fn = 128; // High resolution for smooth curves and accurate D-shape

// --- Dimensions ---
D_KNOB = 30;      // Outer Diameter
H_KNOB = 15;      // Total Height
R_KNOB = D_KNOB / 2;

// Shaft Bore (Bottom)
SHAFT_DIAMETER = 6.2; // Circle diameter
SHAFT_FLAT_WIDTH = 4.7; // Distance from flat to opposite side
SHAFT_DEPTH = 12;      // Depth of blind bore (from Z=0 to Z=12)

// Grip Grooves (Side)
NUM_GROOVES = 18;
GROOVE_DEPTH = 1;      // Depth of groove (radius of half-cylinder)
GROOVE_RADIUS = 1;     // Radius of the 2mm diameter half-cylinder

// Pointer Groove (Top)
POINTER_WIDTH = 1.5;   // Width of groove
POINTER_DEPTH = 1;     // Depth of groove

// --- Calculations ---
// Calculate the width of the cut needed to create the D-shape flat
// Width of cut = Diameter - Flat Width = 6.2 - 4.7 = 1.5mm
CUT_WIDTH = SHAFT_DIAMETER - SHAFT_FLAT_WIDTH;

// --- Construction ---

difference() {
    // 1. Main Body (D-Cylinder)
    // Start with a full cylinder
    cylinder(h = H_KNOB, r = R_KNOB, center = [0, 0, H_KNOB/2]);
    
    // Subtract the rectangular cut to create the flat side of the D
    // The cut is centered on the X-axis.
    // We extend the cut slightly past the faces to ensure clean cutting.
    translate([0, 0, H_KNOB/2]) {
        cube([CUT_WIDTH + 0.1, H_KNOB + 0.1, 0.1], center = [0, 0, H_KNOB/2]);
    }
    
    // 2. D-Shaped Blind Bore
    // Starts from bottom (Z=0) going up SHAFT_DEPTH.
    // Center of the bore is at [0, 0, SHAFT_DEPTH/2].
    // We subtract a D-shape that is slightly larger than the target to ensure clean cut.
    // The D-shape geometry is identical to the outside but scaled.
    translate([0, 0, SHAFT_DEPTH/2]) {
        // Create a temporary D-shape to subtract
        difference() {
            // Base cylinder for the bore
            cylinder(h = SHAFT_DEPTH, r = SHAFT_DIAMETER / 2, center = [0, 0, 0]);
            // Subtract the flat part of the D bore
            // This creates the D-shape profile for the hole
            cube([CUT_WIDTH + 0.1, SHAFT_DEPTH + 0.1, 0.1], center = [0, 0, 0]);
        }
    }
    
    // 3. Vertical Grip Grooves
    // 18 evenly spaced vertical grooves along the full height.
    // Each groove is a 2mm diameter half-cylinder centered on the outer surface.
    // Orientation: Grooves run along Z axis.
    // Position: Centered on the outer radius (R_KNOB).
    
    for (i = [0 : NUM_GROOVES - 1]) {
        angle = (i / (NUM_GROOVES - 1)) * 360;
        translate([R_KNOB, 0, 0]) {
            rotate([0, 0, angle]) {
                // The groove is a half-cylinder (radius = GROOVE_RADIUS)
                // It cuts into the knob from the outside in.
                // We subtract a cylinder of radius (GROOVE_RADIUS + buffer)
                // to ensure it cuts fully through the wall thickness.
                // The groove depth is GROOVE_DEPTH, but we cut slightly deeper.
                cylinder(
                    h = H_KNOB + 0.1, 
                    r = GROOVE_RADIUS + 0.05, 
                    center = [0, 0, H_KNOB/2]
                );
            }
        }
    }
    
    // 4. Pointer Groove (Top Face)
    // 1.5 mm wide, 1 mm deep, running from center to outer edge.
    // Located on the same side as the flat of the D (negative X side).
    // We subtract a rectangular prism from the top face.
    // The groove runs radially from center to edge.
    // Length = R_KNOB. Width = POINTER_WIDTH. Depth = POINTER_DEPTH.
    // Position: Centered on the top face (Z = H_KNOB).
    // Offset in X: The groove is on the flat side.
    // The flat side is centered at X=0. The groove should be on this flat side.
    // Let's place the groove centered on the negative X axis relative to the knob center.
    // To make it run from center to edge, we define a box:
    // X range: -R_KNOB to 0 (approx).
    // Y range: -POINTER_WIDTH/2 to +POINTER_WIDTH/2.
    //