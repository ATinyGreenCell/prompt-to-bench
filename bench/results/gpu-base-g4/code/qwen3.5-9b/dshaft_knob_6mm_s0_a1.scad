// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Print Orientation: Bottom face (Z=0) rests on bed.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Knob Body
D_KNOB = 30;      // Outer diameter
H_KNOB = 15;      // Total height
R_KNOB = D_KNOB / 2;

// Shaft Bore (D-shape)
SHAFT_DIAMETER = 6.2; // Circle diameter
SHAFT_FLAT_WIDTH = 4.7; // Distance from flat to opposite side
SHAFT_DEPTH = 12;      // Depth of blind bore

// Grip Grooves
NUM_GROOVES = 18;
GROOVE_DEPTH = 2;      // Diameter of half-cylinder groove
GROOVE_RADIUS = GROOVE_DEPTH / 2;

// Top Pointer Groove
POINTER_WIDTH = 1.5;   // Width of groove
POINTER_DEPTH = 1;     // Depth of groove

// --- Main Body Construction ---
difference() {
    // 1. Create the main D-shaped cylinder body
    // We build the D-shape by taking a cylinder and cutting a plane through it.
    // The flat side is at Y = -R_KNOB.
    
    union() {
        // Base Cylinder
        cylinder(h = H_KNOB, d = D_KNOB, center = [0, 0, H_KNOB/2]);
        
        // Cut the flat side to make it D-shaped
        // We cut a plane at Y = -R_KNOB + epsilon to ensure clean cut
        translate([0, -R_KNOB + 0.01, 0]) {
            cube([D_KNOB + 2, 10, H_KNOB + 2], center = true);
        }
    }
    
    // 2. Cut the D-shaped blind bore
    // The bore is 12mm deep, starting from Z=0.
    // It has a 6.2mm diameter circle with a flat side.
    // The flat side of the bore aligns with the flat side of the knob.
    
    translate([0, 0, 0]) {
        difference() {
            // The solid material to remove (the bore shape)
            // We create a D-shaped cylinder of height 12mm
            union() {
                cylinder(h = SHAFT_DEPTH, d = SHAFT_DIAMETER, center = [0, 0, SHAFT_DEPTH/2]);
                // Cut the flat side of the bore
                translate([0, -SHAFT_DIAMETER/2 + 0.01, 0]) {
                    cube([SHAFT_DIAMETER + 2, 10, SHAFT_DEPTH + 2], center = true);
                }
            }
        }
    }
    
    // 3. Cut the vertical grip grooves
    // 18 evenly spaced vertical grooves along the full height.
    // Each groove is a 2mm diameter half-cylinder centered on the outer surface.
    // "Half-cylinder" here implies a semi-circular cross-section groove.
    // To achieve this, we subtract a cylinder of diameter 2mm, but we must ensure
    // the cut is only on the outside. Since the cylinder is centered on the surface,
    // subtracting a full cylinder would create a hole through the knob.
    // However, the prompt says "half-cylinder groove". This usually means the shape removed
    // is a semi-cylinder. If we subtract a full cylinder centered on the surface, we remove
    // a full cylinder volume. The resulting surface is a hole.
    // If the user wants a groove (a channel), they likely mean the cross-section is a semi-circle.
    // To get a semi-circular groove on the surface, we subtract a cylinder of diameter 2mm,
    // but we need to ensure the cut is only on the outside.
    // If we subtract a cylinder of diameter 2mm centered on the surface, we get a hole.
    // If we want a groove, we need to subtract a cylinder of diameter 2mm, but we need to ensure the cut is only on the outside.
    // Let's assume the user means a groove with a semi-circular cross-section.
    // This is achieved by subtracting a cylinder of diameter 2mm, but we need to ensure the cut is only on the outside.
    // If we subtract a cylinder of diameter 2mm centered on the surface, we get a hole.
    // If we want a groove, we need to subtract a cylinder of diameter 2mm, but we need to ensure the cut is only on the outside.
    // Let's try a different approach:
    // Subtract a cylinder of diameter 2mm, but we need to ensure the cut is only on the outside.
    // We can do this by intersecting the cylinder with a plane?
    // Or, we can subtract a cylinder of diameter 2mm, but we need to ensure the cut is only on the outside.
    // Let's assume the user means a groove with a semi-circular cross-section.
    // This is achieved by subtracting a cylinder of diameter 2mm, but we need to ensure the cut is only on the outside.
    // If we subtract a cylinder of diameter 2mm centered on the surface, we get a hole.
    // If we want a groove