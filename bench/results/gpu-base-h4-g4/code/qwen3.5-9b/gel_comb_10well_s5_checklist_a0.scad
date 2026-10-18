// 10-well agarose gel comb - flat plate with spine and hanging teeth.
// Orientation: Lying flat on XY plane, spine along X, teeth hanging in -Y.

// Dimensions
spine_len = 70;
spine_w   = 12;
plate_thk = 1.5;

tooth_w   = 5.0;
tooth_l   = 12;
tooth_gap = 1.5;
num_teeth = 10;

$fn = 64;

// Calculate total width of the tooth row
tooth_row_w = (num_teeth * tooth_w) + ((num_teeth - 1) * tooth_gap);

// Calculate position of the tooth row relative to the spine center
// The row is centred on the spine in X.
// The teeth hang from the -Y edge of the spine.
// Spine Y range: [-spine_w/2, spine_w/2]
// Teeth Y range: [-spine_w/2 - tooth_l, -spine_w/2]
// X offset for the row: 0 (centred)

// Define the 2D profile for linear_extrude
// We build the shape in the XY plane (z=0) and extrude along Z.
// Points are [x, y].
// Spine: Rectangle from x=-spine_len/2 to spine_len/2, y=-spine_w/2 to spine_w/2.
// Teeth: 10 rectangles hanging from y=-spine_w/2 down to y=-spine_w/2 - tooth_l.

// Calculate X positions for the teeth
// Total width of teeth + gaps = tooth_row_w
// Spine width = spine_w
// We need to center the tooth_row_w within the spine_len? 
// No, the prompt says "row of teeth is centred on the spine in X".
// This implies the center of the tooth row aligns with the center of the spine.
// The spine is 70mm long. The tooth row is tooth_row_w wide.
// So the tooth row is centered at x=0.

// Let's construct the polygon points.
// Start at bottom-left of spine, go around spine, then cut out teeth.
// Actually, it's easier to define the outer boundary and subtract the teeth, 
// or define the union of spine and teeth.
// Since teeth hang from the spine, we can define the spine and then add teeth 
// that overlap the spine edge, or define the whole shape as one polygon.

// Let's use a polygon for the whole shape.
// Y goes from -spine_w/2 - tooth_l (bottom of teeth) to spine_w/2 (top of spine).
// X goes from -spine_len/2 to spine_len/2.

// Tooth centers in X:
// The row is centered at 0.
// The width of the row is tooth_row_w.
// The start of the row (leftmost edge of first tooth) is at: -tooth_row_w / 2.
// The end of the row (rightmost edge of last tooth) is at: +tooth_row_w / 2.
// We need to place 10 teeth of width 5.0 with 1.5 gaps.
// Let's verify the span: 10*5 + 9*1.5 = 50 + 13.5 = 63.5 mm.
// Centered at 0, so left edge is -31.75, right edge is +31.75.

// Let's generate the points for the polygon.
// Path:
// 1. Bottom-left corner of the whole assembly.
// 2. Bottom-right corner.
// 3. Top-right corner of spine.
// 4. Top-left corner of spine.
// 5. Traverse the bottom edge of the spine, cutting out teeth.
//    Wait, the teeth hang from the -Y edge.
//    So the spine is the top part. The teeth are below the spine.
//    The "bottom" of the assembly is the bottom of the teeth.
//    The "top" is the top of the spine.
//    The "left" and "right" are the ends of the spine.

// Let's trace the perimeter:
// Start at (-spine_len/2, -spine_w/2 - tooth_l)
// Go to (spine_len/2, -spine_w/2 - tooth_l)
// Go to (spine_len/2, -spine_w/2)
// Go to (-spine_len/2, -spine_w/2)
// Go to (-spine_len/2, spine_w/2)
// Go to (spine_len/2, spine_w/2)
// Go to (spine_len/2, -spine_w/2 - tooth_l) -- closing loop? No, we need to cut the teeth.

// Better approach: Union of Spine and Teeth.
// Spine: cube([spine_len, spine_w, plate_thk]) centered at (0, 0, plate_thk/2).
// Teeth: 10 cylinders or cubes hanging from the spine.
// Spine Y range: [-6, 6]
// Teeth Y range: [-18, -6] (since tooth_l=12)
// Teeth X range: centered at 0, width 63.5 total.

// Let's build the spine first.
// Then add teeth.
// Spine: translate([-spine_len/2, -spine_w/2, 0]) cube([spine_len, spine_w, plate_thk]);
// Teeth: for loop.
// Tooth X position:
// Left edge of row: -tooth_row_w / 2.
// Tooth i (0 to 9):
//   x_start = -tooth_row_w / 2 + i * (tooth_w + tooth_gap)
//   x_end   = x_start + tooth_w
//   y_start = -spine_w/2 - tooth_l
//   y_end   = -spine_w/2
//   z_start = 0
//   z_end   = plate_thk

// Let's refine the X positions.
// Row width = 63.5. Centered at 0.
// Left edge of row = -31.75.
// Tooth 0: x = -31.75, w = 5.0 -> [-31.75, -26.75]
// Tooth 1: x = -26.75 + 1.5 = -25.25, w = 5.0 -> [-25.25, -20.25]
// ...
// Tooth 9: x = ...

// Let's calculate the offset for the loop.
// offset_x = -tooth_row_w / 2;
// step = tooth_w + tooth_gap;

// Code structure:
// 1. Define variables.
// 2. Spine.
// 3. Loop for teeth.

// Check constraints:
// "row of teeth is centred on the spine in X"
// Spine X: [-35, 35]
// Tooth Row X: [-31.75, 31.75]
// This is centered correctly.

// "teeth that hang from one long edge of the spine in the -Y direction"
// Spine Y: [-6, 6]
// Teeth Y: [-18, -6]
// This hangs from y=-6 downwards. Correct.

// "10 rectangular teeth"
// num_teeth = 10. Correct.

// "Each tooth is 5.0 mm wide (X) and 12 mm long (Y)"
// tooth_w = 5.0, tooth_l = 12. Correct.

// "gaps between neighbouring teeth are 1.5 mm"
// tooth_gap = 1.5. Correct.

// "flat plate 1.5 mm thick (Z) lying on the bed"
// plate_thk = 1.5, z from 0 to 1.5. Correct.

// "straight spine (back bar) 70 mm long (X) and 12 mm wide (Y)"
// spine_len = 70, spine_w = 12. Correct.

// Implementation details:
// Use union() to combine spine and teeth.
// Use translate() to position.
// Use cube() for the rectangular prism.

// Spine translation:
// x: -35
// y: -6
// z: 0
// size: [70, 12, 1.5]

// Tooth translation for index i:
// x: -31.75 + i * 6.5
// y: -18
// z: 0
// size: [5.0, 12, 1.5]

// Wait, the tooth is 12mm long in Y.
// Spine bottom edge is at y = -6.
//