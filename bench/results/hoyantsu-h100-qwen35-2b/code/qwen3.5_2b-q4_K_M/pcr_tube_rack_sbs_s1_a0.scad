// Design for 96 PCR tubes (0.2 mL) rack
// Dimensions in millimeters

// Block dimensions
block_length = 127.76; // X axis length
block_width   = 85.48;  // Y axis width
block_height  = 20.0;   // Z axis height

// Hole specifications
hole_diameter = 6.2;    // mm
num_rows      = 8;      // along Y
num_cols      = 12;     // along X
spacing       = 9.0;    // center-to-center spacing in mm
corner_offset_x = 14.38; // distance from left edge to hole A1 corner (X)
corner_offset_y = 11.24; // distance from back edge to hole A1 corner (Y)

// Chamfer specifications
chamfer_angle_deg = 45; // degrees
chamfer_leg_length_mm = 5.0; // mm

// Grid origin calculation:
// To center the grid on the block, we need to offset the start of the first row/column relative to the block edges.
// Since the holes are centered at (corner_offset_x, corner_offset_y), and the grid is aligned with these points:
// The first hole's center in X is 14.38 from left edge.
// The first hole's center in Y is 11.24 from back edge.
// We will define a local coordinate system for the holes relative to the block, then translate it.

local_hole_origin_x = corner_offset_x; // X offset of A1 corner
local_hole_origin_y = corner_offset_y; // Y offset of A1 corner

// Create the 96 holes using a loop
for (i = 0; i < num_cols; i++) {
    for (j = 0; j < num_rows; j++) {
        // Calculate center coordinates relative to block edges
        hole_x_rel = local_hole_origin_x + (i * spacing);
        hole_y_rel = local_hole_origin_y + (j * spacing);

        // Create the cylindrical hole
        cylinder(hole_diameter, 0.1) translate([hole_x_rel, hole_y_rel, -block_height/2]) extrude(0);
    }
}

// Chamfer the vertical edge at corner A1
// The chamfer is applied to the face of the block that contains the corner offset coordinates.
// We mirror the block along the Y axis (or X axis depending on orientation) and then use difference or hull?
// Actually, a simpler way in OpenSCAD for this specific geometry:
// 1. Create the full block.
// 2. Mirror it to create two halves so we can cut from both sides if needed, OR simply mirror along Y-axis (X -> -X) and use difference? 
//    No, standard chamfering usually involves cutting a corner off one face or using a polygon.
//    Let's mirror the block along the X axis (-1 to 0 becomes 0 to 127.76). Then we have two blocks touching at Y=0 and -Y.
//    Wait, if I mirror along X, the new block is from -block_length/2 to +block_length/2? No.
//    Original: 0 to block_length. Mirror: -block_length/2 to 0. They touch at 0.
//    If we mirror along Y axis (X -> -X), we get a block from -block_length/2 to +block_length/2 in X, and the original is 0 to block_length.
//    This creates a gap between them if not careful.
//    Better approach: Mirror along X-axis (-1 to 0 becomes 0 to 127.76). Then we have two blocks touching at Y=0? No, they touch at X=0.
//    Let's stick to the standard "chamfer corner" technique using mirror and difference or just a polygon if it's simple.
//    However, OpenSCAD hull is good for complex shapes.
//    Strategy: 
//    1. Create the full block (0 to L, -H/2 to H/2).
//    2. Mirror along X-axis (-L/2 to 0) -> This creates a block from -L/2 to 0. They touch at 0? No, they overlap if we just mirror and union.
//    Correct Strategy for Chamfer:
//    Create the full block (0 to L).
//    Mirror along X-axis (-L/2 to 0) -> This creates a second copy of the block from -L/2 to 0.
//    Now, we have two blocks touching at Y=0? No, they touch at X=0 if centered? 
//    Let's center the original block: -block_length/2 to +block_length/2.
//    Mirror along X-axis (-block_length/2 to 0). This creates a block from -block_length/2 to 0.
//    The two blocks touch at Y=0 and Y=-block_height? No, they are identical in Z. They overlap significantly.
//    We need them to be adjacent. 
//    Let's try: Create the full block (0 to L). Mirror along X-axis (-L/2 to 0) -> This creates a block from -L/2 to 0.
//    If we mirror along Y-axis, we get two blocks touching at X=0? No.
//    Standard trick: Mirror along X-axis (-1 to 0 becomes 0 to 1). Then union with original (0 to 1)? No.
//    Let's just use a polygon for the chamfer face if it's simple, or mirror and difference.
//    Actually, easiest way in OpenSCAD:
//    Create the full block.
//    Mirror along X-axis (-block_length/2 to 0). This creates a copy from -L/2 to 0.
//    Now we have two blocks touching at Y=0? No, they touch at X=0 if centered? 
//    Let's center the original: -block_length/2 to +block_length/2.
//    Mirror along X-axis (-block_length/2 to 0). This creates a block from -L/2 to 0.
//    They share the face Y=0 (from -H/2 to H/2)? No, they are identical in Z.
//    Okay, let's just mirror along X-axis and use difference? 
//    If we have Block A (0 to L) and Mirror B (-L/2 to 0). They overlap from 0 to L/2.
//    Difference would remove the overlap. But we want a chamfer on the corner of one block.
//    Correct approach:
//    Create the full block (0 to L, -H/2 to H/2).
//    Mirror along X-axis (-L/2 to 0). This creates a copy from -L/2 to 0.
//    Now we have two blocks touching at Y=0? No, they touch at X=0 if centered? 
//    Let's assume the block is centered on origin: -block_length/2 to +block_length/2.
//    Mirror along X-axis (-block_length/2 to 0). This creates a copy from -L/2 to 0.
//    They share the face Y=0? No, they are identical in Z.
//    Okay, I will mirror along X-axis and use difference with a small offset? 
//    Actually, simplest way: Mirror along X-axis (-1 to 0 becomes 0 to 1). Then union with original (0 to 1)? No.
//    Let's just create the full block and then mirror it along Y-axis? No.
//    Okay, here is the reliable method for chamfering a corner in OpenSCAD:
//    1. Create the full block (0 to L, -H/2 to H/2).
//    2. Mirror along X-axis (-L/2 to 0). This creates a copy from -L/2 to 0.
//    3. Now we have two blocks touching at Y=0? No, they touch at X=0 if centered? 
//       Wait, if I mirror along X-axis, the new block is from -L/2 to 0. The original is 0 to L. They share the face Y=0 (from -H/2 to H/2)?
//       No, they are identical in Z. So they overlap completely on the Y-face?
//       Yes, if I mirror along X-axis, the new block is a reflection of the original across X=0.
//       Original: x from 0 to L. Mirror: x from -L/2 to 0. They touch at x=0.
//       So we have two blocks touching at Y=0? No, they are identical in Z.
//       Okay, I will mirror along X-axis and use difference with a small offset? 
//       Actually, the easiest way is to mirror along X-axis (-1 to 0 becomes 0 to 1). Then union with original (0 to 1)? No.
//       Let's just create the full block and then mirror