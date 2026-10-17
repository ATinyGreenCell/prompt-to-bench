// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Print Orientation: Bottom face (with D-bore) on Z=0, building upward.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and precise D-shape

// Main Body
D_KNOB_DIAMETER = 30;
D_KNOB_HEIGHT = 15;
D_KNOB_RADIUS = D_KNOB_DIAMETER / 2;

// Shaft Bore (D-shape)
// Based on prompt: "6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
// This defines the final D-shape geometry.
// Max Width (Arc to Arc) = 6.2 mm -> Radius = 3.1 mm.
// Min Width (Flat) = 4.7 mm.
// Total Height (Flat to Top) = 4.7 mm.
//
// Geometry Calculation:
// Radius (R) = 3.1 mm.
// Total Height (H) = 4.7 mm.
// Distance from Center to Flat (Y_flat) = H - R = 4.7 - 3.1 = 1.6 mm.
// Check Flat Width: 2 * sqrt(R^2 - Y_flat^2) = 2 * sqrt(3.1^2 - 1.6^2) = 2 * sqrt(9.61 - 2.56) = 2 * sqrt(7.05) ≈ 5.31 mm.
// Note: The prompt's "4.7 mm" likely refers to the height dimension (flat to top) which is critical for the D-shaft fit, 
// while the width is derived from the 6.2mm circle diameter. We prioritize the 6.2mm diameter and the 4.7mm height constraint.

SHAFT_RADIUS = 3.1;
SHAFT_DEPTH = 12;
D_SHAPE_HEIGHT = 4.7;
D_SHAPE_Y_OFFSET = D_SHAPE_HEIGHT - SHAFT_RADIUS; // Distance from center to flat face

// Grip Grooves
NUM_GROOVES = 18;
GROOVE_DEPTH = 2; // Radius of the half-cylinder cut
GROOVE_DIAMETER = 2;

// Top Pointer
POINTER_WIDTH = 1.5;
POINTER_DEPTH = 1; // Depth from top surface

// --- Construction ---

// 1. Main Cylinder Body
difference() {
    // Outer Cylinder
    cylinder(h = D_KNOB_HEIGHT, r = D_KNOB_RADIUS, center = true);
    
    // 2. D-Shaped Blind Bore
    translate([0, 0, D_KNOB_HEIGHT - SHAFT_DEPTH]) {
        difference() {
            // Create the D-shape profile using a circle and a subtracted rectangle
            // Circle Center at (0,0). Flat face at y = D_SHAPE_Y_OFFSET.
            
            // Full Circle
            circle(r = SHAFT_RADIUS);
            
            // Subtract the rectangular segment to create the flat
            // Width of the flat = 2 * sqrt(R^2 - Y_offset^2)
            // Height of the cut = Y_offset (from center to flat)
            flat_width = 2 * sqrt(SHAFT_RADIUS*SHAFT_RADIUS - D_SHAPE_Y_OFFSET*D_SHAPE_Y_OFFSET);
            
            translate([0, D_SHAPE_Y_OFFSET, 0]) {
                cube([flat_width, D_SHAPE_Y_OFFSET, 1], center = false);
            }
        }
    }
    
    // 3. Grip Grooves (18 evenly spaced vertical half-cylinders)
    for (i = [0 : NUM_GROOVES - 1]) {
        angle = (i / NUM_GROOVES) * 360;
        translate([
            D_KNOB_RADIUS * cos(angle * pi / 180),
            D_KNOB_RADIUS * sin(angle * pi / 180),
            0
        ]) {
            // Cut a half-cylinder groove
            // The groove is a half-cylinder of diameter GROOVE_DIAMETER
            // We rotate it 90 degrees around X so the flat side faces the center of the knob
            rotate([90, 0, 0]) {
                cylinder(h = D_KNOB_HEIGHT, r = GROOVE_DEPTH, center = true);
            }
        }
    }
    
    // 4. Top Pointer Groove
    // Runs from center to outer edge, 1.5mm wide, 1mm deep.
    // Located on the same side as the flat of the D (negative Y side relative to the knob's local D-orientation).
    // Since the knob is printed with the flat facing "down" (Z=0), the flat is at the bottom.
    // The pointer is on the "same side as the flat". 
    // In the D-shape calculation above, the flat was at +Y. 
    // However, standard D-shafts have the flat on one side. Let's assume the flat is at +Y for the bore.
    // The prompt says "on the same side as the flat of the D".
    // So the pointer groove should be at +Y on the top face.
    
    translate([0, 0, D_KNOB_HEIGHT - POINTER_DEPTH]) {
        // Create a slot: 1.5mm wide, 1mm deep (radius 0.5mm), length = Radius
        // We use a difference to cut this into the top face.
        // The slot is a half-cylinder cut from the top.
        
        // Define the slot geometry
        slot_width = POINTER_WIDTH;
        slot_radius = POINTER_DEPTH;
        slot_length = D_KNOB_RADIUS;
        
        // Position: Centered at Y = D_SHAPE_Y_OFFSET (same side as flat)
        // X = 0
        
        translate([0, D_SHAPE_Y_OFFSET, 0]) {
            // Cut a half-cylinder
            rotate([90, 0, 0]) {
                cylinder(h = slot_length, r = slot_radius, center = true);
            }
        }
    }
}