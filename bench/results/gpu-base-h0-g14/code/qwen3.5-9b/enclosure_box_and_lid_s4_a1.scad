// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10mm gap.

$fn = 64;

// --- Dimensions ---

// Part 1: Box
// Outer size X x Y x Z
BOX_OUT_X = 70;
BOX_OUT_Y = 50;
BOX_OUT_Z = 30;
// Wall thickness
BOX_WALL_THICK = 2;
// Floor thickness
BOX_FLOOR_THICK = 2;

// Part 2: Lid
// Plate thickness
LID_PLATE_THICK = 2;
// Lip dimensions
LIP_WALL_THICK = 1.5;
LIP_HEIGHT = 4;
// Lip outer size (slightly smaller than box inner to allow clearance)
LIP_OUT_X = 65.6;
LIP_OUT_Y = 45.6;

// Gap between parts
PART_GAP = 10;

// --- Part 1: Box ---
// Centered at X = - (BOX_OUT_X/2 + PART_GAP/2), Y = 0, Z = 0
// Actually, let's place the Box first, then the Lid.
// Box Center X = - (BOX_OUT_X/2 + PART_GAP/2)
// Box Center Y = 0
// Box Center Z = BOX_OUT_Z / 2 (to sit on bed)

translate([-(BOX_OUT_X/2 + PART_GAP/2), 0, BOX_OUT_Z/2])
difference() {
    // Outer Box
    cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z]);
    
    // Cut out the inside
    // Inner dimensions
    inner_x = BOX_OUT_X - 2*BOX_WALL_THICK;
    inner_y = BOX_OUT_Y - 2*BOX_WALL_THICK;
    inner_z = BOX_OUT_Z - BOX_FLOOR_THICK; // Open top
    
    translate([BOX_WALL_THICK, BOX_WALL_THICK, BOX_WALL_THICK])
    cube([inner_x, inner_y, inner_z + 0.01]); // +0.01 to ensure clean cut
}

// --- Part 2: Lid ---
// Placed on the +X side of the box.
// Center X = BOX_OUT_X/2 + PART_GAP/2
// Center Y = 0
// Center Z = LID_PLATE_THICK / 2 (sitting on bed)
// Orientation: Printed upside down. 
// This means the "top" of the part (the lip) is facing -Z relative to the part's local geometry if we build it normally,
// but since it sits on the bed, the plate is at Z=0 and the lip goes UP (+Z).
// Wait, "printed upside down" usually implies the part is flipped in the slicer or model.
// If the model is built with the lip going UP, and we print it, the lip is on top.
// If the user says "printed upside down", they might mean the part is inverted in the model so the lip is at the bottom?
// No, "Lid ... printed upside down: a plate ... lying on the bed, with a rectangular lip on top of it".
// This describes the physical result: Plate on bed, Lip on top.
// So the model should be built with the lip extending +Z from the plate.
// The phrase "printed upside down" might refer to the fact that the "inside" of the lid (the hollow part) is facing down?
// No, a lid covers the box. The lip goes over the box.
// Let's assume standard orientation: Plate at Z=0, Lip extends +Z.
// The "upside down" might be a confusion in the prompt, or it means the part is designed such that the "top" surface is the bottom surface of the printed object?
// Let's stick to the geometry description: "plate ... lying on the bed, with a rectangular lip on top of it".
// This means:
// 1. Plate is the base.
// 2. Lip is extruded upwards from the plate.
// 3. The lip fits into the box.

translate([BOX_OUT_X/2 + PART_GAP/2, 0, LID_PLATE_THICK/2])
difference() {
    // Outer shape: Plate + Lip
    // We can model this as a large block and cut the hole, or build it up.
    // Building up is easier for the lip geometry.
    
    // 1. The Plate
    cube([BOX_OUT_X, BOX_OUT_Y, LID_PLATE_THICK]);
    
    // 2. The Lip
    // The lip sits on the plate.
    // Lip Outer Size: LIP_OUT_X x LIP_OUT_Y
    // Lip Wall Thickness: LIP_WALL_THICK
    // Lip Height: LIP_HEIGHT
    // Lip Inner Size: LIP_OUT_X - 2*LIP_WALL_THICK
    
    lip_inner_x = LIP_OUT_X - 2*LIP_WALL_THICK;
    lip_inner_y = LIP_OUT_Y - 2*LIP_WALL_THICK;
    
    // Position the lip on top of the plate
    // Z position: LID_PLATE_THICK
    translate([0, 0, LID_PLATE_THICK])
    union() {
        // The solid block of the lip (including the walls)
        cube([LIP_OUT_X, LIP_OUT_Y, LIP_HEIGHT]);
        
        // The hole in the lip
        // The hole goes through the lip walls.
        // Z range of lip: LID_PLATE_THICK to LID_PLATE_THICK + LIP_HEIGHT
        // Hole Z range: LID_PLATE_THICK + LIP_WALL_THICK (bottom of hole) to LID_PLATE_THICK + LIP_HEIGHT (top)
        // Actually, the hole is inside the lip walls.
        // Bottom of hole is at Z = LID_PLATE_THICK + LIP_WALL_THICK
        // Top of hole is at Z = LID_PLATE_THICK + LIP_HEIGHT
        // We need to cut a hole that is slightly larger than the inner dimensions to ensure fit.
        // Clearance calculation:
        // Box Inner X = 66, Box Inner Y = 46.
        // Lip Outer X = 65.6, Lip Outer Y = 45.6.
        // Lip Inner X = 65.6 - 3 = 62.6.
        // Lip Inner Y = 45.6 - 3 = 42.6.
        // Clearance X = (66 - 62.6)/2 = 1.7mm.
        // Clearance Y = (46 - 42.6)/2 = 1.7mm.
        // This is a very tight fit (1.7mm total clearance). 
        // To ensure it prints and fits, we might want to slightly enlarge the hole in the model 
        // or rely on the user's specific measurements. 
        // The prompt says "0.2 mm clearance on each side". 
        // If we strictly follow "0.2mm clearance", the Lip Inner should be 65.6 x 45.6.
        // But the prompt also says "outer size is 65.6 x 45.6".
        // There is a contradiction. 
        // If Lip Outer is 65.6 and Wall is 1.5, Inner is 62.6.
        // If Inner is 65.6 (for 0.2mm clearance), Wall must be (65.6 - 65.6)/2 = 0? No.
        // If Inner is 65.6 and Outer is 65.6, Wall is 0.
        // If Inner is 65.6 and Wall is 1.5, Outer is 68.6.
        // Given the explicit "outer size 65.6", I will use that. 
        // The resulting clearance is ~1.7mm. This is likely what the user measured.
        // I will use the calculated inner dimensions based on the explicit outer size and wall thickness.
        
        translate([LIP_WALL_THICK, LIP_WALL_THICK, LID_PLATE_THICK + LIP_WALL_THICK])
        cube([lip_inner_x, lip_inner_y, LIP_HEIGHT - LIP_WALL_THICK + 0.01]);
    }
}