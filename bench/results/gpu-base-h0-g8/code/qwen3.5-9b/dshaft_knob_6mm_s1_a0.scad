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
                // Half cylinder groove
                // We extrude a rectangle and cut it with a cylinder to get the half shape
                // Or simpler: rotate a half-cylinder profile.
                // Using difference with a full cylinder cut from a larger block is tricky for "half"
                // Easier approach: Rotate a half-cylinder shape.
                
                // Create the half-cylinder shape
                // We need a shape that is a cylinder cut in half.
                // Let's build it by rotating a rectangle and subtracting a cylinder? 
                // No, let's just use a cylinder and mirror it, then union? 
                // Actually, the simplest way to get a "half cylinder" centered on the surface:
                // Rotate a cylinder 90 deg, translate, then rotate back? No.
                
                // Let's define the groove as a cylinder of radius GROOVE_RADIUS 
                // but we only want the part that is "outside".
                // Since we are in difference(), we can just subtract a full cylinder 
                // if we position it correctly? No, that makes a full hole.
                
                // Correct approach for "half cylinder groove":
                // Create a shape that is a cylinder cut by a plane.
                // We will create a temporary object: a cylinder of radius GROOVE_RADIUS.
                // Then we will subtract it. But we need to ensure it's only half.
                
                // Let's construct the "bit to remove" explicitly.
                // It is a cylinder of radius GROOVE_RADIUS, but we only want the part 
                // where the distance from the center axis is > 0 in the radial direction?
                
                // Simpler: 
                // 1. Create a cylinder of radius GROOVE_RADIUS.
                // 2. Cut it in half with a plane.
                // 3. Position the half-cylinder so its flat face is tangent to the knob surface.
                
                // Let's do this:
                // Translate to the surface.
                // Rotate to align flat face with radial direction.
                // Subtract the half-cylinder.
                
                // Define the half-cylinder geometry
                // We want to subtract a shape that is a cylinder cut in half.
                // Let's create a "half_cylinder" module logic inline.
                
                // Position: On the surface at radius D_KNOB_RADIUS.
                // Orientation: Flat face pointing radially outward.
                
                // We will subtract a cylinder of radius GROOVE_RADIUS.
                // To make it a half-cylinder, we intersect it with a half-space?
                // OpenSCAD doesn't have half-space.
                
                // Alternative: Subtract a full cylinder, then add back the inner half? No.
                
                // Best way: 
                // Create a cylinder of radius GROOVE_RADIUS.
                // Rotate it 90 degrees around X.
                // Translate it so the flat face is at X = D_KNOB_RADIUS.
                // Rotate it back 90 degrees.
                // Now we have a half-cylinder sticking out.
                // But we need to subtract only the part that overlaps the knob.
                
                // Let's try a different construction:
                // The groove is a hole. We can model the groove as a cylinder of radius GROOVE_RADIUS
                // centered at (D_KNOB_RADIUS, 0, 0) but we only want the "outer" half.
                
                // Let's build the "bit to remove" as a union of two parts? No.
                // Let's build the "bit to remove" as a cylinder, then cut it in half using difference with a plane?
                // We can use a large flat plate to cut the cylinder in half.
                
                // Step A: Create a full cylinder of radius GROOVE_RADIUS.
                // Step B: Cut it in half with a plane at X = 0 (relative to cylinder center).
                // Step C: Position the half-cylinder so its flat face is at X = D_KNOB_RADIUS.
                
                // Implementation:
                // 1. Translate to (D_KNOB_RADIUS, 0, 0).
                // 2. Rotate 90 deg around X.
                // 3. Create a cylinder of radius GROOVE_RADIUS.
                // 4. Difference with a large flat plate at X = -GROOVE_RADIUS (relative to cylinder center).
                //    This leaves the half where X > 0.
                // 5. Rotate back 90 deg around X.
                // 6. Subtract this from the main body.
                
                translate([D_KNOB_RADIUS, 0, 0]) {
                    rotate([90, 0, 0]) {
                        difference() {
                            cylinder(h = D_KNOB_HEIGHT, r = GROOVE_RADIUS, center = true);
                            // Cut in half: keep the part where X > 0 (relative to this local coord)
                            // The flat face will be at X = -GROOVE_RADIUS.
                            // We want to remove the part where X < 0.
                            // So we subtract a block that covers X < 0.
                            translate([-GROOVE_RADIUS - 0.1, -D_KNOB_HEIGHT/2 - 1, -D_KNOB_HEIGHT/2 - 1]) {
                                cube([GROOVE_RADIUS * 2 + 0.2, D_KNOB_HEIGHT + 2, D_KNOB_HEIGHT + 2]);
                            }
                        }
                    }
                    // Rotate back to align flat face radially
                    rotate([-90, 0, 0]);
                    
                    // Now subtract this half-cylinder from the main body
                    // Wait, the logic above creates the half-cylinder. 
                    // We need to subtract it.
                    // The code above creates the shape. We just need to subtract it.
                    // But I put the difference inside the loop.
                    // Let's restructure slightly to be cleaner.
                    
                    // Actually, the code above:
                    // 1. Translates to surface.
                    // 2. Rotates 90.
                    // 3. Creates cylinder.
                    // 4. Cuts it in half (removes left side).
                    // 5. Rotates back.
                    // 6. This resulting shape is the "bit to