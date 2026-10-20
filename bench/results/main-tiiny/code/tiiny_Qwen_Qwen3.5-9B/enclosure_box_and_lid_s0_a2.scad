$fn = 128; // High resolution for smooth curves and precise fits

// --- Part 1: Box Dimensions ---
// Outer dimensions (X x Y x Z)
BOX_OUT_X = 70;
BOX_OUT_Y = 50;
BOX_OUT_Z = 30;

// Wall and floor thickness
WALL_THICKNESS = 2;
FLOOR_THICKNESS = 2;

// --- Part 2: Lid Dimensions ---
// Plate dimensions (same as box outer footprint)
LID_PLATE_X = 70;
LID_PLATE_Y = 50;
LID_PLATE_Z = 2; // Thickness of the base plate

// Lip dimensions
LIP_WALL_THICKNESS = 1.5;
LIP_HEIGHT = 4; // Height of the lip above the plate

// Lip outer size (calculated to provide 0.2mm clearance inside the 70x50 box)
// Box inner width = 70 - 2*2 = 66. Target clearance = 0.2. Lip width = 66 - 2*0.2 = 65.6
// Box inner depth = 50 - 2*2 = 46. Target clearance = 0.2. Lip depth = 46 - 2*0.2 = 45.6
LIP_OUT_X = 65.6;
LIP_OUT_Y = 45.6;

// --- Assembly Positioning ---
// Gap between parts
GAP = 10;

// Positioning variables
// Box is centred at X=0, Y=0, Z=0 (bottom at 0)
// Lid is placed on the +X side with a 10mm gap
// Lid X position = (Box X / 2) + GAP + (Lid X / 2)
// Lid Y position = 0 (centred)
// Lid Z position = 0 (bottom at 0)
LID_X_OFFSET = (BOX_OUT_X / 2) + GAP + (LID_PLATE_X / 2);

module box() {
    // Create the box shell
    // We use a single difference to create the hollow box
    difference() {
        // Outer block
        translate([0, 0, 0])
            cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z], center = true);
        
        // Inner void (negative space)
        // Inner dimensions:
        // X: 70 - 2*2 = 66
        // Y: 50 - 2*2 = 46
        // Z: 30 - 2 (floor) = 28
        // We translate the inner cube so its bottom is at Z = FLOOR_THICKNESS
        translate([WALL_THICKNESS, WALL_THICKNESS, FLOOR_THICKNESS])
            cube([
                BOX_OUT_X - 2*WALL_THICKNESS,
                BOX_OUT_Y - 2*WALL_THICKNESS,
                BOX_OUT_Z - FLOOR_THICKNESS
            ], center = true);
    }
}

module lid() {
    // The lid consists of a base plate and a lip.
    // We model this as a solid block with the lip extruded, then subtract the hole for the board.
    
    // 1. Create the base plate
    // Dimensions: 70 x 50 x 2
    // The lip sits on top of this plate.
    
    // 2. Create the lip
    // The lip is a wall of thickness 1.5mm and height 4mm.
    // Outer size of lip: 65.6 x 45.6
    // Inner size of lip (hole for board): 65.6 - 2*1.5 = 62.6 x 45.6 - 2*1.5 = 42.6
    
    // We construct the lid by:
    // a) Creating the full solid block (plate + lip volume)
    // b) Subtracting the hole for the electronics board
    
    difference() {
        // --- Solid Geometry Construction ---
        
        // Start with the base plate
        // Dimensions: 70 x 50 x 2
        // Bottom at Z=0, Top at Z=2
        translate([0, 0, 0])
            cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_Z], center = true);
        
        // Add the lip on top
        // Lip is centered on the plate.
        // Lip thickness is 1.5, so it extends 0.75 above and below the top surface of the plate.
        // However, since we are building up, we can just add a block of height (2 + 1.5) = 3.5
        // but we need to ensure the bottom of the lip is flush with the top of the plate.
        // Easier approach: Add a block of height (LID_PLATE_Z + LIP_HEIGHT) centered at Z=0?
        // No, let's keep Z=0 as the bottom of the plate.
        
        // Let's rebuild the solid logic to be cleaner:
        // Union of Plate and Lip.
        
        // Plate: 70 x 50 x 2, centered at Z=1 (bottom at Z=0)
        // Lip: 65.6 x 45.6 x (2 + 1.5), centered at Z=1 (bottom at Z=0)
        // Wait, the prompt says "lip on top of it".
        // So Plate is 2mm thick. Lip is 4mm tall sitting on top.
        // Total height = 6mm.
        
        // Let's define the solid union first.
        union() {
            // Base Plate
            translate([0, 0, 0])
                cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_Z], center = true);
            
            // Lip (sitting on top of plate)
            // Lip outer size: 65.6 x 45.6
            // Lip thickness: 1.5
            // Lip height: 4
            // Position: Centered on plate (X,Y), Bottom at Z = LID_PLATE_Z
            translate([0, 0, LID_PLATE_Z])
                cube([LIP_OUT_X, LIP_OUT_Y, LIP_HEIGHT], center = true);
        }
        
        // --- Subtraction: Hole for Board ---
        // The hole must go through the entire thickness (Plate + Lip).
        // Total thickness = 2 + 4 = 6mm.
        // Hole dimensions:
        // X: Lip Outer X - 2 * Lip Wall Thickness = 65.6 - 3 = 62.6
        // Y: Lip Outer Y - 2 * Lip Wall Thickness = 45.6 - 3 = 42.6
        
        translate([0, 0, 0])
            cube([
                LIP_OUT_X - 2*LIP_WALL_THICKNESS,
                LIP_OUT_Y - 2*LIP_WALL_THICKNESS,
                LID_PLATE_Z + LIP_HEIGHT
            ], center = true);
    }
}

// --- Main Assembly ---
// Combine Box and Lid with the specified gap
// Box is at origin
translate([0, 0, 0])
    box();

// Lid is on the +X side
translate([LID_X_OFFSET, 0, 0])
    lid();