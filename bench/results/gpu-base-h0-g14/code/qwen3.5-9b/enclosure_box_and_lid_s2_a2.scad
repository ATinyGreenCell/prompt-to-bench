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
        // Wall height is Total Height - Floor Thickness
        WALL_HEIGHT = BOX_OUT_Z - BOX_FLOOR_THICK;
        
        // Build from bottom up
        // 1. Floor
        cube([BOX_OUT_X, BOX_OUT_Y, BOX_FLOOR_THICK], center=false);
        
        // 2. Walls (using difference to cut out the hole)
        // We create a solid block of walls and subtract the inner volume.
        // The wall block sits on top of the floor.
        difference() {
            // Solid block representing the walls (sitting on the floor)
            translate([0, 0, BOX_FLOOR_THICK]) {
                cube([BOX_OUT_X, BOX_OUT_Y, WALL_HEIGHT], center=false);
            }
            
            // Cut out the inner empty space
            // The hole starts at the top of the floor
            translate([BOX_WALL_THICK, BOX_WALL_THICK, BOX_FLOOR_THICK]) {
                cube([INNER_X, INNER_Y, WALL_HEIGHT], center=false);
            }
        }
    }
}

// Create the Lid (Part 2)
// The lid is printed upside down relative to the box opening.
// The plate lies on the bed. The lip sticks UP from the plate.
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
        
        // We construct the lip as a hollow box sitting on the plate.
        
        // 1. Solid block for the lip walls + plate connection
        // Dimensions: LIP_OUT_X x LIP_OUT_Y x (LIP_HEIGHT + LID_PLATE_THICK)
        // We place this block starting at Z = LID_PLATE_THICK
        
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

// We use union to combine the two parts.
// Since they are separated by a gap, they will remain distinct bodies in the final mesh 
// (unless the slicer merges them, but OpenSCAD treats them as one union object).
// The prompt asks for "two-part enclosure... so they print together".
// Placing them in the same file with a gap achieves this.

union() {
    // Part 1: Box
    box();
    
    // Part 2: Lid
    lid();
}