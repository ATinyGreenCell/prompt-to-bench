// Two-part enclosure for electronics board (Box + Lid)
// Part 1: Box (70x50x30, 2mm walls, 2mm floor, open top)
// Part 2: Lid (70x50 plate with 65.6x45.6 lip, 0.2mm clearance)
// Orientation: Both rest on XY plane (Z=0). Lid is on +X side.

// Dimensions
BOX_X  = 70;
BOX_Y  = 50;
BOX_Z  = 30;
WALL   = 2;
FLOOR  = 2;

LID_PLATE_X = 70;
LID_PLATE_Y = 50;
LID_PLATE_T = 2;

LIP_OUT_X  = 65.6;
LIP_OUT_Y  = 45.6;
LIP_WALL_T = 1.5;
LIP_H      = 4;

// Clearance calculation
// Box inner width = 70 - 2*2 = 66
// Lip outer width = 65.6
// Total clearance = 66 - 65.6 = 0.4 mm
// Clearance per side = 0.2 mm (matches requirement)

// Gap between parts
GAP = 10;

$fn = 64;

// --- Part 1: The Box ---
// Constructed by extruding a 2D profile with a hole for the opening.
// Profile: Outer rect 70x50, Inner rect (opening) 66x48 at bottom.
// Thickness: 2mm.

module box() {
    // Calculate inner opening dimensions
    inner_w = BOX_X - 2 * WALL; // 66
    inner_h = BOX_Y - 2 * WALL; // 46 (Wait, floor is 2mm, walls are 2mm. 
                                // If it's open top, the hole goes all the way through the side walls.
                                // Floor is 2mm thick.
                                // So the hole is defined by the inner walls.
                                // Inner width = 70 - 2*2 = 66.
                                // Inner height (Y) = 50 - 2*2 = 46.
                                // The hole depth is BOX_Z - FLOOR = 28.
    // Let's refine the profile logic:
    // We extrude a shape that is 2mm thick.
    // The shape has an outer boundary and an inner boundary (hole).
    
    // Outer profile points (radius, height) for rotate_extrude? No, use linear_extrude.
    // Let's build the solid directly using difference for clarity.
    
    // Base block
    translate([0, 0, 0]) 
        cube([BOX_X, BOX_Y, BOX_Z]);
    
    // Cut the top opening
    // The opening is a hole through the top, but the floor remains.
    // Hole dimensions: (BOX_X - 2*WALL) x (BOX_Y - 2*WALL)
    // Hole depth: BOX_Z - FLOOR
    translate([WALL, WALL, BOX_Z - FLOOR])
        cube([BOX_X - 2 * WALL, BOX_Y - 2 * WALL, FLOOR]);
}

// --- Part 2: The Lid ---
// A plate 70x50x2 with a lip on top.
// The lip is 1.5mm thick, 4mm tall.
// Lip outer size: 65.6 x 45.6.
// Lip is centred on the plate.

module lid() {
    // Main plate
    translate([0, 0, 0])
        cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_T]);
    
    // Lip
    // The lip sits on top of the plate.
    // Lip outer dimensions: 65.6 x 45.6
    // Lip thickness: 1.5
    // Lip height: 4
    // Position: Centred on the plate.
    // Plate is 70x50. Lip is 65.6x45.6.
    // Offset X = (70 - 65.6) / 2 = 2.2
    // Offset Y = (50 - 45.6) / 2 = 2.2
    
    lip_offset_x = (LID_PLATE_X - LIP_OUT_X) / 2;
    lip_offset_y = (LID_PLATE_Y - LIP_OUT_Y) / 2;
    
    translate([lip_offset_x, lip_offset_y, LID_PLATE_T])
        cube([LIP_OUT_X, LIP_OUT_Y, LIP_WALL_T + LIP_H]);
}

// --- Assembly ---
// Place Box at origin.
// Place Lid at +X side with 10mm gap.
// Lid X position = BOX_X + GAP = 70 + 10 = 80.
// Lid Y position = 0 (centred).
// Lid Z position = 0 (resting on bed).

translate([0, 0, 0]) box();
translate([BOX_X + GAP, 0, 0]) lid();