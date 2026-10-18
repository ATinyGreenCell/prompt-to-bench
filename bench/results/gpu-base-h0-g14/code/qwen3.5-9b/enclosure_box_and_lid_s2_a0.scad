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
// Wall and floor thickness
BOX_WALL_THICK = 2;
BOX_FLOOR_THICK = 2;

// Part 2: Lid
// Base plate thickness
LID_PLATE_THICK = 2;
// Lip dimensions
LIP_WALL_THICK = 1.5;
LIP_HEIGHT = 4;
// Lip outer size (fits inside box opening)
LIP_OUT_X = 65.6;
LIP_OUT_Y = 45.6;
// Clearance per side (calculated from outer size vs box inner size)
// Box inner X = 70 - 2*2 = 66. Lip outer X = 65.6. Clearance = (66-65.6)/2 = 0.2
CLEARANCE_X = 0.2;
// Clearance Y = (50 - 2*2 - 45.6)/2 = (46 - 45.6)/2 = 0.2
CLEARANCE_Y = 0.2;

// --- Positioning ---
// Gap between parts
PART_GAP = 10;

// Center the whole assembly on the bed (X=0)
// Total width = BOX_OUT_X + PART_GAP + LIP_OUT_X
TOTAL_WIDTH = BOX_OUT_X + PART_GAP + LIP_OUT_X;
ORIGIN_X = -TOTAL_WIDTH / 2;

// Center Y
ORIGIN_Y = -BOX_OUT_Y / 2;

// Z starts at 0
ORIGIN_Z = 0;

// --- Helper Functions ---

// Create the Box (Part 1)
module box() {
    translate([ORIGIN_X, ORIGIN_Y, ORIGIN_Z]) {
        // Calculate inner dimensions
        INNER_X = BOX_OUT_X - 2 * BOX_WALL_THICK;
        INNER_Y = BOX_OUT_Y - 2 * BOX_WALL_THICK;
        INNER_Z = BOX_OUT_Z - BOX_FLOOR_THICK; // Open top
        
        // Build from bottom up
        // 1. Floor
        cube([BOX_OUT_X, BOX_OUT_Y, BOX_FLOOR_THICK], center=false);
        
        // 2. Walls (using difference to cut out the hole)
        // We create a solid block of walls and subtract the inner volume
        // Wall block dimensions:
        // X: BOX_OUT_X
        // Y: BOX_OUT_Y
        // Z: BOX_OUT_Z - BOX_FLOOR_THICK (height of walls)
        
        difference() {
            // Solid block representing the walls
            cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z - BOX_FLOOR_THICK], center=false);
            
            // Cut out the inner empty space
            translate([BOX_WALL_THICK, BOX_WALL_THICK, BOX_FLOOR_THICK]) {
                cube([INNER_X, INNER_Y, INNER_Z], center=false);
            }
        }
    }
}

// Create the Lid (Part 2)
// The lid is printed upside down relative to the box opening.
// The plate lies on the bed. The lip sticks UP from the plate.
// However, the prompt says "printed upside down: a plate ... with a rectangular lip on top of it".
// This implies the lip is the part that goes INTO the box.
// If the plate is on the bed, and the lip is "on top", the lip points +Z.
// The box has an open top at +Z.
// So the lid sits on the bed, lip points up, and slides into the box.
// Wait, if the lid is printed upside down, usually that means the "top" of the part (the lip) is facing the bed?
// Let's re-read carefully: "Part 2, the lid, printed upside down: a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
// This phrasing is slightly ambiguous. 
// Interpretation A: The physical part has a plate and a lip. When printed, the plate is on the bed, lip points up. This is the "normal" orientation for a lid that sits on top of a box.
// Interpretation B: "Printed upside down" means the part is flipped. If the part is designed with the lip on the "top" face, printing it upside down puts the lip on the bed.
// BUT the description says: "a plate ... lying on the bed, with a rectangular lip on top of it".
// This explicitly states the plate is on the bed and the lip is on top of the plate (pointing +Z).
// So the "printed upside down" might refer to the design intent (it's a lid, usually placed on top, but here we print it flat on the bed).
// Let's stick to the explicit geometric description: Plate on bed, Lip pointing +Z.
// The lip outer size is 65.6 x 45.6.
// The box inner size is 66 x 46.
// Clearance is 0.2 on each side.
// The lip slides into the box.

module lid() {
    translate([ORIGIN_X + BOX_OUT_X + PART_GAP, ORIGIN_Y, ORIGIN_Z]) {
        // Base Plate
        cube([BOX_OUT_X, BOX_OUT_Y, LID_PLATE_THICK], center=false);
        
        // Lip
        // The lip sits ON TOP of the plate.
        // Lip outer dimensions: LIP_OUT_X x LIP_OUT_Y
        // Lip wall thickness: LIP_WALL_THICK
        // Lip height: LIP_HEIGHT
        
        // We construct the lip as a solid block and subtract the inner hole.
        // Lip block size: LIP_OUT_X x LIP_OUT_Y x (LIP_HEIGHT + LID_PLATE_THICK)
        // Wait, the lip is a wall. It has thickness.
        // The lip sits on the plate.
        // The lip's outer footprint is LIP_OUT_X x LIP_OUT_Y.
        // The lip's inner hole is (LIP_OUT_X - 2*LIP_WALL_THICK) x (LIP_OUT_Y - 2*LIP_WALL_THICK).
        // The lip height is LIP_HEIGHT.
        
        // Let's build the lip as a hollow box sitting on the plate.
        
        // 1. Solid block for the lip walls + plate connection
        // Dimensions: LIP_OUT_X x LIP_OUT_Y x (LIP_HEIGHT + LID_PLATE_THICK)
        lip_block_h = LIP_HEIGHT + LID_PLATE_THICK;
        
        // We need to be careful with the "on top" part.
        // The plate is already printed.
        // Now we add the lip structure.
        
        // Lip Outer Box (Solid)
        translate([0, 0, LID_PLATE_THICK]) {
            cube([LIP_OUT_X, LIP_OUT_Y, LIP_HEIGHT], center=false);
        }
        
        // Lip Inner Hole (Cutout)
        // The hole goes through the lip walls.
        // It starts at the top of the lip (Z = LID_PLATE_THICK + LIP_HEIGHT)
        // and goes down to the top of the plate (Z = LID_PLATE_THICK).
        // Actually, usually the hole goes all the way through the lip walls.
        // Does it go into the plate? No, the plate is solid.
        // So the hole is a cylinder/box of height LIP_HEIGHT.
        
        translate([LIP_WALL_THICK, LIP_WALL_THICK, LID_PLATE_THICK]) {
            cube([LIP_OUT_X - 2*LIP_WALL_THICK, LIP_OUT_Y - 2*LIP_WALL_THICK, LIP_HEIGHT], center=false);
        }
    }
}

// --- Main Assembly ---

difference() {
    // We use difference just to ensure clean separation if we were merging, 
    // but since we are placing them side-by-side with a gap, union is safer to avoid artifacts.
    // However, the prompt asks for "two-part enclosure... so they print together".
    // We just place them.
    
    // Part 1: Box
    box();
    
    // Part 2: Lid
    lid();
}