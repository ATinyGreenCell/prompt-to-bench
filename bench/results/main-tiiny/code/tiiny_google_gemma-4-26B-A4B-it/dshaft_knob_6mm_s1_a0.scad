// --- Parameters ---
// Knob Dimensions
knob_diameter = 30.0;          // Total diameter of the knob
knob_height = 15.0;            // Total height of the knob

// D-Shaft Bore (Blind Bore)
bore_circle_dia = 6.2;         // Diameter of the circular part of the D-bore
bore_flat_width = 4.7;         // Distance from flat to opposite side
bore_depth = 12.0;             // How deep the D-bore goes into the knob

// Grip Grooves
num_grooves = 18;              // Number of vertical grooves
groove_dia = 2.0;              // Diameter of the half-cylinder groove

// Pointer Groove (Top Face)
pointer_width = 1.5;           // Width of the pointer groove
pointer_depth = 1.0;           // Depth of the pointer groove
pointer_length = knob_diameter / 2; // From center to edge

// Resolution
fn_val = 64;                   // Smoothness for cylinders

// --- Calculations ---
knob_radius = knob_diameter / 2;
bore_radius = bore_circle_dia / 2;
groove_radius = groove_dia / 2;

// Calculate the angle of the flat side for the D-bore
// Using law of cosines or simple trig: 
// The distance from center to flat is bore_flat_width / 2.
// half_chord_angle = acos((bore_flat_width/2) / bore_radius)
// But we need the angle of the "cut" part.
// Let's define the flat by a subtraction of a cylinder at an offset.
flat_offset = bore_flat_width / 2;

// --- Main Model ---

union() {
    difference() {
        // Main Knob Body
        cylinder(h = knob_height, d = knob_diameter, $fn = fn_val);

        // 1. D-Shaft Blind Bore
        // We create the D-shape by intersecting a cylinder with a half-space 
        // or subtracting a cylinder offset from the center.
        translate([0, 0, -0.01]) // Extend slightly below Z=0
        union() {
            // The main circular part of the bore
            cylinder(h = bore_depth + 0.01, d = bore_circle_dia, $fn = fn_val);
            
            // To make it a "D", we subtract a large cylinder that is offset
            // so that the edge of the large cylinder creates the flat.
            // The distance from center to the flat is 4.7/2 = 2.35.
            // The large cylinder must have a radius such that its edge is at 2.35.
            // However, it's easier to subtract a cylinder that is offset.
            // Let's subtract a cylinder whose edge is at x = -2.35.
            // The center of this subtraction cylinder would be at x = -2.35 - bore_radius
            // No, simpler: Subtract a cylinder that is offset so its edge is at x = -2.35.
            // Let's use a large cylinder centered at x = -bore_radius - (bore_circle_dia - bore_flat_width)/2
            // Actually, the simplest way to make a D-bore:
            // Take a cylinder and subtract a cylinder that is offset.
        }
        
        // Correct D-bore subtraction logic:
        // We want a circle of dia 6.2, but cut at 4.7.
        // We subtract a cylinder that is offset from the center.
        // The distance from center to the flat is 4.7/2 = 2.35.
        // The subtraction cylinder's edge must be at x = -2.35.
        // Let's use a very large cylinder to ensure a clean flat.
        translate([-(bore_circle_dia/2 + (bore_circle_dia - bore_flat_width)/2), 0, -0.01])
        cylinder(h = bore_depth + 0.01, d = knob_diameter, $fn = fn_val);
        
        // Wait, the above logic is for a "cut". Let's do it properly:
        // We want the bore to be a cylinder of 6.2, but we cut a side.
        // Let's use a difference of two cylinders for the bore.
    }
    
    // We need to re-structure to use difference correctly.
}

// RE-WRITING MAIN STRUCTURE FOR CLEAN DIFFERENCE
difference() {
    // Base Body
    cylinder(h = knob_height, d = knob_diameter, $fn = fn_val);

    // 1. D-Shaft Bore (Blind)
    // We create the D-shape by taking a cylinder and subtracting a larger cylinder offset to the side
    translate([0, 0, -0.01]) {
        union() {
            // The circular part
            cylinder(h = bore_depth + 0.01, d = bore_circle_dia, $fn = fn_val);
            // The "D" part is actually the intersection of a circle and a half-plane.
            // Let's subtract a cylinder that is offset so its edge is at x = -2.35
            // The distance from center to the edge of the subtracted cylinder is 2.35.
            // The center of the subtracted cylinder is at x = -2.35 - (some_large_radius).
            // Actually, let's just subtract a cylinder that is offset.
            // To get a flat at x = -2.35, we subtract a cylinder of radius R at center X_c.
            // X_c + R = -2.35 is not right.
            // Let's use a simpler approach: Subtract a cylinder that is offset.
            // If we want the flat at x = -2.35, and the circle is at x=0, r=3.1.
            // We subtract a cylinder centered at x = -3.1 - (3.1 - 2.35) = -3.85? No.
            // Let's just subtract a cylinder that is offset so its edge is at x = -2.35.
            // The distance from center to the flat is 2.35.
            // The subtraction cylinder's edge should be at x = -2.35.
            // Let's use a cylinder with a very large radius centered at x = -2.35 - large_R.
        }
    }
    // Let's try again. The D-bore is a cylinder of 6.2mm, but one side is flat at 4.7mm.
    // This means we take a cylinder of 6.2 and subtract a cylinder of 6.2 offset by (6.2-4.7)/2.
    // No, that's not right. To get a flat at 4.7, we subtract a cylinder whose edge is at 4.7/2.
    // Let's use a cylinder of diameter 100 (very large) centered at x = -2.35 - 50.
    // That's too complex. Let's use a simple subtraction:
    // A cylinder of 6.2, and then subtract a cylinder of 6.2 offset by (6.2-4.7)/2.
    // Wait, if I subtract a cylinder of 6.2 offset by 0.75, the edge is at 3.1 - 0.75 = 2.35.
    // 2.35 * 2 = 4.7. Perfect.
    
    // Let's use this logic:
    // 1. Cylinder (6.2)
    // 2. Subtract Cylinder (6.2) offset by (6.2 - 4.7)/2 = 0.75.
    // Wait, if I subtract a cylinder of 6.2 offset by 0.75, the "left" edge is at -3.1 - 0.75 = -3.85.
    // The "right" edge is at -3.1 + 0.75 = -2.35.
    // The "right" edge is the flat!
    // So we subtract a cylinder of 6.2 offset by 0.75.
    // But we want the bore to be 6.2 at the widest part.
    // Let's use a cylinder of 6.2, and subtract a cylinder of 6.2 offset by 0.75.
    // This results in a shape where the widest part is 6.2 and the narrow part is 4.7.
    // Let's check: Center is 0. Right edge is 3.1. Left edge is -3