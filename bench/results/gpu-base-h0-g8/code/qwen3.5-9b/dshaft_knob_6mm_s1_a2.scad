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

difference() {
    // 1. Main Cylinder Body
    cylinder(h = D_KNOB_HEIGHT, r = D_KNOB_RADIUS, center = true);
    
    // 2. D-Shaped Blind Bore
    // The bore is centered on Z. The flat side is at negative X.
    // We subtract a cylinder and then subtract a rectangular block to create the flat.
    translate([0, 0, D_SHAFT_HEIGHT / 2]) {
        difference() {
            // The full circular hole
            cylinder(h = D_SHAFT_HEIGHT, r = D_SHAFT_RADIUS, center = true);
            
            // The flat cut on the D-shape
            // This rectangle extends slightly past the circle to ensure a clean cut.
            // Position: Centered on Y, extending from the flat edge outwards.
            // Flat edge is at X = -D_SHAFT_FLAT_WIDTH / 2.
            // We cut from X = -D_SHAFT_FLAT_WIDTH / 2 to X = -D_SHAFT_FLAT_WIDTH / 2 - (width of cut).
            // Actually, the D-shape is defined by the circle MINUS the rectangle.
            // The rectangle should cover the area where the circle exists but we want to remove.
            // The circle goes from X = -R to X = +R.
            // The flat side is at X = -D_SHAFT_FLAT_WIDTH / 2.
            // So we remove the rectangle from X = -D_SHAFT_FLAT_WIDTH / 2 to X = -D_SHAFT_FLAT_WIDTH / 2 - (something)?
            // No, the D-shape has a flat face. The distance from the flat face to the opposite arc is 4.7mm.
            // The circle diameter is 6.2mm. Radius is 3.1mm.
            // The flat face is at X = -3.1mm + (3.1mm - 4.7mm/2)? No.
            // Let's visualize: Circle center (0,0). Flat face is a chord.
            // Distance from center to chord = R - (FlatWidth / 2).
            // Distance = 3.1 - 2.35 = 0.75mm.
            // So the flat face is at X = -0.75mm.
            // We need to subtract a rectangle that covers the region X < -0.75mm within the circle.
            // The rectangle should be from X = -0.75mm to X = -3.1mm (the edge of the circle).
            // Width of rectangle = 3.1 - 0.75 = 2.35mm.
            // Let's calculate the offset explicitly.
            
            flat_offset = D_SHAFT_RADIUS - (D_SHAFT_FLAT_WIDTH / 2);
            rect_width = D_SHAFT_RADIUS - flat_offset;
            
            // Position the rectangle to cut the flat side.
            // Center of rectangle on Y.
            // X range: from -flat_offset to -D_SHAFT_RADIUS.
            translate([-flat_offset, 0, 0]) {
                cube([rect_width, D_SHAFT_RADIUS * 2 + 0.2, D_SHAFT_HEIGHT + 0.1]);
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
                // Construct the half-cylinder bit to subtract
                // We create a full cylinder, cut it in half, then position it.
                
                // Step A: Create the half-cylinder shape
                // We want a shape that is a cylinder of radius GROOVE_RADIUS, cut in half.
                // The flat face will be at X = -GROOVE_RADIUS (relative to this local shape).
                // The curved face will be at X = +GROOVE_RADIUS.
                
                difference() {
                    cylinder(h = D_KNOB_HEIGHT, r = GROOVE_RADIUS, center = true);
                    // Cut in half: Remove the part where X < -GROOVE_RADIUS
                    // We subtract a block that covers the negative X side.
                    translate([-GROOVE_RADIUS - 0.1, -D_KNOB_HEIGHT/2 - 1, -D_KNOB_HEIGHT/2 - 1]) {
                        cube([GROOVE_RADIUS * 2 + 0.2, D_KNOB_HEIGHT + 2, D_KNOB_HEIGHT + 2]);
                    }
                }
                
                // Step B: Position the half-cylinder on the surface
                // The flat face of the shape above is at X = -GROOVE_RADIUS (relative to its local center).
                // We want the flat face to be at X = D_KNOB_RADIUS (relative to knob center).
                // So we translate by [D_KNOB_RADIUS - (-GROOVE_RADIUS), 0, 0]
                translate([D_KNOB_RADIUS + GROOVE_RADIUS, 0, 0]) {
                    // This places the flat face at X = D_KNOB_RADIUS
                    // The curved part extends to X = D_KNOB_RADIUS + 2*GROOVE_RADIUS
                }
            }
        }
    }
    
    // 4. Top Pointer Groove
    // Runs from center to edge on the same side as the flat of the D.
    // The D-flat is at negative X. So the pointer groove is at negative X.
    // It is 1.5mm wide and 1mm deep.
    // We assume a semi-circular cross-section for the groove (radius 0.75mm).
    
    // Construct the pointer groove shape
    // It's a cylinder of radius POINTER_RADIUS, cut in half.
    // The flat face should be at X = -POINTER_RADIUS (relative to groove center).
    // The curved face should be at X = +POINTER_RADIUS.
    // The groove runs from the center (0,0) to the edge (D_KNOB_RADIUS, 0).
    // Since it's on the negative X side, the groove center is at X = -D_KNOB_RADIUS / 2.
    // The flat face of the groove should be at X = -D_KNOB_RADIUS / 2 - POINTER_RADIUS.
    // The curved face should be at X = -D_KNOB_RADIUS / 2 + POINTER_RADIUS.
    
    // Let's build the shape relative to the groove center.
    // Shape: Half cylinder. Flat face at X = -POINTER_RADIUS.
    difference() {
        cylinder(h = POINTER_DEPTH, r = POINTER_RADIUS, center = true);
        // Cut in half: Remove X < -POINTER_RADIUS
        translate([-POINTER_RADIUS - 0.1, -POINTER_RADIUS, -POINTER_RADIUS]) {
            cube([POINTER_RADIUS * 2 + 0.2, POINTER_RADIUS * 2 + 0.2, POINTER_DEPTH + 0.1]);
        }
    }
    
    // Position the groove
    // Groove center X = -D_KNOB_RADIUS / 2
    // We need to translate the shape so its flat face aligns with the groove start.
    // Shape flat face is at X = -POINTER_RADIUS (relative to shape center).
    // Target flat face is at X = -D_KNOB_RADIUS / 2 - POINTER_RADIUS.
    // Translation X = Target - ShapeFlat = (-D_KNOB_RADIUS / 2 - POINTER_RADIUS) - (-POINTER_RADIUS