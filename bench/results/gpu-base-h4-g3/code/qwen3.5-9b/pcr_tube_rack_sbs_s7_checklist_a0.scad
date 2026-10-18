// 96-Well PCR Tube Rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Overall block dimensions
L_total = 127.76;
W_total = 85.48;
H_total = 20;

// Hole specifications
hole_d = 6.2;
hole_r = hole_d / 2;
n_cols = 12; // Along X
n_rows = 8;  // Along Y
pitch_x = 9.0;
pitch_y = 9.0;

// Position of first hole (A1) relative to block edge
offset_x = 14.38;
offset_y = 11.24;

// Chamfer specifications
chamfer_leg = 5;
chamfer_angle = 45;

$fn = 128;

// Calculate grid start positions to center the grid on the block
// The grid spans (n_cols-1)*pitch_x in X and (n_rows-1)*pitch_y in Y
grid_span_x = (n_cols - 1) * pitch_x;
grid_span_y = (n_rows - 1) * pitch_y;

// Center the grid within the block
grid_center_x = (L_total - grid_span_x) / 2;
grid_center_y = (W_total - grid_span_y) / 2;

// Verify A1 position matches requirements
// A1 is at index (0, 0) in the loop
// x = grid_center_x + 0 * pitch_x
// y = grid_center_y + 0 * pitch_y
// Expected: offset_x from left, offset_y from back (assuming back is -Y)
// Let's define the loop such that i=0 is the back row (Y min) and j=0 is the left col (X min)
// Then A1 is at (grid_center_x, grid_center_y).
// Distance from left edge (X=0) to A1 center: grid_center_x + hole_r? No, usually offset is to the center.
// The prompt says "centre of the first hole ... is 14.38 mm from the left edge".
// So grid_center_x should be offset_x.
// Similarly, grid_center_y should be offset_y.
// Let's re-calculate grid_center based on the explicit offset provided for A1.

// Re-defining grid center based on A1 center location
grid_center_x = offset_x;
grid_center_y = offset_y;

// Check if this grid fits in the block
// Max X = grid_center_x + (n_cols-1)*pitch_x/2 + hole_r ? No.
// The grid is defined by centers.
// Max X center = grid_center_x + (n_cols - 1) * pitch_x / 2
// Min X center = grid_center_x - (n_cols - 1) * pitch_x / 2
// Wait, the prompt says "centre of the first hole ... is 14.38 mm from the left edge".
// This implies the coordinate of the center is 14.38.
// If the grid is centered on the block, then:
// Block Center X = L_total / 2 = 63.88
// Grid Center X = 14.38
// This is NOT centered on the block.
// However, the prompt says "so the grid is centred on the block".
// This is a contradiction in the prompt's numbers vs description.
// 127.76 / 2 = 63.88.
// 14.38 is not 63.88.
// Let's re-read carefully: "The centre of the first hole (A1) is 14.38 mm from the left edge and 11.24 mm from the back edge, so the grid is centred on the block."
// Perhaps "first hole" refers to the center of the grid? No, A1 is a corner.
// Maybe the block dimensions provided are for the *inner* usable space? No, "block 127.76 mm long".
// Let's assume the explicit offsets (14.38, 11.24) define the A1 position, and the "centred on the block" part is a descriptive error in the prompt or implies the *grid pattern* is symmetric around the block center, but the A1 offset is just a specific value given.
// Actually, standard 96-well plates are often not perfectly centered in custom racks, or the "block" includes a frame.
// BUT, if I calculate the grid based on A1 being at (14.38, 11.24) and spacing 9.0mm:
// X range: 14.38 to 14.38 + 11*9 = 14.38 + 99 = 113.38.
// Block width 127.76. Margin left = 14.38 - 3.1 (radius) = 11.28. Margin right = 127.76 - 113.38 - 3.1 = 11.28.
// Ah! 14.38 - 3.1 = 11.28.
// 127.76 - (14.38 + 11*9 + 3.1) = 127.76 - 116.48 = 11.28.
// So the grid IS centered on the block if we consider the hole radius.
// Let's check Y:
// Y range: 11.24 to 11.24 + 7*9 = 11.24 + 63 = 74.24.
// Block width 85.48.
// Margin back = 11.24 - 3.1 = 8.14.
// Margin front = 85.48 - 74.24 - 3.1 = 8.14.
// Yes! The grid is perfectly centered on the block.
// My previous mental math was wrong because I didn't account for the radius in the margin calculation.
// So the logic is:
// A1 Center X = 14.38
// A1 Center Y = 11.24
// Grid starts at A1 and goes +X and +Y.

// Chamfer logic:
// Cut a 45 deg chamfer with 5mm legs off the vertical edge at the A1 corner.
// A1 corner is at X=14.38, Y=11.24.
// The "vertical edge" at the A1 corner is the edge of the block at X=0, Y=0?
// Or is it the edge of the rack at the A1 position?
// "off the vertical edge at the A1 corner".
// Usually, this means the corner of the block itself (X=0, Y=0).
// If we chamfer the corner (0,0), the chamfer plane intersects X=0 at Z=5 and Y=0 at Z=5.
// This creates a bevel at the bottom-left-back corner.
// This serves as an orientation mark.

module main_part() {
    // Main block
    translate([0, 0, 0])
        cube([L_total, W_total, H_total]);

    // Holes
    // Loop j for columns (X), i for rows (Y)
    // A1 is at j=0, i=0.
    for (j = [0 : n_cols - 1]) {
        for (i = [0 : n_rows - 1]) {
            // Calculate center of hole
            cx = grid_center_x + j * pitch_x;
            cy = grid_center_y + i * pitch_y;
            
            // Cut hole
            translate([cx, cy, 0])
                cylinder(h = H_total + 1, d = hole_d); // +1 to ensure clean cut
        }
    }

    // Chamfer at A1 corner (X=0, Y=0)
    // We need to cut a plane that goes from (0, 0, 5) to (5, 0, 0) to (5, 5, 0)?
    // No, a 45 deg chamfer with 5mm legs on the vertical edge at the corner.
    // The vertical edge is the line X=0, Y=0 from Z=0 to Z=20.
    // The chamfer removes material near this edge.
    // The cut surface is a plane passing through (5, 0, 0), (0, 5, 0) and (0, 0, 5)?
    // No, that would be a corner chamfer on the top face too.
    // "off the vertical edge" usually implies a bevel along the edge.
    // If the leg is 5mm, it means the distance from the edge to the cut is