// Bench Rack for 1.5 mL Microcentrifuge Tubes
// Dimensions based on user specifications (mm)

// Block dimensions
$X_LEN = 106;
$Y_WID = 72;
$Z_TALL = 30;

// Grid parameters
$HOLE_COUNT_X = 6; // Along X axis
$HOLE_COUNT_Y = 4; // Along Y axis (rows)
$CC_SPACING_X = 16; // Centre-to-centre spacing along X
$CC_SPACING_Y = 16; // Centre-to-centre spacing along Y

// Hole parameters
$HOLE_DIAMETER = 11.2;
$HOLE_DEPTH = 25;   // Depth of the hole (open at top)
$FLOOR_HEIGHT = $Z_TALL - $HOLE_DEPTH; // Remaining solid floor height

// Geometry settings
$FN_CURVE = 64;      // Facets for smooth holes

// Calculate grid offset to center the array on the block face
// Total span X: (N-1) * spacing. Offset needed from edge is half of that + half spacing? 
// Actually, we want the first hole at a specific distance or perfectly centered?
// "Grid centred on the block" implies symmetry around Z=0 plane for Y and X centerline.
// Let's calculate position relative to -X/2 and -Y/2 (bottom-left corner of bounding box)

$OFFSET_X = (($HOLE_COUNT_X - 1) * $CC_SPACING_X / 2); 
$OFFSET_Y = (($HOLE_COUNT_Y - 1) * $CC_SPACING_Y / 2);

// Main block
difference() {
    // Create the solid rectangular block
    cube([
        $X_LEN, 
        $Y_WID, 
        $Z_TALL
    ], center=true);

    // Generate holes using a loop for repeated features
    // We iterate over X index (0 to 5) and Y row index (0 to 3)
    for(i = [0:$HOLE_COUNT_X - 1]) {
        for(j = [0:$HOLE_COUNT_Y - 1]) {
            
            // Calculate center position of this specific hole relative to block center
            $cx = ($OFFSET_X * i); 
            $cy = ($OFFSET_Y * j);

            // Create the cutting cylinder (hole)
            // Extend slightly past bottom face (-Z direction) to ensure clean cut in difference()
            $cut_depth = $HOLE_DEPTH + 0.1; 
            
            translate([
                -($X_LEN/2) + $cx, 
                -($Y_WID/2) + $cy, 
                -$cut_depth // Start below the block so it cuts through completely
            ]) {
                cylinder(
                    h = $HOLE_DEPTH + 0.1, // Slightly deeper than hole depth to clear floor in difference logic if needed, but here we just cut out volume
                    d = $HOLE_DIAMETER, 
                    center = true
                );
                
                // Note: In OpenSCAD 'difference', the cutter must be inside the solid.
                // Since our block is centered at 0, and cylinder is translated to absolute coords relative to origin?
                // Wait, translate([ -X/2 + cx ... ]) puts it in world coordinates where X_LEN/2 is right edge.
                // My translation logic above: 
                // Block center = (53, 36). 
                // Hole grid starts at offset from left/bottom edges? No, offsets calculated are relative to the start of the array.
                // Let's re-verify coordinate system.
                
                // Re-calculation for clarity inside loop:
                $pos_x = -($X_LEN/2) + ($OFFSET_X * i); 
                $pos_y = -($Y_WID/2) + ($OFFSET_Y * j);
            }
        }
    }
}

// Correction on the difference logic above: The cylinder command inside translate needs to be relative or absolute.
// If I use center=true, it centers around 0,0 of its own local space. Then I translate that origin.
// However, standard practice in OpenSCAD for holes is often simpler if we define positions correctly.

// Let's rewrite the difference block cleanly with correct coordinate math inside a single pass or corrected logic.
// The previous snippet had a logical error in how `translate` interacts with `cylinder(center=true)`.
// If cylinder has center=true, it spans from -d/2 to +d/2 relative to translation point.
// So translating by [pos_x, pos_y] places the hole correctly.

// Re-running the logic mentally:
// Block is centered at 0,0 in XY? No, `cube(..., center=true)` centers it at 0,0.
// The user said "centre it on the origin". So X range [-53, 53], Y range [-36, 36].
// Grid spacing 16mm. 
// If centered, the first hole (i=0) should be at -Offset + something?
// Let's define the grid such that it is symmetric around Z axis of block.
// Total width in X = $HOLE_COUNT_X * $CC_SPACING_X ? No, usually spacing is center-to-center.
// If we have 6 holes with 16mm pitch centered on a 106mm bar:
// Span = (6-1)*16 = 80mm. 
// Center of span should be at X=0.
// So first hole x_center = -40, last = +40? No.
// Let's assume the user wants a standard grid where holes are spaced by 16mm and the whole group is centered on the block face (XZ plane).
// Actually "grid centred on the block" usually means symmetric about X=0 and Y=0 planes of the block center.

$START_X = -($OFFSET_X); // Position of first hole relative to left edge? No.
// Let's calculate absolute positions from block center (0,0).
// Half span X = 4 * 16 = 64mm. 
// So holes are at x = -64, -48, ..., +64? That would make the outer hole edges touch or go out of bounds if radius is large enough.
// Radius = 5.6mm. Edge at -69.6 and -70.2 (approx). Block edge is -53. This fits easily inside 106mm width.

$POS_X_LIST = [];
for(i = [0:$HOLE_COUNT_X - 1]) {
    $x_val = ($OFFSET_X * i) - (($X_LEN/2) + ((($HOLE_COUNT_X-1)*$CC_SPACING_X)/2)); 
    // Wait, simpler way:
    // Center of the grid array is at X=0.
    // The first hole (i=0) should be at -(TotalSpan / 2).
    $x_val = -((($HOLE_COUNT_X-1)*$CC_SPACING_X)/2) + ($CC_SPACING_X * i); 
}

// Let's restart the code generation with a clean, verified script structure.