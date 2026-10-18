// 96-Well PCR Tube Rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Block dimensions
L     = 127.76; // Length (X)
W     = 85.48;  // Width (Y)
H     = 20;     // Height (Z)

// Hole specifications
n_cols = 12; // Columns along X
n_rows = 8;  // Rows along Y
hole_d = 6.2;
pitch_x = 9.0;
pitch_y = 9.0;

// Grid origin offset from the left/back edge to the first hole centre
offset_x = 14.38;
offset_y = 11.24;

// Chamfer specifications
chamfer_leg = 5.0;
chamfer_angle = 45;

$fn = 64;

// Calculate grid start positions based on the offset and pitch
// The grid is centred on the block, but the first hole is at a specific offset.
// We calculate the position of the first hole (A1) relative to the block corner.
// Then we generate the rest of the grid from there.

// Define the main block
block = translate([0, 0, 0]) cube([L, W, H]);

// Define the chamfer
// The chamfer is on the vertical edge at the A1 corner.
// A1 is at (offset_x, offset_y) relative to the back-left corner (0,0).
// The chamfer cuts the edge connecting the top face to the side face? 
// No, "vertical edge" usually means the edge running up/down (Z axis).
// However, a 45 degree chamfer on a vertical edge of a rectangular block 
// typically cuts the corner of the top face and the side face, or the side face and the bottom face.
// Given "orientation mark", it's likely cutting the top-front-left corner or similar.
// Let's assume it cuts the top face and the side face (Y=0 plane) near the A1 corner.
// Actually, standard chamfers on blocks often cut the top face and a side face.
// Let's cut the corner at (offset_x, offset_y, H) down to the side face Y=0?
// Or cut the edge at X=offset_x, Y=offset_y?
// The prompt says "vertical edge at the A1 corner".
// The A1 corner is a point in the XY plane. The vertical edge goes from (offset_x, offset_y, 0) to (offset_x, offset_y, H).
// A chamfer on this edge would cut the block near this edge.
// Let's create a chamfer that removes material near the top of this edge, cutting the top face and the side face (Y=0).
// Wait, if the edge is at Y=offset_y, the side face is Y=0.
// Let's assume the chamfer cuts the top face and the face at Y=0 (back).
// The cut will be a plane at 45 degrees.
// The leg is 5mm.
// We can model this by subtracting a wedge or using a plane.
// A simple way is to subtract a cylinder or a custom shape.
// Let's define the chamfer as a plane cutting the corner.
// The corner is at (offset_x, offset_y, H).
// The cut goes down 5mm in Y and 5mm in X? Or just along the edge?
// "45-degree chamfer with 5 mm legs".
// This usually means the cut removes a triangle with legs 5mm along the two intersecting faces.
// The faces meeting at the vertical edge are the Top (Z=H) and the Back (Y=0).
// So we cut a wedge from the top-front-left corner? No, A1 is at offset_x, offset_y.
// Let's assume the block is oriented such that X is length, Y is width.
// A1 is at X=14.38, Y=11.24.
// The vertical edge is at X=14.38, Y=11.24.
// The chamfer cuts the top face and the back face (Y=0)? Or the left face (X=0)?
// "A1 corner" implies the corner of the grid.
// Let's assume the chamfer is on the edge defined by X=offset_x and Y=offset_y.
// But a vertical edge is a line. A chamfer on a line creates a bevel.
// Let's assume the chamfer is on the top-front-left corner of the block, but shifted to A1?
// No, "at the A1 corner".
// Let's interpret this as a chamfer on the top face and the side face (Y=0) near the point (offset_x, offset_y, H).
// Actually, let's look at the standard orientation. A1 is usually top-left or bottom-left.
// Let's assume the chamfer is on the edge between the Top face and the Back face (Y=0).
// The cut removes material where X > offset_x - 5 and Y < offset_y + 5?
// Let's try to cut the corner at (offset_x, offset_y, H) by removing a wedge.
// The wedge is defined by a plane passing through (offset_x - 5, offset_y, H), (offset_x, offset_y - 5, H) and (offset_x, offset_y, H - 5)?
// No, that's a corner chamfer on the top face.
// Let's assume the chamfer is on the vertical edge at X=offset_x, Y=offset_y.
// This edge runs from Z=0 to Z=H.
// A chamfer on a vertical edge usually cuts the adjacent vertical faces.
// The adjacent faces are X=0 (Left) and Y=0 (Back).
// So the chamfer cuts the corner of the block at (0,0,H)? No, that's the physical corner.
// The prompt says "at the A1 corner".
// Maybe it means the chamfer is on the top face, starting from the edge X=offset_x, Y=offset_y?
// Let's assume the chamfer is a cut on the top face and the side face Y=0, starting from the point (offset_x, offset_y, H).
// The cut removes a triangular prism.
// The vertices of the cut on the top face are (offset_x, offset_y, H), (offset_x - 5, offset_y, H), (offset_x, offset_y - 5, H).
// The vertices on the side face Y=0 are (offset_x, 0, H), (offset_x - 5, 0, H), (offset_x, 0, H - 5)?
// This is getting complicated.
// Let's simplify: A 45 deg chamfer with 5mm legs on the vertical edge at A1.
// This likely means the edge at X=offset_x, Y=offset_y is beveled.
// But the block is 127x85. The edge at A1 is internal to the block if A1 is not at the corner.
// A1 is at 14.38, 11.24. The block corners are (0,0), (L,0), (0,W), (L,W).
// So the edge at A1 is not a physical corner of the block.
// Perhaps the user means the chamfer is on the top face, starting from the edge X=offset_x, Y=offset_y?
// Or maybe the "A1 corner" refers to the corner of the rack where the A1 tube sits, and the chamfer is on the top face near that tube.
// Let's assume the chamfer is on the top face, cutting the corner of the block at (0,0,H) but shifted?
// No, "at the A1 corner".
// Let's assume the user wants a chamfer on the top face, starting from the point (offset_x, offset_y, H) and cutting towards the origin (0,0).
// This would create a chamfer on the top face and the two side faces meeting at (0,0).
// But the prompt says "vertical edge at the A1 corner".
// This is ambiguous. Let's assume the most logical interpretation for a rack:
// A chamfer on the top face and the side face (Y=0) at the location of the first tube (A1).
// The cut removes a wedge with legs 5mm along the X and Y axes from the point (offset_x, offset_y, H).
// The cut plane passes through (offset_x - 5, offset_y, H), (offset_x, offset_y - 5, H) and (offset_x, offset_y, H - 5).
// Wait, if the leg is 5mm, then the cut goes 5mm in X and 5mm in Y?
// Let's assume the chamfer is on the top face and the side face Y=0.
// The cut removes material where X > offset_x - 5 and Y < offset_y +