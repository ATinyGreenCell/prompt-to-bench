// Sowing Template for 90mm Petri Dish
// Designed to sit flat inside a standard 90mm dish.
// Orientation: Rests on XY plane at Z=0. Notch is on +Y side (front/right).

$fn = 128 // High resolution for smooth holes and curves

// --- Dimensions ---
// Outer diameter of the disc base
D_OUTER = 85; 
// Thickness of the disc
H_THICKNESS = 2; 

// Grid parameters
GRID_COUNT_X = 7;
GRID_COUNT_Y = 7;
DIAMETER_HOLE = 3; // Diameter of each sowing hole
SPACING_CENTRE_TO_CENTRE = 9;

// Notch dimensions (on the +Y side)
NOTCH_WIDTH_X = 10;   // Width along X axis
NOTCH_DEPTH_Y = 4;    // Depth measured inwards from the outer rim along Y

// --- Calculations ---
// Calculate grid offset to center the grid on the disc origin
GRID_OFFSET = (SPACING_CENTRE_TO_CENTRE * GRID_COUNT_X) / 2 - SPACING_CENTRE_TO_CENTRE/2;

// Define main body as a cylinder for easy hole subtraction later, 
// or construct via union of base and cutouts. Using difference is cleaner here.
// We start with the full outer disc shape.

difference() {
    // 1. Create the solid base disc (cylinder)
    translate([0, -NOTCH_DEPTH_Y/2 + NOTCH_WIDTH_X/2, 0]) { 
        // Note: The notch is on the +Y side of the part itself.
        // If we center the part at origin, the "front" face is usually considered positive Y in standard orientation logic for printing?
        // User said: "rectangular orientation notch into the rim on the +Y side".
        // Standard OpenSCAD view: X right, Y up (in 2D projection), Z out. 
        // However, user says "rests on bed" -> XY plane is horizontal. Z is vertical.
        // So +Y is one of the sides in the horizontal plane. Let's assume standard math orientation where +Y is 'front'.
        
        cylinder(
            h = H_THICKNESS, 
            r1 = D_OUTER/2, 
            r2 = D_OUTER/2,
            center = true
        )
    }

    // 2. Cut the Grid of Holes
    for (i_x = [0 : GRID_COUNT_X - 1], i_y = [0 : GRID_COUNT_Y - 1]) {
        translate([GRID_OFFSET + SPACING_CENTRE_TO_CENTRE/2, 
                   GRID_OFFSET + SPACING_CENTRE_TO_CENTRE/2, 
                   H_THICKNESS/2]) { // Center the hole on top face (Z = thickness/2)
            cylinder(
                h = -H_THICKNESS, // Negative height to cut through from top down
                r1 = DIAMETER_HOLE / 2, 
                r2 = DIAMETER_HOLE / 2,
                center = true
            )
        }
    }

    // 3. Cut the Orientation Notch on the +Y side
    // The notch is centered on the Y axis of the part? 
    // "centred on the Y axis" usually means symmetric around X=0 if we consider the cross section, 
    // but here it implies symmetry across the line perpendicular to the cut face.
    // Let's interpret: Notch centerline is at X = 0 (aligned with global origin).
    
    notch_center_x = 0; 
    
    translate([notch_center_x - NOTCH_WIDTH_X/2, 
                D_OUTER/2 - NOTCH_DEPTH_Y/2 + H_THICKNESS/2]) { // Position on top face at Y side
        cube(
            [NOTCH_WIDTH_X, NOTCH_DEPTH_Y, 1.05], // Extend slightly past Z=thickness to ensure clean cut in difference
            center = false 
        )
    }
    
    // Wait, the logic above for notch position:
    // Top face is at z = H_THICKNESS/2 (approx 1mm).
    // The cube needs to be inside the cylinder.
    // Let's redo the difference block structure carefully.
}

// Re-structuring to ensure valid geometry without complex nesting errors in thought process:

difference() {
    
    union() {
        // Main Body
        translate([0, 0, -H_THICKNESS/2]) { 
            cylinder(
                h = H_THICKNESS + (1), // Add tiny buffer to ensure it covers the notch cut if needed later, though difference handles this.
                r = D_OUTER / 2,
                center = true
            )
        }
    }

    // Cut Grid Holes
    for (i_x = [0 : GRID_COUNT_X - 1], i_y = [0 : GRID_COUNT_Y - 1]) {
        translate([GRID_OFFSET + SPACING_CENTRE_TO_CENTRE/2, 
                   GRID_OFFSET + SPACING_CENTRE_TO_CENTRE/2, 
                   H_THICKNESS/2]) { // Center on top face
            cylinder(
                h = -(H_THICKNESS + 0.1), // Cut slightly deeper than thickness to ensure clean hole bottom in difference logic if base was taller, but here exact match is fine with buffer.
                r1 = DIAMETER_HOLE / 2, 
                r2 = DIAMETER_HOLE / 2,
                center = true
            )
        }
    }

    // Cut Notch on +Y side (Front)
    // Centered on Y axis of the part? "centred on the Y axis" implies symmetry around X=0.
    // Position: Top face is at Z = H_THICKNESS/2 relative to center, but we want it flush with top or slightly into rim? 
    // User says "into the rim". Usually means starting from outer edge inwards.
    
    notch_z_pos = H_THICKNESS / 2; 
    
    translate([0, D_OUTER/2 - NOTCH_DEPTH_Y/2 + (H_THICKNESS/2), notch_z_pos]) { 
        // Wait, coordinate system check:
        // Cylinder center is at Z=0. Top face is Z = H_THICKNESS/2? No, cylinder h goes from 0 to h usually if not centered vertically in translate.
        // My main body was translated by -H_THICKNESS/2 so it sits on Z=-1mm and ends at +1mm (if thickness=2). 
        // Let's standardize: Base is cube/cylinder from z=0 to z=h, then translate down? 
        // Rule 3 says "rests on the bed". So bottom face must be at Z=0.
        
    }

}

// Corrected Single Block Approach for Final Output:

difference() {
    
    // Main Disc (Resting on XY plane at z=0)
    translate([0, 0, -H_THICKNESS/2]) { 
        cylinder(
            h = H_THICKNESS + 1.5, // Make it tall enough to cover the notch cut depth easily if we model from top down? No.
            r = D_OUTER / 2,
            center = true
        )
    }

    // Cut Grid Holes (From Top Down)
    for (i_x = [0 : GRID_COUNT_X - 1], i_y = [0 : GRID_COUNT_Y - 1]) {
        translate([GRID_OFFSET + SPACING_CENTRE_TO_CENTRE/2, 
                   GRID_OFFSET + SPACING_CENTRE