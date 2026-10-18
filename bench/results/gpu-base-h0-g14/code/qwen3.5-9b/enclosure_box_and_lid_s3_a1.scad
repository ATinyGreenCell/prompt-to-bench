// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10 mm gap.

$fn = 64;

// --- Dimensions ---

// Part 1: Box
// Outer dimensions (X x Y x Z)
BOX_OUT_X = 70;
BOX_OUT_Y = 50;
BOX_OUT_Z = 30;
// Wall thicknesses
BOX_WALL_THICK = 2;
BOX_FLOOR_THICK = 2;

// Part 2: Lid
// Base plate dimensions
LID_PLATE_X = 70;
LID_PLATE_Y = 50;
LID_PLATE_THICK = 2;
// Lip dimensions (outer size of the lip)
LIP_OUT_X = 65.6;
LIP_OUT_Y = 45.6;
LIP_THICK = 1.5;
LIP_HEIGHT = 4;

// --- Layout ---
// Gap between parts
PART_GAP = 10;

// --- Part 1: The Box ---
// Position: Centered on origin in X, Y, Z=0.
// We build the floor and walls.
// We use difference to subtract the empty interior starting above the floor.

translate([0, 0, 0])
difference() {
    // 1. The solid block representing the outer volume
    cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z], center = false);
    
    // 2. The empty interior to subtract
    // Inner dimensions:
    // X: 70 - 2*2 = 66
    // Y: 50 - 2*2 = 46
    // Z: Starts at BOX_FLOOR_THICK (2mm) and goes up to the top.
    translate([
        BOX_WALL_THICK, 
        BOX_WALL_THICK, 
        BOX_FLOOR_THICK // Start subtraction 2mm up from bed to leave the floor
    ])
    cube([
        BOX_OUT_X - (2 * BOX_WALL_THICK),
        BOX_OUT_Y - (2 * BOX_WALL_THICK),
        BOX_OUT_Z - BOX_FLOOR_THICK // Height of the empty space
    ]);
}

// --- Part 2: The Lid ---
// Position: On the +X side of the box.
// Box center X = 35. Box right edge = 70.
// Lid left edge = 70 + 10 = 80.
// Lid center X = 80 + (70/2) = 115.
// Lid is printed upside down: Plate on bed (Z=0), Lip on top.

translate([
    BOX_OUT_X + PART_GAP, 
    0, 
    0
])
difference() {
    // 1. The solid block representing the outer volume (Plate + Lip)
    // Total height = Plate(2) + Lip(4) = 6mm
    // Lip outer size is 65.6 x 45.6. Plate is 70 x 50.
    // We construct the union of the plate and the lip as one solid block first.
    
    // Construct the combined shape using a single large block and subtracting the inner voids
    // Outer envelope: 70 x 50 x 6
    cube([LID_PLATE_X, LID_PLATE_Y, LID_PLATE_THICK + LIP_HEIGHT], center = false);
    
    // 2. Subtract the voids to create the lip shape
    
    // Void A: The space under the lip (between the plate and the lip bottom)
    // This is a hole in the plate where the lip sits.
    // Lip outer: 65.6 x 45.6. Plate: 70 x 50.
    // The lip sits on the plate. The void is the area of the plate NOT covered by the lip's footprint?
    // No, the lip is a solid wall. The void is the empty space inside the lip's perimeter, 
    // extending from the top of the plate down to the bed? 
    // Wait, the lip is "on top of it".
    // Geometry: 
    // Z=0 to 2: Plate (70x50).
    // Z=2 to 6: Lip (Outer 65.6x45.6, Wall 1.5).
    // The void inside the lip is from Z=2 to Z=6.
    // The void between the lip and the plate edge is from Z=0 to Z=2.
    
    // Let's build the voids explicitly.
    
    // Void 1: The inner cavity of the lip (Z=2 to Z=6)
    // Inner X = 65.6 - 2*1.5 = 62.6
    // Inner Y = 45.6 - 2*1.5 = 42.6
    translate([
        (LID_PLATE_X - LIP_OUT_X)/2, 
        (LID_PLATE_Y - LIP_OUT_Y)/2, 
        LID_PLATE_THICK // Start at top of plate
    ])
    cube([
        LIP_OUT_X - (2 * LIP_THICK),
        LIP_OUT_Y - (2 * LIP_THICK),
        LIP_HEIGHT
    ]);
    
    // Void 2: The space between the lip and the plate edges (Z=0 to Z=2)
    // This is the area of the plate that is outside the lip's footprint.
    // Lip footprint: 65.6 x 45.6.
    // Plate: 70 x 50.
    // We need to subtract the corners/edges of the plate that are not under the lip.
    // Easiest way: Create a block representing the "Lip Footprint" and subtract it from the Plate?
    // No, we are subtracting voids from the solid.
    // The solid is 70x50x6.
    // We subtracted the inner cavity (Void 1).
    // Now we need to remove the material that is "under the lip" but "outside the lip walls"? 
    // No, the lip walls are solid. The material under the lip walls (from Z=0 to Z=2) should remain.
    // The material OUTSIDE the lip footprint (from Z=0 to Z=2) should remain (it's the plate edge).
    // Wait, if the lip is a "wall", it implies a hollow center.
    // The solid block I created (70x50x6) includes the material under the lip walls.
    // I subtracted the inner cavity (Void 1).
    // Is there any other void?
    // The prompt says "rectangular lip... 1.5 mm thick wall".
    // This implies the lip is a hollow box sitting on the plate.
    // My current logic:
    // Solid = 70x50x6.
    // Subtract Inner Cavity (62.6x42.6x4) starting at Z=2.
    // Result: 
    // Z=0..2: Solid 70x50 (Plate).
    // Z=2..6: Solid 70x50 MINUS Inner Cavity.
    // This creates a lip that is 70x50 at the bottom and 65.6x45.6 at the top?
    // No. If I subtract the inner cavity from the 70x50 block, the top surface becomes 70x50 with a hole.
    // But the lip outer size is 65.6x45.6.
    // So the top surface should be 65.6x45.6 (solid) with a hole inside?
    // Or is the lip a rim?
    // "rectangular lip on top of it - a 1.5 mm thick wall,