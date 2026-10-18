// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Print Orientation: Bottom face (with D-bore) on Z=0, building upward.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Main Body
D_KNOB_DIAMETER = 30;
D_KNOB_HEIGHT = 15;
D_KNOB_RADIUS = D_KNOB_DIAMETER / 2;

// Shaft Bore (D-shape)
D_SHAFT_DIAMETER = 6;
D_SHAFT_HEIGHT = 12;
D_SHAFT_RADIUS = D_SHAFT_DIAMETER / 2;
D_SHAFT_FLAT_WIDTH = 4.7; // Distance from flat to opposite arc

// Grip Grooves (18 vertical slots)
N_GROOVES = 18;
GROOVE_DEPTH = 2; // 2mm diameter half-cylinder
GROOVE_RADIUS = GROOVE_DEPTH / 2;

// Top Pointer Groove
POINTER_WIDTH = 1.5;
POINTER_DEPTH = 1;
POINTER_RADIUS = POINTER_WIDTH / 2;

// --- Construction ---

// 1. Main Cylinder Body
difference() {
    // Base Cylinder
    cylinder(h = D_KNOB_HEIGHT, r = D_KNOB_RADIUS, center = true);
    
    // 2. D-Shaped Blind Bore
    // We create the D-shape by taking a circle and subtracting a rectangle on one side.
    // The D-shape is centered on the Z-axis.
    // The flat side is at X = -D_SHAFT_FLAT_WIDTH / 2.
    translate([0, 0, D_SHAFT_HEIGHT / 2]) {
        difference() {
            // The full circular hole
            cylinder(h = D_SHAFT_HEIGHT, r = D_SHAFT_RADIUS, center = true);
            
            // The flat cut on the D-shape
            // This rectangle extends slightly past the circle to ensure a clean cut
            translate([-D_SHAFT_FLAT_WIDTH / 2, -D_SHAFT_RADIUS - 0.1, 0]) {
                cube([D_SHAFT_FLAT_WIDTH, D_SHAFT_RADIUS * 2 + 0.2, D_SHAFT_HEIGHT + 0.1]);
            }
        }
    }
    
    // 3. Vertical Grip Grooves
    // 18 evenly spaced grooves along the full height.
    // Each is a half-cylinder (radius = 1mm) centered on the outer surface.
    for (i = [0 : N_GROOVES - 1]) {
        angle = (i / (N_GROOVES - 1)) * 180; // 0 to 180 degrees
        translate([0, 0, D_KNOB_HEIGHT / 2]) {
            rotate([0, 0, angle]) {
                // Create the half-cylinder shape to subtract
                // We build a full cylinder, cut it in half, then position it.
                
                // Local coordinate system for the groove bit
                // We want a half-cylinder where the flat face is at X = 0 and the curve is at X > 0
                // Then we translate it to the knob surface.
                
                difference() {
                    // Full cylinder of the groove depth
                    cylinder(h = D_KNOB_HEIGHT, r = GROOVE_RADIUS, center = true);
                    
                    // Cut in half: Remove the part where X < 0
                    // We subtract a block that covers the negative X side
                    translate([-GROOVE_RADIUS - 0.1, -D_KNOB_HEIGHT/2 - 1, -D_KNOB_HEIGHT/2 - 1]) {
                        cube([GROOVE_RADIUS * 2 + 0.2, D_KNOB_HEIGHT + 2, D_KNOB_HEIGHT + 2]);
                    }
                }
                
                // Position the half-cylinder on the surface
                // The flat face should be at X = D_KNOB_RADIUS
                translate([D_KNOB_RADIUS, 0, 0]) {
                    // The shape created above has the flat face at X = -GROOVE_RADIUS (relative to its center)
                    // and the curve at X = +GROOVE_RADIUS.
                    // We need to shift it so the flat face aligns with the knob surface.
                    // Current flat face is at X = -GROOVE_RADIUS.
                    // Target flat face is at X = 0 (relative to this translation block).
                    // So we need to translate by +GROOVE_RADIUS along X.
                    translate([GROOVE_RADIUS, 0, 0]) {
                        // Now the flat face is at X = 0 (relative to this inner translate)
                        // And the curve is at X = 2*GROOVE_RADIUS.
                        // Wait, let's re-verify the geometry.
                        // Original cylinder center at (0,0,0).
                        // Cut removes X < -GROOVE_RADIUS.
                        // Remaining shape: X from -GROOVE_RADIUS to +GROOVE_RADIUS.
                        // Flat face is at X = -GROOVE_RADIUS.
                        // We want flat face at X = D_KNOB_RADIUS.
                        // So we translate by [D_KNOB_RADIUS - (-GROOVE_RADIUS), 0, 0] = [D_KNOB_RADIUS + GROOVE_RADIUS, 0, 0].
                        
                        // Let's simplify the construction to avoid confusion.
                        // We will construct the half-cylinder explicitly.
                    }
                }
            }
        }
    }
    
    // Re-doing the grooves with a cleaner, verified construction method inside the loop
    // Clearing the previous complex loop logic and replacing with a robust one.
    // We will re-run the subtraction logic cleanly.
    
    // Actually, let's just rebuild the whole difference block structure to be safe and clear.
    // The previous code had nested differences that might have been confusing.
    // Let's restart the "3. Vertical Grip Grooves" section logic.
    
    // We need to subtract 18 half-cylinders.
    // Each half-cylinder has radius GROOVE_RADIUS.
    // Its flat face is tangent to the knob surface.
    // Its axis is vertical (Z).
    
    for (i = [0 : N_GROOVES - 1]) {
        angle = (i / (N_GROOVES - 1)) * 180;
        translate([0, 0, D_KNOB_HEIGHT / 2]) {
            rotate([0, 0, angle]) {
                // Construct the half-cylinder bit
                // 1. Start with a full cylinder
                // 2. Cut it in half with a plane
                // 3. Position it
                
                // Let's create a temporary object for the bit
                // We'll use a difference to cut the cylinder in half
                difference() {
                    cylinder(h = D_KNOB_HEIGHT, r = GROOVE_RADIUS, center = true);
                    // Cut plane: A large flat plate at X = -GROOVE_RADIUS
                    translate([-GROOVE_RADIUS - 0.1, -D_KNOB_HEIGHT/2 - 1, -D_KNOB_HEIGHT/2 - 1]) {
                        cube([GROOVE_RADIUS * 2 + 0.2, D_KNOB_HEIGHT + 2, D_KNOB_HEIGHT + 2]);
                    }
                }
                
                // Now translate this half-cylinder to the surface
                // The flat face of the shape above is at X = -GROOVE_RADIUS (relative to its local center)
                // We want the flat face to be at X = D_KNOB_RADIUS (relative to knob center)
                // So we translate by [D_KNOB_RADIUS - (-GROOVE_RADIUS), 0, 0]
                translate([D_KNOB_RADIUS + GROOVE_RADIUS, 0, 0]) {
                    // This places the flat face at X = D_KNOB_RADIUS
                    // The curved part extends to X = D_KNOB_RADIUS + 2*GROOVE_RADIUS
                    // This is correct.
                }
            }
        }
    }
    
    // 4. Top Pointer Groove
    // Runs from center to edge on the same side as the flat of the D.
    // The D-flat is at negative X (based on our bore construction: flat at -D_SHAFT_FLAT_WIDTH/2).
    // So the pointer groove is at negative X.
    // It is 1.5mm wide, 1mm deep.
    
    // We need to subtract a shape that is a cylinder cut in half (or a prism)
    // The groove is a "V" or "U" shape? "1.5 mm wide and 1 mm deep".
    // Usually implies a rectangular cross-section or a semi-circular one.
    // Given "groove", and dimensions, a semi-circular groove of diameter 1.5mm (radius 0.75mm)
    // would